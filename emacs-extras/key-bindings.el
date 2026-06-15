;; -*- lexical-binding: t; -*-

;; =====================================================================
;; Settings & Configuration
;; =====================================================================

(defalias 'kill-this-buffer 'kill-current-buffer)

(cua-mode t)

(setq inhibit-startup-screen t)


;; --- File Associations ---
(setq auto-mode-alist (cons '("bashrc" . shell-script-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.bashrc" . shell-script-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cfg" . shell-script-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cu" . c-mode) auto-mode-alist))

(when (< max-specpdl-size 1000) (setq max-specpdl-size 2000))


;; --- Session & Startup ---
(desktop-read)
(load "info")
(load "msb")


;; --- Emacs Behavior ---
(custom-set-variables
 '(history-length 500)
 '(comint-input-ignoredups 't)
 '(comint-input-ring-size 500)
 '(line-number-display-limit 500000)
 '(font-lock-maximum-size '((c-mode . 256000) (c++-mode . 256000))))

(custom-set-variables
 '(comint-completion-fignore '("~" "#" "%" ".o"))
 '(shell-completion-fignore '("~" "#" "%" ".o"))
 '(comint-completion-autolist nil))

(custom-set-variables '(next-line-add-newlines nil))

(put 'narrow-to-region 'disabled nil)
(auto-compression-mode)
(setq make-backup-files nil)

(fset 'yes-or-no-p 'y-or-n-p)
(setq kill-ring-max 200)
(setq auto-image-file-mode t)
(setq auto-save-mode nil)
(unless (eq window-system 'ns)
  (setq x-select-enable-clipboard t))
(setq mouse-yank-at-point t)

;; Suppress echoing when a subprocess asks for a password
(defcustom comint-password-prompt-regexp
  "\\(\\([Oo]ld \\|[Nn]ew \\|Kerberos \\|'s \\|login \\|^CVS \\|^\\)[Pp]assword\\( (again)\\)?\\|pass phrase\\|Enter passphrase\\)\\( for [^@ 	\n]+@[^@ 	\n]+\\)?:\\s *\\'"
  "*Regexp matching prompts for passwords in the inferior process.
This is used by `comint-watch-for-password-prompt'."
  :type 'regexp
  :group 'comint)

(add-hook 'comint-output-filter-functions
  'comint-watch-for-password-prompt)


;; --- Display & UI ---
(setq display-time-24hr-format t)
(setq display-time-day-and-date nil)
(display-time)

(column-number-mode t)
(setq mouse-buffer-menu-mode-mult 2)
(menu-bar-mode '-1)
(if (not (equal (getenv "HOSTTYPE") "sparc"))
    (tool-bar-mode '-1))
(custom-set-variables '(scroll-bar-mode (quote right)))
(temp-buffer-resize-mode '1)

(winner-mode 1)

;; Auto-start shell
(shell)


;; =====================================================================
;; Custom Functions
;; =====================================================================

(defun match-paren (arg)
  "Go to the matching parenthesis if on parenthesis otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	((looking-at "\\s\)") (forward-char 1) (backward-list 1))
	(t (self-insert-command (or arg 1)))))

(defun kill-whole-line ()
  "Kill the whole line the cursor located"
  (interactive)
  (beginning-of-line nil)
  (kill-line nil)
  (kill-line nil))

(defun copy-to-register-t (start end)
  "Copy the selected region into a default register, t"
  (interactive "r")
  (copy-to-register t start end)
  (if transient-mark-mode (setq deactivate-mark t)))

(defun insert-register-t (pos)
  "Insert the contents of default register, t, into current position"
  (interactive "d")
  (insert-register t 1))

(defun query-replace-reg-t (to-string)
  (interactive (let (to)
		 (setq to (read-from-minibuffer
			   (format "Query-replace \"%s\" with: "
				   (get-register t))
			   nil nil nil
			   query-replace-to-history-variable nil t))
		 (list to)))
  (perform-replace (get-register t) to-string t nil nil))

(defun replace-string-reg-t (to-string)
  (interactive (let (to)
		 (setq to (read-from-minibuffer
			   (format "Replace \"%s\" with: "
				   (get-register t))
			   nil nil nil
			   query-replace-to-history-variable nil t))
		 (list to)))
  (perform-replace (get-register t) to-string nil nil nil))

(defun find-file_goto-line (str)
  "Open a file and goto specific line. Usage: <filename:linenum>"
  (interactive "sGoto <filename:linenum>")
  (setq numN (string-match ":" str))
  (setq filename (substring str 0 numN))
  (find-file (concat default-directory filename))
  (goto-line (string-to-number (substring str (+ numN 1)))))

(defun bookmark-delete (str)
  "Delete a specified bookmark"
  (interactive "d")
  (bookmark-set str))

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

(defun rotate-split ()
  "Toggle between vertical and horizontal window split"
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


;; =====================================================================
;; Bookmark Functions
;; =====================================================================

(defun bookmark-jump-default1 (pos)
  "Jump to default-bookmark1, then reset it to current position."
  (interactive "d")
  (bookmark-jump "default-bookmark1")
  (bookmark-set "default-bookmark1"))

(defun bookmark-set-default1 (pos)
  "Set default-bookmark1 at current position."
  (interactive "d")
  (bookmark-set "default-bookmark1"))

(defun bookmark-jump-default2 (pos)
  "Jump to default-bookmark2, then reset it to current position."
  (interactive "d")
  (bookmark-jump "default-bookmark2")
  (bookmark-set "default-bookmark2"))

(defun bookmark-set-default2 (pos)
  "Set default-bookmark2 at current position."
  (interactive "d")
  (bookmark-set "default-bookmark2"))


;; =====================================================================
;; Keybindings
;; =====================================================================

;; --- Navigation & Movement ---
(global-set-key [delete] 'delete-char)
(global-set-key (kbd "C-S-<right>") 'forward-word)
(global-set-key (kbd "C-S-<left>") 'backward-word)
(global-set-key (kbd "C-S-<up>") 'forward-paragraph)
(global-set-key (kbd "C-S-<down>") 'backward-paragraph)
(global-set-key [f5] 'goto-line)
(global-set-key (kbd "C-g") 'goto-line)
(global-set-key (kbd "C-M--") 'goto-last-change-reverse)
(global-set-key (kbd "C-S--") 'goto-last-change)
(global-set-key [S-home] 'move-beginning-of-line)
(global-set-key [S-end] 'move-end-of-line)
(global-set-key (kbd "M-[ h") 'move-beginning-of-line)
(global-set-key (kbd "M-[ f") 'move-end-of-line)
(global-set-key "%" 'match-paren)

;; --- Search & Replace ---
(define-key global-map [f3] 'isearch-forward)
(define-key isearch-mode-map [f3] 'isearch-repeat-forward)
(define-key global-map [C-f3] 'isearch-forward-regexp)
(define-key global-map [S-f3] 'isearch-backward)
(define-key isearch-mode-map [S-f3] 'isearch-repeat-backward)
(define-key global-map [C-S-f3] 'isearch-backward-regexp)
(global-set-key (kbd "C-S-f") 'deadgrep)
(global-set-key [f9] 'query-replace)
(global-set-key [C-f9] 'query-replace-regexp)
(global-set-key [S-f9] 'query-replace-reg-t)
(global-set-key [f10] 'replace-string)
(global-set-key [C-f10] 'replace-string-regexp)
(global-set-key [S-f10] 'replace-string-reg-t)

;; --- Bookmarks & Registers ---
(global-set-key [f1] 'bookmark-jump-default1)
(global-set-key [C-f1] 'bookmark-set-default1)
(global-set-key [f2] 'bookmark-jump-default2)
(global-set-key [C-f2] 'bookmark-set-default2)
(global-set-key [S-f2] 'bookmark-jump)
(global-set-key [S-C-f2] 'bookmark-set)
(global-set-key (kbd "C-x r d") 'bookmark-delete)
(global-set-key [S-f4] 'insert-register-t)

;; --- File & Buffer Management ---
(global-set-key "\C-o" 'find-file)
(global-set-key (kbd "C-n") 'find-file)
(global-set-key [C-f5] 'find-file_goto-line)
(global-set-key "\C-s" 'save-buffer)
(global-set-key (kbd "C-S-s") 'write-file)
(global-set-key [C-f4] 'kill-this-buffer)
(global-set-key (kbd "C-w") 'delete-window)
(global-set-key [C-f6] 'switch-to-buffer)
(global-set-key [S-f6] 'buffer-menu)
(global-set-key [C-tab] 'ibuffer)
(global-set-key (kbd "C-S-e") 'dired)
(global-set-key (kbd "C-x p") 'ido-dired)

;; --- Text Editing ---
(global-set-key (kbd "C-z") 'undo)
(global-set-key [C-backspace] 'backward-kill-word)
(global-set-key [C-delete] 'kill-word)
(global-set-key "\C-d" 'kill-whole-line)
(global-set-key (kbd "C-S-l") 'mc/mark-all-like-this)
(global-set-key (kbd "M-S-i") 'mc/edit-lines)
(global-set-key (kbd "C-\\") 'comment-or-uncomment-region)
(global-set-key (kbd "C-S-a") 'comment-box)
(global-set-key (kbd "C-S-[") 'hs-hide-block)
(global-set-key (kbd "C-S-]") 'hs-show-block)
(global-set-key (kbd "C-S-i") 'indent-region-or-buffer)
(global-set-key [C-space] 'completion-at-point)
(global-set-key (kbd "C-.") 'eglot-code-actions)

;; --- Development Tools ---
(global-set-key [f8] 'consult-flymake)
(global-set-key [S-f8] 'flymake-goto-prev-error)
(global-set-key [f12] 'xref-find-definitions)
(global-set-key [C-S-f10] 'xref-find-definitions)
(global-set-key [S-f12] 'xref-find-references)
(global-set-key (kbd "C-S-<space>") 'eldoc)
(global-set-key (kbd "C-S-o") 'imenu-list-smart-toggle)
(global-set-key (kbd "C-t") 'imenu)
(global-set-key (kbd "C-M-i") 'copilot-chat)
(global-set-key (kbd "C-S-M-i") 'copilot-chat-agent)

;; --- Shell & Terminal ---
(global-set-key [f7] 'comint-previous-matching-input-from-input)
(global-set-key [S-f7] 'comint-next-matching-input-from-input)
(global-set-key (kbd "C-S-`") 'eshell)

;; --- Window & Frame ---
(global-set-key [f6] 'other-window)
(global-set-key (kbd "C-l") 'crux-other-window-or-switch-buffer)
(global-set-key [f11] 'toggle-frame-fullscreen)
(global-set-key (kbd "C-x 5") 'ace-swap-window)
(global-set-key (kbd "C-x 6") 'rotate-split)
(global-set-key (kbd "M-z") 'visual-line-mode)

;; --- Application Management ---
(global-set-key [M-f4] 'save-buffers-kill-emacs)
(global-set-key (kbd "C-x M-c") #'kill-emacs)
(global-set-key (kbd "C-x C-c") (lambda ()
                                   "断开 client 连接（daemon 继续运行）。
非 daemon 模式保持原有关闭行为。"
                                   (interactive)
                                   (save-some-buffers)
                                   (if (daemonp)
                                       (delete-frame)
                                     (save-buffers-kill-emacs))))

;; --- Other ---
(global-set-key [mouse-3] 'mouse-buffer-menu)
(global-set-key (kbd "C-S-g") 'magit-status)
(global-set-key (kbd "C-S-v") 'markdown-live-preview-mode)
