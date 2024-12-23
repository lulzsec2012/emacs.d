;; =================================================================
;; load global emacs initial file if it exists, which include
;; template
;; verilog-mode
;; =================================================================
;; (defconst ENV_EMACS_DIR "~/.emacs.d/Emacs_ingenic/.environment/emacs/")
;; (add-to-list 'load-path ENV_EMACS_DIR)

;; Enable CUA mode
;; This maps edit keys to standard Windows keystokes. It requires the
;; library cua-mode.el from Kim Storm at the following URL:
(if (load "cua-mode" t) (CUA-mode t))

;; enabel CUA mode in case emacs version >= 22
(if (not (string-match "^21.*" emacs-version)) (cua-mode t))

(setq inhibit-startup-screen t)

;; auto-load template, the global template files in ENV_EMACS_DIR, and set its
;; subdir: template the default directory
;; (require 'template)
;; (template-initialize)
;; (setq template-default-directories
;;    (cons (concat ENV_EMACS_DIR "template/") template-default-directories))
;; (setq	verilog-auto-newline		nil
;; 	verilog-tab-always-indent 	nil)

;; =================================================================
;; Key Binding
;; =================================================================
(global-set-key [delete] 'delete-char)

;;(defconst font-lock-type-face "set_case_analysis")
;; =================================================================
;; Load
;; =================================================================

;; =================================================================
;; Saving Emacs Sessions - Useful when you have a bunch of source
;; files open and you don't want to go and manually open each
;; one, especially when they are in various directories. Page 377
;; of the GNU Emacs Manual says: "The first time you save the state
;; of the Emacs session, you must do it manually, with the command
;; M-x desktop-save. Once you have dome that, exiting Emacs will
;; save the state again -- not only the present Emacs session, but
;; also subsequent sessions. You can also save the state at any
;; time, without exiting Emacs, by typing M-x desktop-save again.
;; =================================================================
;;(load "desktop")
;;(desktop-load-default)

;; make .l_bashrc shell-script file
(setq auto-mode-alist (cons '("bashrc" . shell-script-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.bashrc" . shell-script-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cfg" . shell-script-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cu" . c-mode) auto-mode-alist))
;; make .pt or *.synopsys_pt.setup a .tcl file
(when (< max-specpdl-size 1000) (setq max-specpdl-size 2000))

;; make *.synopsys_dc.setup a .scr file
(setq auto-mode-alist (cons '(".*\\.pt$" . tcl-mode) auto-mode-alist))
(setq auto-mode-alist (cons '(".*\\.synopsys_..\\.setup$" . tcl-mode) auto-mode-alist))

;; make vflist vfl .ld files a .c file
;;(setq auto-mode-alist (cons '("vfl\\(ist\\|_*\\)" . c-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("vfl_.+" . c-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("vflist$" . c-mode) auto-mode-alist))
(setq auto-mode-alist (cons '(".*\\.ld$" . c-mode) auto-mode-alist))

(desktop-read)

;; Info
(load "info")

;; A nice buffer handling
(load "msb")

;; =================================================================
;; Behavior of emacs
;; =================================================================
;; command history length
(custom-set-variables
 '(history-length 500)
 '(comint-input-ignoredups 't)
 '(comint-input-ring-size 500)
 '(line-number-display-limit 500000)
 '(font-lock-maximum-size '((c-mode . 256000) (c++-mode . 256000)
			    (verilog-mode . 1024000))))


;; shell/comint Completion
(custom-set-variables
 '(comint-completion-fignore '("~" "#" "%" ".o"))
 '(shell-completion-fignore '("~" "#" "%" ".o"))
 '(comint-completion-autolist nil))

;;(partial-completion-mode)

;; No new line due to cursor move
(custom-set-variables '(next-line-add-newlines nil))

(put 'narrow-to-region 'disabled nil)
(auto-compression-mode)

;; No too many #*, *~ files
(setq make-backup-files nil)

;; Make the % key jump to the matching {}[]() if on another, like VI
(global-set-key "%" 'match-paren)

(defun match-paren (arg)
  "Go to the matching parenthesis if on parenthesis otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	((looking-at "\\s\)") (forward-char 1) (backward-list 1))
	(t (self-insert-command (or arg 1)))))

;; This maps edit keys to standard Windows keystokes. It requires the
;; library cua-mode.el from Kim Storm at the following URL:
;;(load "cua-mode")
;;(load "/usr/bin/emacs/site-lisp/cua-mode.el" nil t t)
;;(CUA-mode t)

;; Suppress echoing when a subprocess asks for a password
(defcustom comint-password-prompt-regexp
  "\\(\\([Oo]ld \\|[Nn]ew \\|Kerberos \\|'s \\|login \\|^CVS \\|^\\)[Pp]assword\\( (again)\\)?\\|pass phrase\\|Enter passphrase\\)\\( for [^@ 	\n]+@[^@ 	\n]+\\)?:\\s *\\'"

  "*Regexp matching prompts for passwords in the inferior process.
This is used by `comint-watch-for-password-prompt'."
  :type 'regexp
  :group 'comint)

(add-hook 'comint-output-filter-functions
  'comint-watch-for-password-prompt)

;; Let the emacsclient can be runed
;;(setenv "IN_EMACS" "in_emacs")
;;(load "resume")
;;(add-hook 'suspend-hook 'resume-suspend-hook)
;;(add-hook 'suspend-resume-hook 'resume-process-args)
;;(server-start)

;; =================================================================
;; Out Look of emacs
;; =================================================================

;; Show clock in status bar
;; Comment out first line if you prefer to show time in 12 hour format
(setq display-time-24hr-format t)
(setq display-time-day-and-date nil)
(display-time)

;; Display the current column number on mode line
(column-number-mode t)

;; Set sub-mouse-menu min number
(setq mouse-buffer-menu-mode-mult 2)

;; Don't display menu bar. Type M-x menu-bar-mode to display it
(menu-bar-mode '-1)
;; Don't display tool bar. Type M-x tool-bar-mode to display it
(if (not (equal (getenv "HOSTTYPE") "sparc"))
    (tool-bar-mode '-1))

;; Scroll bar place
(custom-set-variables '(scroll-bar-mode (quote right)))
;;(custom-set-variables '(scroll-bar-mode (quote left)))

;; Make temp buffer size min
(temp-buffer-resize-mode '1)

;; =================================================================
;; Key Binding
;; =================================================================

;; Book mark 1
(global-set-key [f1] 'bookmark-jump-default1)
(defun bookmark-jump-default1 (pos)
  "Set a default bookmark 1 default-bookmark1 at current position"
  (interactive "d")
  (bookmark-jump "default-bookmark1")
  (bookmark-set "default-bookmark1"))

(global-set-key [C-f1] 'bookmark-set-default1)
(defun bookmark-set-default1 (pos)
  "Jump to the default bookmark 1 default-bookmark1"
  (interactive "d")
  (bookmark-set "default-bookmark1"))

;; Book mark 2
(global-set-key [f2] 'bookmark-jump-default2)
(defun bookmark-jump-default2 (pos)
  "Set a default bookmark 2 default-bookmark2 at current position"
  (interactive "d")
  (bookmark-jump "default-bookmark2")
  (bookmark-set "default-bookmark2"))

(global-set-key [C-f2] 'bookmark-set-default2)
(defun bookmark-set-default2 (pos)
  "Jump to the default bookmark 2 default-bookmark2"
  (interactive "d")
  (bookmark-set "default-bookmark2"))

(global-set-key [S-f2] 'bookmark-jump)
(global-set-key [S-C-f2] 'bookmark-set)

;; Set the word search keys
(define-key global-map [f3] 'isearch-forward)
(define-key isearch-mode-map [f3] 'isearch-repeat-forward)
(define-key global-map [C-f3] 'isearch-forward-regexp)
(define-key global-map [S-f3] 'isearch-backward)
(define-key isearch-mode-map [S-f3] 'isearch-repeat-backward)
(define-key global-map [C-S-f3] 'isearch-backward-regexp)

;; Kill buffer/emacs
(global-set-key [C-f4] 'kill-this-buffer)
(global-set-key [f8] '(lambda() (interactive) (kill-this-buffer)))
(global-set-key [M-f4] 'save-buffers-kill-emacs)

;; Alternative copy/paste
;;(global-set-key [f4] 'copy-to-register-t)
(defun copy-to-register-t (start end)
  "Copy the selected region into a default register, t"
  (interactive "r")
  (copy-to-register t start end)
  (if transient-mark-mode (setq deactivate-mark t)))

(global-set-key [S-f4] 'insert-register-t)
(defun insert-register-t (pos)
  "Insert the contents of default register, t, into current position"
  (interactive "d")
  (insert-register t 1))

;; Go to line
(global-set-key [f5] 'goto-line)

;; Switch windows/buffers
(global-set-key [f6] 'other-window)
(global-set-key [C-f6] 'switch-to-buffer)
(global-set-key [S-f6] 'buffer-menu)

;; Search previour/next issued commend
(global-set-key [S-f7] 'comint-next-matching-input-from-input)
(global-set-key [f7] 'comint-previous-matching-input-from-input)

;; Replace
(global-set-key [f9] 'query-replace)
(global-set-key [C-f9] 'query-replace-regexp)
(global-set-key [S-f9] 'query-replace-reg-t)

(defun query-replace-reg-t (to-string)
  (interactive (let (to)
		 (setq to (read-from-minibuffer
			   (format "Query-replace \"%s\" with: "
				   (get-register t))
			   nil nil nil
			   query-replace-to-history-variable nil t))
		 (list to)))
  (perform-replace (get-register t) to-string t nil nil))

(global-set-key [f10] 'replace-string)
(global-set-key [C-f10] 'replace-string-regexp)
(global-set-key [S-f10] 'replace-string-reg-t)

(defun replace-string-reg-t (to-string)
  (interactive (let (to)
		 (setq to (read-from-minibuffer
			   (format "Replace \"%s\" with: "
				   (get-register t))
			   nil nil nil
			   query-replace-to-history-variable nil t))
		 (list to)))
  (perform-replace (get-register t) to-string nil nil nil))

;; Split/combine windows
(global-set-key [f11] 'delete-other-windows)
(global-set-key [S-f11] 'delete-window)
(global-set-key [f12] 'split-window-vertically)
(global-set-key [S-f12] 'split-window-horizontally)
(global-set-key [M-f12] 'split-window-vertically)
;;(global-set-key [S-f5] 'split-window-horizontally)

;; Mouse operation
(global-set-key [mouse-3] 'mouse-buffer-menu)

;; Common MSWIN like keys
(global-set-key "\C-o" 'find-file)
;;(global-set-key "\C-o" 'helm-find-files)
(global-set-key "\C-s" 'save-buffer)
;;(global-set-key "\C-p" 'pwd)
(global-set-key [C-backspace] 'backward-kill-word)
(global-set-key [C-delete] 'kill-word)
(global-set-key "\C-d" 'kill-whole-line)
(defun kill-whole-line ()
  "Kill the whole line the cursor located"
  (interactive)
  (beginning-of-line nil)
  (kill-line nil)
  (kill-line nil))

(defun convert-port-to-lib (start end)
  "Convert port list selected to lib definitions"
  (interactive "r")
  (shell-command-on-region start end
			   "awk -f ~/project/tools/bin/port2lib.awk"))
;; =================================================================
;; Shell
;; =================================================================
(shell)
(rename-buffer "shell-1")
(shell)
(rename-buffer "shell-2")
;;(split-window-right)

;; If open a big verilog file and want to operate it fast, disable
;; global-font-lock-mode. Do: Alt-x global-font-lock-mode

;; =================================================================
;; load group & user emacs initial file if it exists
;; =================================================================

;; in ~/.group.emacs.el or in ~/.user.emacs.el, put following
;;(load (concat ENV_EMACS_DIR "color-set-*.el") t nil t)

;;(load (concat ENV_EMACS_DIR "color-set-dark1.el") t nil t)
;
;; display line number
;;(require 'linum)
;;(global-linum-mode t)

(fset 'yes-or-no-p 'y-or-n-p)

;; set copy buffer number
(setq kill-ring-max 200)

;; open and display picture
(setq auto-image-file-mode t)

;; auto-save
(setq auto-save-mode nil)

;; allow copy from external
(setq x-select-enable-clipboard t)

;; mouse past
(setq mouse-yank-at-point t)

;; set font
;; (set-default-font "10x20")

(global-set-key [C-f5] 'find-file_goto-line)
(defun find-file_goto-line(str)
  "open a file and goto specific line. [Ctrl+o;F5]"
  (interactive "sGoto <filename:linenum>")
  (setq numN (string-match ":" str))
  (setq filename (substring str 0 numN))
  (find-file (concat default-directory filename))
  (goto-line (string-to-number (substring str (+ numN 1)))))

(global-set-key [C-o] 'find-file)
;;(global-set-key [C-o] '_find-file)
(defun _find-file(str)
  "open a file and goto specific line. [Ctrl+o;F5]"
  (interactive "c-o:")
  (find-file (concat default-directory str)))

(global-set-key (kbd "C-x r d")'bookmark-delete)
(defun bookmark-delete (str)
  "Delete a specified bookmark"
  (interactive "d")
  (bookmark-set str))

(winner-mode 1)

(global-set-key (kbd "C-\\")'comment-or-uncomment-region)

;;(add-to-list 'load-path "~/.emacs.d/Emacs_ingenic/.emacs.d/multi-term")
;;(require 'multi-term)
;;(setq multi-term-program "/bin/bash")

(global-set-key (kbd "C-x p")'ido-dired)


(global-set-key (kbd "C-x 5")'ace-swap-window)
(defun rotate-windows (arg)
  "Rotate your windows; use the prefix argument to rotate the other direction"
  (interactive "P")
  (if (not (> (count-windows) 1))
      (message "You can't rotate a single window!")
    (let* ((rotate-times (prefix-numeric-value arg))
           (direction (if (or (< rotate-times 0) (equal arg '(4)))
                          'reverse 'identity)))
      (dotimes (_ (abs rotate-times))
        (dotimes (i (- (count-windows) 1))
          (let* ((w1 (elt (funcall direction (window-list)) i))
                 (w2 (elt (funcall direction (window-list)) (+ i 1)))
                 (b1 (window-buffer w1))
                 (b2 (window-buffer w2))
                 (s1 (window-start w1))
                 (s2 (window-start w2))
                 (p1 (window-point w1))
                 (p2 (window-point w2)))
            (set-window-buffer-start-and-point w1 b2 s2 p2)
            (set-window-buffer-start-and-point w2 b1 s1 p1)))))))
(global-set-key (kbd "C-x 6")'rotate-split)

(global-set-key (kbd "M-[ h")'move-beginning-of-line)
(global-set-key (kbd "M-[ f")'move-end-of-line)
(defun rotate-split ()
  (interactive)
  (let ((root (car (window-tree))))
    (if (listp root)
        (let* ((w1 (nth 2 root))
               (w2 (nth 3 root))
               (b1 (window-buffer w1))
               (b2 (window-buffer w2)))
          (cond ((car root)             ; currently vertically split
                 (delete-window w2)
                 (set-window-buffer (split-window-horizontally) b2))
                (t                      ; currently horizontally split
                 (delete-window w1)
                 (set-window-buffer (split-window-vertically) b1))))
      (message "Root window not split"))))

;; ;;gtags
;; (add-hook 'c-mode-hook 'counsel-gtags-mode)
;; (add-hook 'c++-mode-hook 'counsel-gtags-mode)

;; (with-eval-after-load 'counsel-gtags
;;   (define-key counsel-gtags-mode-map (kbd "M-t") 'counsel-gtags-find-definition)
;;   (define-key counsel-gtags-mode-map (kbd "M-r") 'counsel-gtags-find-reference)
;;   (define-key counsel-gtags-mode-map (kbd "M-s") 'counsel-gtags-find-symbol)
;;   (define-key counsel-gtags-mode-map (kbd "M-,") 'counsel-gtags-go-backward))
