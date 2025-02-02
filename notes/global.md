## Currently working on

- [x] Add AI dev workflow
- AVANTE

  - [ ] View how query for all the project (@codebase)
  - [x] Enable diff hl
  - [ ] How add files
  - [ ] Autoclose when pressing "A" or "a"
  - [ ] Add an actual chat (float)

- CODECOMPANION
  https://github.com/olimorris/codecompanion.nvim

- Check: https://www.reddit.com/r/neovim/comments/1g68lsy/easiest_way_to_add_tailwindcss_support_for/

* [ ] Try blink and the other cmp compatibility layers
  - [ ] Separate the cmp hl in a different file
    - [ ] Set a cursorline highlight
  - [ ] Redo the cmp config
  - [ ] Create a new blink config
        https://www.reddit.com/r/neovim/comments/1g6o3n7/share_your_blinknvim/

- [ ] Add grapple with markers

- [ ] Redo CMP: https://github.com/iguanacucumber/magazine.nvim

  - [ ] Check sources:
        https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
        https://www.reddit.com/r/neovim/comments/1g4dnry/basics_ls_lsp_for_buffer_path_and_snippet/

- [ ] https://github.com/adigitoleo/haunt.nvim

## TODO

- [ ] Disable neovide menu animations for things like cmp...
- [ ] Change moody colors when dark/light mode
- [ ] go outside current scope pressing tab?
- [ ] AI:
  - Decide if use Avante or another. No good plugins is avaible?
- [ ] BLINK:
  - [ ] Mmm, reduce signature desc
  - [ ] Add colors
  - [ ] Selection order to near cursor
  - [ ] Add type or source text to the completion item
  - [ ] Displace the windows menu
- [ ] Runner for cpp, py
- [ ] Reenable hidden and add a way to check edited buffers (tab with
      only eddit buffers, or a menu with the edited buffers, something)
- [ ] Resize to maxcreen the actual split
- [ ] add change cwd to yazi
- [ ] Maintain/return cursorline when opening a file
- [ ] Use quickfix for grep, go to references, and improve quickfix
  - Ref: https://www.reddit.com/r/neovim/comments/1g7a55c/best_workflow_multiple_screen/
- [x] Markdown Support
- [ ] New terminal support
- [ ] Add Copilot to notes
- [x] Signature help in function
- [ ] Redo cmp config with magazine
  - [ ] Truncate names: https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/plugins/nvim-cmp.lua
- [ ] Sort buffer words based on proximity
- [ ] Sort completion options based on most used
- [ ] Telescope sorting based on most opened
- [x] Change 'NonText' hl in the colorschemes to an llamative one
- Check: https://github.com/jonarrien/telescope-cmdline.nvim

## DEV TODO

- [ ] Implement number, signs color to moody
- [ ] Implement remarked number, signs color
- [ ] Implement light, auto bg colors to moody
  - Refs:
    https://github.com/mvllow/modes.nvim/blob/main/lua/modes.lua
    https://github.com/svampkorg/moody.nvim/blob/main/lua/moody/config.lua
- [ ] Implement the number and sign highlights of the visual selection
      tail
- [ ] trek: keymap to change cwd
- [ ] trek:

### Bugs

- I have bugs writing after a snippet with blink
- The signature not show in normal mode. Maybe it's better that way?
- [ ] Signature not showing
- Typing @prop, do autosuggestion of copilot and enter to new line,
  insert the property snippet
- [x] Try other gui to check if nvim explode
  - [ ] Determine if is copilot, cpu usage or ram usage
- Close notes with the keymaps
- [ ] fix resize of windows
- [ ] Trek explode if try to open staying in a file that doesn't exist

## Misc

1:14: Hildren

---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
provider = "claude"

---

Afterwards I switched to Grapple, configuring the keybinds so that I could use a leader + prefix + spacebar + any letter on the keyboard to mark a file, and leader + prefix + letter to jump to that file, and to me that works pretty well, since a file is marked to a specific key, so unmarking any file won't affect other marks, there's no need to reorder the marks, and the marks are persisted between sessions.

---

I'm not sure about lualine, but https://github.com/nvim-treesitter/nvim-treesitter-context will display the context, you'll need to change the queries so that it only displays function names. I have replaced the query for cpp to be this:

(function*definition
body: (* (\_) @context.end)
) @context

---

vim.tbl_filter(function(window)
return vim.api.nvim_win_get_buf(window) ~= 0
end, actual_tab_windows)

---

Persistent floating windows where I can open things...

## GIT COMMIT

Nvim: changes

-- Added smart splits
-- Added trek for file managin
-- Mini cursorword added
-- Currently disabling yazi
-- Restore tab keymaps (I'm trying to know what to do about that)
-- Add neovide auto fullscreen
-- Copilot to all buffers
-- Lualine basic unsaved buffers state
