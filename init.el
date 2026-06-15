;;; init.el --- -*- lexical-binding: t; -*-

;; Compatibility shims for Emacs 30
(unless (fboundp 'set-local)
  (defun set-local (variable value)
    "Set VARIABLE to VALUE in the current buffer."
    (set (make-local-variable variable) value)))
(unless (fboundp 'any)
  (defun any (pred list)
    "Return non-nil if PRED returns non-nil for any element of LIST."
    (cl-some pred list)))

(require 'package)
(setq custom-file "/dev/null")     ;; Prevent Customize writing to init.el
(setq package-archives
      '(("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
        ("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")))
(setq package-install-upgrade-built-in t)
(package-initialize)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq-default buffer-file-coding-system 'utf-8)
(setq native-comp-async-report-warnings-errors nil)

;; Bootstrap use-package for literate config
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'org)
(require 'bind-key)
(org-babel-load-file "~/.emacs.d/configuration.org")

(load-file "~/.emacs.d/emacs-extras/key-bindings.el")
