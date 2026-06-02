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
        ("melpa-stable" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa-stable/")
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
