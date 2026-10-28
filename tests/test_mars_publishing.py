import json
from pathlib import Path
import re
import sys
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'scripts'))
import render_mars_teaching as mars


class MarsPublishingTests(unittest.TestCase):
    def test_all_historical_code_and_figures_are_preserved(self):
        archive = json.loads(mars.ARCHIVE.read_text())['chunks']
        published = (ROOT / 'docs/escaping-from-mars.html').read_text()
        for chunk in archive:
            self.assertIn(chunk['html'].strip(), published)
        self.assertEqual(len(re.findall(r'<img ', ''.join(c['html'] for c in archive))), 15)

    def test_changed_legacy_computation_requires_new_output(self):
        source = (ROOT / '06_gravity.Rmd').read_text()
        archive = json.loads(mars.ARCHIVE.read_text())['chunks']
        old_code = archive[-1]['code']
        self.assertIn(old_code, source)
        changed = source.replace(old_code, old_code + '\nerror("changed computation")', 1)
        with patch.object(mars.subprocess, 'check_output') as pandoc:
            with self.assertRaisesRegex(ValueError, 'Legacy Julia chunk changed'):
                mars.render(changed, '<section class="normal" id="section-"></section>')
            pandoc.assert_not_called()

    def test_missing_legacy_chunk_is_not_silently_dropped(self):
        source = (ROOT / '06_gravity.Rmd').read_text()
        changed = mars.CHUNK.sub('', source, count=1)
        with self.assertRaisesRegex(ValueError, 'Legacy Julia chunk changed'):
            mars.render(changed, '<section class="normal" id="section-"></section>')


if __name__ == '__main__':
    unittest.main()
