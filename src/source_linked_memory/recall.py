from __future__ import annotations

import re
from dataclasses import dataclass
from pathlib import Path

from .chunking import SourceWindow, file_sha256

TOKEN_RE = re.compile(r"[a-z0-9]+")


@dataclass(frozen=True)
class RecallHit:
    score: float
    window: SourceWindow


def tokenize(text: str) -> set[str]:
    return set(TOKEN_RE.findall(text.lower()))


def recall(query: str, windows: list[SourceWindow], limit: int = 3) -> list[RecallHit]:
    query_terms = tokenize(query)
    hits: list[RecallHit] = []
    for window in windows:
        source_path = Path(window.source_path)
        if not source_path.exists():
            continue
        if file_sha256(source_path) != window.source_sha256:
            continue
        terms = tokenize(window.content)
        if not terms:
            continue
        overlap = len(query_terms & terms)
        if overlap == 0:
            continue
        score = overlap / max(len(query_terms), 1)
        hits.append(RecallHit(score=score, window=window))
    return sorted(hits, key=lambda hit: hit.score, reverse=True)[:limit]

