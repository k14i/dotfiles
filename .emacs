; .emacs
; http://www.gnu.org/software/emacs/manual/html_node/emacs/Init-File.html


;###########################################################
;# System Settings
;###########################################################

; Initializing .emacs ==================
(let ((toplevel (expand-file-name "~/.emacs.d/elisp")))
  (mapcar '(lambda (file)
    (and (not (string-match "\\.+$" file))
      (file-directory-p file)
      (setq load-path (cons file load-path))))
    (directory-files toplevel t))
  (setq load-path (cons toplevel load-path)))

;(setq load-path (cons (expand-file-name "~/.emacs.d/elisp") load-path))
(require 'install-elisp)
(setq install-elisp-repository-directory (expand-file-name "~/.emacs.d/elisp"))

;(byte-recompile-directory (expand-file-name "~/.emacs.d/elisp"))
;(load (expand-file-name "~/.emacs.d/elisp"))
; =====================================

; i18n ================================
;(require 'ucs-normalize)
;(set-file-name-coding-system 'utf-8-hfs)
;(setq locale-coding-system 'utf-8-hfs)
; =====================================

; Byte-compiling ======================
(add-hook 'kill-emacs-hook
  (lambda ()
    (if (file-newer-than-file-p "~/.emacs" "~/.emacs.elc")
      (progn
        (require 'bytecomp)
        (displaying-byte-compile-warnings
          (unless (byte-compile-file "~/.emacs")
            (signal nil nil)))))))
; =====================================

; Backup and saving ===================
;;;; Inhibit creating backup files --------
(setq backup-inhibited t)
;;;; Auto saving --------
(setq auto-save-default nil)
;(setq auto-save-list-file-prefix "~/.emacs.d/auto-save-list/.saves-")
;(setq temporary-file-directory "~/.emacs.d/tmp")
; =====================================

; Version control =====================
(setq vc-follow-symlinks t)
(setq vc-suppress-confirm t)
(setq vc-command-messages t)
; =====================================


;###########################################################
;# Input Settings
;###########################################################

; Tab ===================================
(setq-default indent-tabs-mode nil)
(setq tab-width 2)
;(setq-default tab-width 2)
;(setq default-tab-width 2)
;(setq tab-stop-list '(2 4 8 12 16 20 24 28 32 36 40 44 48 52 56 60
;                      64 68 72 76 80 84 88 92 96 100 104 108 112 116 120))

(defun set-aurora-tab-width (num &optional local redraw)
  (interactive "nTab Width: ")
  (when local
    (make-local-variable 'tab-width)
    (make-local-variable 'tab-stop-list))
  (setq tab-width num)
  (setq tab-stop-list ())
  (while (<= num 256)
    (setq tab-stop-list `(,@tab-stop-list ,num))
    (setq num (+ num tab-width)))
  (when redraw (redraw-display)) tab-width)
(set-aurora-tab-width (setq default-tab-width (setq-default tab-width 2)))

;(setq indent-line-function 'insert-tab)

; Key assigns ==========================
;;;; Assign Meta to Option --------
(setq mac-option-modifier 'meta)
;(setq mac-option-modifier 'alt)
;(setq mac-command-modifier 'meta)

;(require 'mark-lines)
;(global-set-key [(control x) (control p)] 'mark-lines-previous-line)
;(global-set-key [(control x) (control n)] 'mark-lines-next-line)

;;;; C-h "backspace" --------
(global-set-key "\C-h" 'backward-delete-char)

;;;; C-x e "Use electric-buffer-list when switching a buffer" --------
(global-set-key "\C-xe" 'electric-buffer-list)

;;;; C-x % "Jump between brackets" --------
(progn
  (defvar com-point nil
    "Remember com point as a marker. \(buffer specific\)")
  (set-default 'com-point (make-marker))
  (defun getcom (arg)
    "Get com part of prefix-argument ARG."
    (cond ((null arg) nil)
      ((consp arg) (cdr arg))
      (t nil)))
  (defun paren-match (arg)
    "Go to the matching parenthesis."
    (interactive "P")
    (let ((com (getcom arg)))
      (if (numberp arg)
        (if (or (> arg 99) (< arg 1))
          (error "Prefix must be between 1 and 99.")
          (goto-char
            (if (> (point-max) 80000)
              (* (/ (point-max) 100) arg)
              (/ (* (point-max) arg) 100)))
          (back-to-indentation))
        (cond ((looking-at "[\(\[{]")
          (if com (move-marker com-point (point)))
          (forward-sexp 1)
            (if com
              (paren-match nil com)
              (backward-char)))
          ((looking-at "[])}]")
            (forward-char)
            (if com (move-marker com-point (point)))
            (backward-sexp 1)
            (if com (paren-match nil com)))
            )
          (t (error ""))))))
  (define-key ctl-x-map "%" 'paren-match)

;;;; C-t, M-C-t "Switch buffers quickly" --------
(defun previous-buffer ()
  "Select previous window."
  (interactive)
  (bury-buffer))
(defun backward-buffer ()
  "Select backward window."
  (interactive)
  (switch-to-buffer
  (car (reverse (buffer-list)))))
(global-set-key "\C-t"    'previous-buffer)
(global-set-key "\M-\C-t" 'backward-buffer)
; =====================================


;###########################################################
;# Display Settings
;###########################################################

; Mouse scrolling ======================
;(define-key global-map 'button4
;   '(lambda (&rest args)
;      (interactive)
;      (let ((curwin (selected-window)))
;           (select-window (car (mouse-pixel-position)))
;           (scroll-down 5)
;           (select-window curwin))))
;(define-key global-map 'button5
;   '(lambda (&rest args)
;      (interactive)
;      (let ((curwin (selected-window)))
;           (select-window (car (mouse-pixel-position)))
;           (scroll-up 5)
;           (select-window curwin))))

;(defvar wheel-scroll-ratio 0.5)
;(defun wheel-scroll-count (window)
;  (ceiling (* wheel-scroll-ratio
;             (float (window-height window)))))
;(defun wheel-scroll-window (event cmd)
;  (let ((window (event-window event)))
;       (if window
;         (save-selected-window
;           (select-window window t)
;           (funcall cmd (wheel-scroll-count window))))))
;
;(defun wheel-scroll-up (event)
;  (interactive "e")
;  (wheel-scroll-window event 'scroll-up))
;(defun wheel-scroll-down (event)
;  (interactive "e")
;  (wheel-scroll-window event 'scroll-down))
;(global-set-key 'button4 'wheel-scroll-down)
;(global-set-key 'button5 'wheel-scroll-up)
; =====================================

; Startup Messages ====================
;;;; Hide startup messages --------
(setq inhibit-startup-message t)
;(setq initial-scratch-message "")
; =====================================

; Buffer Control ======================
;;;; Enable narrow --------
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
;;;; Display the full path or buffer name on the title bar --------
(defvar dired-mode-p nil)
(add-hook 'dired-mode-hook
  (lambda ()
    (make-local-variable 'dired-mode-p)
    (setq dired-mode-p t)))
(setq frame-title-format-orig frame-title-format)
(setq frame-title-format '((buffer-file-name "%f"
  (dired-mode-p default-directory
    mode-line-buffer-identification))))
;;;; Limit with iswitchb --------
(add-hook 'iswitchb-define-mode-map-hook
  (lambda ()
    (define-key iswitchb-mode-map "\C-o" 'iswitchb-shrink-buflist)))
(defun iswitchb-shrink-buflist ()
  (interactive)
  (setq iswitchb-buflist iswitchb-matches)
  (erase-buffer))
; =====================================

; Window Control ======================
;;;; Resize windows when completing file name in C-hv --------
(temp-buffer-resize-mode t)

(defun my-other-window ()
  ""
  (interactive)
  (other-window 1)
  (let (( max-width (truncate (* (frame-width) 0.65))))
    (if ( < (window-width) max-width)
      (enlarge-window-horizontally (- max-width (window-width))))))
; =====================================

; Other Display Options ===============
;;;; Display date and time --------
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(setq display-time-string-forms
  '(month "/" day "(" dayname ") " 24-hours ":" minutes))
(display-time-mode 1)

(setq calendar-latitude 35.0)
(setq calendar-longitude 139.0)
(setq calendar-time-display-form
  '(24-hours ":" minutes
     (if time-zone "(") time-zone (if time-zone ")" )))

;;;; Display battery status --------
;(display-battery-mode 1)

;;;; Display column number --------
(column-number-mode t)

;;;; Visualize blanks (SPACE and TAB)
(require 'blank-mode)

;;;; Line numbering --------
; http://www.emacswiki.org/LineNumbers
(line-number-mode t)
(require 'linum)
(setq linum-format "%4d \u2502")
;(setq linum-format "%4d")
(global-linum-mode)
; =====================================

; Others ==============================
;;;; Scroll just one line out the screen --------
(setq scroll-conservatively 1)

;;;; Enable moving cursole in a long row --------
(global-set-key "\C-p" 'previous-window-line)
(global-set-key "\C-n" 'next-window-line)
(global-set-key [up] 'previous-window-line)
(global-set-key [down] 'next-window-line)
(defun previous-window-line (n)
  (interactive "p")
  (let ((cur-col
       (- (current-column)
         (save-excursion (vertical-motion 0) (current-column)))))
           (vertical-motion (- n))
    (move-to-column (+ (current-column) cur-col)))
  (run-hooks 'auto-line-hook))
(defun next-window-line (n)
  (interactive "p")
  (let ((cur-col
       (- (current-column)
         (save-excursion (vertical-motion 0) (current-column)))))
           (vertical-motion n)
    (move-to-column (+ (current-column) cur-col)))
  (run-hooks 'auto-line-hook))

;;;; Show Directory Tree --------
; tree-mode.el -- A mode to manage tree widgets
; http://www.emacswiki.org/emacs/tree-mode.el
(require 'tree-mode)
; windata.el -- convert window configuration to list
; http://www.emacswiki.org/emacs/windata.el
(require 'windata)
; dirtree.el -- Directory tree views for Emacs
; https://github.com/zkim/emacs-dirtree
(require 'dirtree)
(autoload 'dirtree "dirtree" "Add directory to tree view" t)
(global-set-key "\C-o" 'dirtree-show)

;;;; Imenu Mode
; http://emacswiki.org/emacs/ImenuMode
; imenu-tree.el --- A mode to view imenu using tree-widget
(add-hook 'org-mode-hook
  (lambda()
    (require 'imenu-tree)))
(global-set-key (kbd "M-h") 'imenu-tree)

; =====================================


;###########################################################
;# Highlighting
;###########################################################

;;;; Coloring in c-mode etc. --------
(global-font-lock-mode t)
(setq font-lock-support-mode 'jit-lock-mode)

;;;; Highliting a line --------
;; Standard Library 'hl-line.el'
;; GnuEmacs version 21 has library 'hl-line.el', which provide
;; a local and a global minor mode for highlighting the current line.
;(require 'hl-line)
;(global-hl-line-mode 1)

;; HighlineMode
;; http://www.emacswiki.org/emacs/HighlineMode
;; This package is a minor mode to highlight the current line in buffer.
(require 'highline)
;(highline-mode)

;; highlight-current-line.el --- highlight line where the cursor is.
;; http://emacswiki.org/emacs/highlight-current-line.el
(require 'highlight-current-line)
;; If you want to mark only to the end of line:
;(highlight-current-line-whole-line-on nil)
;; switch highlighting on
;(highlight-current-line-on t)
;; Ignore no buffer
(setq highlight-current-line-ignore-regexp nil) ; or set to ""
;; alternate way to ignore no buffers
(fmakunbound 'highlight-current-line-ignore-function)
;; Ignore more buffers
(setq highlight-current-line-ignore-regexp
  (concat "Dilberts-Buffer\\|"
    highlight-current-line-ignore-regexp))
;(highlight-current-line-set-fg-color "black")
(highlight-current-line-set-bg-color "black")

;;;; Highlighting when searching --------
(setq transient-mark-mode t)
(setq search-highlight t)
(setq query-replace-highlight t)

;;;; Emphasize Brackets --------
(and (or window-system (eq emacs-major-version '21))
  (locate-library "mic-paren")
  (autoload 'paren-activate "mic-paren" nil t)
  (setq paren-match-face 'bold paren-sexp-mode t)
)

;;;; Highlighting whitespaces like tabs, 2-byte space and spaces or tabs in front of \n --------
(defface my-face-b-1 '((t (:background "gray"))) nil)
(defface my-face-b-2 '((t (:background "gray26"))) nil)
(defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)

(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
    major-mode
    '(("\t" 0 my-face-b-2 append)
       ("　" 0 my-face-b-1 append)
       ("[ \t]+$" 0 my-face-u-1 append))))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)

;;;; Delete whitespaces at the end of lines --------
(defun ys:trim-whitespaces () "Trim excess whitespaces."
  (interactive "*")
  (let ((key (read-char "Convert spaces?: (t)abify (u)ntabify (n)o"))
        (reg (and transient-mark-mode mark-active)))
       (save-excursion
         (save-restriction
           (if reg (narrow-to-region (region-beginning) (region-end)))
           (goto-char (point-min))
           (while (re-search-forward "[ \t]+$" nil t) (replace-match "" nil nil))
           (if reg nil (goto-char (point-max)) (delete-blank-lines))
           (cond ((= key ?t) (tabify (point-min) (point-max)))
                 ((= key ?u) (untabify (point-min) (point-max)))))))
  (deactivate-mark))

;;;; Elixir mode --------
(require 'elixir-mode)


;###########################################################
;# Assist Coding
;###########################################################

;;;; magic comment --------
(defun ruby-insert-magic-comment-if-needed ()
  "Insert a magic comment refering coding-system in the buffer."
  (when (and (eq major-mode 'ruby-mode)
             (find-multibyte-characters (point-min) (point-max) 1))
        (save-excursion
          (goto-char 1)
          (when (looking-at "^#!")
            (forward-line 1))
          (if (re-search-forward "^#.+coding" (point-at-eol) t)
              (delete-region (point-at-bol) (point-at-eol))
              (open-line 1))
          (let* ((coding-system (symbol-name buffer-file-coding-system))
                 (encoding (cond ((string-match "japanese-iso-8bit\\|euc-j" coding-system)
                                    "euc-jp")
                                  ((string-match "shift.jis\\|sjis\\|cp932" coding-system)
                                    "shift_jis")
                                  ((string-match "utf-8" coding-system)
                                    "utf-8"))))
                (insert (format "# -*- coding: %s -*-" encoding))))))
(add-hook 'before-save-hook 'ruby-insert-magic-comment-if-needed)

;;;; Create macro when detecting repeated operations --------
;(require 'dmacro)

;;;; ASCII code display --------
(require 'ascii)
(setq ascii-window-size 6)

;;;; Ignore case in completion --------
;(completion-ignore-case t)
(if (fboundp 'partial-completion-mode)
    (partial-completion-mode t))

;;;; Delete white spaces --------
(defun trim-buffer ()
  "Delete excess white space."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "[ \t]+$" nil t)
      (replace-match "" nil nil))
    (goto-char (point-max))
    (delete-blank-lines)))

;;;; auto-complete --------
;(require 'auto-complete)
;(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/auto-complete"))
;(global-auto-complete-mode t)
;(add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/auto-complete/ac-dict")
;(add-to-list 'ac-dictionary-directories (expand-file-name "~/.emacs.d/elisp/auto-complete/ac-dict"))
;(require 'auto-complete-config)
;(ac-config-default)

;;;; RSense --------
;(setq rsense-home (expand-file-name "~/lib/rsense-0.3"))
;(add-to-list 'load-path (concat rsense-home "/etc"))
;(require 'rsense)

;;;; rcodetools --------
;(require 'rcodetools)
;(setq rcodetools-home "/Library/Ruby/Gems/1.8/gems/rcodetools-0.8.5.0")
;(add-to-list 'load-path (concat rcodetools-home "/"))
;(require 'anything-rcodetools)
;(define-key ruby-mode-map "\C-cl" 'rct-complete-symbol)
;(define-key ruby-mode-map "\C-cx" 'xmpfilter)

;;;; Ruby -------

;;;;;;;; ruby-mode -------
(autoload 'ruby-mode "ruby-mode" "Major mode for ruby files" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))

;(autoload 'ruby-mode "ruby-mode"
;  "Mode for editing ruby source files" t)
;(setq auto-mode-alist
;  (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
;(setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
;  interpreter-mode-alist))
;;;;;;;; ruby-style -------
(require 'ruby-style)
(add-hook 'c-mode-hook 'ruby-style-c-mode)
(add-hook 'c++-mode-hook 'ruby-style-c-mode)
;;;;;;;; inf-ruby -------
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook '(lambda () (inf-ruby-keys)))
;;;;;;;; ruby-electric -------
(require 'ruby-electric)
;;;;;;;; rdoc-mode -------
(require 'rdoc-mode)
;;;;;;;; rubydb3x -------
;(require 'rubydb3x)
;;;;;;;; rubydb2x -------
;(require 'rubydb2x)


;(setq load-path (append ( list (expand-file-name "~/.emacs.d/elisp/ruby") load-path)))
;
;(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files" t)
;(setq auto-mode-alist (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
;(setq interpreter-mode-alist (append '(("ruby" . ruby-mode)) interpreter-mode-alist))
;(autoload 'run-ruby "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")
;(add-hook 'ruby-mode-hook '(lambda () (inf-ruby-keys)))
;
;(require 'ruby-mode)
;(defun ruby-mode-set-encoding () ())
;(require 'ruby-electric)
;(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))
;
;(autoload 'rubydb "rubydb3x" "run rubydb on program file in buffer *gud-file*. the directory co;ntaining file becomes the initial working directory and source-file directory for your debugger;." t)
;
;(require 'ruby-block)
;(ruby-block-mode t)
;(setq ruby-block-highlight-toggle t)

;;;; Rails -------
;(setq load-path (cons "~/.emacs.d/rails" load-path))
;(require 'rails)

;(setq load-path (append ( list (expand-file-name "~/.emacs.d/elisp/emacs-rails") load-path)))
;(defun try-complete-abbrev (old)
;  (if (expand-abbrev) t nil))
;(setq hippie-expand-try-functions-list
;      '(try-complete-abbrev
;         try-complete-file-name
;         try-expand-dabbrev))
;(setq rails-use-mongrel t)
;(require 'cl)
;(require 'rails)

;;;; ECB --------
;(setq load-path (cons (expand-file-name "~/.emacs.d/elisp/ecb-2.32") load-path))
;(load-file "~/.emacs.d/elisp/cedet-1.0pre3/common/cedet.el")
;(setq semantic-load-turn-useful-things-on t)
;(require 'ecb)
;(setq ecb-tip-of-the-day nil)
;(setq ecb-windows-width 0.25)
;(defun ecb-toggle ()
;  (interactive)
;  (if ecb-minor-mode
;    (ecb-deactivate)
;    (ecb-activate)))
;(global-set-key [f2] 'ecb-toggle)

;;;; Sphinx --------
;(require 'rst)
;(setq auto-mode-alist
;      (append '(("\\.rst$" . rst-mode)
;                ("\\.rest$" . rst-mode)) auto-mode-alist))
;(setq frame-background-mode 'dark)
;(add-hook 'rst-mode-hook '(lambda() (setq indent-tabs-mode nil)))


;###########################################################
;# IDE
;###########################################################

;; Rinari - Rinari Is Not A Ruby IDE ===
;; https://github.com/eschulte/rinari
;;;;; Interactively Do Things (highly recommended, but not strictly required)
;(require 'ido)
;(ido-mode t)
;;;;; Rinari
;(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/ruby/rinari"))
;(require 'rinari)

; JDEE ================================
;;;; cedet
;;(load-library "cedet")
;(load-library "~/.emacs.d/elisp/cedet/common/cedet.el")
;(global-ede-mode 1)
;;(semantic-mode 1)
;
;(setenv "JAVA_HOME" "/Library/Java/Home")
;(setenv "ANT_HOME" "/usr/share/java/ant-1.8.2")
;(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/jdee/lisp"))
;(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/cedet/common"))
;(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/cedet/semantic"))
;(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/cedet/eieio"))
;(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/cedet/speedbar"))
;(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/cedet/cogre"))
;(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/cedet/ede"))
;(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/cedet/srecode"))
;(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/elib/lisp/elib"))
;
;(require 'cedet)
;(require 'jde)
;(setq compilation-window-height 8)
;
;(require 'jde-ant)
;(setq jde-ant-enable-find t)
;(setq jde-ant-home "/usr/share/java/ant-1.8.2")
;(setq jde-ant-program "/usr/bin/ant")
;(setq jde-ant-read-target t)
;(setq jde-build-function (quote (jde-ant-build)))
; =====================================


;###########################################################
;# Notification
;###########################################################

;; Enotify: a networked notification system for emacs =======
;; https://github.com/laynor/enotify
;; http://www.emacswiki.org/emacs/Enotify
;(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/enotify"))
;(require 'enotify)
;(enotify-minor-mode t)


;###########################################################
;# Applications on Emacs
;###########################################################

;;;; emacs-w3m --------
;(require 'w3m-load)
;(setq w3m-key-binding 'info)


;###########################################################
;# Experimantal Features
;###########################################################

;(iswitchb-default-keybindings)
;(resize-minibuffer-mode)
;(replace-string (concat "ret" "run") "return")

