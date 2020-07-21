;;(setq emacs_config_version nil)
(setq emacs_config_version t)
(when emacs_config_version
  (require 'package)
  (setq package-archives
	'(("gnu"   . "https://elpa.emacs-china.org/gnu/")
	  ("melpa" . "https://elpa.emacs-china.org/melpa/")
	  ("org" . "https://elpa.emacs-china.org/org/")
	  ("ublt" . "https://elpa.ubolonton.org/packages/")
	  ))
  (package-initialize)
  (set-terminal-coding-system 'utf-8)
  ;; Ensure that use-package is installed.
  ;;
  ;; If use-package isn't already installed, it's extremely likely that this is a
  ;; fresh installation! So we'll want to update the package repository and
  ;; install use-package before loading the literate configuration.
  (when (not (package-installed-p 'use-package))
    (package-refresh-contents)
    (package-install 'use-package))

  (org-babel-load-file "~/.emacs.d/configuration.org")
  )
(load-file "~/.emacs.d/Emacs_ingenic/.emacs")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(comint-completion-autolist nil)
 '(comint-completion-fignore (quote ("~" "#" "%" ".o")))
 '(comint-input-ignoredups (quote t))
 '(comint-input-ring-size 500)
 '(font-lock-maximum-size
   (quote
    ((c-mode . 256000)
     (c++-mode . 256000)
     (verilog-mode . 1024000))))
 '(history-length 500)
 '(line-number-display-limit 500000)
 '(next-line-add-newlines nil)
 '(package-selected-packages
   (quote
    (ace-window goto-chg avy expand-region wrap-region ivy-rich smex flx counsel yasnippet-snippets which-key helpful company-auctex auctex company-math ob-async org-super-agenda org-pomodoro workgroups2 web-mode virtualenvwrapper use-package undo-tree typescript-mode symon symbol-overlay solarized-theme smartparens smart-jump rspec-mode realgud rainbow-mode rainbow-delimiters protobuf-mode projectile powerline paredit org-plus-contrib org-bullets nord-theme multi-term magit-lfs ivy-xref imenu-list hydra highlight-indent-guides git-timemachine ggtags geiser flycheck-package ein diff-hl deadgrep company-statistics cmake-font-lock bazel-mode bash-completion auto-package-update auto-compile)))
 '(scroll-bar-mode (quote right))
 '(shell-completion-fignore (quote ("~" "#" "%" ".o"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
