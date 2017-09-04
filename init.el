;; Path to the directory where this file is located
(setq dotfile-directory (file-name-directory (or load-file-name buffer-file-name)))

;; Load the very secret tokens which shall never make it into the repository
(load-file (concat dotfile-directory "secrets.el"))

;; Initialize package 
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)

;; bootstrap use-package (http://www.lunaryorn.com/)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; and call it?
(eval-when-compile (require 'use-package))

(when (not package-archive-contents)
  (package-refresh-contents))

;; Eigengrau theme taken from Jack Rusher's dotemacs config:
;; https://github.com/jackrusher/dotemacs/blob/master/eigengrau
;; Theme is then loaded with customize.
(add-to-list 'custom-theme-load-path (concat dotfile-directory "/themes/eigengrau"))

;; turn off splash screen messages
(setq inhibit-startup-echo-area-message t
      inhibit-startup-screen t)

;;; utf-8 all the time
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq slime-net-coding-system 'utf-8-unix)

;; Switch to next window with M-o instead of C-x o
(global-set-key (kbd "M-o") 'other-window)
;; Replace region with yank buffer content
(delete-selection-mode 1)
;; Highlight current line minor mode
(global-hl-line-mode 1)
;; Make indentation commands use space only, never tab characters
(setq-default indent-tabs-mode nil)
;; Set default tab char's display width to 4 spaces
(setq-default tab-width 4)

;; Tramp
(setq tramp-default-method "ssh")

;;; Auto complete
(use-package auto-complete
             :ensure t
             :pin melpa-stable
             :diminish auto-complete-mode
             :config
             (progn
               (global-auto-complete-mode)
               (add-to-list 'ac-sources 'ac-source-abbrev)
               (add-to-list 'ac-sources 'ac-source-dictionary)
               (add-to-list 'ac-sources 'ac-source-filename)
               (add-to-list 'ac-sources 'ac-source-imenu)
               (add-to-list 'ac-sources 'ac-source-semantic)
               (add-to-list 'ac-sources 'ac-source-words-in-buffer)
               (add-to-list 'ac-sources 'ac-source-yasnippet))
             (ac-config-default))

;;; Auto-complete Cider
(use-package ac-cider
             :ensure t
             :pin melpa-stable
             :config
             (add-hook 'cider-mode-hook 'ac-flyspell-workaround)
             (add-hook 'cider-mode-hook 'ac-cider-setup)
             (add-hook 'cider-repl-mode-hook 'ac-cider-setup)
             (eval-after-load "auto-complete"
               '(progn
                  (add-to-list 'ac-modes 'cider-mode)
                  (add-to-list 'ac-modes 'cider-repl-mode))))

;;; Clojure Cider
(use-package cider
             :ensure t
             :pin melpa-stable)

;;; CSV
(use-package csv-mode
             :ensure t
             :mode "\\.csv\\'")

(use-package dired
             :init
             ;; 'a' reuses the current buffer, 'RET' opens a new one
             (put 'dired-find-alternate-file 'disabled nil)
             ;; '^' reuses the current buffer
             (add-hook 'dired-mode-hook
                       (lambda ()
                         (define-key dired-mode-map (kbd "^")
                           (lambda ()
                             (interactive)
                             (find-alternate-file ".."))))))

;;; Expand Region
(use-package expand-region
             :ensure t
             :pin melpa-stable
             :bind ("C-=" . er/expand-region))

;;; Helm
(use-package helm
             :ensure t
             :pin melpa-stable)

;;;
(use-package highlight-parentheses
             :ensure t
             :pin melpa-stable)

;;; 
(use-package ido-ubiquitous
             :ensure t
             :pin melpa-stable
             :config
             ;; enable C-x C-f history
             (ido-mode t)
             (ido-ubiquitous t))

;;; JSON
(use-package json-mode
             :ensure t
             :pin melpa-stable)

;;; Magit
(use-package magit
             :ensure t
             :pin melpa-stable
             :bind ("C-x g" . magit-status))

;;; Markdown mode
(use-package markdown-mode
             :ensure t
             :pin melpa-stable
             :init
             (add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
             (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
             (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode)))

;;; Olivetti
(use-package olivetti
             :ensure t
             :pin melpa-stable)

;;;
(use-package org
             :ensure t
             :pin melpa-stable
             :init
             ;; Enable syntax highlighting in #+BEGIN_SRC sections
             (setq org-src-fontify-natively t))

;;;
(use-package org-ac
             :ensure t
             :pin melpa-stable
             :config
             (org-ac/config-default))

;;;
(use-package paredit
             :ensure t
             :pin melpa-stable
             :config
             (add-hook 'prog-mode-hook #'enable-paredit-mode))

;;; Processing
(use-package processing-mode
             :ensure t
             :pin melpa-stable

             :init
             (setq processing-location "/usr/local/bin/processing-java")
             (setq processing-application-dir "/Applications/Processing.app")
             (setq processing-sketchbook-dir "~/Development/processing")
             (add-to-list 'ac-modes 'processing-mode)

             :config
             (make-local-variable 'ac-sources)
             (setq ac-sources '(ac-source-dictionary ac-source-yasnippet))
             (make-local-variable 'ac-user-dictionary)
             (setq ac-user-dictionary (append processing-functions
                                              processing-builtins
                                              processing-constants)))

;;; Projectile
(use-package projectile
             :ensure t
             :pin melpa-stable
             :config
             (projectile-global-mode))

;;; Python
(use-package python
             :ensure t
             :config
             (setenv "PYTHONIOENCODING" "utf-8")
             (setenv "LANG" "en_US.UTF-8"))

;;; Parentheses coloring
(use-package rainbow-delimiters
             :ensure t
             :pin melpa-stable
             :config
             (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

;;; Regex builder, comes with emacs
(use-package re-builder
             :config
             (setq reb-re-syntax 'string))

;;; Rainbow mode - Sets background color to strings
;;; that match color names, e.g. #0000ff red rgb(100,20,0)
(use-package rainbow-mode
             :ensure t
             :pin gnu
             :config
             (add-hook 'prog-mode-hook 'rainbow-mode))

(use-package rcirc
  :ensure t
  :pin melpa-stable
  :init
  (rcirc-track-minor-mode 1)
  :config
  (setq rcirc-default-nick secrets-irc-freenode-user)
  (setq rcirc-notify-timeout 15)
  (setq rcirc-omit-responses '("PART" "QUIT"))
  (setq rcirc-authinfo `(("freenode" nickserv ,secrets-irc-freenode-user ,secrets-irc-freenode-pass)))
  (setq rcirc-server-alist '(("irc.freenode.net"
                              :port 6667
                              :channels ("#emacs")))))

;;; SMEX M-x history
(use-package smex
             :ensure t
             :pin melpa-stable)

;;; Transpose frame
(use-package transpose-frame
             :ensure t
             :pin melpa
             :bind (("C-," . rotate-frame-anticlockwise)
                    ("C-." . rotate-frame-clockwise)))

;;; Web mode
(use-package web-mode
             :ensure t
             :pin melpa-stable
             :init
             (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
             (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
             (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
             (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
             (add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
             (add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
             (add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
             :config
             (setq web-mode-css-indent-offset 2)
             (setq web-mode-code-indent-offset 2)
             (setq web-mode-markup-indent-offset 2)
             (setq web-mode-enable-current-element-highlight t))

;;  Highlight Parentheses
(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  (lambda ()
    (highlight-parentheses-mode t)))
(global-highlight-parentheses-mode t)

;;; Hideshow
(load-library "hideshow")
(global-set-key (kbd "C-+") 'hs-toggle-hiding)
(global-set-key (kbd "C-x <C-up>") 'hs-hide-block)
(global-set-key (kbd "C-x <C-down>") 'hs-show-block)
(add-hook 'prog-mode-hook 'hs-minor-mode)

;; Customize interface to safe config in separate file
(setq custom-file (concat dotfile-directory "custom.el"))
(load custom-file)
