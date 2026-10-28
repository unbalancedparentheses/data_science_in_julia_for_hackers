import html
from html.parser import HTMLParser
import importlib.util
import json
from pathlib import Path
import re
import subprocess
import unittest
from unittest.mock import patch

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


class JuliaBlocks(HTMLParser):
    def __init__(self):
        super().__init__()
        self.active = False
        self.blocks = []

    def handle_starttag(self, tag, attrs):
        if tag == 'code' and 'julia' in dict(attrs).get('class', '').split():
            self.active = True
            self.blocks.append('')

    def handle_data(self, text):
        if self.active:
            self.blocks[-1] += text

    def handle_endtag(self, tag):
        if tag == 'code':
            self.active = False


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

    def test_each_sidebar_part_contains_a_chapter(self):
        summary = re.search(r'<ul class="summary">.*?</ul>(?=\s*</nav>)',
                            (ROOT / 'docs/index.html').read_text(), re.S)[0]
        for section in re.split(r'<li class="part">', summary)[1:]:
            self.assertIn('class="chapter"', section)

    def test_renderer_prefers_quarto_over_system_pandoc(self):
        spec = importlib.util.spec_from_file_location('renderer', ROOT / 'scripts/render_new_chapters.py')
        renderer = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(renderer)
        with patch.dict(renderer.os.environ, {}, clear=True), patch.object(renderer.shutil, 'which', return_value='/bin/found'):
            self.assertEqual(renderer.pandoc_command(), ['quarto', 'pandoc'])
        with patch.dict(renderer.os.environ, {'QUARTO': '/pinned/quarto'}, clear=True):
            self.assertEqual(renderer.pandoc_command(), ['/pinned/quarto', 'pandoc'])
        with patch.dict(renderer.os.environ, {'PANDOC': '/chosen/pandoc', 'QUARTO': '/pinned/quarto'}, clear=True):
            self.assertEqual(renderer.pandoc_command(), ['/chosen/pandoc'])
        with patch.dict(renderer.os.environ, {}, clear=True), patch.object(renderer.shutil, 'which', side_effect=lambda name: '/bin/pandoc' if name == 'pandoc' else None):
            self.assertEqual(renderer.pandoc_command(), ['pandoc'])

    def test_gitbook_search_initialization_has_configuration(self):
        for path in (ROOT / 'docs').glob('*.html'):
            match = re.search(r'gitbook\.start\((\{.*?\})\);', path.read_text(), re.S)
            self.assertIsNotNone(match, path.name)
            self.assertIn(json.loads(match[1])['search']['engine'], ('lunr', 'fuse'), path.name)

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


    def test_new_chapter_code_is_published_verbatim(self):
        cases = [('14_model_evaluation', 'model-evaluation'),
                 ('15_tabular_learning', 'tabular-learning'),
                 ('16_causal_inference', 'causal-inference'),
                 ('17_bayesian_workflow', 'bayesian-workflow')]
        for source, page in cases:
            blocks = re.findall(r'^```(?:\{julia[^\n]*\}|julia)[ \t]*\n(.*?)^```',
                                (ROOT / (source + '.Rmd')).read_text(), re.S | re.M)
            parser = JuliaBlocks()
            parser.feed((ROOT / 'docs' / (page + '.html')).read_text())
            self.assertTrue(blocks, source)
            self.assertEqual([b.rstrip() for b in parser.blocks], [b.rstrip() for b in blocks], source)

    def test_readme_chapter_links_exist(self):
        links = re.findall(r'https://datasciencejuliahackers.com/([^\s)#]+\.html)',
                           (ROOT / 'README.md').read_text())
        self.assertGreaterEqual(len(links), 17)
        for link in links:
            self.assertTrue((ROOT / 'docs' / link).is_file(), link)
        self.assertNotIn('datasciencejuliahackers.com:wq', (ROOT / 'README.md').read_text())

    def test_new_chapter_sequence(self):
        sequence = ['time-series', 'model-evaluation', 'tabular-learning',
                    'causal-inference', 'bayesian-workflow']
        for previous, following in zip(sequence, sequence[1:]):
            before = (ROOT / 'docs' / (previous + '.html')).read_text()
            after = (ROOT / 'docs' / (following + '.html')).read_text()
            self.assertIn(f'<link rel="next" href="{following}.html"', before)
            self.assertIn(f'<link rel="prev" href="{previous}.html"', after)
            self.assertRegex(before, f'href="{following}.html" class="navigation navigation-next"')
            self.assertRegex(after, f'href="{previous}.html" class="navigation navigation-prev"')


    def test_download_menu_does_not_advertise_missing_artifacts(self):
        for page in (ROOT / 'docs').glob('*.html'):
            match = re.search(r'"download":\s*(null|\[[^\]]*\])', page.read_text())
            self.assertIsNotNone(match, page.name)
            downloads = json.loads(match[1]) or []
            for filename in downloads:
                self.assertTrue((ROOT / 'docs' / filename).is_file(), (page.name, filename))


    def test_new_chapter_metadata_and_math(self):
        cases = [(14, '14_model_evaluation', 'model-evaluation'),
                 (15, '15_tabular_learning', 'tabular-learning'),
                 (16, '16_causal_inference', 'causal-inference'),
                 (17, '17_bayesian_workflow', 'bayesian-workflow')]
        for number, source, page in cases:
            markdown = (ROOT / (source + '.Rmd')).read_text()
            rendered = (ROOT / 'docs' / (page + '.html')).read_text()
            self.assertIn(f'<title>Chapter {number} ', rendered)
            self.assertIn('<html lang="en" xml:lang="en">', rendered)
            display_count = markdown.count('\\[') + markdown.count('$$') // 2
            self.assertEqual(rendered.count('class="math display"'), display_count, page)


if __name__ == '__main__':
    unittest.main()
