#!/usr/bin/env bash
# tree_to_md.sh — Convert `tree` command output into nested Markdown headings.
#
# Top-level entries become "##", their children "###", grandchildren "####",
# and so on (capped at "######").
#
# Uses an embedded Python parser (rather than awk) because awk's handling of
# tree's multi-byte box-drawing characters (│ ├ └) is inconsistent across
# awk implementations and locales. Python's native Unicode string handling
# avoids that whole class of bugs.
#
# Also handles the fact that some tree builds pad continuation lines with
# non-breaking spaces (U+00A0) instead of regular spaces after "│", to
# survive whitespace-trimming when output is copy-pasted.
#
# Handles both of tree's output styles:
#   Unicode (default in UTF-8 locales): ├── └── │
#   ASCII   (default in non-UTF-8 locales, or `tree --charset=ascii`): |-- `-- |
#
# Requires python3 (present on virtually every modern system).
#
# Usage:
#   tree | ./tree_to_md.sh > output.md
#   ./tree_to_md.sh < tree_output.txt > output.md
#   :%!./tree_to_md.sh          (inside Neovim, filters current buffer)

python3 <(cat << 'PYEOF'
import sys, re

# A continuation "unit" is one indent level's worth of padding before the
# next connector: either "│" + 3 whitespace-like chars, "|" + 3 whitespace
# chars (ASCII mode), or 4 plain whitespace-like chars (last-branch mode).
# Whitespace-like includes regular space (U+0020) and non-breaking space
# (U+00A0), since different tree builds/platforms use either.
WS = ' \u00a0'
UNIT = r'(?:\u2502[' + WS + r']{3}|\|[' + WS + r']{3}|[' + WS + r']{4})'
CONNECTOR_RE = re.compile(
    r'^(' + UNIT + r'*)(?:\u251c\u2500\u2500 |\u2514\u2500\u2500 |\|-- |`-- )(.*)$'
)
SUMMARY_RE = re.compile(r'^\d+ director(y|ies), \d+ files?$')


def main():
    first = True
    for raw in sys.stdin:
        line = raw.rstrip('\n')
        stripped = line.strip()

        if not stripped or SUMMARY_RE.match(stripped):
            first = False
            continue

        m = CONNECTOR_RE.match(line)
        if m:
            depth = len(m.group(1)) // 4
            name = m.group(2)
        else:
            depth = -1 if first else 0
            name = stripped

        first = False
        name = name.rstrip('/')
        if not name:
            continue

        level = min(max(depth + 2, 1), 6)
        print('#' * level + ' ' + name)


if __name__ == '__main__':
    main()
PYEOF
)
