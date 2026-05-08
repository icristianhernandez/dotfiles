(use-package everforest-theme
  :config
  (load-theme 'everforest-hard-dark t))

(use-package nerd-icons
  :if (display-graphic-p))

(use-package doom-modeline
  :after nerd-icons
  :init (doom-modeline-mode 1)
  :custom
  ((doom-modeline-height 25)
   (doom-modeline-icon t)
   (doom-modeline-major-mode-icon t)))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
