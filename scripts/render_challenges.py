#!/usr/bin/env python3
"""Publish the companion exercises without adding a numbered book chapter."""
import argparse
import re
import subprocess

from render_new_chapters import ROOT, page, pandoc_command


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    content = subprocess.check_output(
        pandoc_command() + ['--from=markdown', '--to=html4', '--section-divs', '--wrap=none'],
        input=(ROOT / 'documentation/Challenges.md').read_text(), text=True, cwd=ROOT)
    rendered = page((ROOT / 'docs/time-series.html').read_text(), content,
                    0, 'Experiments to try after each chapter', 'index', None)
    rendered = rendered.replace('Chapter 0 Experiments', 'Experiments')
    link = ('<p id="chapter-challenges">Ready to try your own experiments? '
            '<a href="challenges.html">The chapter challenge guide</a> offers '
            'prediction questions, experiments, and projects, with hints and worked reasoning.</p>')
    home_path = ROOT / 'docs/index.html'
    home = home_path.read_text()
    if 'id="chapter-challenges"' in home:
        home = re.sub(r'<p id="chapter-challenges">.*?</p>', lambda _: link, home, count=1, flags=re.S)
    else:
        if home.count('</section>') != 1:
            raise ValueError('Expected one homepage reading section')
        home = home.replace('</section>', link + '\n</section>')
    changed = []
    for path, value in [(ROOT / 'docs/challenges.html', rendered), (home_path, home)]:
        if not path.exists() or path.read_text() != value:
            changed.append(path.name)
            if not args.check:
                path.write_text(value)
    if args.check and changed:
        raise SystemExit('Stale challenge publication: ' + ', '.join(changed))
    print(f'Checked challenge guide and homepage; {len(changed)} changed.')


if __name__ == '__main__':
    main()
