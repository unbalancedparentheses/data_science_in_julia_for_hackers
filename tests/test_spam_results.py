"""Guard the observed chapter-4 readouts against fixture/source/HTML drift."""
import importlib.util
from pathlib import Path
import re
import sys
import tomllib
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'scripts'))
from spam_results import result_fragments


class SpamResultsTests(unittest.TestCase):
    def test_observed_counts_and_denominators(self):
        r = tomllib.loads((ROOT / '04_naive_bayes/book_results.toml').read_text())
        self.assertEqual(r['training_count'] + r['test_count'], 5172)
        self.assertEqual(sum(r[k] for k in ('true_ham', 'missed_spam', 'blocked_ham', 'true_spam')), r['test_count'])
        self.assertAlmostEqual(r['accuracy'], (r['true_ham'] + r['true_spam']) / r['test_count'])
        self.assertAlmostEqual(r['ham_recall'], r['true_ham'] / (r['true_ham'] + r['blocked_ham']))
        self.assertAlmostEqual(r['spam_recall'], r['true_spam'] / (r['true_spam'] + r['missed_spam']))

    def test_readouts_match_verified_fixture(self):
        r = tomllib.loads((ROOT / '04_naive_bayes/book_results.toml').read_text())
        source = (ROOT / '04_naive_bayes.Rmd').read_text()
        for name, expected in result_fragments(r).items():
            match = re.search(rf'<!-- spam-result:{name} -->\n(.*?)\n<!-- /spam-result:{name} -->', source, re.S)
            self.assertIsNotNone(match, name)
            self.assertEqual(match[1], expected)
        page = (ROOT / 'docs/spam-filter.html').read_text()
        for key in ('accuracy', 'ham_recall', 'spam_recall', 'all_ham_accuracy'):
            self.assertIn(f'{100*r[key]:.2f}%', page)
        for value in (r['true_ham'], r['missed_spam'], r['blocked_ham'], r['true_spam']):
            self.assertRegex(page, rf'<td[^>]*>{value}</td>')
        self.assertNotIn(r'\emph', source)
        self.assertNotIn(r'\emph', page)
        self.assertNotIn('Evaluate the corrected classifier', page)
        self.assertEqual(source.count('*naive Bayes* classifier to create our spam filter.'), 1)


if __name__ == '__main__':
    unittest.main()
