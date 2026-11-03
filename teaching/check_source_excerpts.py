#!/usr/bin/env python3
"""Keep the small code excerpts readers inspect aligned with executed chapter code."""
from pathlib import Path
import re
import textwrap

ROOT = Path(__file__).resolve().parents[1]
CHAPTERS = ("14_model_evaluation", "15_tabular_learning", "16_causal_inference", "17_bayesian_workflow")
PATTERN = re.compile(r'<!-- source-excerpt: ([^\n]+) -->\s*```julia\n(.*?)\n```', re.S)


def main():
    checked = 0
    for chapter in CHAPTERS:
        for name, excerpt in PATTERN.findall((ROOT / (chapter + '.Rmd')).read_text()):
            source = ROOT / name
            lines = source.read_text().splitlines()
            count = len(excerpt.splitlines())
            matches = [textwrap.dedent('\n'.join(lines[i:i + count])).strip()
                       for i in range(len(lines) - count + 1)]
            if excerpt.strip() not in matches:
                raise SystemExit(f'{chapter}: excerpt drifted from {name}\n{excerpt}')
            checked += 1
    if checked == 0:
        raise SystemExit('No source excerpts found')
    print(f'{checked} teaching excerpts match the executed source.')


if __name__ == '__main__':
    main()
