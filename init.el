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
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq-default buffer-file-coding-system 'utf-8)
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
(require 'org)
(load-file "~/.emacs.d/Emacs_ingenic/.emacs")
