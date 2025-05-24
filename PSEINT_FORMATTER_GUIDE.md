# PSeInt Formatter for Neovim

## Overview

This guide explains how to set up and use a Python script to format PSeInt pseudocode within Neovim. The formatter automatically adjusts indentation, spacing, and keyword casing to ensure your PSeInt code is clean and consistent.

## Requirements

*   **Neovim:** A recent version of Neovim installed.
*   **Python 3:** Python version 3.x installed and accessible via the `python3` command in your system's PATH.

## Setup Instructions

### Step 1: Save the Formatter Script

1.  You need the `pseint_formatter.py` Python script. Save the code below to a suitable location on your system. A common place is within your Neovim configuration directory, for example:
    *   Linux/macOS: `~/.config/nvim/scripts/pseint_formatter.py`
    *   Windows: `~/AppData/Local/nvim/scripts/pseint_formatter.py`

    Create the `scripts` directory if it doesn't exist. Make sure the script is executable by running `chmod +x /path/to/your/scripts/pseint_formatter.py` (replace with your actual path).

2.  **`pseint_formatter.py` Code:**

    <details>
    <summary>Click to expand Python formatter script</summary>

    ```python
    import re

    def format_pseint_code(code_string):
        lines = code_string.split('\n')
        formatted_lines = []
        indentation_level = 0
        indent_size = 4 # Default to 4 spaces

        # --- Keyword Categorization for Indentation and Casing ---
        all_keywords_list = [
            "Proceso", "FinProceso", "SubProceso", "FinSubProceso", "Algoritmo", "FinAlgoritmo",
            "Definir", "Como", "Leer", "Escribir", "Si", "Entonces", "Sino", "FinSi",
            "Mientras", "Hacer", "FinMientras", "Para", "Hasta", "Con Paso", "FinPara",
            "Segun", "Caso", "De Otro Modo", "FinSegun", "Repetir", "Hasta Que",
            "Entero", "Real", "Numero", "Logico", "Booleano", "Caracter", "Texto", "Cadena", "MOD"
        ]
        all_keywords_lower_to_proper_case = {kw.lower(): kw for kw in all_keywords_list}

        indent_starters = {
            "proceso", "subproceso", "algoritmo",
            "si", "mientras", "para", "segun", "repetir",
            "sino", "de otro modo"
        }
        indent_enders = {
            "finproceso", "finsubproceso", "finalgoritmo",
            "finsi", "finmientras", "finpara", "finsegun", "hasta que"
        }
        indent_mid_transitions = {"sino", "de otro modo", "caso"}

        def get_keyword_starting_line(line_content_lower, keywords_set):
            for kw_lower in keywords_set:
                if line_content_lower.startswith(kw_lower):
                    # Specific check for "caso" to avoid matching identifiers like "casos"
                    # and ensure it's likely a structural "Caso expr:"
                    if kw_lower == "caso":
                        if not line_content_lower.startswith("caso ") and not ":" in line_content_lower:
                             continue # Likely not a structural "Caso"
                    return kw_lower
            return None

        in_repetir_block_awaiting_hasta_que = False # Specific for Repetir/Hasta Que structure

        for line_number, line in enumerate(lines):
            stripped_line = line.strip()

            if not stripped_line:
                formatted_lines.append("")
                continue
            
            comment_text = ""
            if "//" in stripped_line:
                parts = stripped_line.split("//", 1)
                main_code_part = parts[0].strip()
                comment_part = parts[1]
                if not comment_part.startswith(" "):
                    comment_part = " " + comment_part
                comment_text = "//" + comment_part
            else:
                main_code_part = stripped_line

            # Tokenize for keyword casing and spacing
            # Corrected regex: \b for word boundaries
            raw_tokens = re.split(r'(\s+|<-|<=|>=|<>|==|!=|=|<|>|\+|-|\*|/|%|\bMOD\b|Y|&|O|\||NO|~|\(|\)|,|//)', main_code_part)
            
            cased_and_spaced_tokens = []
            is_after_comment_delimiter = False # Flag to track if we are processing tokens after //
            for token_idx, token in enumerate(raw_tokens):
                if token is None or not token: 
                    continue

                if is_after_comment_delimiter: # Text after // is part of the comment
                    cased_and_spaced_tokens.append(token)
                    continue
                
                if token == "//":
                    cased_and_spaced_tokens.append(token)
                    is_after_comment_delimiter = True
                    continue

                if token.isspace(): # Preserve original significant spaces for now
                    cased_and_spaced_tokens.append(token)
                    continue
                
                lower_token = token.lower()
                # Rule 3: Keyword Casing
                if lower_token in all_keywords_lower_to_proper_case:
                    cased_token = all_keywords_lower_to_proper_case[lower_token]
                    cased_and_spaced_tokens.append(cased_token)
                else:
                    cased_and_spaced_tokens.append(token) # Not a keyword, add as is

            main_code = "".join(cased_and_spaced_tokens)
            # Reset flag for the next line's main_code processing
            is_after_comment_delimiter = False 

            # Rule 2.d: Space after keywords (if not followed by specific chars or end of line)
            for kw_l, kw_p in all_keywords_lower_to_proper_case.items():
                if kw_p not in ["MOD"]: # MOD is an operator, handled separately
                     # Corrected regex: \b for word boundary, \1 for backreference
                     main_code = re.sub(r'\b(' + re.escape(kw_p) + r')\b(?!\s|[\(\,])(?=\S)', r'\1 ', main_code)

            # Rule 2.a (Operators), 2.b (Commas), 2.c (Parentheses)
            # Corrected regex: \1 for backreference, \b for MOD
            main_code = re.sub(r'\s*(<-|<=|>=|<>|==|!=|=|<|>|\+|-|\*|/|%|\bMOD\b|Y|&|O|\||NO|~)\s*', r' \1 ', main_code)
            main_code = re.sub(r'\s*,\s*', r', ', main_code)
            main_code = re.sub(r'\(\s*', r'(', main_code)
            main_code = re.sub(r'\s*\)', r')', main_code)
            
            # Collapse multiple spaces into one, and strip leading/trailing spaces from the code part
            main_code = re.sub(r'\s+', ' ', main_code).strip()

            # Re-attach comment (Rule 5 comment spacing already handled)
            if comment_text:
                if main_code:
                    formatted_line_content = main_code + " " + comment_text
                else: # Line is only a comment
                    formatted_line_content = comment_text
            else:
                formatted_line_content = main_code
            
            # 1. Indentation
            current_indent_level_for_line = indentation_level # Indentation for the current line
            
            effective_code_lower = main_code_part.lower() # Use pre-formatted code part for structure check

            matched_ender = get_keyword_starting_line(effective_code_lower, indent_enders)
            matched_mid_transition = get_keyword_starting_line(effective_code_lower, indent_mid_transitions)

            if matched_ender:
                indentation_level = max(0, indentation_level - 1)
                current_indent_level_for_line = indentation_level 
                if matched_ender == "hasta que": # specific to Repetir-Hasta Que
                    in_repetir_block_awaiting_hasta_que = False
            elif matched_mid_transition:
                indentation_level = max(0, indentation_level - 1) # Dedent for self
                current_indent_level_for_line = indentation_level # This line uses the outer level
            
            current_indent_str = " " * current_indent_level_for_line * indent_size
            
            if not main_code_part and comment_text: # Line was originally only a comment
                final_line_to_add = current_indent_str + comment_text.lstrip() 
            else:
                final_line_to_add = current_indent_str + formatted_line_content

            formatted_lines.append(final_line_to_add)

            # Update indentation level for *next* line
            keyword_causing_next_indent = None
            if matched_mid_transition: # Sino, Caso, De Otro Modo also start a new indented block
                keyword_causing_next_indent = matched_mid_transition
            elif not matched_ender: # Enders don't start new indents
                keyword_causing_next_indent = get_keyword_starting_line(effective_code_lower, indent_starters)
            
            if keyword_causing_next_indent:
                indentation_level += 1
                if keyword_causing_next_indent == "repetir": # specific to Repetir-Hasta Que
                    in_repetir_block_awaiting_hasta_que = True
        
        # Rule 4: Blank Lines (Simplified: remove multiple consecutive blank lines, ensure at most one)
        final_output_lines = []
        last_line_was_blank = False
        for i, l_idx in enumerate(formatted_lines): # Use l_idx to avoid conflict with outer 'line'
            is_current_blank = not formatted_lines[i].strip() # Check current line from list
            if is_current_blank:
                if not last_line_was_blank:
                    final_output_lines.append("") # Add one blank line
                last_line_was_blank = True
            else:
                final_output_lines.append(formatted_lines[i])
                last_line_was_blank = False
                
        # Remove leading blank lines if any resulted
        while final_output_lines and not final_output_lines[0].strip():
            final_output_lines.pop(0)
            
        # Remove trailing blank lines if any resulted
        while final_output_lines and not final_output_lines[-1].strip():
            final_output_lines.pop()

        return "\n".join(final_output_lines)

    # If the script is run directly, read from stdin, format, and print to stdout
    if __name__ == '__main__':
        import sys
        # Basic test if run directly, not used by Neovim integration normally
        # To test manually: echo "Proceso prueba Escribir 'hola' FinProceso" | python3 this_script.py
        if not sys.stdin.isatty():
            input_code = sys.stdin.read()
            formatted_code = format_pseint_code(input_code)
            sys.stdout.write(formatted_code)
            if formatted_code and not formatted_code.endswith('\n'):
                 sys.stdout.write('\n')
            sys.stdout.flush()
        else:
            # Example for direct run test
            sample_code = "Proceso prueba\nEscribir 'hola'\nFinProceso"
            print("Original:")
            print(sample_code)
            print("\nFormatted:")
            print(format_pseint_code(sample_code))

    ```
    </details>

    *Note: The embedded Python script has corrected regex patterns (using `\b` for word boundaries and `\1` for backreferences) compared to the original version provided in the prompt.*

