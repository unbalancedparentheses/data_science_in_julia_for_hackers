#!/usr/bin/env python3
"""Rebuild GitBook search from all canonical published chapter pages."""
from html.parser import HTMLParser
import json
from update_navigation import CHAPTERS, DOCS


class Content(HTMLParser):
    def __init__(self):
        super().__init__()
        self.active = False
        self.heading = False
        self.headings = []
        self.text = []

    def handle_starttag(self, tag, attrs):
        if tag == 'section' and dict(attrs).get('class') == 'normal':
            self.active = True
        if self.active:
            self.text.append(' ')
            if tag in ('h1', 'h2', 'h3', 'h4', 'h5', 'h6'):
                self.heading = True
                self.headings.append(' ')

    def handle_endtag(self, tag):
        if tag == 'section':
            self.active = False
        if tag in ('h1', 'h2', 'h3', 'h4', 'h5', 'h6'):
            self.heading = False

    def handle_data(self, data):
        if self.active:
            self.text.append(data)
            if self.heading:
                self.headings.append(data)


def main():
    entries = []
    for name in CHAPTERS:
        content = Content()
        content.feed((DOCS / (name + '.html')).read_text())
        text = ' '.join(''.join(content.text).split())
        headings = ' '.join(''.join(content.headings).split())
        if not text or not headings:
            raise ValueError(f'No searchable content in {name}')
        entries.append([name + '.html', headings, text])
    (DOCS / 'search_index.json').write_text(json.dumps(entries, ensure_ascii=False) + '\n')


if __name__ == '__main__':
    main()
