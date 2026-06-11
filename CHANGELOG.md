# Changelog

All notable changes to string_editor will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-06-11

### Added
- `before_last()` - Extract text before the last occurrence of a pattern
- `after_last()` - Extract text after the last occurrence of a pattern
  (e.g. filename from a path, extension from a multi-dot filename)
- `replace_before()` - Replace text before the first occurrence of a pattern
- `replace_after()` - Replace text after the first occurrence of a pattern
- `replace_between()` - Replace text between two patterns, keeping the delimiters

### Fixed
- CI tested with Gleam 1.11.1, which is below the package's declared minimum
  of 1.17.0 and failed to compile the package. CI now tests against both the
  minimum supported Gleam version (1.17.0) and the latest 1.x release, and
  also runs the test suite on the JavaScript target.
- README "filename from path" example used `after()`, which returns the text
  after the *first* `/` rather than the filename. The example now uses the new
  `after_last()`.

### Changed
- Condensed the README performance section into a short complexity table.

## [1.0.4] - 2026-06-11

### Fixed
- `before`, `after`, and `between` now consistently return `Error(Nil)` for an
  empty pattern on all targets. Previously the result was target-dependent:
  `Error(Nil)` on Erlang but `Ok` on JavaScript.

## [1.0.3] - 2026-06-11

### Changed
- Updated minimum Gleam version requirement from 1.4.0 to 1.17.0
- Updated gleam_stdlib requirement to `>= 1.0.0 and < 2.0.0`
- Replaced removed `list.range` with `int.range` for gleam_stdlib 1.0 compatibility (no behaviour change)

### Fixed
- Fixed invalid TOML syntax in the `links` section of `gleam.toml`

## [1.0.2] - 2025-01-20

### Changed
- Updated minimum Gleam version requirement from 1.0.0 to 1.4.0
- Removed upper bound constraint on Gleam version to improve forward compatibility

## [1.0.1] - 2025-01-20

### Fixed
- Fixed CHANGELOG.md to accurately reflect Gleam string_editor functions
- Code formatting improvements

## [1.0.0] - 2025-01-20

### Added
- Initial release of string_editor for Gleam
- Core string extraction functions:
  - `before()` - Extract text before first occurrence of pattern
  - `after()` - Extract text after first occurrence of pattern
  - `between()` - Extract text between two patterns
  - `count()` - Count occurrences of pattern in string
- Indexed extraction functions:
  - `before_at()` - Extract text before nth occurrence of pattern
  - `after_at()` - Extract text after nth occurrence of pattern
  - `between_at()` - Extract text between nth occurrence of start and next end pattern
- Batch extraction functions:
  - `before_all()` - Extract all text segments before each pattern occurrence
  - `after_all()` - Extract all text segments after each pattern occurrence
  - `between_all()` - Extract all text segments between pattern pairs
- Comprehensive test suite
- Full documentation with usage examples
- Published to Hex package manager