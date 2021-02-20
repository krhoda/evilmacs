; thx 4 all the linkz:
; https://sam217pa.github.io/2016/09/02/how-to-build-your-own-spacemacs/
; https://jamiecollinson.com/blog/my-emacs-config/

; Ripped for a bunch of lisp config.
; https://lupan.pl/dotemacs/

;;; TO LOAD THIS UP PLACE IN ~/.emacs
; (add-to-list 'load-path "~/.emacs.d/lisp")
; (load "~/.emacs.d/lisp/init.el")

;;; CHANGE THESE AS NEEDED PER MACHINE
;;; CODE:
(setq our-zsh-path "/usr/bin/zsh")

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
(tool-bar-mode -1) ; No Toolbars.

(setq shell-file-name our-zsh-path) ; Hail ZSH
; (global-hl-line-mode 1) ; vim mechwarrior

(add-to-list 'load-path "~/.emacs.d/lisp/") ; vaccum in all the custom lisp I have lying around
(add-hook 'before-save-hook 'delete-trailing-whitespace) ; you get it.
(add-to-list 'exec-path "usr/local/bin") ; I want go etc
(add-hook 'prog-mode-hook 'electric-pair-mode)  ; Colored parens everywhere

;;; PACKAGE MANAGEMENT
(require 'package)
(setq package-enable-at-startup nil) ; tells emacs not to load any packages before starting up

(setq package-archives '(("melpa" . "http://melpa.org/packages/")
			 ("org"       . "http://orgmode.org/elpa/")
			 ("gnu"       . "http://elpa.gnu.org/packages/"))
	  tls-checklist t
	  tls-program '("gnutls-cli --x509cafile %t -p %p %h")
	  gnutls-verify-error t)

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package)
  (require 'use-package)) ; bootstrap use-package

(setq use-package-always-ensure t)      ; All packages used have to be installed
(require 'use-package)

;; Ya Snippet, frequent dep of other packages.
(use-package yasnippet
  :ensure
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode))


(use-package yasnippet-snippets :ensure t)

(use-package auto-complete :ensure t)
;;; Company for auto-complete menu
(use-package company
  :init
  :hook (after-init . global-company-mode))

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
  (setq evil-undo-system 'undo-redo)
  :config ; tweak evil after loading it
  (evil-mode)) ; load evil

(use-package evil-nerd-commenter :ensure t)

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package undo-fu
  :config
  (define-key evil-normal-state-map "u" 'undo-fu-only-undo)
  (define-key evil-normal-state-map "\C-r" 'undo-fu-only-redo))


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

(use-package projectile
  :ensure t
  :config
  (projectile-mode +1)
  (setq projectile-search-path '("~/magic/proj/")))

(use-package load-theme-buffer-local :ensure t)

;;; Referred to in LEADERSHIP, used in LISPS
(use-package paredit
  :hook (eval-expression-minibuffer-setup . paredit-mode))

;; MARKDOWN
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;;; LEADERSHIP
(use-package general :ensure t
  :config
  ; Define "SPC", "g", and "," as prefixes
  (general-create-definer augustus :prefix "SPC") ; SPACE IS OUR LEADER.
  (general-create-definer caeser :prefix "g") ; g is our lesser leader.
  (general-create-definer dux :prefix ",") ; , is our mobility leader

  (augustus
   :keymaps 'normal
   "E"    '(config-self :which-key "open init.el")

   "e"    '(er/expand-region :which-key "expand region in normal mode")

   "b"	  '(ivy-switch-buffer :which-key "switch-buffer")  ; change buffer, chose using ivy

   "/"    '(counsel-git-grep :which-key "git grep") ; find string in git project
   "f"    '(counsel-find-file :which-key "find file") ; find file in ivy
   "r"    '(counsel-recentf :which-key "recent files") ; find recent files in ivy

   "J"    '(lambda () (interactive) (split-window-below) :which-key "split window below")
   "L"    '(lambda () (interactive) (split-window-right) :which-key "split window right")

   "*"    '(lambda () (interactive) (eshell) :which-key "eshell now!")
   "!"    '(lambda () (interactive) (term our-zsh-path) :which-key "zsh now!")

   "p"    '(projectile-command-map :which-key "projects now!")

   "."    '(paredit-forward-slurp-sexp :which-key "paredit slurp forward")
   ","    '(paredit-backward-slurp-sexp :which-key "paredit slurp backward")
   ">"    '(paredit-forward-barf-sexp :which-key "paredit barf forward")
   "<"    '(paredit-backward-barf-sexp :which-key "paredit barf backward")
   )

  (augustus
	:keymaps 'visual
	"e"   '(er/expand-region :which-key "expand region in visual mode")
   )

  (caeser
   :keymaps 'normal
   "cl"   '(evilnc-comment-or-uncomment-lines :which-key "toggle line comment")
   "cp"   '(evilnc-comment-or-uncomment-paragraphs :which-key "toggle paragraph comment")
   )

  (caeser
   :keymaps 'visual
   "c"    '(evilnc-comment-or-uncomment-lines :which-key "toggle line comment"))

  (dux
   :keymaps 'normal
   ","    '(avy-goto-char-2 :which-key "move to occurance of these 2 chars")
   "m"    '(avy-goto-line :which-key "move to line")

   "j"   '(evil-window-down :which-key "jump to below window")
   "k"   '(evil-window-up :which-key "jump to above window")
   "h"   '(evil-window-left :which-key "jump to window to the left")
   "l"   '(evil-window-right :which-key "jump to window to the right")

   "\""   '(paredit-meta-doublequote :which-key "wrap quote")
   "("    '(paredit-wrap-round :which-key "wrap in parens")
   "["    '(paredit-wrap-square :which-key "wrap in braces")
   "{"    '(paredit-wrap-curly :which-key "wrap in brackets")
   "<"    '(paredit-wrap-angle :which-key "wrap in angle tags")
   )
  )

(use-package which-key :ensure t
  :ensure t
  :diminish which-key-mode
  :config
  (add-hook 'after-init-hook 'which-key-mode)) ; help menus for rebindings

(defun config-self ()
  "Opens Emacs config file in Emacs -- spooky."
  (interactive)
  (find-file "~/.emacs.d/lisp/init.el")
  (message "Opened: %s" (buffer-name)))

;;; COLORSCHEMES:
(add-to-list 'custom-theme-load-path
			 (file-name-as-directory "~/.emacs.d/lisp/themes"))

;; RUST
(use-package rustic
  :ensure
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status)
              ("C-c C-c e" . lsp-rust-analyzer-expand-macro)
              ("C-c C-c d" . dap-hydra))
  :config
  ;; uncomment for less flashiness
  ;; (setq lsp-eldoc-hook nil)
  ;; (setq lsp-enable-symbol-highlighting nil)
  ;; (setq lsp-signature-auto-activate nil)

  ;; comment to disable rustfmt on save
  (setq rustic-format-on-save t)
  (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))

(defun rk/rustic-mode-hook ()
  ;; so that run C-c C-c C-r works without having to confirm
  (setq-local buffer-save-without-query t))

(use-package lsp-mode
  :ensure
  :commands lsp
  :custom
  ;; what to use when checking on-save. "check" is default, I prefer clippy
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package lsp-ui
  :ensure
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable nil))

(use-package flycheck :ensure)

(use-package yasnippet
  :ensure
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode))

(defun company-yasnippet-or-completion ()
  (interactive)
  (or (do-yas-expand)
      (company-complete-common)))

(use-package toml-mode :ensure)

;; Let there be lambda
(defun classic-lambda ()
  "Make lambda a prettier sight for classic LISPs."
  (setq prettify-symbols-alist '(("lambda" . 955))))

(defun industrial-lambda ()
  "Make lambda a prettier sight for fancy clojure."
  (setq prettify-symbols-alist '(("fn". 955))))

;;; LISPS:
(add-hook 'scheme-mode-hook 'classic-lambda)
(add-hook 'racket-mode-hook 'classic-lambda)
(add-hook 'lisp-mode-hook 'classic-lambda)
(add-hook 'clojure-mode-hook 'industrial-lambda)

(global-prettify-symbols-mode 1)


;; EMACS LISP:
(defun our-emacs-lisp-hook ()
  (paredit-mode 1))

;; COMMON LISP:

(setq slime-lisp-implementations '((sbcl ("sbcl")))
	  slime-default-lisp 'sbcl
	  slime-contribs '(slime-fancy))

(use-package slime-company
  :ensure t)

(use-package slime
  :demand
  :config
    (slime-setup '(slime-fancy slime-company slime-cl-indent)))

(defun our-common-lisp-hook ()
  (paredit-mode 1)
  (set (make-local-variable 'company-backends) '(company-slime))
  (company-mode)
  (dux
	:states 'normal
	;;; REPL commands
	"!" '(slime :which-key "Launch Slime")
	"Q" '(slime-quit-lisp :which-key "End Slime REPL connection")
	"L" '(slime-load-file :which-key "Load file into REPL")
	"I" '(slime-interrupt :which-key "Send SIGINT to REPL")
	"R" '(slime-restart-inferior-lisp :which-key "Restart LISP process")
	"P" '(slime-repl-set-package :which-key "Set package of REPL")
	"Y" '(slime-sync-package-and-default-directory :which-key "Sync Working Dir + Package in REPL")

	;;; Consider adding slime-cd and slime-pwd

	;;; Evaluation commands
	"x" '(slime-eval-last-expression :which-key "Evaluate last expression")
	"t" '(slime-eval-defun :which-key "Evaluate top-level expression")
	":" '(slime-interactive-eval :which-key "Interactively evaluation expression")

	;;; Inspection:
	"RET" '(slime-inspector-operate-on-point :which-key "Inspect thing at point")
	"ii" '(slime-inspect :which-key "Inspect thing at point")
	"id" '(slime-inspector-describe :which-key "Describe thing at point in inspector")
	"ie" '(slime-inspector-eval :which-key "Evaluate expression at point in inspector")
	"iv" '(slime-inspector-toggle-verbose :which-key "Toggle slime inspector verbosity")
	"ip" '(slime-inspector-pop :which-key "Go to previous obj in inspector")
	"in" '(slime-inspector-next :which-key "Go to next obj in inspector")
	"ig" '(slime-inspector-reinspect :which-key "Reinspect")

	"iq" '(slime-inspector-quit :which-key "Quit inspector")
	"if" '(slime-inspector-pprint :which-key "Pretty print object in point in other buffer")
	"is" '(slime-inspector-show-source :which-key "Find source code of object at point")
	"ia" '(slime-inspector-fetch-all :which-key "Fetch all inspector contents and go to end (?)")
	"i!" '(slime-inspector-copy-down :which-key "Store the value under point in the variable '*', available in the REPL")
	"iP" '(slime-inspector-previous-inspectable-object :which-key "Previous inspectable object")
	"iN" '(slime-inspector-next-inspectable-object :which-key "Next inspectable object")

	;;; Edit commands
	"f" '(slime-edit-value :which-key "Edit form in new buffer")

	;;; Compile commands
	"ct" '(slime-compile-defun :which-key "Compile top-level expression")
	"cb" '(slime-compile-and-load-file :which-key "Compile and load current buffer")
	"cc" '(slime-compile-file :which-key "Compile current buffer but do not load")

	;;; Compile note navigation
	"cn" '(slime-next-note :which-key "Next compiler note")
	"cp" '(slime-previous-note :which-key "Prev compiler note")
	"cq" '(slime-remove-notes :which-key "Delete all compiler notes")
	"n" '(next-error :which-key "Next error using native Emacs I think")

	;;; Definitions navigation
	"?" '(slime-pop-find-definition-stack :which-key "Go to usage of symbol at point")
	"ds" '(slime-describe-symbol :which-key "Describe symbol at point")
	"df" '(slime-describe-function :which-key "Describe function at point")

	;;; Relationships
	"wc" '(slime-who-calls :which-key "Shows function callers")
	"wC" '(slime-calls-who :which-key "Shows function called by given function")
	"wr" '(slime-who-references :which-key "Shows references to a global variable")
	"wb" '(slime-who-binds :which-key "Shows bindings of a global variable")
	"ws" '(slime-who-sets :which-key "Shows assignments to a global variable")
	"wm" '(slime-who-macroexpands :which-key "Shows expansions of a macro")
	"we" '(slime-who-specializes :which-key "Shows assignments to a global variable")
	"wlc" '(slime-list-callers :which-key "Lists function callers")
	"wlC" '(slime-list-callees :which-key "Lists function called by given function")

	;;; Macros
	"eu" '(slime-macroexpand-undo :which-key "Undo macro-expand")
	"ee" '(slime-expand-1 :which-key "Expand macro at point once")
	"e!" '(slime-macroexpand-all :which-key "Expand macro at point fully")
	"ec" '(slime-compiler-macroexpand-1 :which-key "Compiler-macro expand s-expression at point once")
	"eC" '(slime-compiler-macroexpand :which-key "Compiler-macro expand s-expression at point")

	;;; TODO: What are these "Disassembly commands"?
	;;; https://common-lisp.net/project/slime/doc/html/Disassembly.html

	;;; Apropos
	"a" '(slime-apropos :which-key "Apropos search of Lisp symbol names")
	"A" '(slime-apropos-all :which-key "Apropos search of Lisp symbols, including internal symbols")

	;;; NOTE: Ignored profiling tooling
	;;; https://common-lisp.net/project/slime/doc/html/Profiling.html

	;;; NOTE: Ignored debugger / IO tricks / Multiple REPLs info:
	;;; https://common-lisp.net/project/slime/doc/html/index.html
	)

  (augustus
	:states 'normal
	"?" '(slime-edit-definition-other-frame :which-key "Open definition in new frame")
	)

  (caeser
	:states 'normal
	"d" '(slime-edit-definition :which-key "Go to definition of symbol at point")
	"!f" '(slime-hyperspec-lookup :which-key "Go to definition of function on the internet")
	"!c" '(hyperspec-lookup-format :which-key "Go to definition of format character on the internet")
	"!m" '(hyperspec-lookup-reader-macro :which-key "Go to definition of reader macro on the internet")
	)

  (dux
	:states 'visual
	"cr" '(slime-compile-region :which-key "Compile current current region")
	"r" '(slime-eval-region :which-key "Evaluate region")
	)
)

(add-hook 'emacs-lisp-mode-hook #'our-emacs-lisp-hook)
(add-hook 'lisp-mode-hook #'our-common-lisp-hook)

;;; Racket:
(use-package racket-mode :ensure t)
(require 'racket-xp)
(add-hook 'racket-repl-mode-hook #'racket-unicode-input-method-enable)

(add-hook 'racket-mode-hook      #'our-racket-hook)
(add-hook 'racket-mode-hook      #'racket-xp-mode)
(add-hook 'racket-mode-hook      #'racket-unicode-input-method-enable)

(defun our-racket-hook ()
  (paredit-mode 1)
  (company-mode)
  (dux
  	:states 'normal
	"!" '(racket-run-and-switch-to-repl :which-key "Run and focus on REPL")
	"L" '(racket-run-module-at-point :which-key "Run current buffer in REPL")
  	"z" '(racket-insert-lambda :which-key "Insert Lambda Symbol")
	;;; Skipping Test Fold / Unfold.
	;;; Also skipping some formatting.
	"0" '(racket-cycle-paren-shapes :which-key "Cycle Paren Shapes")

	"n" '(racket-xp-next-error :which-key "Jump to next explorer error")
	"p" '(racket-xp-previous-error :which-key "Jump to previous explorer error")

	"id" '(racket-xp-describe :which-key "Describe thing at point in explorer")
	"iD" '(racket-repl-describe :which-key "Describe thing at point in REPL")
	"ir" '(racket-xp-rename :which-key "Rename Var")
	"ia" '(racket-xp-rename :which-key "Annotate Var")
	"in" '(racket-xp-next-definition :which-key "Next definintion in explorer")
	"ip" '(racket-xp-previous-definition :which-key "Prev definition in explorer")

	"rd" '(racket-send-definition :which-key "Send definition to REPL")
	"rl" '(racket-send-last-sexp :which-key "Send last s-expression to REPL")

	"?" '(racket-xp-next-use :which-key "Next Use of name")
	"/" '(racket-xp-previous-use :which-key "Prev Use of name")

	"t" '(racket-test :which-key "Run the 'test' submodule")
	"T" '(racket-raco-test :which-key "Run the 'test' submodule via Shelling out to Raco")


	"ei" '(racket-stepper-mode :which-key "Interactive Macro Expansion")
	"e!" '(racket-expand-file :which-key "Interactive Macro Expansion over whole file")
	"ed" '(racket-expand-definition :which-key "Interactive Macro Expansion over definition")
	"ex" '(racket-expand-last-sexp :which-key "Expand last s-expression once")

	;;; Skipped Racket:
	;;; Profile
	;;; Logger
	;;; Find Collection / Open Require Path
	;;; Details here: https://www.racket-mode.com/#Introduction

  	)

  (dux
  	:states 'visual
	"r" '(racket-send-region :which-key "Send region to REPL"))

  (caeser
	:states 'normal
	;; Docs
	"d"  '(racket-xp-visit-definition :which-key "Racket go-to definition")
	"D"  '(racket-repl-visit-definition :which-key "Racket REPL go-to definition")
	"!d" '(racket-xp-documentation :which-key "Racket Explorer display docs")
	"!D" '(racket-repl-documentation :which-key "Racket REPL display docs")
	"!m" '(racket-visit-module :which-key "Racket go-to module definition")
	))

;;; DOES NOT PLAY WELL WITH OTHERS:
;;; CLOJURE:
(use-package clojure-mode :ensure t)
(use-package cider :ensure t)

(add-hook 'clojure-mode-hook #'cider-mode)
(add-hook 'clojure-mode-hook 'our-clojure-hook)
(add-hook 'clojure-mode-hook 'enable-paredit-mode)

(defun our-clojure-hook ()
  "Clojure Mode Hook Un-complected."
  (dux
	:states 'normal
	"!" '(cider-jack-in :which-key "start CIDER")
	"I" '(cider-interrupt :which-key "interrupt CIDER computation")
	"Q" '(cider-quit :which-key "Quit CIDER")
	"Y" '(cider-ns-refresh :which-key "CIDER refesh all file in name-space")
    "L" '(cider-switch-to-repl-buffer :which-key "CIDER eval load buffer into repl")
	"P" '(cider-repl-set-ns :which-key "CIDER set repl to current ns")
	"C"  '(cider-find-and-clear-repl-output :which-key "CIDER clear repl")

	;;; Everything.
	"x!" '(cider-eval-buffer :which-key "CIDER eval whole buffer")

	;; Last expressions.
	"xl" '(cider-eval-last-sexp :which-key "CIDER eval last expression")
	"xr" '(cider-eval-last-sexp-and-replace :which-key "CIDER replace expression with result")

	;; At point expressions.
	"xp" '(cider-pprint-eval-defun-at-point :which-key "CIDER pretty-print eval expression")
	"xx" '(cider-eval-sexp-at-point :which-key "CIDER eval expression at point")
	"xf" '(cider-eval-defun-at-point :which-key "CIDER eval defun at point")

	;; Up to point evaluation.
	"x." '(cider-eval-defun-up-to-point :which-key "CIDER eval defun up to point")

	;; Namespace
	"xn" '(cider-eval-ns-form :which-key "CIDER eval ns form")

	;; Macros
	"ee" '(cider-macroexpand-1 :which-key "CIDER expand ONE macro")
	"e!" '(cider-macroexpand-all :which-key "CIDER expand ALL macros")

	"d"  '(cider-doc :which-key "CIDER display doc string")
	;; Eval in Repl
	"il" '(cider-eval-last-sexp-to-repl :which-key "CIDER eval last expression in repl")

	"wr"  '(cider-xref-fn-refs :which-key "CIDER find references across loaded namespaces")
	"wd"  '(cider-xref-fn-deps :which-key "CIDER find dependants across loaded namespaces")
)

   (dux
	:states 'visual
	"r" '(cider-eval-region :which-key "CIDER Eval Region")
	)

   (caeser
	:states 'normal
	;; Docs
	"d"  '(cider-find-var :which-key "CIDER go-to definition")
	"r"  '(cider-find-resource :which-key "CIDER go-to resource")
	"!n" '(cider-find-ns :which-key "CIDER go-to name-space")
	"!d" '(cider-clojuredocs :which-key "CIDER display clojure docs")
	"!w" '(cider-clojuredocs-web :which-key "CIDER display doc string")
	"!j" '(cider-javadoc :which-key "CIDER display java docs")
	)
   )

; A Git Wrapper
(use-package magit
	:ensure t
    :bind ("C-x g" . magit-status))


;;; COLORHOOKS:
;;; ON TRIAL:
;
;;; TO BE TRIED:
; (use-package git-timemachine :ensure t) ; Didn't work :(

;;; Separedit, edit comments separate from code.
;;; https://github.com/twlz0ne/separedit.el

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

(provide 'init)
