# Qutebrowser Userscripts

This directory contains custom userscripts for qutebrowser.

## Installation

Run the setup script to create symlinks to the qutebrowser userscripts directory:

```bash
./setup.sh
```

This will:
- Create the `~/.local/share/qutebrowser/userscripts/` directory if needed
- Make all scripts executable
- Create symlinks for each userscript

## Userscripts

### heckyesmarkdown

Converts the current webpage to Markdown using the [heckyesmarkdown](https://heckyesmarkdown.com/) service.

**Features:**
- Uses Readability algorithm to extract main content
- Formats with inline links
- Automatically copies markdown to clipboard
- Shows status messages in qutebrowser

**Usage:**
- Keyboard binding: `,h` - Convert current page to markdown
- Keyboard binding: `,H` - Use hint mode to select a link and convert it
- Manual: `:spawn --userscript heckyesmarkdown`

**Requirements:**
- One of: `wl-copy` (Wayland), `xclip`, or `xsel` (X11) for clipboard support

**Configuration:**
The keyboard bindings are defined in `~/.config/qutebrowser/config.py`:
```python
config.bind(',h', 'spawn --userscript heckyesmarkdown')
config.bind(',H', 'hint links userscript heckyesmarkdown')
```
