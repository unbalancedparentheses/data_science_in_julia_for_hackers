#!/usr/bin/env python3
"""Rebuild every sidebar from the headings in the published chapter pages."""
import html
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
DOCS = ROOT / "docs"
CHAPTERS = ["index", "science-technology-and-epistemology", "meeting-julia",
            "probability-introduction", "spam-filter", "probabilistic-programming",
            "escaping-from-mars", "football-simulation", "basketball-shots",
            "optimal-pricing", "image-classification", "ultima-online",
            "ultima-continued", "time-series", "model-evaluation",
            "tabular-learning", "causal-inference", "bayesian-workflow"]
PARTS = {1: ["I Data Science and Julia"], 3: ["II Bayesian Statistics"],
         10: ["III Deep Learning"],
         11: ["IV Scientific Machine Learning"], 13: ["V Time Series and Forecasting"],
         14: ["VI Evaluating and Improving Models"],
         16: ["VII Causal Inference and Bayesian Workflow"]}


def chapter_entries(name):
    source = (DOCS / (name + ".html")).read_text()
    sections = re.findall(r'<div id="([^"]+)" class="section level(\d)[^"]*"[^>]*>\s*<h\d[^>]*>(.*?)</h\d>', source, re.S)
    entries = []
    for anchor, level, heading in sections:
        match = re.search(r'<span class="header-section-number">(.*?)</span>', heading)
        number = re.sub(r'^Chapter\s+', '', match[1]) if match else ""
        heading = re.sub(r'<span class="header-section-number">.*?</span>', '', heading)
        title = html.unescape(re.sub('<[^>]+>', '', heading)).strip()
        entries.append((int(level), anchor, number, title))
    if not entries:
        raise ValueError(f"No chapter headings in {name}")
    output, depth = [], 0
    ancestors = []
    for source_level, anchor, number, title in entries:
        # Some existing chapters skip a heading level. Preserve the outline
        # without emitting an invalid <ul> directly inside another <ul>.
        while ancestors and ancestors[-1] >= source_level:
            ancestors.pop()
        ancestors.append(source_level)
        level = len(ancestors)
        if level > depth:
            output.extend(["<ul>"] * (level - depth - (depth == 0)))
        else:
            output.append("</li>")
            output.extend(["</ul></li>"] * (depth - level))
        path = name + ".html"
        label = (f"<b>{html.escape(number)}</b> " if number else "") + html.escape(title)
        output.append(f'<li class="chapter" data-level="{number}" data-path="{path}"><a href="{path}#{anchor}"><i class="fa fa-check"></i>{label}</a>')
        depth = level
    output.append("</li>")
    output.extend(["</ul></li>"] * (depth - 1))
    return "\n".join(output)


def main():
    parts = ['<li><a href="./">Data Science in Julia for Hackers</a></li>']
    for index, name in enumerate(CHAPTERS):
        for title in PARTS.get(index, []):
            parts.append(f'<li class="part"><span><b>{title}</b></span></li>')
        parts.append(chapter_entries(name))
    parts.append('<li><a href="https://github.com/unbalancedparentheses/data_science_in_julia_for_hackers" target="blank">Published with bookdown</a></li>')
    sidebar = '<ul class="summary">\n' + '\n'.join(parts) + '\n</ul>'
    for path in DOCS.glob('*.html'):
        source, count = re.subn(r'<ul class="summary">.*?</ul>(?=\s*</nav>)', lambda _: sidebar, path.read_text(), flags=re.S)
        if count != 1:
            raise ValueError(f"Expected one sidebar in {path}, got {count}")
        path.write_text(source)


if __name__ == '__main__':
    main()
