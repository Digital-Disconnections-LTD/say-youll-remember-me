-- Portable source-linked memory schema sketch.
-- This is not a production migration.

CREATE TABLE IF NOT EXISTS memory_sources (
  id TEXT PRIMARY KEY,
  source_path TEXT NOT NULL,
  source_sha256 CHAR(64) NOT NULL,
  source_kind TEXT NOT NULL DEFAULT 'markdown',
  captured_at TEXT NOT NULL,
  CHECK (length(source_sha256) = 64)
);

CREATE TABLE IF NOT EXISTS memory_windows (
  id TEXT PRIMARY KEY,
  source_id TEXT NOT NULL REFERENCES memory_sources(id) ON DELETE CASCADE,
  window_id TEXT NOT NULL,
  start_line INTEGER NOT NULL,
  end_line INTEGER NOT NULL,
  content TEXT NOT NULL,
  content_sha256 CHAR(64) NOT NULL,
  UNIQUE (source_id, window_id),
  CHECK (start_line > 0),
  CHECK (end_line >= start_line),
  CHECK (length(content_sha256) = 64)
);

CREATE TABLE IF NOT EXISTS memory_index_records (
  id TEXT PRIMARY KEY,
  window_id TEXT NOT NULL REFERENCES memory_windows(id) ON DELETE CASCADE,
  index_kind TEXT NOT NULL,
  index_model TEXT NOT NULL,
  indexed_at TEXT NOT NULL,
  source_path TEXT NOT NULL,
  source_sha256 CHAR(64) NOT NULL,
  CHECK (length(source_sha256) = 64)
);

CREATE TABLE IF NOT EXISTS memory_modules (
  id TEXT PRIMARY KEY,
  module_kind TEXT NOT NULL,
  name TEXT NOT NULL,
  context_path TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS recall_events (
  id TEXT PRIMARY KEY,
  query TEXT NOT NULL,
  module_id TEXT REFERENCES memory_modules(id),
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS recall_citations (
  recall_event_id TEXT NOT NULL REFERENCES recall_events(id) ON DELETE CASCADE,
  index_record_id TEXT NOT NULL REFERENCES memory_index_records(id),
  rank INTEGER NOT NULL,
  score REAL NOT NULL,
  PRIMARY KEY (recall_event_id, index_record_id)
);

