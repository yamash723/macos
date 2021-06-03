;; package
(setq package-list '(auto-complete undo-tree nord-theme))
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;; plugin: auto-complete
(ac-config-default)
(ac-set-trigger-key "TAB")
(global-auto-complete-mode t)
;; plugin: undo-tree
(global-undo-tree-mode t)
(global-set-key (kbd "M-/") 'undo-tree-redo)
;; plugin: nord-theme
(load-theme 'nord t)

;; line number
(require 'linum)
(global-linum-mode 1)
;; highlight pair
(show-paren-mode 1)
;; auto pair
(electric-pair-mode 1)
;; no backup file
(setq make-backup-files nil)
(setq auto-save-default nil)
;; no startup message
(setq inhibit-startup-message 1)
;; tab width
(setq-default indent-tabs-mode nil)
(setq tab-width 4)
;; auto indent
(electric-indent-mode -1)
(global-set-key "\C-m" 'newline-and-indent)
