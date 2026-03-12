# Keybinding Reference

> **Leader:** `\` &nbsp;&nbsp; **Localleader:** `Space`

## Strategy

Keybindings live in **two layers**:

| Layer | File | Scope |
|---|---|---|
| **VSCode** | `keybindings.json` (profile) | Global — works in terminal, sidebar, panels |
| **Neovim** | `lua/config/vscode_keymaps.lua` | Editor-only — fires when neovim has focus |

**Rule of thumb:** If it needs to work when the cursor is *not* in an editor
(e.g. toggling sidebar, switching editor groups), keep it in VSCode.  Everything
else goes in neovim so it can use Vim modes and `<localleader>`.

---

## VSCode Layer (`keybindings.json`)

| Key | Action |
|---|---|
| `ctrl+shift+p` | Command palette |
| `ctrl+p` | Quick open file |
| `ctrl+b` | Toggle sidebar |
| `ctrl+shift+c` | Toggle Copilot chat panel |
| `ctrl+i` | Inline chat (editor focus) |
| `ctrl+`` ` | Toggle terminal |
| `ctrl+shift+`` ` | New terminal |
| `ctrl+shift+m` | Insert ` \|> ` (editor: R/Rmd/Quarto, terminal) |
| `cmd+shift+m` (terminal) | Insert ` \|> ` in terminal |
| `ctrl+w h/j/k/l` | Focus left/below/above/right group |
| `ctrl+w H/J/K/L` | Move editor to group |

---

## Neovim Layer (`vscode_keymaps.lua`)

### Insert Mode

| Key | Action |
|---|---|
| `alt+-` | Insert ` <- ` (assignment) |
| `ctrl+shift+m` | Insert ` \|> ` (pipe) — *handled in VSCode layer* |

### Normal / Visual — Code Execution

| Key | Action |
|---|---|
| `Enter` | Run line / selection |
| `ctrl+shift+Enter` | Run chunk / source file / quarto cell |

### `<localleader>r` — R Commands (foreground)

| Key | Action |
|---|---|
| `<localleader>rh` | R help for symbol under cursor |

### `<localleader>` — R Object Inspection (foreground)

Operates on the **word under cursor** (or visual selection).

| Key | R Expression | Description |
|---|---|---|
| `<localleader>s` | `str($$)` | Structure |
| `<localleader>g` | `glimpse($$)` | Glimpse (falls back to str) |
| `<localleader>p` | `$$` | Print |
| `<localleader><localleader>` | `$$` | Print (double-tap) |
| `<localleader>d` | `dim($$)` | Dimensions |
| `<localleader>h` | `head($$)` | Head |
| `<localleader>a` | `attributes($$)` | Attributes |
| `<localleader>n` | `names($$)` | Names |
| `<localleader>N` | `matrix(names($$), ncol=1)` | Names (vertical) |
| `<localleader>v` | `View($$)` | View in viewer |
| `<localleader>u` | `summary($$)` | Summary |
| `<localleader>w` | `options(width=…)` | Set terminal width |

### `<localleader>` — `.Last.value` Inspection

| Key | R Expression | Description |
|---|---|---|
| `<localleader>P` | `.Last.value` | Print last value |
| `<localleader>G` | `glimpse(.Last.value)` | Glimpse last value |

### `<localleader>b` — Background Tasks (package dev, builds)

| Key | Action |
|---|---|
| `<localleader>bd` | `devtools::document()` |
| `<localleader>bl` | Document + `devtools::load_all()` |
| `<localleader>bi` | Document + `devtools::install()` |
| `<localleader>br` | Restart R session |
| `<localleader>bp` | Task: Pkgdown build site |
| `<localleader>bv` | Task: Build Vignettes |
| `<localleader>bt` | Task: Tar Make |
