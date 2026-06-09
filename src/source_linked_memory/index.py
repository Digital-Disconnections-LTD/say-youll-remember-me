from __future__ import annotations

import json
from pathlib import Path

from .chunking import SourceWindow, chunk_markdown_file


class JsonlIndex:
    """Tiny inspectable JSONL index used for the public demo."""

    def __init__(self, path: Path):
        self.path = path

    def build_from_sources(self, source_paths: list[Path]) -> None:
        self.path.parent.mkdir(parents=True, exist_ok=True)
        with self.path.open("w", encoding="utf-8") as handle:
            for source_path in source_paths:
                for window in chunk_markdown_file(source_path):
                    record = window.to_dict()
                    record["index_kind"] = "lexical-demo"
                    record["index_model"] = "python-token-overlap-v1"
                    handle.write(json.dumps(record, sort_keys=True) + "\n")

    def load(self) -> list[SourceWindow]:
        if not self.path.exists():
            return []
        windows: list[SourceWindow] = []
        with self.path.open("r", encoding="utf-8") as handle:
            for line in handle:
                row = json.loads(line)
                windows.append(
                    SourceWindow(
                        source_path=row["source_path"],
                        source_sha256=row["source_sha256"],
                        window_id=row["window_id"],
                        start_line=int(row["start_line"]),
                        end_line=int(row["end_line"]),
                        content=row["content"],
                        content_sha256=row["content_sha256"],
                    )
                )
        return windows

