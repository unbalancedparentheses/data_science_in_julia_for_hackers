#!/usr/bin/env python3
"""Render new chapter prose/code into the existing GitBook shell.

Execution is tested separately by each chapter's Julia scripts. This command
only typesets the Rmd code blocks; it never fabricates computational output.
Requires Pandoc (standalone, or bundled with Quarto).
"""
import argparse
import html
import os
from pathlib import Path
import re
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[1]
CHAPTERS = [
    (14, '14_model_evaluation.Rmd', 'model-evaluation', 'How to know your model is wrong'),
    (15, '15_tabular_learning.Rmd', 'tabular-learning', 'Learning from messy tabular data'),
    (16, '16_causal_inference.Rmd', 'causal-inference', 'From prediction to intervention'),
    (17, '17_bayesian_workflow.Rmd', 'bayesian-workflow', 'A complete Bayesian workflow'),
]


def pandoc_command():
    if os.environ.get('PANDOC'):
        return [os.environ['PANDOC']]
    if shutil.which('pandoc'):
        return ['pandoc']
    return [os.environ.get('QUARTO', 'quarto'), 'pandoc']


def page(template, content, number, title, previous, following):
    title = f'Chapter {number} {title} | Data Science in Julia for Hackers'
    source = template.replace('Chapter 13 Time series | Data Science in Julia for Hackers', html.escape(title))
    source = re.sub(r'<html lang="[^"]*" xml:lang="[^"]*">', '<html lang="en" xml:lang="en">', source)
    source = re.sub(r'<meta name="generator" content="[^"]*" />',
                    '<meta name="generator" content="Pandoc and GitBook 2.6.7" />', source)
    source = re.sub(r'(<section class="normal" id="section-">).*?(</section>)', lambda m: m[1] + '\n' + content + '\n' + m[2], source, count=1, flags=re.S)
    source = re.sub(r'<link rel="(?:prev|next)"[^>]+>\s*', '', source)
    relations = f'<link rel="prev" href="{previous}.html"/>\n'
    navigation = f'<a href="{previous}.html" class="navigation navigation-prev" aria-label="Previous page"><i class="fa fa-angle-left"></i></a>'
    if following:
        relations += f'<link rel="next" href="{following}.html"/>\n'
        navigation += f'\n<a href="{following}.html" class="navigation navigation-next" aria-label="Next page"><i class="fa fa-angle-right"></i></a>'
    source = source.replace('</head>', relations + '</head>')
    source, count = re.subn(r'<a href="[^"]+" class="navigation navigation-prev[^\"]*"[^>]*>.*?</a>(?:\s*<a href="[^"]+" class="navigation navigation-next[^\"]*"[^>]*>.*?</a>)?', lambda _: navigation, source, count=1, flags=re.S)
    if count != 1:
        raise ValueError('GitBook template has no previous-page navigation')
    return re.sub(r"[ \t]+$", "", source, flags=re.M)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true', help='fail if committed HTML differs')
    args = parser.parse_args()
    template = (ROOT / 'docs/time-series.html').read_text()
    changed = []
    for index, (number, filename, slug, title) in enumerate(CHAPTERS):
        markdown = (ROOT / filename).read_text()
        markdown = re.sub(r'^```\{julia[^\n]*\}\s*$', '```julia', markdown, flags=re.M)
        content = subprocess.check_output(pandoc_command() + [
            '--from=markdown+tex_math_single_backslash', '--to=html4', '--section-divs', '--mathjax',
            '--number-sections', f'--number-offset={number-1}', '--wrap=none',
        ], input=markdown, text=True, cwd=ROOT)
        previous = CHAPTERS[index-1][2] if index else 'time-series'
        following = CHAPTERS[index+1][2] if index+1 < len(CHAPTERS) else None
        rendered = page(template, content, number, title, previous, following)
        destination = ROOT / 'docs' / (slug + '.html')
        if not destination.exists() or destination.read_text() != rendered:
            changed.append(destination.name)
            if not args.check:
                destination.write_text(rendered)
    if args.check and changed:
        raise SystemExit('Stale chapter pages: ' + ', '.join(changed))
    print(f'Rendered {len(CHAPTERS)} chapter pages; {len(changed)} changed.')


if __name__ == '__main__':
    main()
