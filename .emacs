;; This is GNU Emacs 24.3.1 (i386-mingw-nt6.1.7601) of 2013-03-17 on MARVIN
;; HOME var set to: ~/
;;   c:/Users/bbasaran/Documents
;;   c:\Users\bbasaran\Documents

(defun mystuff ()
  "Loads my init stuff"
  (load "~/folder/emacs/init.el"); # also loads ~/folder/emacs/lib/.xemacs/custom.elc
  (setq custom-file "~/folder/emacs/custom.el")
  (load custom-file))
(mystuff)
(cd "~/")

(add-to-list 'load-path "c:/users/bbasaran/Documents/folder/emacs/lib")
(load "~/folder/emacs/load_codepad.el")
(load "~/folder/emacs/cscope.el")
(load "~/folder/emacs/haskell.el")
(let ((to_load_or_not t)) ; # nil or t
  (cond (to_load_or_not (load "~/folder/emacs/myfiles.el"))
	(t (find-file-other-window "~/.emacs"))))
(defun hide-menus (hide) ; hide (t) or show (nil)
  (if hide
      (let () (tool-bar-mode '0) (menu-bar-mode '0))
    (let () (tool-bar-mode) (menu-bar-mode))))
;(hide-menus t)
(hide-menus nil)

;; 2013 rate
(let ((total-tax 75374.0) (taxable-income 270985))
  (setq rate (/ taxable-income total-tax))) ; # 36%

(/ 3590233 185076.0); 19% Pinar'in odedigi vergi!!
(/ 4333400 201240.0); 22%

