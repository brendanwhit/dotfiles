# Neovim Default Keybindings

This document contains a comprehensive list of Neovim's default keybindings, organized by category.

## Table of Contents
- [Basic Motion (Left-Right-Up-Down)](#basic-motion-left-right-up-down)
- [Word Motion](#word-motion)
- [Line Motion](#line-motion)
- [Text Object Motion](#text-object-motion)
- [Screen Position Motion](#screen-position-motion)
- [Search and Pattern Matching](#search-and-pattern-matching)
- [Marks and Jumps](#marks-and-jumps)
- [Scrolling](#scrolling)
- [Editing - Deletion](#editing---deletion)
- [Editing - Changes](#editing---changes)
- [Editing - Copy and Paste](#editing---copy-and-paste)
- [Editing - Case and Formatting](#editing---case-and-formatting)
- [Visual Mode](#visual-mode)
- [Insert Mode](#insert-mode)
- [Insert Mode - Completion](#insert-mode---completion)
- [Undo and Redo](#undo-and-redo)
- [Repeat and Macros](#repeat-and-macros)
- [Folding](#folding)
- [Window Management](#window-management)
- [Tab Pages](#tab-pages)
- [Help and Documentation](#help-and-documentation)

---

## Basic Motion (Left-Right-Up-Down)

### Left-Right Movement
- `h` or `<Left>` - Move cursor left one character
- `l` or `<Right>` - Move cursor right one character
- `0` - Move to first character of the line
- `^` - Move to first non-blank character of the line
- `$` - Move to end of the line
- `g_` - Move to last non-blank character of the line
- `|` - Move to column [count] (default 1)

### Up-Down Movement
- `k` or `<Up>` - Move cursor up one line
- `j` or `<Down>` - Move cursor down one line
- `-` - Move up to first non-blank character
- `+` or `<CR>` - Move down to first non-blank character
- `gg` - Go to first line of file
- `G` - Go to last line of file (or [count]th line)
- `{count}G` - Go to line [count]
- `{count}%` - Go to percentage through file

---

## Word Motion

- `w` - Move forward to beginning of next word
- `W` - Move forward to beginning of next WORD (non-blank characters)
- `e` - Move forward to end of word
- `E` - Move forward to end of WORD
- `b` - Move backward to beginning of previous word
- `B` - Move backward to beginning of previous WORD
- `ge` - Move backward to end of previous word
- `gE` - Move backward to end of previous WORD

---

## Line Motion

- `0` - Move to first character of line
- `^` - Move to first non-blank character of line
- `$` - Move to end of line
- `g_` - Move to last non-blank character of line
- `g0` - Move to first character of screen line (when lines wrap)
- `g^` - Move to first non-blank character of screen line
- `g$` - Move to end of screen line
- `gm` - Move to middle of screen line

---

## Text Object Motion

- `(` - Move backward to beginning of sentence
- `)` - Move forward to beginning of next sentence
- `{` - Move backward to beginning of paragraph
- `}` - Move forward to beginning of next paragraph
- `[[` - Move backward to beginning of section
- `]]` - Move forward to beginning of section
- `[]` - Move backward to end of section
- `][` - Move forward to end of section

---

## Screen Position Motion

- `H` - Move to top (Home) of screen
- `M` - Move to middle of screen
- `L` - Move to bottom (Last line) of screen
- `%` - Move to matching parenthesis/bracket/brace

---

## Search and Pattern Matching

### Forward/Backward Search
- `/` - Search forward for pattern
- `?` - Search backward for pattern
- `n` - Repeat last search in same direction
- `N` - Repeat last search in opposite direction

### Word Under Cursor Search
- `*` - Search forward for word under cursor (whole word)
- `#` - Search backward for word under cursor (whole word)
- `g*` - Search forward for word under cursor (partial match)
- `g#` - Search backward for word under cursor (partial match)

### Code Navigation
- `gd` - Go to local declaration of identifier under cursor
- `gD` - Go to global declaration of identifier under cursor

---

## Marks and Jumps

### Setting Marks
- `m{a-z}` - Set mark (lowercase: local to file)
- `m{A-Z}` - Set mark (uppercase: global across files)
- `m'` or ``m` `` - Set previous context mark

### Jumping to Marks
- `'{mark}` - Jump to first non-blank character of marked line
- `` `{mark} `` - Jump to exact position of mark
- `''` - Jump to position before latest jump (first non-blank)
- ``` `` ``` - Jump to exact position before latest jump

### Jump List Navigation
- `CTRL-O` - Go to older position in jump list
- `CTRL-I` or `<Tab>` - Go to newer position in jump list

### Change List Navigation
- `g;` - Go to older position in change list
- `g,` - Go to newer position in change list

---

## Scrolling

### Vertical Scrolling (Line-by-Line)
- `CTRL-E` - Scroll window down (text moves up on screen)
- `CTRL-Y` - Scroll window up (text moves down on screen)

### Vertical Scrolling (Half-Screen)
- `CTRL-D` - Scroll down half screen
- `CTRL-U` - Scroll up half screen

### Vertical Scrolling (Full-Screen)
- `CTRL-F` or `<PageDown>` - Scroll forward (down) one full screen
- `CTRL-B` or `<PageUp>` - Scroll backward (up) one full screen

### Position Cursor in Window
- `zt` - Scroll cursor line to top of window
- `zz` - Scroll cursor line to center of window
- `zb` - Scroll cursor line to bottom of window
- `z<CR>` - Scroll cursor line to top, cursor on first non-blank
- `z.` - Scroll cursor line to center, cursor on first non-blank
- `z-` - Scroll cursor line to bottom, cursor on first non-blank

### Horizontal Scrolling (when 'wrap' is off)
- `zh` or `z<Left>` - Scroll view left
- `zl` or `z<Right>` - Scroll view right
- `zH` - Scroll view half screenwidth left
- `zL` - Scroll view half screenwidth right
- `zs` - Scroll horizontally to position cursor at start of screen
- `ze` - Scroll horizontally to position cursor at end of screen

---

## Editing - Deletion

- `x` or `<Del>` - Delete character under cursor
- `X` - Delete character before cursor
- `d{motion}` - Delete text moved over by {motion}
- `dd` - Delete entire line
- `D` - Delete from cursor to end of line
- `dw` - Delete word from cursor
- `db` - Delete word backward
- `diw` - Delete inner word (word under cursor)
- `daw` - Delete a word (word + surrounding whitespace)
- `J` - Join current line with next line (remove line break)
- `gJ` - Join lines without inserting space

---

## Editing - Changes

- `c{motion}` - Change text moved over by {motion} (delete and enter insert mode)
- `cc` - Change entire line
- `C` - Change from cursor to end of line
- `s` - Substitute character (delete char and enter insert mode)
- `S` - Substitute entire line
- `r{char}` - Replace single character with {char}
- `R` - Enter Replace mode (overwrite text)
- `~` - Switch case of character under cursor
- `g~{motion}` - Switch case of text moved over by {motion}
- `gu{motion}` - Make text lowercase
- `gU{motion}` - Make text uppercase
- `>{motion}` - Indent text (shift right)
- `<{motion}` - Unindent text (shift left)
- `>>` - Indent current line
- `<<` - Unindent current line
- `==` - Auto-indent current line
- `={motion}` - Auto-indent text moved over by {motion}

---

## Editing - Copy and Paste

### Yanking (Copying)
- `y{motion}` - Yank (copy) text moved over by {motion}
- `yy` or `Y` - Yank entire line
- `yiw` - Yank inner word
- `yaw` - Yank a word (word + whitespace)

### Putting (Pasting)
- `p` - Put (paste) text after cursor
- `P` - Put text before cursor
- `gp` - Put text after cursor and move cursor after pasted text
- `gP` - Put text before cursor and move cursor after pasted text
- `]p` - Put text after cursor with indentation adjusted
- `[p` - Put text before cursor with indentation adjusted

---

## Editing - Case and Formatting

- `~` - Switch case of character
- `g~{motion}` - Switch case
- `gu{motion}` - Make lowercase
- `gU{motion}` - Make uppercase
- `gq{motion}` - Format text (wrap lines to textwidth)
- `gqap` - Format current paragraph
- `gw{motion}` - Format text but keep cursor position

---

## Visual Mode

### Entering Visual Mode
- `v` - Start visual mode (character-wise)
- `V` - Start visual mode (line-wise)
- `CTRL-V` - Start visual mode (block-wise)
- `gv` - Reselect previous visual selection
- `gn` - Search forward and start visual mode on match
- `gN` - Search backward and start visual mode on match

### Visual Mode Navigation
- `o` - Go to other end of highlighted text
- `O` - Go to other corner (block mode only)

### Exiting Visual Mode
- `<Esc>` or `CTRL-C` - Exit visual mode
- `v` - Exit visual mode (when already in character-wise visual)

### Visual Mode Operations
- `d` - Delete selected text
- `c` - Change selected text (delete and enter insert mode)
- `y` - Yank (copy) selected text
- `~` - Switch case of selected text
- `u` - Make selected text lowercase
- `U` - Make selected text uppercase
- `>` - Shift selected text right (indent)
- `<` - Shift selected text left (unindent)
- `=` - Auto-indent selected text
- `!` - Filter through external command
- `gq` - Format selected text to textwidth

---

## Insert Mode

### Entering Insert Mode
- `i` - Insert before cursor
- `I` - Insert at beginning of line (first non-blank)
- `a` - Append after cursor
- `A` - Append at end of line
- `o` - Open new line below and insert
- `O` - Open new line above and insert
- `gi` - Insert at last insert position
- `gI` - Insert at column 1

### Exiting Insert Mode
- `<Esc>` or `CTRL-[` - Exit insert mode, return to normal mode
- `CTRL-C` - Exit insert mode (doesn't trigger abbreviations)

### Insert Mode Editing
- `<BS>` or `CTRL-H` - Delete character before cursor
- `<Del>` - Delete character under cursor
- `CTRL-W` - Delete word before cursor
- `CTRL-U` - Delete all characters in current line before cursor
- `CTRL-T` - Insert one shiftwidth of indent at start of line
- `CTRL-D` - Delete one shiftwidth of indent at start of line

### Insert Mode Special
- `CTRL-@` - Insert previously inserted text and stop insert
- `CTRL-A` - Insert previously inserted text
- `CTRL-R {register}` - Insert contents of register
- `CTRL-K {char1}{char2}` - Enter digraph (special characters)
- `CTRL-V {code}` - Insert character literally (by code)
- `CTRL-O` - Execute one normal mode command and return to insert mode

### Insert Mode Navigation
- `<Up>` - Move cursor up one line
- `<Down>` - Move cursor down one line
- `<Left>` - Move cursor left one character
- `<Right>` - Move cursor right one character
- `<Home>` - Move to first character of line
- `<End>` - Move to end of line

### Insert from Adjacent Lines
- `CTRL-Y` - Insert character from line above cursor
- `CTRL-E` - Insert character from line below cursor

---

## Insert Mode - Completion

### Basic Completion
- `CTRL-N` - Find next keyword match (forward)
- `CTRL-P` - Find previous keyword match (backward)

### Extended Completion (CTRL-X submodes)
- `CTRL-X CTRL-N` - Complete keywords in current file
- `CTRL-X CTRL-P` - Complete keywords in current file (backward)
- `CTRL-X CTRL-L` - Complete whole lines
- `CTRL-X CTRL-F` - Complete file names
- `CTRL-X CTRL-K` - Complete from dictionary
- `CTRL-X CTRL-T` - Complete from thesaurus
- `CTRL-X CTRL-I` - Complete keywords from current and included files
- `CTRL-X CTRL-]` - Complete tags
- `CTRL-X CTRL-D` - Complete definitions or macros
- `CTRL-X CTRL-O` - Omni completion (language-aware)
- `CTRL-X CTRL-U` - User-defined completion
- `CTRL-X CTRL-V` - Complete like in command-line mode
- `CTRL-X s` - Spelling suggestions

---

## Undo and Redo

### Basic Undo/Redo
- `u` - Undo last change
- `CTRL-R` - Redo (undo the undo)
- `U` - Undo all changes on current line

### Undo Tree Navigation
- `g-` - Go to older text state in undo tree
- `g+` - Go to newer text state in undo tree

### Command-Line Undo
- `:undo` or `:u` - Undo one change
- `:redo` - Redo one change
- `:undo {N}` - Jump to state after change number N
- `:earlier {count}` - Go to older text state
- `:later {count}` - Go to newer text state
- `:undolist` - List the leaves in the undo tree

---

## Repeat and Macros

### Simple Repeat
- `.` - Repeat last change
- `@:` - Repeat last command-line command

### Recording and Playing Macros
- `q{register}` - Start recording macro into register
- `q` - Stop recording macro
- `@{register}` - Execute macro from register
- `@@` - Repeat last executed macro
- `Q` - Repeat last recorded register
- `{count}@{register}` - Execute macro [count] times

### Visual Mode Macros
- `{Visual}@{register}` - Execute macro for each selected line
- `{Visual}Q` - Repeat last recorded register for each line

---

## Folding

### Creating and Deleting Folds
- `zf{motion}` - Create fold for motion
- `{Visual}zf` - Create fold for visual selection
- `zF` - Create fold for [count] lines
- `zd` - Delete fold at cursor
- `zD` - Delete folds recursively at cursor
- `zE` - Eliminate all folds in window

### Opening and Closing Folds
- `zo` - Open fold under cursor
- `zO` - Open all folds under cursor recursively
- `zc` - Close fold under cursor
- `zC` - Close all folds under cursor recursively
- `za` - Toggle fold under cursor
- `zA` - Toggle all folds under cursor recursively
- `zv` - View cursor line (open folds to show cursor)
- `zx` - Update folds
- `zX` - Undo manually opened/closed folds

### Fold Level Commands
- `zm` - Fold more (decrease foldlevel)
- `zM` - Close all folds (set foldlevel=0)
- `zr` - Reduce folding (increase foldlevel)
- `zR` - Open all folds

### Fold Navigation
- `zj` - Move down to start of next fold
- `zk` - Move up to end of previous fold

### Fold Options
- `zn` - Fold none (disable folding)
- `zN` - Fold normal (enable folding)
- `zi` - Toggle foldenable option

---

## Window Management

### Creating Windows
- `CTRL-W s` or `CTRL-W S` - Split window horizontally
- `CTRL-W v` - Split window vertically
- `CTRL-W n` - Create new empty window (horizontal split)
- `CTRL-W ^` - Split and edit alternate file

### Window Navigation
- `CTRL-W h` - Move to window on the left
- `CTRL-W j` - Move to window below
- `CTRL-W k` - Move to window above
- `CTRL-W l` - Move to window on the right
- `CTRL-W w` - Cycle to next window
- `CTRL-W W` - Cycle to previous window
- `CTRL-W t` - Move to top-left window
- `CTRL-W b` - Move to bottom-right window
- `CTRL-W p` - Move to previous (last accessed) window

### Moving Windows
- `CTRL-W r` - Rotate windows downward/rightward
- `CTRL-W R` - Rotate windows upward/leftward
- `CTRL-W x` - Exchange current window with next window
- `CTRL-W H` - Move current window to far left (full height)
- `CTRL-W J` - Move current window to bottom (full width)
- `CTRL-W K` - Move current window to top (full width)
- `CTRL-W L` - Move current window to far right (full height)
- `CTRL-W T` - Move current window to new tab page

### Resizing Windows
- `CTRL-W =` - Make all windows equal size
- `CTRL-W +` - Increase window height
- `CTRL-W -` - Decrease window height
- `CTRL-W >` - Increase window width
- `CTRL-W <` - Decrease window width
- `CTRL-W _` - Maximize window height
- `CTRL-W |` - Maximize window width

### Closing Windows
- `CTRL-W q` or `CTRL-W c` - Quit/close current window
- `CTRL-W o` - Close all other windows (make current window only)

---

## Tab Pages

### Creating and Navigating Tabs
- `gt` or `CTRL-PageDown` - Go to next tab page
- `gT` or `CTRL-PageUp` - Go to previous tab page
- `{count}gt` - Go to tab page {count}
- `g<Tab>` or `CTRL-W g<Tab>` - Go to last accessed tab page

### Opening Files in Tabs
- `CTRL-W gf` - Open file under cursor in new tab
- `CTRL-W gF` - Open file under cursor in new tab and jump to line number

### Tab Commands
- `:tabnew` - Create new tab page
- `:tabedit {file}` - Edit file in new tab
- `:tabclose` - Close current tab page
- `:tabonly` - Close all other tab pages
- `:tabnext` or `:tabn` - Go to next tab
- `:tabprevious` or `:tabp` - Go to previous tab
- `:tabfirst` - Go to first tab
- `:tablast` - Go to last tab
- `:tabmove` - Move current tab to different position

---

## Help and Documentation

### Accessing Help
- `:help` or `:h` - Open help
- `:help {subject}` - Get help on specific subject
- `:helpgrep {pattern}` - Search all help files for pattern
- `CTRL-]` - Jump to tag under cursor (in help)
- `CTRL-T` or `CTRL-O` - Jump back from tag

### Help Navigation
- `CTRL-D` - Show matching help entries when typing :help
- `:q` - Close help window

### Mode-Specific Help Prefixes
When searching for help on mode-specific commands:
- Normal mode: no prefix (e.g., `:help x`)
- Visual mode: `v_` prefix (e.g., `:help v_d`)
- Insert mode: `i_` prefix (e.g., `:help i_CTRL-W`)
- Command-line mode: `:` prefix (e.g., `:help :quit`)
- Command-line editing: `c_` prefix (e.g., `:help c_CTRL-R`)

---

## Additional Notes

### Counts
Most commands can be prefixed with a count (number) to repeat the action. For example:
- `3j` - Move down 3 lines
- `2dd` - Delete 2 lines
- `5w` - Move forward 5 words

### Text Objects
Many commands work with text objects when combined with `i` (inner) or `a` (around):
- `w` - word
- `s` - sentence
- `p` - paragraph
- `t` - tag
- `"` `'` `` ` `` - quotes
- `(` `)` `b` - parentheses
- `{` `}` `B` - braces
- `[` `]` - brackets
- `<` `>` - angle brackets

Examples:
- `diw` - Delete inner word
- `ci"` - Change inside quotes
- `ya{` - Yank around braces (including braces)
- `dap` - Delete around paragraph

### Registers
Neovim has multiple registers for storing text:
- `"` - unnamed register (default)
- `0` - yank register
- `1-9` - delete registers (history)
- `a-z` - named registers
- `A-Z` - append to named registers
- `+` - system clipboard
- `*` - selection clipboard (X11)
- `_` - black hole register (deletes without saving)
- `/` - last search pattern
- `:` - last command
- `.` - last inserted text
- `%` - current file name
- `#` - alternate file name

Access registers with `"{register}` before a command (e.g., `"ayy` to yank line into register a).

---

*This reference guide covers the default keybindings in Neovim. Custom mappings and plugin-specific bindings are not included.*
