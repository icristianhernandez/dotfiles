;;; init.el --- Emacs configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; This is a simple, maintainable, and modern Emacs configuration
;; that mirrors a Neovim setup.

;;; Code:

;; Bootstrap Elpaca
(defvar elpaca-installer-version 0.9)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1
                              :files (:exclude "extensions")
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (< emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (shell-command-to-string (format "git clone %s %s" (plist-get order :repo) repo))))
            (message "%s" buffer)
          (error "Could not clone elpaca %s" err))
      (error (delete-directory repo t) (signal (car err) (cdr err)))))
  (require 'elpaca-client)
  (elpaca-wait)
  (elpaca elpaca-order (elpaca--activate-package)))

;; Install use-package support for Elpaca
(elpaca elpaca-use-package
  (elpaca-use-package-mode))
(setq use-package-always-ensure t)
(elpaca-wait)

;; Basic UI settings
(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)

(setq visible-bell t)

(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Indentation
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

;; Encoding
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;; Load configurations
(load (expand-file-name "evil-config.el" user-emacs-directory))
(load (expand-file-name "ui-config.el" user-emacs-directory))
(load (expand-file-name "lsp-config.el" user-emacs-directory))
(load (expand-file-name "git-file-config.el" user-emacs-directory))
(load (expand-file-name "theme-config.el" user-emacs-directory))

(provide 'init)
;;; init.el ends here
