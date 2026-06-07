#!/bin/bash
# =============================================================================
# macOS Emacs Environment Installer
# =============================================================================
# shellcheck disable=SC2317
set -euo pipefail

# Suppress Homebrew noise (tap trust warnings, env hints on newer brew)
export HOMEBREW_NO_REQUIRE_TAP_TRUST=1
export HOMEBREW_NO_ENV_HINTS=1

echo "============================================"
echo " macOS Emacs Environment Installer"
echo "============================================"

# =============================================================================
# Helpers
# =============================================================================

brew_install_if_missing() {
  local pkg=$1
  if brew list "$pkg" &>/dev/null 2>&1; then
    echo "[✓] $pkg already installed"
    return 0
  fi
  echo "[ ] Installing $pkg..."
  brew install "$pkg"
}

brew_cask_install_if_missing() {
  local pkg=$1
  if brew list --cask "$pkg" &>/dev/null 2>&1; then
    echo "[✓] $pkg already installed"
    return 0
  fi
  echo "[ ] Installing $pkg..."
  brew install --cask "$pkg"
}

# Check if an npm global package is installed (but skip if a brew version
# already shadows the binary, to avoid EEXIST conflicts).
npm_install_if_missing() {
  local pkg=$1
  local bin=${2:-$pkg}
  if command -v "$bin" &>/dev/null; then
    echo "[✓] npm:$pkg already installed (found $bin in PATH)"
    return 0
  fi
  echo "[ ] Installing npm:$pkg..."
  npm install -g "$pkg"
}

# =============================================================================
# 1. Xcode Command Line Tools
# =============================================================================
install_xcode_clt() {
  if xcode-select -p &>/dev/null; then
    echo "[✓] Xcode CLT already installed"
    return 0
  fi
  echo "[ ] Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "Please wait for the installation to complete, then re-run this script."
  exit 0
}

# =============================================================================
# 2. Homebrew
# =============================================================================
install_homebrew() {
  if command -v brew &>/dev/null; then
    echo "[✓] Homebrew already installed"
    return 0
  fi
  echo "[ ] Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

# =============================================================================
# 3. Emacs (GUI version via --cask)
# =============================================================================
install_emacs() {
  if command -v emacs &>/dev/null; then
    echo "[✓] Emacs already installed ($(emacs --version | head -1))"
    return 0
  fi
  echo "[ ] Installing Emacs..."
  brew install --cask emacs
}

# =============================================================================
# 4. Core tools
# =============================================================================
install_core_tools() {
  local pkgs=(coreutils ripgrep fd findutils gnu-sed grep)
  echo "[ ] Installing core tools..."
  for pkg in "${pkgs[@]}"; do
    brew_install_if_missing "$pkg"
  done
}

# =============================================================================
# 5. Version control
# =============================================================================
install_vc_tools() {
  echo "[ ] Installing version control tools..."
  brew_install_if_missing git
  brew_install_if_missing git-lfs
}

# =============================================================================
# 6. Spell check (Jinx)
# =============================================================================
install_spell() {
  echo "[ ] Installing spell check tools..."
  brew_install_if_missing pkg-config
  brew_install_if_missing enchant
}

# =============================================================================
# 7. Language Servers
# =============================================================================
install_lsp() {
  echo "[ ] Installing Language Servers..."
  brew_install_if_missing llvm
  brew_install_if_missing texlab
  brew_install_if_missing rust-analyzer
  brew_install_if_missing bash-language-server
  brew_install_if_missing lua-language-server

  if command -v npm &>/dev/null; then
    echo "[ ] Installing npm-based LSPs..."
    # yaml-language-server may be installed via brew, which shadows npm's
    # binary and causes EEXIST.  Let brew handle it when already present.
    npm_install_if_missing typescript tsc
    npm_install_if_missing typescript-language-server
    if ! command -v yaml-language-server &>/dev/null; then
      npm_install_if_missing yaml-language-server
    else
      echo "[✓] yaml-language-server already in PATH (likely from brew)"
    fi
  else
    echo "[!] npm not found — install Node.js: brew install node"
    echo "    Skipping: typescript, typescript-language-server, yaml-language-server"
  fi

  if command -v pip3 &>/dev/null; then
    # macOS SIP / PEP 668 prevents pip install system-wide.
    # python-lsp-server is available via Homebrew as an alternative.
    if brew list python-lsp-server &>/dev/null 2>&1; then
      echo "[✓] python-lsp-server already installed (brew)"
    elif brew install python-lsp-server &>/dev/null 2>&1; then
      echo "[✓] python-lsp-server installed via brew"
    else
      echo "[!] brew install python-lsp-server failed — falling back to pipx/pip"
      if command -v pipx &>/dev/null; then
        pipx install python-lsp-server
      else
        pip3 install --user python-lsp-server --break-system-packages 2>/dev/null || \
          echo "[!] Could not install python-lsp-server. Run manually: brew install python-lsp-server"
      fi
    fi
  else
    echo "[!] pip3 not found — install Python: brew install python"
    echo "    Skipping: python-lsp-server (try: brew install python-lsp-server)"
  fi
}

# =============================================================================
# 8. Font
# =============================================================================
install_font() {
  brew_cask_install_if_missing font-iosevka-ss09
}

# =============================================================================
# 9. Other tools
# =============================================================================
install_other() {
  echo "[ ] Installing other tools..."
  brew_install_if_missing pandoc
  brew_install_if_missing gnuplot
}

# =============================================================================
# 10. WezTerm symlink
# =============================================================================
install_wezterm_symlink() {
  local target="$HOME/.emacs.d/emacs-extras/wezterm.lua"
  local link="$HOME/.config/wezterm/wezterm.lua"

  if [[ ! -f "$target" ]]; then
    echo "[!] WezTerm config not found at $target — skipping symlink"
    return 0
  fi

  if [[ "$(readlink "$link")" == "$target" ]] && [[ -L "$link" ]]; then
    echo "[✓] WezTerm symlink already set"
    return 0
  fi

  echo "[ ] Setting up WezTerm symlink..."
  mkdir -p "$(dirname "$link")"
  ln -sfn "$target" "$link"
  echo "[✓] WezTerm symlink created: $link → $target"
}

# =============================================================================
# Post-install info
# =============================================================================
print_post_install() {
  cat <<'EOF'

============================================
 Installation Complete!
============================================

Next steps:

  1. First launch:
     Open Emacs and let packages install.
     The first startup may take a few minutes for native-compilation.

  2. Caps Lock → Control:
     System Settings → Keyboard → Keyboard Shortcuts → Modifier Keys
     → Caps Lock → Control

  3. Enable F-keys for Emacs:
     System Settings → Keyboard → Keyboard Shortcuts → Function Keys
     → Click "+" → add Emacs.app

     Or globally: System Settings → Keyboard → "Use F1-F12 as standard
     function keys" (toggle on)

   4. LLVM/clangd PATH:
      Homebrew installs LLVM as keg-only (not linked into /opt/homebrew/bin).
      Add to ~/.zshrc to make clangd/llvm-config available:

        # LLVM (keg-only, needed for clangd LSP)
        export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
        export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
        export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

   5. If Emacs native-compilation warns about missing gcc-lib:
      brew install gcc

EOF
}

# =============================================================================
# Main
# =============================================================================
main() {
  install_xcode_clt
  install_homebrew
  brew update

  install_emacs
  install_core_tools
  install_vc_tools
  install_spell
  install_lsp
  install_font
  install_other
  install_wezterm_symlink
  print_post_install
}

main "$@"
