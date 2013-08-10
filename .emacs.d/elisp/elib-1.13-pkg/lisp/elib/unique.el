;;; unique.el --- functions and commands to uniquify

;; Copyright (C) 1994 Simon Marshall.

;; Author: Simon Marshall <Simon.Marshall@mail.esrin.esa.it>
;; Keywords: unix unique
;; Version: 1.01

;; LCD Archive Entry:
;; unique|Simon Marshall|Simon.Marshall@mail.esrin.esa.it|
;; Functions and commands to uniquify lists or buffer text (cf. sort).|
;; 28-Jun-1994|1.01|~/misc/unique.el.Z|
;; The archive is archive.cis.ohio-state.edu in /pub/gnu/emacs/elisp-archive.

;;; This file is not part of GNU Emacs.

;;; This program is free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 2, or (at your option)
;;; any later version.

;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.

;;; You should have received a copy of the GNU General Public License
;;; along with GNU Emacs; see the file COPYING.  If not, write to
;;; the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:

;; Purpose:
;; 
;; This package provides functions to uniquify lists, and commands to uniquify
;; buffer text.

;; Provided are uniquification functions `unique' and `uniq'.  Their
;; differences and relative performances are described below.
;;
;; The function `unique' takes the list to be uniquified and a destructor
;; function as args.  This function takes an element and list as args.  It
;; returns the list minus occurrences of the element.  This destructor function
;; is called for each item in the list to be uniquified, with the rest of the
;; list, and `unique' is therefore polynomial (as a function of the square of
;; the length of the list, i.e., it is quadratic) iff the destructor function
;; never removes any items from the list.
;;
;; The function `uniq' takes the list to be uniquified and a comparator
;; function as args.  This function takes two elements.  It returns non-nil if
;; the two elements are equivalent, the latter duplicate is removed.  This
;; comparator function is called for each item in the list to be uniquified,
;; except the last, and `uniq' is therefore polynomial (as a function of the
;; length of the list, i.e., it is linear) iff the comparator function never
;; returns non-nil (no items are removed from the list).
;;
;; For example, the uniquification function `unique':
;;
;; (unique '("a" "b" "b" "b" "c" "d" "d" "e") 'delete)
;;      => ("a" "b" "c" "d" "e")
;;
;; Note that non-adjacent duplicate items are removed too:
;;
;; (unique '("foo" "bar" "is" "fubar" "as" "well" "as" "foo" "bar") 'delete)
;;      => ("foo" "bar" "is" "fubar" "as" "well")
;;
;; If you want to remove all but the last duplicate, reverse the list before
;; and after uniquification:
;;
;; (let ((list '("foo" "bar" "is" "fubar" "as" "well" "as" "foo" "bar")))
;;   (nreverse (unique (nreverse list) 'delete)))
;;      => ("is" "fubar" "well" "as" "foo" "bar")
;;
;; However, the uniquification function `uniq' only removes adjacent duplicate
;; items, like the Un*x command "uniq":
;;
;; (uniq '("foo" "bar" "is" "fubar" "as" "well" "as" "foo" "bar")
;;       'string-equal)
;;      => ("foo" "bar" "is" "fubar" "as" "well" "as" "foo" "bar")
;;
;; To work on non-adjacent duplicate items, you must sort the list first.
;; However, using `sort' changes the order of the list and is relatively slow:
;;
;; (let ((list '("foo" "bar" "is" "fubar" "as" "well" "as" "foo" "bar")))
;;   (uniq (sort list 'string-lessp) 'string-equal))
;;      => ("as" "bar" "foo" "fubar" "is" "well")
;;
;; So why is it provided?  Good question.  If the list is already sorted, and
;; most items are unique anyway, `uniq' is quicker than `unique'.  See below.
;;
;; With strings:
;;
;; For example, running these functions on the list of one-character strings
;; built from the file .../lisp/comint.el (89146 strings, 98 (0.11%) unique):
;;
;; `uniq'	6.0 s	(pre-sorted)	0.008 s (pre-uniqed pre-sorted)
;; `unique'	11.4 s			0.047 s	(pre-uniqued)
;; `sort'	43.8 s			0.013 s (pre-uniqed pre-sorted)
;;					0.017 s	(pre-uniqued)
;; Speedup:	1.9x	(0.23x incl. `sort')
;;
;; For example, running these functions on the list of word strings built from
;; the file .../lisp/comint.el (12727 words, 2034 (16.0%) unique):
;; 
;; `uniq'	0.78 s	(pre-sorted)	0.14 s (pre-uniqed pre-sorted)
;; `unique'	58.8 s			15.9 s	(pre-uniqued)
;; `sort'	4.80 s			0.440 s (pre-uniqed pre-sorted)
;;					0.638 s	(pre-uniqued)
;; Speedup:	75x	(10x incl. `sort')
;;
;; For example, running these functions on the list of lines built from
;; the file .../lisp/comint.el (2073 lines, 1736 (83.7%) unique):
;; 
;; `uniq'	0.14 s	(pre-sorted)	0.12 s (pre-uniqed pre-sorted)
;; `unique'	10.8 s			10.6 s	(pre-uniqued)
;; `sort'	0.65 s			0.356 s (pre-uniqed pre-sorted)
;;					0.509 s	(pre-uniqued)
;; Speedup:	77x	(14x incl. `sort')
;;
;; With numbers:
;;
;; For example, running these functions on a list of 1024 random integers in
;; the interval [0, 102400) (typically 99.5% unique):
;; 
;; `uniq'	0.066 s	(pre-sorted)
;; `unique'	0.841 s
;; `sort'	0.277 s
;; Speedup:	12.7x	(2.45x incl. `sort')
;;
;; For example, running these functions on a list of 5120 random integers in
;; the interval [0, 512000) (typically 99.5% unique):
;; 
;; `uniq'	0.336 s	(pre-sorted)
;; `unique'	18.85 s
;; `sort'	1.707 s
;; Speedup:	56x	(9.23x incl. `sort')
;;
;; For example, running these functions on a list of 10240 random integers in
;; the interval [0, 1024000) (typically 99.5% unique):
;; 
;; `uniq'	0.671 s	(pre-sorted)
;; `unique'	73.88 s
;; `sort'	3.759 s
;; Speedup:	110x	(16.7x incl. `sort')
;;
;; Note how `uniq' runs in approximately linear time w.r.t. the length of the
;; list (and `sort' is almost linear---probably n*log2(n)---see a book),
;; whereas `unique' runs in approximately polynomial (square) time.  Double the
;; length of the list, quadruple the evaluation time.  Therefore, if the list
;; is almost entirely unique, the speedup of `uniq' (sorting excluded) over
;; `unique' is almost the same as the increase in list size.
;;
;; From the above, we can see that rather than deciding when you should use
;; `uniq' rather than `unique' it is the other way around (wibble).  If (1) you
;; care about list order and/or (2) you know that hardly any items are unique,
;; then you should use `unique'.  Otherwise, use `uniq' and `sort'.

;; Provided are uniquification commands:
;;
;; `unique-lines' for the removal of duplicate lines, `unique-words' for words
;; and `unique-sentences' for sentences.  They can be invoked as extended
;; commands or bound to keys:
;;
;; M-x unique-lines
;;
;; (local-set-key "\C-cl" 'unique-lines)
;;
;; Typing C-c l invokes `unique-lines' on the currently selected region.

;; Installation:
;; 
;; To use, put in your package that uses these functions:
;;
;; (require 'unique)
;;
;; or autoload in your ~/.emacs the specific functions you require:
;;
;; (autoload 'unique "unique"
;;   "Uniquify LIST, deleting elements using PREDICATE.")
;; (autoload 'uniq "unique"
;;   "Uniquify LIST, comparing adjacent elements using PREDICATE.")
;;
;; (autoload 'unique-lines "unique" "Uniquify lines in region." t)
;; (autoload 'unique-words "unique" "Uniquify words in region." t)
;; (autoload 'unique-sentences "unique" "Uniquify sentences in region." t)

;; Feedback:
;;
;; This is hand written software.  Use it at your own risk.
;;
;; Please send me bug reports, bug fixes, and extensions, so that I can
;; merge them into the master source.
;;     - Simon Marshall (Simon.Marshall@mail.esrin.esa.it)
;; Don't forget the version number of the package.

;; History:
;;
;; - 1.00--1.01:
;;   Analysis of the performance of `uniq' (and `sort') vs. `unique'.
;;   Corrected Copyleft.

;; Guts of the list-processing code

(defun unique (list predicate)
  "Uniquify LIST, deleting elements using PREDICATE.
Return the list with subsequent duplicate items removed by side effects.
PREDICATE is called with an element of LIST and a list of elements from LIST,
and should return the list of elements with occurrences of the element removed.
This function will work even if LIST is unsorted.  See also `uniq'."
  (let ((list list))
    (while list
      (setq list (setcdr list (funcall predicate (car list) (cdr list))))))
  list)

;; Were this file in core, the following compiler macro means it could
;; replace font-lock-unique without any loss of performance. 
(define-compiler-macro unique (&whole form list predicate)
  (if (not (and (and (consp predicate)
                     (or (eq (car predicate) 'quote)
                         (eq (car predicate) 'function))
                     (symbolp (cadr predicate)))))
      form
    `(let ((list ,list))
      (let ((list list))
        (while list 
          (setq list (setcdr list (,(cadr predicate) (car list) (cdr list))))))
      list)))

(defun uniq (list predicate)
  "Uniquify LIST, comparing adjacent elements using PREDICATE.
Return the list with adjacent duplicate items removed by side effects.
PREDICATE is called with two elements of LIST, and should return non-nil if the
first element is \"equal to\" the second.
This function will only work as expected if LIST is sorted, as with the Un*x
command of the same name.  See also `sort' and `unique'."
  (let ((list list))
    (while list
      (while (funcall predicate (car list) (nth 1 list))
	(setcdr list (nthcdr 2 list)))
      (setq list (cdr list))))
  list)

(define-compiler-macro uniq (&whole form list predicate)
  (if (not (and (and (consp predicate)
                     (or (eq (car predicate) 'quote)
                         (eq (car predicate) 'function))
                     (symbolp (cadr predicate)))))
      form
    `(let ((list ,list))
      (let ((list list))
        (while (,(cadr predicate) (car list) (nth 1 list))
	(setcdr list (nthcdr 2 list)))
        (setq list (cdr list)))
      list)))

(defsubst delete-dups (list)
  "Destructively remove `equal' duplicates from LIST.
Store the result in LIST and return it.  LIST must be a proper list.
Of several `equal' occurrences of an element in LIST, the first
one is kept."
  (unique list #'equal))


;; Guts of the buffer-processing code

;; Might as well reuse as much code as we can.  This is always the first sort
;; function called.
(autoload #'sort-build-lists "sort")

(eval-when-compile
  (require 'sort))

(defvar unique-fold-case nil
  "*Non-nil if the buffer unique functions should ignore case.")

(defun unique-subr (nextrecfun endrecfun &optional startkeyfun endkeyfun)
  "General text unique routine to divide buffer into records and uniquify them.
Arguments are NEXTRECFUN ENDRECFUN and optional STARTKEYFUN ENDKEYFUN.

We divide the accessible portion of the buffer into disjoint pieces called
unique records (they are the same as sort records).  A portion of each unique
record (perhaps all of it) is designated as the unique key.  The records are
rearranged in the buffer by their unique keys.  The records may or may not be
contiguous.

The four arguments are functions to be called to move point across a unique
record.  They will be called many times from within unique-subr.

NEXTRECFUN is called with point at the end of the previous record.  It moves
point to the start of the next record.  It should move point to the end of the
buffer if there are no more records.  The first record is assumed to start at
the position of point when unique-subr is called.

ENDRECFUN is called with point within the record.  It should move point to the
end of the record.

STARTKEYFUN moves from the start of the record to the start of the key.  It may
return either a non-nil value to be used as the key, or else the key is the
substring between the values of point after STARTKEYFUN and ENDKEYFUN are
called.  If STARTKEYFUN is nil, the key starts at the beginning of the record.

ENDKEYFUN moves from the start of the unique key to the end of the unique key.
ENDKEYFUN may be nil if STARTKEYFUN returns a value or if it would be the
same as ENDRECFUN."
  ;; Heuristically try to avoid messages if uniquifying a small amt of text.
  (let ((messages (> (- (point-max) (point-min)) 10000))
	(case-fold-search unique-fold-case) (unique-lists ()))
    (save-excursion
      (if messages (message "Finding unique keys..."))
      (setq unique-lists (nreverse (sort-build-lists nextrecfun endrecfun
						     startkeyfun endkeyfun)))
      (if (null unique-lists)
	  (if messages (message "Finding unique keys...none found"))
	(if messages (message "Uniquifying records..."))
	(setq unique-lists (unique unique-lists
				   (if (consp (car (car unique-lists)))
				       'unique-delete-buffer-substrings
				     'delete)))
	(if messages (message "Reordering buffer..."))
	(unique-reorder-buffer unique-lists)
	(if messages (message "Reordering buffer...done"))))))

(defun unique-delete-buffer-substrings (a blist)
  ;; Return BLIST without occurrences of the text referred to by unique key A.
  (let ((bl blist)
	(unique-equal-buffer-substrings
	 ;; Is the text refered to by the unique keys A and B the same?
	 (function (lambda (a b) (zerop (compare-buffer-substrings
					 nil (car (car a)) (cdr (car a))
					 nil (car (car b)) (cdr (car b))))))))
    (while bl
      (while (funcall unique-equal-buffer-substrings a (nth 1 bl))
	(setcdr bl (nthcdr 2 bl)))
      (setq bl (cdr bl)))
    (if (funcall unique-equal-buffer-substrings a (car blist))
	(cdr blist)
      blist)))

(defun unique-reorder-buffer (unique-lists)
  (let ((inhibit-quit t)
	(min (point-min)) (max (point-max)))
    ;; Make sure insertions done for reordering
    ;; do not go after any markers at the end of the uniquified region,
    ;; by inserting a space to separate them.
    (goto-char (point-max))
    (insert-before-markers " ")
    (narrow-to-region min (1- (point-max)))
    (while unique-lists
      (goto-char (point-max))
      (insert-buffer-substring (current-buffer)
			       (nth 1 (car unique-lists))
			       (1+ (cdr (cdr (car unique-lists)))))
      (setq unique-lists (cdr unique-lists)))
    ;; Delete the original copy of the text.
    (delete-region min max)
    ;; Get rid of the separator " ".
    (goto-char (point-max))
    (narrow-to-region min (1+ (point)))
    (delete-region (point) (1+ (point)))))

;;; Commands

(defun unique-lines (beg end) 
  "Uniquify lines in region.
Called from a program, there are two arguments: BEG and END (the region)."
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region beg end)
      (goto-char (point-min))
      (unique-subr 'forward-line 'end-of-line))))

(defun unique-words (beg end)
  "Uniquify words in region.
Called from a program, there are two arguments: BEG and END (the region)."
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region beg end)
      (goto-char (point-min))
      (unique-subr (function (lambda () (skip-chars-forward "\n \t\f")))
		   (function (lambda () (forward-word 1)))))))

(defun unique-sentences (beg end)
  "Uniquify sentences in region.
Called from a program, there are two arguments: BEG and END (the region)."
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region beg end)
      (goto-char (point-min))
      (unique-subr (function (lambda () (skip-chars-forward "\n \t\f")))
		   (function (lambda () (forward-sentence 1)
			       (or (zerop (skip-chars-forward "\n \t\f"))
				   (backward-char 1))))))))

;;; Functions for emacs-18

(or (fboundp 'delete)
    (defun delete (elt list)
      "Delete by side effect any occurrences of ELT as a member of LIST.
The modified LIST is returned.  Comparison is done with `equal'.
If the first member of LIST is ELT there is no way to remove it by side effect;
therefore, write `(setq foo (delete element foo))'
to be sure of changing the value of `foo'."
      (let ((list list))
	(while list
	  (while (equal elt (nth 1 list))
	    (setcdr list (nthcdr 2 list)))
	  (setq list (cdr list))))
      (if (equal elt (car list)) (cdr list) list)))

;; Maybe one day `compare-buffer-substrings' too.  But then again, maybe not.
(or (fboundp 'compare-buffer-substrings)
    (defun compare-buffer-substrings (buffer1 start1 end1 buffer2 start2 end2)
      "In GNU Emacs 19 this function compares two substrings of two buffers."
      (let ((version (emacs-version)))
	(error "Function `compare-buffer-substrings' is not provided in %s"
	       (substring version 0 (string-match "\\.[0-9]+ " version))))))

(provide 'unique)

;;; unique.el ends here
