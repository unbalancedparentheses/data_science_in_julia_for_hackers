import html
from html.parser import HTMLParser
import importlib.util
import json
from pathlib import Path
import re
import subprocess
import unittest

ROOT = Path(__file__).resolve().parents[1]


class Lists(HTMLParser):
    def __init__(self):
        super().__init__()
        self.stack = []

    def handle_starttag(self, tag, attrs):
        if tag == 'ul':
            if self.stack:
                assert self.stack[-1] == 'li', 'A nested list must belong to a list item'
            self.stack.append(tag)
        elif tag == 'li':
            assert self.stack[-1] == 'ul', 'A list item must belong to a list'
            self.stack.append(tag)

    def handle_endtag(self, tag):
        if tag in ('ul', 'li'):
            assert self.stack.pop() == tag, 'Mismatched list closing tag'


class SiteTests(unittest.TestCase):
    def test_navigation_is_balanced_and_identical(self):
        summaries = []
        for page in (ROOT / 'docs').glob('*.html'):
            summary = re.search(r'<ul class="summary">.*?</ul>(?=\s*</nav>)', page.read_text(), re.S)[0]
            parser = Lists()
            parser.feed(summary)
            self.assertFalse(parser.stack, page.name)
            summaries.append(summary)
        self.assertEqual(len(set(summaries)), 1)

    def test_all_local_links(self):
        subprocess.run(['python3', 'scripts/check_site.py'], cwd=ROOT, check=True)

    def test_search_contains_every_chapter(self):
        spec = importlib.util.spec_from_file_location('navigation', ROOT / 'scripts/update_navigation.py')
        navigation = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(navigation)
        entries = json.loads((ROOT / 'docs/search_index.json').read_text())
        self.assertEqual([entry[0] for entry in entries], [name + '.html' for name in navigation.CHAPTERS])
        for _, headings, content in entries:
            self.assertTrue(headings)
            self.assertTrue(content)

    def test_published_algorithms_match_source(self):
        cases = [
            ('04_naive_bayes.Rmd', 'spam-filter.html', 'cb5', 'mutable struct BayesSpamFilter'),
            ('04_naive_bayes.Rmd', 'spam-filter.html', 'cb7', 'function fit!('),
            ('04_naive_bayes.Rmd', 'spam-filter.html', 'cb12', 'function spam_predict('),
            ('04_naive_bayes.Rmd', 'spam-filter.html', 'cb13', 'function get_predictions('),
            ('10_bees_vs_wasps.Rmd', 'image-classification.html', 'cb2', 'function resize_and_grayify('),
        ]
        for source, page, block, prefix in cases:
            expected = re.search(re.escape(prefix) + r'.*?\nend', (ROOT / source).read_text(), re.S)[0]
            rendered = re.search(r'<div class="sourceCode" id="' + block + r'">(.*?)</div>', (ROOT / 'docs' / page).read_text(), re.S)[1]
            actual = html.unescape(re.sub('<[^>]+>', '', rendered))
            self.assertEqual(actual, expected, (source, block))

    def test_chapter_setups_keep_repository_working_directory(self):
        for source in ROOT.glob('*.Rmd'):
            text = source.read_text()
            self.assertNotRegex(text, r'^cd\(', source.name)
            for project in re.findall(r'Pkg.activate\("([^\"]+)"\)', text):
                self.assertTrue((ROOT / project / 'Project.toml').is_file(), source.name)


if __name__ == '__main__':
    unittest.main()
