;; (error "Don't use this!")
; On db43* machines, use emacs alias
; GNU Emacs 22.3.1 (i386-mingw-nt5.1.2600) of 2008-09-06 on SOFT-MJASON
; GNU Emacs 21.3.1 (x86_64-redhat-linux-gnu, X toolkit, Xaw3d scroll bars) of 2006-08-15 on mehak.karan.org
(message "Starting in my .emacs ~bbasaran/.emacs")
(defvar *emacs-load-start* (current-time))

(defun myfiles ()
  "Open common files I need"
  (load "~bbasaran/folder/emacs/files.el"))

;;(require 'cl) ; common lisp? needed for destructuring-bind

(defun mystuff ()
  "Loads my init stuff"
  (load "~bbasaran/folder/emacs/init.el"); # also loads bunch of others like ~bbasaran/folder/emacs/lib/custom.el

  (setq custom-file "~bbasaran/folder/emacs/custom.el")
  (load custom-file)
  ; last line
  )
(defun my_custom ()
  "Open the file only, but not load it"
  (message "Did we skip my customization")
  (find-file-other-window "~bbasaran/folder/emacs/custom.el"))
(let ((to_load_my_custom_or_not t)) ; # nil or t
  (cond (to_load_my_custom_or_not (mystuff))
	(t (my_custom))))

;;(message "My .emacs loaded in %ds" 
;;	 (cl-destructuring-bind (hi lo ms) (current-time) (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*)))))

(defvar *emacs-load-start2* (current-time))

(if (equal (getenv "USER") "bbasaran")
    (let ((to_load_files_or_not nil)) ; # nil or t
      (cond (to_load_files_or_not (myfiles))
	    (t (find-file-other-window "~/.emacs")))))
;;(message "My files loaded in %ds" 
;;	 (destructuring-bind (hi lo ms) (current-time) (- (+ hi lo) (+ (first *emacs-load-start2*) (second *emacs-load-start2*)))))


;;
;; python support is internal :-) Upon load of a .py file:
;; Local value of py-indent-offset set to 4
;; Using the CPython shell
;(find-file "~/helix/ws/tot/code/helix/PyHelix/Directives.py")

;;
;; P4 from ~/folder/emacs/path/p4.el
;;
;; C-x p used to be: (emil-previous-window)
;; in ~/folder/emacs/lib/custom.el
;; (p4-maybe-start-update-statuses) used to use copy-list. Now using copy-sequence..
(add-to-list 'load-path "/u/bbasaran/folder/emacs/path")
(require `p4)

;;
;; CSCOPE
;; see: ~/helix/ws/tot/code/CSCOPE
(require 'xcscope)
(setq cscope-do-not-update-database t)
(cscope-set-initial-directory "~/helix/ws/tot/code/")
;(find-file "~/helix/ws/tot/code/helix/Helix/HelixMain.cpp")
;(find-file "~/helix/ws/tot/code/santana/dloBase/src/dlo.h")

;; From: http://stackoverflow.com/questions/3124567/tags-in-emacs-with-a-large-codebase
(defun hide-cscope-buffer ()
  "Turn off the display of cscope buffer"
   (interactive)
   (if (not cscope-display-cscope-buffer)
       (progn
         (set-variable 'cscope-display-cscope-buffer t)
         (message "Turning ON display of cscope results buffer."))
     (set-variable 'cscope-display-cscope-buffer nil)
     (message "Toggling OFF display of cscope results buffer.")))

(global-set-key [f9] 'cscope-find-this-symbol)
(global-set-key [f10] 'cscope-find-global-definition-no-prompting)
(global-set-key [f11] 'cscope-find-functions-calling-this-function)
(global-set-key [f12] 'cscope-find-this-file)
;;(global-set-key (kbd "C-t") 'cscope-pop-mark)
;;(global-set-key (kbd "C-n") 'cscope-next-symbol)
;;(global-set-key (kbd "C-p") 'cscope-prev-symbol)
;;(global-set-key (kbd "C-b") 'hide-cscope-buffer)
(global-set-key [S-f7] 'cscope-next-file)
(global-set-key [S-f8] 'cscope-prev-file)
(global-set-key [S-f9] 'cscope-find-this-text-string)
(global-set-key [S-f10] 'cscope-find-global-definition)
(global-set-key [S-f11] 'cscope-find-egrep-pattern)
(global-set-key [S-f12] 'cscope-find-files-including-file)


; instead of C-x 5 o
(global-set-key (kbd "C-j") (quote other-frame))

; (fset 'bb-from-cvs-update-to-ediff
;   [?\C-x ?c return ?\C-x ?v ?~ return ?\C-x ?\C-d return return (switch-frame #<frame  *Minibuf-1* 0xcd7a50\ >) ?\C-x ?\C-o ?n (switch-frame #<frame  *Minibuf-1* 0xcd7a50\ >) (switch-frame #<frame Ediff 0x1aa78c0\ >) ?n (switch-frame #<frame  *Minibuf-1* 0xcd7a50\ >) (switch-frame #<frame Ediff 0x1aa78c0\ >) (switch-frame #<frame  *Minibuf-1* 0xcd7a50\ >)])

; end of .emacs

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

; make a func: (shell-command "find . -name Root -path '*/CVS/*' -print | xargs sed -i 's/magma/remote/'" nil nil)
(custom-set-variables
 '(load-home-init-file t t))
(custom-set-faces)
