#!/usr/bin/env python3
"""Check local HTML links and section anchors, including sparse checkouts."""
from html.parser import HTMLParser
from pathlib import Path
import posixpath
import subprocess
from urllib.parse import unquote, urlsplit

ROOT = Path(__file__).resolve().parents[1]


class Page(HTMLParser):
    def __init__(self, source):
        super().__init__()
        self.ids, self.links = set(), []
        self.feed(source)

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if 'id' in attrs:
            self.ids.add(attrs['id'])
        for key in ('href', 'src'):
            if attrs.get(key):
                self.links.append(attrs[key])


def main():
    tracked = set(subprocess.check_output(['git', 'ls-files'], cwd=ROOT, text=True).splitlines())
    pages = {p.relative_to(ROOT).as_posix(): Page(p.read_text()) for p in (ROOT / 'docs').glob('*.html')}
    errors = []
    for path, page in pages.items():
        for link in page.links:
            url = urlsplit(link)
            if url.scheme or url.netloc:
                continue
            target = posixpath.normpath(posixpath.join(posixpath.dirname(path), unquote(url.path))) if url.path else path
            if target == 'docs':
                target = 'docs/index.html'
            if target not in tracked and not (ROOT / target).is_file():
                errors.append(f'{path}: missing file {link}')
            elif url.fragment and target in pages and unquote(url.fragment) not in pages[target].ids:
                errors.append(f'{path}: missing anchor {link}')
    for error in errors:
        print(error)
    print(f'Checked {len(pages)} HTML pages: {len(errors)} broken local links.')
    return bool(errors)


if __name__ == '__main__':
    raise SystemExit(main())
