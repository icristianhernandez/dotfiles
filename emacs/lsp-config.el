;; Completion
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0)
  (corfu-auto-prefix 1)
  :init
  (global-corfu-mode))

(use-package yasnippet
  :init
  (yas-global-mode 1))

;; Treesitter
(setq treesit-font-lock-level 4)

;; LSP
(use-package eglot
  :ensure nil ; Built-in
  :hook ((python-mode . eglot-ensure)
         (nix-mode . eglot-ensure)
         (js-mode . eglot-ensure)
         (lua-mode . eglot-ensure))
  :config
  (my/leader-keys
    "c"   '(:ignore t :which-key "code")
    "ca"  '(eglot-code-actions :which-key "code actions")
    "cr"  '(eglot-rename :which-key "rename")
    "cf"  '(eglot-format-buffer :which-key "format buffer")
    "cd"  '(eldoc :which-key "documentation")))

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package lua-mode)
