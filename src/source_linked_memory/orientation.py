from __future__ import annotations

from pathlib import Path

from .chunking import chunk_markdown_file
from .index import JsonlIndex
from .recall import recall


def read_optional(path: Path) -> str:
    if not path.exists():
        return ""
    return path.read_text(encoding="utf-8").strip()


def build_orientation_bundle(
    memory_root: Path,
    query: str,
    module: str = "demo-client",
    budget_chars: int = 8000,
) -> str:
    self_block = read_optional(memory_root / "self" / "SOUL.md")
    company_block = read_optional(memory_root / "company" / "COMPANY.md")
    module_block = read_optional(memory_root / "modules" / module / "CONTEXT.md")

    source_paths = sorted((memory_root / "sources").glob("*.md"))
    index_path = memory_root / ".cache" / "source_windows.jsonl"
    index = JsonlIndex(index_path)
    index.build_from_sources(source_paths)
    hits = recall(query, index.load())

    sections = [
        ("Self", self_block),
        ("Company", company_block),
        (f"Module: {module}", module_block),
    ]

    recall_lines: list[str] = []
    for rank, hit in enumerate(hits, start=1):
        window = hit.window
        recall_lines.append(
            "\n".join(
                [
                    f"{rank}. score={hit.score:.2f}",
                    f"   source={window.source_path}:{window.start_line}",
                    f"   sha256={window.source_sha256}",
                    f"   excerpt={window.content}",
                ]
            )
        )
    sections.append(("Source-Linked Recall", "\n\n".join(recall_lines) or "No hits."))

    bundle = "\n\n".join(
        f"## {title}\n\n{body}" for title, body in sections if body
    )
    if len(bundle) <= budget_chars:
        return bundle

    fixed = "\n\n".join(
        f"## {title}\n\n{body}" for title, body in sections[:3] if body
    )
    remaining = max(budget_chars - len(fixed) - 80, 0)
    recall_block = ("\n\n".join(recall_lines))[:remaining]
    return f"{fixed}\n\n## Source-Linked Recall\n\n{recall_block}\n\n[truncated]"


def build_bundle_from_single_source(path: Path, query: str) -> str:
    windows = chunk_markdown_file(path)
    hits = recall(query, windows)
    return "\n".join(f"{hit.window.source_path}:{hit.window.start_line}" for hit in hits)