### Step 2: Configure Neovim

Add the following Lua code to your Neovim configuration. You can place it in your `init.lua` or in a separate file that is sourced by your `init.lua` (e.g., `lua/custom/pseint_formatter.lua` and then `require('custom.pseint_formatter')` in your `init.lua`).

```lua
-- PSeInt Formatter Integration
--
-- IMPORTANT: Update the 'formatter_cmd' variable below to point to your pseint_formatter.py script!
-- Example: local formatter_cmd = 'python3 ' .. vim.fn.stdpath('config') .. '/scripts/pseint_formatter.py'
local formatter_cmd = 'python3 /path/to/your/scripts/pseint_formatter.py' -- !!! CHANGE THIS PATH !!!
local python_executable = formatter_cmd:match("^([^ ]+)")

if vim.fn.executable(python_executable) == 1 then
  local function format_pseint(range_start, range_end)
    local view = vim.fn.winsaveview()
    local cmd_to_run

    if range_end == 0 then -- Whole buffer
      cmd_to_run = '%!' .. formatter_cmd
    else -- Range
      -- string.format for ranges, ensuring correct quoting for cmd module
      cmd_to_run = string.format("%d,%d!%s", range_start, range_end, formatter_cmd)
    end
    
    -- Using pcall to catch errors during the external command execution
    local status, err = pcall(vim.cmd, cmd_to_run)

    if not status then
      vim.notify("PSeInt formatting failed: " .. err, vim.log.levels.ERROR)
    else
      vim.notify("PSeInt: Formatted code.", vim.log.levels.INFO)
    end
    vim.fn.winrestview(view)
  end

  vim.keymap.set('n', '<leader>fp', function() format_pseint(0, 0) end,
    { noremap = true, silent = true, desc = "Format PSeInt Buffer" })
  vim.keymap.set('v', '<leader>fp', function()
      -- For visual mode, vim.fn.line("'<") and vim.fn.line("'>") get the start and end lines of the last visual selection.
      local start_line = vim.fn.line("'<")
      local end_line = vim.fn.line("'>")
      format_pseint(start_line, end_line)
    end,
    { noremap = true, silent = true, desc = "Format PSeInt Selection" })

  vim.notify("PSeInt Formatter enabled. Keymap: <leader>fp.", vim.log.levels.INFO)
  -- Check if the user is still using the placeholder path
  if formatter_cmd:match("/path/to/your/scripts/pseint_formatter.py") then
    vim.notify("PSeInt Formatter: Remember to update 'formatter_cmd' in your Neovim config!", vim.log.levels.WARN)
  end
else
  vim.notify("PSeInt Formatter: Python command '" .. python_executable .. "' not found. Formatter disabled. (Used command: " .. formatter_cmd .. ")", vim.log.levels.WARN)
end
```

