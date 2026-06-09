from __future__ import annotations

from dataclasses import dataclass, asdict
from hashlib import sha256
from pathlib import Path


@dataclass(frozen=True)
class SourceWindow:
    source_path: str
    source_sha256: str
    window_id: str
    start_line: int
    end_line: int
    content: str
    content_sha256: str

    def to_dict(self) -> dict[str, object]:
        return asdict(self)


def file_sha256(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def chunk_markdown_file(path: Path, lines_per_window: int = 24) -> list[SourceWindow]:
    if lines_per_window < 1:
        raise ValueError("lines_per_window must be positive")

    text = path.read_text(encoding="utf-8")
    source_hash = sha256(text.encode("utf-8")).hexdigest()
    lines = text.splitlines()
    if not lines:
        lines = [""]

    windows: list[SourceWindow] = []
    for offset in range(0, len(lines), lines_per_window):
        chunk_lines = lines[offset : offset + lines_per_window]
        content = "\n".join(chunk_lines).strip()
        start_line = offset + 1
        end_line = offset + len(chunk_lines)
        window_id = f"L{start_line}-L{end_line}"
        windows.append(
            SourceWindow(
                source_path=str(path),
                source_sha256=source_hash,
                window_id=window_id,
                start_line=start_line,
                end_line=end_line,
                content=content,
                content_sha256=sha256(content.encode("utf-8")).hexdigest(),
            )
        )
    return windows

