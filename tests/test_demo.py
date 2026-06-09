from __future__ import annotations

from pathlib import Path
import tempfile
import unittest

from source_linked_memory import JsonlIndex, build_orientation_bundle, chunk_markdown_file

ROOT = Path(__file__).resolve().parents[1]


class DemoTests(unittest.TestCase):
    def test_chunk_has_source_hash(self) -> None:
        source = ROOT / "examples" / "memory" / "sources" / "demo-client-request.md"
        windows = chunk_markdown_file(source)
        self.assertGreaterEqual(len(windows), 1)
        self.assertEqual(len(windows[0].source_sha256), 64)
        self.assertEqual(windows[0].start_line, 1)

    def test_index_and_orientation_include_source(self) -> None:
        memory_root = ROOT / "examples" / "memory"
        bundle = build_orientation_bundle(
            memory_root=memory_root,
            query="owned websites without tracking",
        )
        self.assertIn("## Self", bundle)
        self.assertIn("## Company", bundle)
        self.assertIn("demo-client-request.md", bundle)
        self.assertIn("sha256=", bundle)

    def test_jsonl_index_roundtrip(self) -> None:
        source = ROOT / "examples" / "memory" / "sources" / "demo-client-request.md"
        with tempfile.TemporaryDirectory() as tmp:
            index = JsonlIndex(Path(tmp) / "index.jsonl")
            index.build_from_sources([source])
            self.assertEqual(len(index.load()), 1)


if __name__ == "__main__":
    unittest.main()

