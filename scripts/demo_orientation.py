#!/usr/bin/env python3
from __future__ import annotations

import argparse
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from source_linked_memory import build_orientation_bundle


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--memory-root", type=Path, default=ROOT / "examples" / "memory")
    parser.add_argument("--module", default="demo-client")
    parser.add_argument("--query", required=True)
    parser.add_argument("--budget-chars", type=int, default=8000)
    args = parser.parse_args()

    print(
        build_orientation_bundle(
            memory_root=args.memory_root,
            query=args.query,
            module=args.module,
            budget_chars=args.budget_chars,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

