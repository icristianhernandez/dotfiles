(use-package general
  :demand t)

(use-package evil
  :demand t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump t)
  (setq evil-undo-system 'undo-redo)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; Wait for evil and general to be ready before defining keys
(elpaca-wait)

(general-create-definer my/leader-keys
  :keymaps '(normal insert visual emacs)
  :prefix "SPC"
  :global-prefix "C-SPC")

(my/leader-keys
  "SPC" '(execute-extended-command :which-key "execute command")
  "q"  '(:ignore t :which-key "quit/session")
  "qq" '(save-buffers-kill-terminal :which-key "quit emacs")

  "f"  '(:ignore t :which-key "file/find")
  "ff" '(find-file :which-key "find file")
  "fs" '(save-buffer :which-key "save file")

  "w"  '(:ignore t :which-key "windows")
  "wq" '(delete-window :which-key "quit window")
  "wd" '(delete-window :which-key "delete window")
  "wo" '(delete-other-windows :which-key "close other windows")
  "ws" '(split-window-below :which-key "horizontal split")
  "wv" '(split-window-right :which-key "vertical split")
  "wh" '(evil-window-left :which-key "window left")
  "wj" '(evil-window-down :which-key "window down")
  "wk" '(evil-window-up :which-key "window up")
  "wl" '(evil-window-right :which-key "window right")

  "b"  '(:ignore t :which-key "buffers")
  "bb" '(switch-to-buffer :which-key "switch buffer")
  "bd" '(kill-current-buffer :which-key "delete buffer")
  "br" '(revert-buffer :which-key "reload buffer")
  "b[" '(previous-buffer :which-key "previous buffer")
  "b]" '(next-buffer :which-key "next buffer")

  "<leader>" '(mode-line-other-buffer :which-key "alternate buffer"))

;; Map C-s to save in all states
(general-define-key
 :keymaps '(normal insert visual emacs)
 "C-s" 'save-buffer)