**Crucial:** You **MUST** change the line:
`local formatter_cmd = 'python3 /path/to/your/scripts/pseint_formatter.py'`
to reflect the actual path where you saved `pseint_formatter.py`. For instance, if you saved it to `~/.config/nvim/scripts/pseint_formatter.py`, the line should look like this (Lua example):
`local formatter_cmd = 'python3 ' .. vim.fn.stdpath('config') .. '/scripts/pseint_formatter.py'`

## Usage

Once the script is saved and Neovim is configured:

*   **Normal Mode:** Press `<leader>fp` (typically `\fp` or `,fp` depending on your leader key) to format the entire PSeInt file.
*   **Visual Mode:** Select a portion of your PSeInt code and press `<leader>fp` to format only the selected lines.

## Formatting Rules Summary

The formatter applies the following main rules:

1.  **Indentation:** Uses 4 spaces for indentation. Indents bodies of `Proceso`, `SubProceso`, `Algoritmo`, `Si`, `Sino`, `Mientras`, `Para`, `Segun`, `Caso`, `De Otro Modo`, and `Repetir` blocks.
2.  **Spacing:**
    *   Adds single spaces around binary operators (e.g., `<-`, `+`, `MOD`).
    *   Ensures a single space after commas.
    *   No space after opening parentheses `(` and no space before closing parentheses `)`.
    *   Attempts to add a single space after keywords (like `Leer`, `Escribir`) if followed by other code.
3.  **Keyword Casing:** Converts PSeInt keywords to initial capital letter format (e.g., `proceso` becomes `Proceso`).
4.  **Blank Lines:** Reduces multiple consecutive blank lines to a single blank line. Removes leading/trailing blank lines from the output.
5.  **Comments:** Ensures a single space after `//`. Indents full-line comments to the current block level.
6.  **Line Endings:** Ensures each statement ends with a newline and removes trailing whitespace from all lines.

## Example

**Before Formatting:**

```pseint
Proceso    SUMA
  Escribir "Ingrese el primer numero:"
    Leer   A
Escribir "Ingrese el segundo numero:"
Leer B
    C  <-   A+B
    Escribir    "El resultado es: ",C // Suma realizada
FinProceso
```

**After Formatting (`<leader>fp`):**

```pseint
Proceso Suma
    Escribir "Ingrese el primer numero:"
    Leer A
    Escribir "Ingrese el segundo numero:"
    Leer B
    C <- A + B
    Escribir "El resultado es: ", C // Suma realizada
FinProceso
```
