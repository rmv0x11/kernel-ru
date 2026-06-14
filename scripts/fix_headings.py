#!/usr/bin/env python3
"""Normalize reStructuredText section-title under/overline lengths after translation.

A Russian title rarely matches the length of the English one it replaced, so its
underline (and optional overline) can end up shorter than the title text and Sphinx
errors with "Title underline too short". This tool lengthens such adornment lines to
match the title width.

Design for safety (it is a NO-OP on the untouched English tree — that is the test):

  * Only the adornment characters the kernel actually uses for section titles are
    considered: = - ~ ^ " # * + . This deliberately excludes ':' so the RST literal
    block marker "::" is never mistaken for a title underline.
  * An adornment line is only touched when it is directly adjacent to a title *text*
    line (so transitions, which are surrounded by blank lines, are left alone) and is
    not indented (so code/literal blocks are left alone).
  * LENGTHEN-ONLY: a line is changed only when it is *shorter* than the title width.
    Over-long underlines (valid RST) are never shortened. Hence a no-op on English.
  * For over+under titles, when either adornment is too short, both are set equal to
    the title width (always valid).

Width is counted in Unicode code points (Cyrillic letters have width 1, matching how
docutils measures adornment length).

Usage:
    fix_headings.py FILE...        # fix files in place
    fix_headings.py --check FILE   # exit 1 if any change would be made (no write)
"""
import sys

# Only the adornment characters used for section titles in the kernel docs.
# Excludes ':' (literal-block marker '::') and '.' (comment/directive '..').
TITLE_ADORN = set('=-~^"#*+')


def adorn_char(line):
    """Return the adornment char if `line` is a non-indented run of one title
    adornment char (length >= 2), else None."""
    s = line.rstrip('\n')
    if len(s) < 2 or s[0] in (' ', '\t'):
        return None
    ch = s[0]
    if ch in TITLE_ADORN and s == ch * len(s):
        return ch
    return None


def is_title_text(line):
    """A plausible section-title text line: non-blank, not indented, not an
    adornment line itself."""
    s = line.rstrip('\n')
    if not s or s[0] in (' ', '\t'):
        return False
    return adorn_char(line) is None


def width(line):
    # docutils ignores trailing whitespace on the title line.
    return len(line.rstrip())


def _set_len(line, ch, n):
    nl = '\n' if line.endswith('\n') else ''
    return ch * n + nl


def fix_lines(lines):
    out = list(lines)
    n = len(out)
    for j in range(n):
        ch = adorn_char(out[j])
        if ch is None:
            continue
        # Underline candidate: adornment line directly under a title text line.
        if j - 1 < 0 or not is_title_text(out[j - 1]):
            continue
        need = width(out[j - 1])
        under_len = width(out[j])
        # Matching overline directly above the title text line?
        over_j = j - 2 if (j - 2 >= 0 and adorn_char(out[j - 2]) == ch) else None
        over_len = width(out[over_j]) if over_j is not None else None

        # Only treat as a real underline if it is already a *plausible* one: at least
        # 3 chars and at least half the title width. This skips quoted-email "--" and
        # similar short runs that sit under text but are not section titles. A truly
        # broken underline beyond this range is caught by the Sphinx build instead.
        if under_len < 3 or under_len * 2 < need:
            continue

        too_short = under_len < need or (over_len is not None and over_len < need)
        if not too_short:
            continue  # lengthen-only: leave valid (>=) adornments untouched

        out[j] = _set_len(out[j], ch, need)
        if over_j is not None:
            out[over_j] = _set_len(out[over_j], ch, need)
    return out


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
    changed_any = False
    for path in files:
        with open(path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        fixed = fix_lines(lines)
        if fixed != lines:
            changed_any = True
            if check:
                print(f"would change: {path}")
            else:
                with open(path, 'w', encoding='utf-8') as f:
                    f.writelines(fixed)
                print(f"fixed: {path}")
    return 1 if (check and changed_any) else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
