#!/bin/bash
# =============================================================================
# macOS Emacs Environment Installer
# =============================================================================
set -euo pipefail

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
    npm install -g typescript typescript-language-server yaml-language-server
  else
    echo "[!] npm not found — install Node.js: brew install node"
    echo "    Skipping: typescript-language-server, yaml-language-server"
  fi

  if command -v pip3 &>/dev/null; then
    echo "[ ] Installing pip-based LSPs..."
    pip3 install python-lsp-server
  else
    echo "[!] pip3 not found — install Python: brew install python"
    echo "    Skipping: python-lsp-server"
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

  4. LLVM/clangd PATH (add to ~/.zshrc):
     export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

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
