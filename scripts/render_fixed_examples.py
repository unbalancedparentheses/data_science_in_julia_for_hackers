#!/usr/bin/env python3
"""Refresh legacy algorithms and typeset chapter 4 results verified by evaluate_book.jl."""
import argparse
import re
import subprocess

from render_new_chapters import ROOT, pandoc_command
from spam_results import sync_spam_results

CASES = [
    ('04_naive_bayes.Rmd', 'spam-filter.html', 'cb5', 'mutable struct BayesSpamFilter'),
    ('04_naive_bayes.Rmd', 'spam-filter.html', 'cb7', 'function fit!('),
    ('04_naive_bayes.Rmd', 'spam-filter.html', 'cb12', 'function spam_predict('),
    ('04_naive_bayes.Rmd', 'spam-filter.html', 'cb13', 'function get_predictions('),
    ('10_bees_vs_wasps.Rmd', 'image-classification.html', 'cb2', 'function resize_and_grayify('),
]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    pages = {}
    for source, page, block, prefix in CASES:
        code = re.search(re.escape(prefix) + r'.*?\nend', (ROOT / source).read_text(), re.S)[0]
        rendered = subprocess.check_output(pandoc_command() + ['--from=markdown', '--to=html4', '--wrap=none'],
            input='```julia\n' + code + '\n```\n', text=True, cwd=ROOT).strip()
        rendered = rendered.replace('cb1', block)
        rendered = re.sub(r'<a href="#(cb\d+-\d+)"',
                          lambda m: f'<a href="{page}#{m[1]}" aria-hidden="true"', rendered)
        destination = ROOT / 'docs' / page
        before = pages.get(destination, destination.read_text())
        after, count = re.subn(r'<div class="sourceCode" id="' + block + r'">.*?</div>',
                              lambda _: rendered, before, count=1, flags=re.S)
        if count != 1:
            raise ValueError(f'Expected algorithm block {page}#{block}')
        pages[destination] = after
    source_path = ROOT / '04_naive_bayes.Rmd'
    page_path = ROOT / 'docs/spam-filter.html'
    pages[source_path], pages[page_path] = sync_spam_results(source_path.read_text(), pages[page_path])
    changed = [path.name for path, content in pages.items() if content != path.read_text()]
    if args.check and changed:
        raise SystemExit('Stale corrected code blocks: ' + ', '.join(changed))
    if not args.check:
        for path, content in pages.items():
            path.write_text(content)
    print(f'Rendered corrected legacy code and verified readouts; {len(changed)} files changed.')


if __name__ == '__main__':
    main()
