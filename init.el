; thx 4 all the linkz:
; https://sam217pa.github.io/2016/09/02/how-to-build-your-own-spacemacs/
; https://jamiecollinson.com/blog/my-emacs-config/

;;; TO LOAD THIS UP PLACE IN ~/.emacs
; (add-to-list 'load-path "~/.emacs.d/lisp")
; (load "~/.emacs.d/lisp/init.el")

;;; CHANGE THESE AS NEEDED PER MACHINE
(setq our-zsh-path "/usr/bin/zsh")
(setq our-goplayground-path "/home/kdr/magic/sandbox/goplayground")

;;; NEW DEFAULTS:
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
    backup-by-copying t    ; Don't delink hardlinks
    version-control t      ; Use version numbers on backups
    delete-old-versions t  ; Automatically delete excess backups
    kept-new-versions 20   ; how many of the newest versions to keep
    kept-old-versions 5)    ; and how many of the old

(setq vc-follow-symlinks t) ; follow & open the symlinked file
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t))) ;transform backups file name
(setq inhibit-startup-screen t)	; inhibit useless and old-school startup screen
(setq ring-bell-function 'ignore)	; silent bell when you make a mistake
(setq coding-system-for-read 'utf-8)	; use utf-8 by default
(setq coding-system-for-write 'utf-8)
(setq sentence-end-double-space nil)
(setq initial-scratch-message "fortune | cowsay") ; print a default message in the empty scratch buffer opened at startup
(setq-default tab-width 4)
(menu-bar-mode -1) ; No Menubars. I haven't forgotten Vim.
; (tool-bar-mode -1) ; No Toolbars.

(setq shell-file-name our-zsh-path) ; Hail ZSH

(global-hl-line-mode 1) ; vim mechwarrior

(add-to-list 'load-path "~/.emacs.d/lisp/") ; vaccum in all the custom lisp I have lying around
(add-hook 'before-save-hook 'delete-trailing-whitespace) ; you get it.
(add-to-list 'exec-path "usr/local/bin") ; I want go etc
(add-hook 'prog-mode-hook 'electric-pair-mode) ; If paredit isn't for you, consider becoming the kind of person paredit is for.
(add-hook 'prog-mode-hook 'mechwarrior)

;;; PACKAGE MANAGEMENT
(require 'package)
(setq package-enable-at-startup nil) ; tells emacs not to load any packages before starting up

(setq package-archives '(("melpa" . "http://melpa.org/packages/")
			 ("org"       . "http://orgmode.org/elpa/")
			 ("gnu"       . "http://elpa.gnu.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package)) ; bootstrap use-package

(require 'use-package)

;;; DEFY NATURE:
(use-package evil
  :ensure t ;; install the evil package if not installed
  :init ; tweak evil's configuration before loading it
  (setq evil-search-module 'evil-search)
  (setq evil-ex-complete-emacs-commands nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-shift-round nil)
  (setq evil-want-C-u-scroll t)
  :config ; tweak evil after loading it
  (evil-mode)) ; load evil

(use-package evil-nerd-commenter :ensure t)

;;; GENERAL USE

(use-package linum-relative
  :ensure t
  :config
  (setq linum-relative-backend 'display-line-numbers-mode)
  )

(use-package avy :ensure t
  :commands (avy-goto-char-2
	     avy-goto-line)) ; Emacs Easy Motion

(use-package smex :ensure t) ; Dependancy of Counsel

(use-package ivy
  :ensure t
  :diminish ivy-mode
  :config
  (ivy-mode t)) ; Ivy improves the meta mini buffer

(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x))) ; Better M-X, Better Command Suggestion

(setq ivy-initial-inputs-alist nil) ; Removes the "^" from the default search format
(use-package ivy-hydra :ensure t) ; menus for ivy.

(use-package expand-region
  :ensure t
  :commands er/expand-region) ; Logical Region Expansion

(use-package powerline
  :disabled
  :ensure t
  :config
  (setq powerline-default-separator 'utf-8)) ; Vim4Lyfe

(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)) ; Paren Coloring

(use-package aggressive-indent :ensure t)

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize)) ; Helps resolve Path issues with Shell

(use-package git-gutter
  :ensure t
  :config
  (global-git-gutter-mode 't) ; The classic
  :diminish git-gutter-mode)

(use-package auto-complete :ensure t) ; Auto Complete, a dependency of...
(use-package company :ensure t) ; ...The gold standard in emacs land
(add-hook 'after-init-hook 'global-company-mode)

(use-package flycheck
  :ensure t
  :config
  (setq-default flycheck-disabled-checkers
		(append flycheck-disabled-checkers
			'(javascript-jshint json-jsonlist)))
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (add-hook 'after-init-hook #'global-flycheck-mode)
  (setq flycheck-erlang-include-path '("../include")
        flycheck-erlang-library-path '()
        flycheck-check-syntax-automatically '(save))
  ) ; Linter

(use-package projectile
  :ensure t
  :config
  (projectile-mode +1)
  (setq projectile-search-path '("~/magic/proj/", "~/go/src/touchsource/")))

(use-package load-theme-buffer-local :ensure t)

;;; LANGUAGES:
;; MARKDOWN
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; GOLANG:
(use-package go-mode :ensure t)
(use-package go-autocomplete :ensure t)
(use-package flymake-go :ensure t)
(use-package go-guru :ensure t)

(add-hook 'go-mode-hook 'our-go-mode)
(with-eval-after-load 'go-mode
   (require 'go-autocomplete))

;; Go Playground / REPL
(use-package go-playground
  :ensure t
  :config
  (setq go-playground-basedir our-goplayground-path))

;; JAVASCRIPT:
; for some reason not in MELPA...?
(require 'web-mode)
; (use-package web-mode
  ; :ensure t
  ; :config
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.js[x]?\\'" . web-mode))
(setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))

(add-hook 'web-mode-hook  'our-web-hook)
;; )

(use-package rjsx-mode :ensure t)
(require 'eslint-fix)

;; ERLANG:
(use-package erlang
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("\\.P\\'" . erlang-mode))
  (add-to-list 'auto-mode-alist '("\\.E\\'" . erlang-mode))
  (add-to-list 'auto-mode-alist '("\\.S\\'" . erlang-mode))
  :config
  (add-hook 'erlang-mode-hook
            'our-erlang-hook))

(use-package edts
  :ensure t
  :init
  (setq edts-inhibit-package-check t
        edts-man-root "~/.emacs.d/edts/doc/18.2.1"))

;;; LANG SERVER:
;;; FORGET THE PAST.

;;; LEADERSHIP
(use-package general :ensure t
  :config
  ; Define "SPC", "g", and "," as prefixes
  (general-create-definer dear-leader :prefix "SPC") ; SPACE IS OUR LEADER.
  (general-create-definer despot :prefix "g") ; g is our lesser leader.
  (general-create-definer scholar :prefix ",") ; , is our mobility leader

  (dear-leader
   :keymaps 'normal
   "a"    '(org-agenda :which-key "org-agenda")
   "e"    '(er/expand-region :which-key "expand region in normal mode")
   "E"    '(config-self :which-key "open init.el")
   "s"    '(swiper :which-key "swiper")
   "b"	  '(ivy-switch-buffer :which-key "switch-buffer")  ; change buffer, chose using ivy
   "/"    '(counsel-git-grep :which-key "git grep") ; find string in git project
   "ff"   '(counsel-find-file :which-key "find file") ; find file in ivy
   "h"    '(counsel-recentf :which-key "recent files") ; find recent files in ivy
   "fg"   '(counsel-git :which-key "find file in git") ; find file in git project
   "wj"   '(evil-window-down :which-key "jump to below window")
   "wk"   '(evil-window-up :which-key "jump to above window")
   "wh"   '(evil-window-left :which-key "jump to window to the left")
   "wl"   '(evil-window-right :which-key "jump to window to the right")
   "J"    '(lambda () (interactive) (split-window-below) :which-key "split window below")
   "L"    '(lambda () (interactive) (split-window-right) :which-key "split window right")
   "*"    '(lambda() (interactive) (eshell) :which-key "eshell now!")
   "!"    '(lambda() (interactive) (term our-zsh-path) :which-key "zsh now!")
   "p"    '(projectile-command-map :which-key "Ctrl-P For Emacs")
	;;; Figure out how to break it into mode specific
   "k"    '(org-metaup :which-key "shift org list up")
   "j"    '(org-metadown :which-key "shift org list down")
   "h"    '(org-metaleft :which-key "premote org list down")
   "l"    '(org-metaright :which-key "demote org list")
   )

  (dear-leader
	:keymaps 'visual
	"e"   '(er/expand-region :which-key "expand region in visual mode")
   )

  (despot
   :keymaps 'normal
   "cl"   '(evilnc-comment-or-uncomment-lines :which-key "toggle line comment")
   "cp"   '(evilnc-comment-or-uncomment-paragraphs :which-key "toggle paragraph comment")
   "pn"   '(go-playground :which-key "new Go Playground")
   "pe"   '(go-playground-exec :which-key "run Go Playground")
   "pd"   '(go-playground-rm :which-key "delete Go Playground")
   )

  (despot
   :keymaps 'visual
   "c"    '(evilnc-comment-or-uncomment-lines :which-key "toggle line comment"))

  (scholar
   :keymaps 'normal
   ","    '(avy-goto-char-2 :which-key "move to occurance of these 2 chars")
   "l"    '(avy-goto-line :which-key "move to line")
   )
  )

(use-package which-key :ensure t
  :diminish which-key-mode
  :config
  (add-hook 'after-init-hook 'which-key-mode)) ; help menus for rebindings

;; ;;; CUSTOM FUNCTIONS:
;; (defun fullscreen ()
;;   "Fullscreen now!"
;;   (interactive)
;;   (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
;; 						 '(2 "_NET_WM_STATE_FULLSCREEN" 0)))

(defun config-self ()
  "Opens Emacs config file in Emacs -- spooky."
  (interactive)
  (find-file "~/.emacs.d/lisp/init.el")
  (message "Opened: %s" (buffer-name)))

(defun mechwarrior ()
  "Mechwarrior Style Line Modes!"
  (interactive)
  (linum-relative-mode 1))

;; MODE HOOKS
(defun our-go-mode ()
  "DIY go mode custom keybindings and constant fmt."
  (add-hook 'before-save-hook 'gofmt-before-save) ; gofmt before every save
  (setq gofmt-command "goimports")                ; gofmt uses invokes goimports
  (if (not (string-match "go" compile-command))   ; set compile command default
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))

  (go-guru-hl-identifier-mode)                    ; highlight identifiers

  ;; Key bindings specific to go-mode
  (despot
   :states 'normal
   "d" 'godef-jump)

  (despot
    :states 'normal
    "f" 'gofmt)

  (dear-leader
    :states 'normal
    "m" 'compile)

  ;; Misc go stuff
  (auto-complete-mode 1)
  )

(defun our-web-hook ()
  "Hooks for Web mode.  Adjust indent."
  (setq web-mode-markup-indent-offset 4)
  (dear-leader
    :states 'normal
    "z" 'eslint-fix))

(defun our-erlang-hook ()
  "Erlang Mode Hook, hello Joe!"
  (setq mode-name "erl"
	erlang-compile-extra-opts '((i . "../include"))
	erlang-root-dir "/usr/local/lib/erlang"))

;; (defun our-local-theme-hook (theme)
;;   "Set local buffer theme."
;;   (load-theme-buffer-local theme (current-buffer)))

;; (fullscreen)

;;; COLORSCHEMES:
(use-package ubuntu-theme :ensure t)
(use-package abyss-theme :ensure t)
(use-package cyberpunk-theme :ensure t)
(use-package soothe-theme :ensure t)
(add-to-list 'custom-theme-load-path
			 (file-name-as-directory "~/.emacs.d/lisp/themes"))

;;; COLORHOOKS:
;;; ON TRIAL:
;
;;; TO BE TRIED:
; (use-package git-timemachine :ensure t) ; Didn't work :(

; FREAKING STACK OVERFLOW IN EMACS
  ; (use-package sx
    ; :ensure t
    ; :config
    ; (bind-keys :prefix "C-c s"
               ; :prefix-map my-sx-map
               ; :prefix-docstring "Global keymap for SX."
               ; ("q" . sx-tab-all-questions)
               ; ("i" . sx-inbox)
               ; ("o" . sx-open-link)
               ; ("u" . sx-tab-unanswered-my-tags)
               ; ("a" . sx-ask)
               ; ("s" . sx-search)))

  ; This sounds interesting
  ; (use-package undo-tree
    ; :ensure t
    ; :chords (("uu" . undo-tree-visualize))
    ; :diminish undo-tree-mode:
    ; :config
    ; (global-undo-tree-mode 1))

; Emoji support
  ; (use-package emojify :ensure t)

  ; This looks smart:
  ; (use-package dumb-jump
    ; :ensure t
    ; :diminish dumb-jump-mode
    ; :bind (("C-M-g" . dumb-jump-go)
           ; ("C-M-p" . dumb-jump-back)
           ; ("C-M-q" . dumb-jump-quick-look)))

  ; A Git Wrapper
  ; (use-package magit
    ; :ensure t
    ; :bind ("C-x g" . magit-status))

(provide 'init)
;;; init ends here
