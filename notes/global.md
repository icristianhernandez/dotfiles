## TODO

- [x] Markdown Support
- [x] Add AI dev workflow
  - [ ] View how query for all the project (@codebase)
  - [ ] Enable diff hl
  - [ ] How add files
  - [ ] Autoclose when pressing "A" or "a"
  - [ ] Add an actual chat (float)
- [ ] New terminal support
- [ ] Add Copilot to notes
- [x] Signature help in function
- [ ] Redo cmp config with magazine
  - [ ] Truncate names: https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/plugins/nvim-cmp.lua
- [ ] Try blink and the other cmp compatibility layers
- [ ] Sort buffer words based on proximity
- [ ] Sort completion options based on most used
- [ ] Telescope sorting based on most opened
- [x] Change 'NonText' hl in the colorschemes to an llamative one

### Bugs

- The signature not show in normal mode. Maybe it's better that way?
- Typing @prop, do autosuggestion of copilot and enter to new line,
  insert the property snippet
- [ ] Try other gui to check if nvim explode

## Misc

1:14: Hildren

---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
provider = "claude"

---

Afterwards I switched to Grapple, configuring the keybinds so that I could use a leader + prefix + spacebar + any letter on the keyboard to mark a file, and leader + prefix + letter to jump to that file, and to me that works pretty well, since a file is marked to a specific key, so unmarking any file won't affect other marks, there's no need to reorder the marks, and the marks are persisted between sessions.

---
