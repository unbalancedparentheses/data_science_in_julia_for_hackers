#!/usr/bin/env python3
"""Typeset the Mars teaching revision while preserving historical computed figures.

This is not a Julia execution engine. Exact legacy chunk inputs are checked
against their archived rendering; changed inputs require fresh computed output.
New teaching snippets are typeset only and tested by the companion's test suite.
"""
import argparse
import json
from pathlib import Path
import re
import subprocess

from render_new_chapters import pandoc_command

ROOT = Path(__file__).resolve().parents[1]
ARCHIVE = ROOT / 'publishing/mars/legacy-chunks.json'
CHUNK = re.compile(r'^```\{julia([^\n]*)\}[^\n]*\n(.*?)^```', re.M | re.S)


def render(source, template):
    chunks = json.loads(ARCHIVE.read_text())['chunks']
    remaining = set(range(len(chunks)))
    placeholders = {}

    def preserve(match):
        matches = [i for i in remaining if chunks[i]['code'] == match[2].strip()
                   and chunks[i]['options'] == match[1].strip()]
        if matches:
            index = matches[0]
            remaining.remove(index)
            marker = f'<!-- preserved-mars-chunk-{index} -->'
            placeholders[marker] = chunks[index]['html']
            return marker
        # Newly authored teaching examples have no archived computational output.
        return '```julia\n' + match[2] + '```'

    markdown = CHUNK.sub(preserve, source)
    if remaining:
        raise ValueError('Legacy Julia chunk changed or disappeared; rerun and review its output before updating the archive: ' +
                         ', '.join(str(i) for i in sorted(remaining)))
    content = subprocess.check_output(pandoc_command() + [
        '--from=markdown+tex_math_single_backslash', '--to=html4', '--section-divs',
        '--mathjax', '--number-sections', '--number-offset=5', '--wrap=none',
    ], input=markdown, text=True, cwd=ROOT)
    # Preserve old cb* links and keep newly typeset examples in their own namespace.
    content = re.sub(r'\bcb(\d+)(-\d+)?\b', r'mars-teaching-cb\1\2', content)
    for marker, original in placeholders.items():
        if content.count(marker) != 1:
            raise ValueError('Pandoc did not preserve a legacy chunk placeholder')
        content = content.replace(marker, original)
    result, count = re.subn(r'(<section class="normal" id="section-">).*?(</section>)',
                            lambda m: m[1] + '\n' + content + '\n' + m[2],
                            template, count=1, flags=re.S)
    if count != 1:
        raise ValueError('Expected a single GitBook content section')
    return re.sub(r'[ \t]+$', '', result, flags=re.M)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    destination = ROOT / 'docs/escaping-from-mars.html'
    before = destination.read_text()
    after = render((ROOT / '06_gravity.Rmd').read_text(), before)
    if args.check and before != after:
        raise SystemExit('Stale Mars teaching page; run scripts/render_mars_teaching.py')
    if not args.check and before != after:
        destination.write_text(after)
    print(f'Rendered Mars prose with preserved legacy outputs; {int(before != after)} page changed.')


if __name__ == '__main__':
    main()
