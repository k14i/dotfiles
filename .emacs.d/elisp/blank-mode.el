;;; blank-mode --- Minor mode to visualize blanks (SPACE and TAB).

;; Copyright (C) 2000 Vinicius Jose Latorre

;; Author:     Vinicius Jose Latorre <vinicius@cpqd.com.br>
;; Maintainer: Vinicius Jose Latorre <vinicius@cpqd.com.br>
;; Keywords:   data, wp
;; Time-stamp: <2000/08/06 15:22:46 vinicius>
;; Version:    2.2
;; X-URL: http://www.cpqd.com.br/~vinicius/emacs/Emacs.html

;; This file is *NOT* (yet?) part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by the Free
;; Software Foundation; either version 2, or (at your option) any later
;; version.

;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
;; FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
;; more details.

;; You should have received a copy of the GNU General Public License along with
;; GNU Emacs; see the file COPYING.  If not, write to the Free Software
;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

;;; Commentary:

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Introduction
;; ------------
;;
;; This package is a minor mode to visualize blanks (SPACE and TAB).
;;
;; To use blank-mode, insert in your ~/.emacs:
;;
;;    (require 'blank-mode)
;;
;; Or:
;;
;;    (autoload 'blank-mode-on        "blank-mode"
;;      "Turn on blank visualization."   t)
;;    (autoload 'blank-mode-off       "blank-mode"
;;      "Turn off blank visualization."  t)
;;    (autoload 'blank-mode           "blank-mode"
;;      "Toggle blank visualization."    t)
;;    (autoload 'blank-mode-customize "blank-mode"
;;      "Customize blank visualization." t)
;;
;; For good performance, be sure to byte-compile blank-mode.el, e.g.
;;
;;    M-x byte-compile-file <give the path to blank-mode.el when prompted>
;;
;; This will generate blank-mode.elc, which will be loaded instead of
;; blank-mode.el.
;;
;; blank-mode was tested with GNU Emacs 20.6.1.
;;
;;
;; Using blank-mode
;; ----------------
;;
;; To activate blank-mode, type:
;;
;;    M-x blank-mode-on RET
;;
;; Or:
;;
;;    C-u 1 M-x blank-mode RET
;;
;; To deactivate blank-mode, type:
;;
;;    M-x blank-mode-off RET
;;
;; Or:
;;
;;    C-u 0 M-x blank-mode RET
;;
;; To toggle blank-mode, type:
;;
;;    M-x blank-mode RET
;;
;; To customize blank-mode, type:
;;
;;    M-x blank-mode-customize RET
;;
;; You can also bind `blank-mode', `blank-mode-on', `blank-mode-off' and
;; `blank-mode-customize' to some key, like:
;;
;;    (global-set-key "\C-c\C-a" 'blank-mode-on)
;;    (global-set-key "\C-c\C-e" 'blank-mode-off)
;;    (global-set-key "\C-c\C-t" 'blank-mode)
;;    (global-set-key "\C-c\C-c" 'blank-mode-customize)
;;
;;
;; Hooks
;; -----
;;
;; blank-mode has the following hook variables:
;;
;; `blank-mode-hook'
;;    It is evaluated always when blank-mode is turned on.
;;
;; `blank-load-hook'
;;    It is evaluated after blank-mode package is loaded.
;;
;;
;; Options
;; -------
;;
;; Below it's shown a brief description of blank-mode options, please, see the
;; options declaration in the code for a long documentation.
;;
;; `blank-space-face'		Face used to visualize SPACE.
;;
;; `blank-tab-face'		Face used to visualize TAB.
;;
;; `blank-verbose'		Non-nil means generate messages.
;;
;; `blank-chars'		Specify which kind of blank is visualized.
;;
;; `blank-space-chars'		Specify space characters.
;;
;; `blank-tab-chars'		Specify tab characters.
;;
;; `blank-priority'		Specify blank overlay priority.
;;
;; To set the above options you may:
;;
;; a) insert the code in your ~/.emacs, like:
;;
;;	 (setq blank-space-face 'underline)
;;
;;    This way always keep your default settings when you enter a new Emacs
;;    session.
;;
;; b) or use `set-variable' in your Emacs session, like:
;;
;;	 M-x set-variable RET blank-space-face RET underline RET
;;
;;    This way keep your settings only during the current Emacs session.
;;
;; c) or use customization, for example:
;;	 click on menu-bar *Help* option,
;;	 then click on *Customize*,
;;	 then click on *Browse Customization Groups*,
;;	 expand *Data* group,
;;	 expand *Blank* group
;;	 and then customize blank-mode options.
;;    Through this way, you may choose if the settings are kept or not when
;;    you leave out the current Emacs session.
;;
;; d) or see the option value:
;;
;;	 C-h v blank-space-face RET
;;
;;    and click the *customize* hypertext button.
;;    Through this way, you may choose if the settings are kept or not when
;;    you leave out the current Emacs session.
;;
;; e) or invoke:
;;
;;	 M-x blank-mode-customize RET
;;
;;    and then customize blank-mode options.
;;    Through this way, you may choose if the settings are kept or not when
;;    you leave out the current Emacs session.
;;
;;
;; Acknowledgements
;; ----------------
;;
;; Thanks to Pete Forman <pete.forman@westgeo.com> for indicating
;; whitespace-mode on XEmacs.
;;
;; Thanks to all who emailed comments.
;;
;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; code:


;; GNU Emacs
(or (fboundp 'set-window-redisplay-end-trigger)
    (defalias 'set-window-redisplay-end-trigger 'ignore))


;; XEmacs needs overlay emulation package
(eval-and-compile
  (and (let (case-fold-search)
	 (string-match "XEmacs\\|Lucid\\|Epoch" emacs-version))
       (not (require 'overlay))
       (error "`blank-mode' requires `overlay' package.")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; User Variables:


