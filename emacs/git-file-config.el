(use-package magit
  :commands magit-status
  :config
  (my/leader-keys
    "g"   '(:ignore t :which-key "git")
    "gg"  '(magit-status :which-key "magit status")
    "gb"  '(magit-branch-checkout :which-key "git branch")
    "gl"  '(magit-log-current :which-key "git log")
    "gd"  '(magit-diff-unstaged :which-key "git diff")))

(use-package dirvish
  :init
  (dirvish-override-dired-mode)
  :config
  (setq dirvish-mode-line-format
        '(:left (path) :right (free-space)))
  (setq dirvish-attributes
        '(vc-state subtree-state git-msg file-size))
  (my/leader-keys
    "e"   '(:ignore t :which-key "file explorer")
    "ee"  '(dirvish :which-key "open dirvish")
    "ec"  '(dirvish-side :which-key "dirvish side")))

(use-package vterm
  :commands vterm
  :config
  (setq vterm-max-scrollback 10000)
  (my/leader-keys
    "st"  '(vterm :which-key "terminal")))
