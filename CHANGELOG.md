# Changelog

All notable changes to string_editor will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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