;;; Interface to the command system


(defgroup blank nil
  "Visualize blanks (SPACE and TAB)"
  :link '(emacs-library-link :tag "Source Lisp File" "blank-mode.el")
  :group 'wp
  :group 'data)


(defcustom blank-space-face 'blank-space-face
  "*Symbol face used to visualize SPACE."
  :type 'face
  :group 'blank)


(defface blank-space-face '((t (:background "LightGray")))
  "Face used to visualize SPACE.")


(defcustom blank-tab-face 'blank-tab-face
  "*Symbol face used to visualize TAB."
  :type 'face
  :group 'blank)


(defface blank-tab-face '((t (:inverse-video t)))
  "Face used to visualize TAB.")


(defcustom blank-verbose t
  "*Non-nil means generate messages."
  :type 'boolean
  :group 'blank)


(defcustom blank-chars 'tabs-and-spaces
  "*Specify which kind of blank is visualized.

Valid values are:

   'tabs-and-spaces     TABs and SPACEs are visualized.
   'tabs                only TABs are visualized.
   'spaces              only SPACEs are visualized.

Any other value is treated as `tabs-and-spaces'."
  :type '(radio :tag "Kind of Blank"
		(const tabs-and-spaces)
		(const tabs)
		(const spaces))
  :group 'blank)


(defcustom blank-space-chars " "
  "*Specify space characters.

If you're using `mule' package, it may exists other characters besides \" \"
that it should be considered space."
  :type '(string :tag "Space Chars")
  :group 'blank)


(defcustom blank-tab-chars "\t"
  "*Specify tab characters.

If you're using `mule' package, it may exists other characters besides \"\\t\"
that it should be considered tab."
  :type '(string :tag "Tab Chars")
  :group 'blank)


(defcustom blank-priority 0
  "*Specify blank overlay priority.

Higher integer means higher priority, so blank overlay will have precedence
over overlays with lower priority.  *Don't* use negative number."
  :type 'integer
  :group 'blank)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Macros I


(defmacro blank-message (&rest body)
  (` (and blank-verbose (interactive-p)
	  (message (,@ body)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Customization


;;;###autoload
(defun blank-mode-customize ()
  "Customize blank-mode options."
  (interactive)
  (customize-group 'blank))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; User commands


(defvar blank-mode nil)
(make-variable-buffer-local 'blank-mode)


(defvar blank-skip-chars nil)
(make-variable-buffer-local 'blank-skip-chars)


;;;###autoload
(defun blank-mode (&optional arg)
  "Toggle blank visualization.

If ARG is null, toggle blank visualization.
If ARG is a number and is greater than zero, turn on visualization; otherwise,
turn off visualization."
  (interactive "P")
  (if (if arg
	  (> (prefix-numeric-value arg) 0)
	(not blank-mode))
      (blank-mode-on)
    (blank-mode-off))
  (blank-message "Blank Mode is now %s." (if blank-mode "on" "off")))


;;;###autoload
(defun blank-mode-on ()
  "Turn on blank visualization."
  (interactive)
  (or (and (boundp 'blank-mode) blank-mode)
      (let ((inhibit-point-motion-hooks t))
	(setq blank-mode t
	      blank-skip-chars
	      (concat "^"
		      (cond ((eq blank-chars 'tabs)   blank-tab-chars)
			    ((eq blank-chars 'spaces) blank-space-chars)
			    (t (concat blank-space-chars blank-tab-chars)))))
	(blank-after-scroll-on (selected-window) (window-start))
	(run-hooks 'blank-mode-hook)
        (if (fboundp 'make-local-hook)
	    (make-local-hook 'after-change-functions))
	(add-hook 'after-change-functions 'blank-after-change-function t t)
        (if (fboundp 'make-local-hook)
	    (make-local-hook 'window-scroll-functions))
	(remove-hook 'window-scroll-functions 'blank-after-scroll-off t)
	(add-hook 'window-scroll-functions 'blank-after-scroll-on t t)
	(blank-message "Blank Mode is now on."))))


;;;###autoload
(defun blank-mode-off ()
  "Turn off blank visualization."
  (interactive)
  (and (boundp 'blank-mode) blank-mode
       (let ((inhibit-point-motion-hooks t))
	 (setq blank-mode nil)
	 (remove-hook 'after-change-functions 'blank-after-change-function t)
	 (remove-hook 'window-scroll-functions 'blank-after-scroll-on t)
	 (add-hook 'window-scroll-functions 'blank-after-scroll-off t t)
	 (blank-after-scroll-off (selected-window) (window-start))
	 (blank-message "Blank Mode is now off."))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Macros II (adapted from lazy-lock.el)


;; This is to preserve/protect things when modifying text properties.
(defmacro blank-save-buffer-state (&rest body)
  "Eval BODY restoring buffer state."
  `(save-excursion
     (save-restriction
       (save-match-data
	 (let ((modified (buffer-modified-p))
	       (buffer-undo-list t)
	       (inhibit-read-only t)
	       (inhibit-point-motion-hooks t)
	       before-change-functions
	       after-change-functions
	       deactivate-mark
	       buffer-file-name
	       buffer-file-truename
	       inhibit-quit)
	   (widen)
	   ,@body
	   (set-buffer-modified-p modified))))))

(put 'blank-save-buffer-state 'lisp-indent-function 0)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Internal functions


(defun blank-after-scroll-on (window window-start)
  (blank-save-buffer-state
    ;; Called from `window-scroll-functions'.
    ;; Visualize blanks on WINDOW from WINDOW-START following the scroll.
    (let ((end (window-end window t)))
      (cond
       ((text-property-not-all window-start end 'blank-mode t)
	(blank-add-prop window-start end))
       ((not (text-property-not-all (point-min) (point-max) 'blank-mode t))
	(remove-hook 'window-scroll-functions 'blank-after-scroll-on t))
       ))
    ;; A prior deletion that did not cause scrolling, followed by a scroll,
    ;; would result in an unnecessary trigger after this if we did not cancel
    ;; it now.
    (set-window-redisplay-end-trigger window nil)))


(defun blank-after-scroll-off (window window-start)
  (blank-save-buffer-state
    ;; Called from `window-scroll-functions'.
    ;; Don't visualize blanks on WINDOW from WINDOW-START following the
    ;; scroll.
    (let ((end (window-end window t)))
      (cond
       ((text-property-any window-start end 'blank-mode t)
	(blank-remove-prop window-start end))
       ((not (text-property-any (point-min) (point-max) 'blank-mode t))
	(remove-hook 'window-scroll-functions 'blank-after-scroll-off t))
       ))
    ;; A prior deletion that did not cause scrolling, followed by a scroll,
    ;; would result in an unnecessary trigger after this if we did not cancel
    ;; it now.
    (set-window-redisplay-end-trigger window nil)))


(defun blank-after-change-function (beg end oldlen)
  ;; Called from `after-change-functions'.
  ;; Visualize blanks from BEG to END.
  (blank-save-buffer-state
    ;; Rescan between start of lines enclosing the region.
    (goto-char beg)
    (beginning-of-line)
    (setq beg (point))
    (goto-char end)
    (forward-line 1)
    (blank-add-prop beg (point))))


(defun blank-add-prop (beg end)
  (goto-char beg)
  (let (match face)
    (while (progn
	     (skip-chars-forward blank-skip-chars end)
	     (< (point) end))
      (and (let ((char (char-to-string (following-char))))
	     (setq face (cond ((string-match char blank-space-chars)
			       (setq match blank-space-chars)
			       blank-space-face)
			      ((string-match char blank-tab-chars)
			       (setq match blank-tab-chars)
			       blank-tab-face)
			      (t
			       nil)
			      )))
	   (let ((the-beg (point))
		 (the-end (progn
			    (skip-chars-forward match end)
			    (point)))
		 overlay)
	     (let ((overlays (overlays-in the-beg the-end)))
	       (while overlays
		 (let ((ov (car overlays)))
		   (and (overlay-get ov 'blank-mode)
			(let ((oface (overlay-get ov 'face)))
			  (cond ((eq oface face)
				 (setq overlay  ov
				       overlays nil))
				((eq oface blank-space-face))
				((eq oface blank-tab-face))
				(t
				 (delete-overlay ov))))))
		 (setq overlays (cdr overlays))))
	     (if overlay
		 (move-overlay overlay the-beg the-end)
	       (setq overlay (make-overlay the-beg the-end))
	       (overlay-put overlay 'face face)
	       (overlay-put overlay 'blank-mode t))
	     (overlay-put overlay 'priority blank-priority))))
    (add-text-properties beg end '(blank-mode t))))


(defun blank-remove-prop (beg end)
  (let ((overlays (overlays-in beg end)))
    (while overlays
      (and (overlay-get (car overlays) 'blank-mode)
	   (delete-overlay (car overlays)))
      (setq overlays (cdr overlays))))
  (remove-text-properties beg end '(blank-mode nil)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(add-to-list 'minor-mode-alist '(blank-mode " Blank"))


(provide 'blank-mode)


(run-hooks 'blank-load-hook)


;;; blank-mode.el ends here
