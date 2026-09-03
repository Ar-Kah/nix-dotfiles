;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom	es (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(defun toggle-evil-insert-normal ()
  "Toggle from evil insert mode to normal mode and vise versa."
  (interactive)
  (if (evil-insert-state-p)
      (if (eolp)
          (evil-normal-state)
        (progn
          (forward-char 1)
          (evil-normal-state)))
    ;; if in visual mode escape back to normal mode
    (if (evil-visual-state-p)
        (evil-normal-state)
      (evil-insert-state))))

;; ---------------
;; Insert fuctions
;; ---------------
(defun doom-insert-new-line-above ()
  "Insert a new line above the cursor without moving point."
  (interactive)
  (save-excursion
    (if (bobp)
        (newline)
      (forward-line -1)
      (end-of-line)
      (newline))))

(defun doom-insert-new-line ()
  "Insert a new line below the cursor without changing the palce
of the cursor"
  (interactive)
  (save-excursion
    (evil-move-end-of-line)
    (insert (if use-hard-newlines hard-newline "\n"))))

(defun insert-space-left ()
  "Insert a space left of the cursor in evil normal mode"
  (interactive)
  (insert " "))

(defun insert-space-right ()
  "Insert a space right of the cursor in evil normal mode"
  (interactive)
  (save-excursion
    (forward-char 1)
    (insert " ")))

(setq dired-listing-switches "-alh")

;; remaping keys
(map!   "M-O"           #'doom-insert-new-line-above)
(map!   "M-o"           #'doom-insert-new-line)
(map!   "§"             #'toggle-evil-insert-normal)
(map!   "M-j"           #'drag-stuff-down)
(map!   "M-k"           #'drag-stuff-up)
(map!   "M-h"           #'drag-stuff-left)
(map!   "M-l"           #'drag-stuff-right)
(map!   :n "M-i"        #'insert-space-left)
(map!   :n "M-I"        #'insert-space-right)
(map!   :n "C-x l"      #'consult-line)
(map!   "<f10>"         #'toggle-frame-maximized)
(map!   "C-M-h"         #'switch-to-prev-buffer)
(map!   "C-M-l"         #'switch-to-next-buffer)

(map!   "C-M-j"         #'evil-window-down)
(map!   "C-M-k"         #'evil-window-up)
(map!   "C-M-n"         #'evil-window-left)
(map!   "C-M-m"         #'evil-window-right)

;; line-number colors
(custom-set-faces!
  (set-face-foreground 'line-number "#7f848e")
  (set-face-foreground 'line-number-current-line "#61afef")
  (set-face-attribute 'default nil :height 120))

(after! vertico
  (setq vertico-count 13))  ;; shorter minibuffer list

(setq scroll-margin 7)

;; set wraping text to true
(setq global-visual-line-mode t)
