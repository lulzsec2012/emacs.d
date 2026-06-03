;;; init.el --- -*- lexical-binding: t; -*-

;; Compatibility shims for Emacs 30+ functions missing from this build.
;; Needed by the latest magit.
(unless (fboundp 'set-local)
  (defun set-local (variable value)
    "Set VARIABLE to VALUE in the current buffer."
    (set (make-local-variable variable) value)))
(unless (fboundp 'any)
  (defun any (pred list)
    "Return non-nil if PRED returns non-nil for any element of LIST.
Like `cl-some' with the predicate as the first argument."
    (cl-some pred list)))

(require 'package)
(setq package-archives
      '(("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
        ("melpa-stable" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/stable-melpa/")
        ("gnu"   . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ;; ("gnu-devel"   . "https://elpa.gnu.org/devel/")
        ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
        ))
(setq package-install-upgrade-built-in t)
(package-initialize)
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq-default buffer-file-coding-system 'utf-8)
(setq native-comp-async-report-warnings-errors nil) ;; suppress the native compile warning.
;; Ensure that use-package is installed.
;;
;; If use-package isn't already installed, it's extremely likely that this is a
;; fresh installation! So we'll want to update the package repository and
;; install use-package before loading the literate configuration.
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))
(require 'org)
(require 'bind-key)
(org-babel-load-file "~/.emacs.d/configuration.org")

(load-file "~/.emacs.d/Emacs_ingenic/.emacs")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(comint-completion-autolist nil)
 '(comint-completion-fignore '("~" "#" "%" ".o"))
 '(comint-input-ignoredups 't)
 '(comint-input-ring-size 500)
 '(font-lock-maximum-size
   '((c-mode . 256000) (c++-mode . 256000) (verilog-mode . 1024000)))
 '(history-length 500)
 '(line-number-display-limit 500000)
 '(next-line-add-newlines nil)
 '(package-selected-packages
   '(ace-window auctex auto-compile auto-package-update back-button bazel bing-dict
                buildbot cape clang-format compiler-explorer corfu crux
                cython-mode dape deadgrep deft demangle-mode dired-narrow
                dired-rsync dumb-jump easy-kill eat ef-themes elf-mode
                emacs-opencode embark-consult exec-path-from-shell expand-region
                expreg fanyi find-file-in-project flatbuffers-mode fussy geiser
                git-gutter git-timemachine goto-chg gptel-agent
                graphviz-dot-mode groovy-mode helpful hydra imenu-list
                indent-bars jinx jq-mode magit-lfs marginalia mcp-server
                monkeytype multiple-cursors nov ob-async opencode org-bullets
                org-contrib org-pomodoro org-super-agenda orgalist plantuml-mode
                popper protobuf-mode pyim rainbow-delimiters rainbow-mode
                repeat-help request rmsbolt rspec-mode ruff-format
                rust-playground smartparens symbol-overlay undo-tree
                virtualenvwrapper visual-regexp vterm web-mode wgrep-deadgrep
                wrap-region zig-mode))
 '(package-vc-selected-packages
   '((opencode :url "https://codeberg.org/sczi/opencode.el.git")))
 '(scroll-bar-mode 'right)
 '(shell-completion-fignore '("~" "#" "%" ".o")))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-delimiter-face ((t (:inherit italic :foreground "#969faf"))))
 '(font-lock-comment-face ((t (:inherit italic :foreground "#969faf")))))
