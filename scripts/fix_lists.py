#!/usr/bin/env python3
"""Insert the blank line RST requires between a multi-line paragraph and an indented
list that immediately follows it.

docutils raises "Unexpected indentation" when a paragraph spanning two or more lines is
immediately followed (no blank line) by a more-indented bullet/enumerated list; a
single-line paragraph in the same spot is accepted. Translation rewraps prose, so an
English single-line intro often becomes a multi-line Russian one and trips this. The fix
— a blank line before the list — is valid RST and renders identically.

This tool is DOCUTILS-DRIVEN rather than heuristic: it parses the file, and only at the
exact lines docutils reports "Unexpected indentation" — and only when that line is an
indented bullet/enumerated list item preceded by a non-blank line — does it insert a
blank line. It re-parses and repeats until stable. Lines docutils does not complain
about are never touched, so it cannot corrupt field lists, literal blocks, etc.

Requires docutils (installed as a Sphinx dependency); run it with the project venv's
python. If docutils is unavailable it does nothing (exit 0).

Usage:
    fix_lists.py FILE...        # fix files in place
    fix_lists.py --check FILE   # exit 1 if any change would be made (no write)
"""
import io
import re
import sys

BULLET = re.compile(r'^([-*+])( |\t|$)')
ENUM = re.compile(r'^(\d+|[a-zA-Z]|#)[.)]( |\t|$)')

try:
    from docutils.core import publish_doctree
    HAVE_DOCUTILS = True
except Exception:
    HAVE_DOCUTILS = False


def is_list_item(line):
    s = line.lstrip(' \t')
    return bool(BULLET.match(s) or ENUM.match(s))


def indent(line):
    s = line.rstrip('\n')
    return len(s) - len(s.lstrip(' \t'))


def indentation_error_lines(text):
    """Return the set of 1-based line numbers docutils reports as 'Unexpected
    indentation'."""
    ws = io.StringIO()
    try:
        publish_doctree(text, settings_overrides={
            'report_level': 2, 'halt_level': 5,
            'warning_stream': ws, 'input_encoding': 'utf-8',
        })
    except Exception:
        pass
    out = set()
    for line in ws.getvalue().splitlines():
        if 'Unexpected indentation' in line:
            m = re.search(r':(\d+):', line)
            if m:
                out.add(int(m.group(1)))
    return out


def fix_text(text):
    """Iteratively insert blank lines before docutils-flagged indented list items."""
    lines = text.splitlines(keepends=True)
    changed = False
    for _ in range(50):  # safety bound; each pass fixes >=1 site
        joined = ''.join(lines)
        errs = indentation_error_lines(joined)
        if not errs:
            break
        # Insert bottom-up so earlier line numbers stay valid.
        did = False
        for ln in sorted(errs, reverse=True):
            i = ln - 1
            if i < 1 or i >= len(lines):
                continue
            if not is_list_item(lines[i]) or indent(lines[i]) <= 0:
                continue
            if lines[i - 1].strip() == '':
                continue  # already preceded by a blank line
            lines.insert(i, '\n')
            did = True
            changed = True
        if not did:
            break  # nothing we recognise; leave the rest to the build gate
    return ''.join(lines), changed


def main(argv):
    check = False
    files = []
    for a in argv:
        if a == '--check':
            check = True
        else:
            files.append(a)
    if not files:
        print(__doc__)
        return 2
    if not HAVE_DOCUTILS:
        sys.stderr.write("fix_lists: docutils unavailable; skipping.\n")
        return 0
    changed_any = False
    for path in files:
        with open(path, 'r', encoding='utf-8') as f:
            text = f.read()
        fixed, changed = fix_text(text)
        if changed and fixed != text:
            changed_any = True
            if check:
                print(f"would change: {path}")
            else:
                with open(path, 'w', encoding='utf-8') as f:
                    f.write(fixed)
                print(f"fixed: {path}")
    return 1 if (check and changed_any) else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
