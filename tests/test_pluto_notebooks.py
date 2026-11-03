"""Structural checks that protect native Pluto bonds and exported script defaults."""
from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[1]
NOTEBOOKS = ["06_gravity/mission/notebook.jl",
             "14_model_evaluation/14_model_evaluation.jl",
             "15_tabular_learning/15_tabular_learning.jl",
             "16_causal_inference/notebook.jl",
             "17_bayesian_workflow/notebook.jl"]


class PlutoNotebookTests(unittest.TestCase):
    def test_script_bind_fallback_is_outside_pluto_cells(self):
        for filename in NOTEBOOKS:
            with self.subTest(notebook=filename):
                source = (ROOT / filename).read_text()
                preamble, cells = source.split("# ╔═╡ ", 1)
                self.assertIn("macro bind(def, element)", preamble)
                self.assertNotRegex(cells, r"\bmacro\s+bind\b")
                self.assertIn("@bind ", cells)

    def test_cell_order_matches_cell_definitions(self):
        for filename in NOTEBOOKS:
            with self.subTest(notebook=filename):
                source = (ROOT / filename).read_text()
                body, order = source.split("# ╔═╡ Cell order:")
                ids = re.findall(r"^# ╔═╡ ([0-9a-f-]{36})$", body, re.M)
                ordered = re.findall(r"^# [╠╟][═─]([0-9a-f-]{36})$", order, re.M)
                self.assertEqual(len(ids), len(set(ids)))
                self.assertEqual(len(ordered), len(set(ordered)))
                self.assertEqual(set(ids), set(ordered))


if __name__ == "__main__":
    unittest.main()
