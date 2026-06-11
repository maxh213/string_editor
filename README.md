# string_editor

[![Package Version](https://img.shields.io/hexpm/v/string_editor)](https://hex.pm/packages/string_editor)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/string_editor/)

A Gleam library for string manipulation and extraction. Extract or replace substrings before, after, or between specific patterns.

## Installation

```sh
gleam add string_editor
```

## Usage

```gleam
import string_editor

pub fn main() -> Nil {
  // Extract text before a pattern
  let assert Ok("hello") = string_editor.before("hello world", on: " ")
  
  // Extract text after a pattern  
  let assert Ok("world") = string_editor.after("hello world", on: " ")
  
  // Extract text after the last occurrence of a pattern
  let assert Ok("document.txt") = string_editor.after_last("/home/user/document.txt", on: "/")
  
  // Extract text between two patterns
  let assert Ok("content") = string_editor.between("<div>content</div>", from: "<div>", to: "</div>")
  
  // Replace text between two patterns
  let assert Ok("<div>new</div>") = string_editor.replace_between("<div>old</div>", from: "<div>", to: "</div>", with: "new")
  
  // Count occurrences of a pattern
  let count = string_editor.count("hello hello world", of: "hello") // 2
  
  // Extract at specific index
  let assert Ok("a.b") = string_editor.before_at("a.b.c.d", on: ".", at: 1)
  
  // Extract all occurrences
  let all_before = string_editor.before_all("a.b.c.d", on: ".") // ["a", "a.b", "a.b.c"]
}
```

## API Reference

### `before(string: String, on pattern: String) -> Result(String, Nil)`

Returns the part of a string before the first occurrence of a given substring.

**Examples:**
```gleam
string_editor.before("hello world", on: " ")
// Ok("hello")

string_editor.before("no-match", on: "!")  
// Error(Nil)
```

### `after(string: String, on pattern: String) -> Result(String, Nil)`

Returns the part of a string after the first occurrence of a given substring.

**Examples:**
```gleam
string_editor.after("hello world", on: " ")
// Ok("world")

string_editor.after("no-match", on: "!")
// Error(Nil)
```

### `before_last(string: String, on pattern: String) -> Result(String, Nil)`

Returns the part of a string before the last occurrence of a given substring.

**Examples:**
```gleam
string_editor.before_last("/home/user/document.txt", on: "/")
// Ok("/home/user")

string_editor.before_last("no-match", on: "!")
// Error(Nil)
```

### `after_last(string: String, on pattern: String) -> Result(String, Nil)`

Returns the part of a string after the last occurrence of a given substring.

**Examples:**
```gleam
string_editor.after_last("/home/user/document.txt", on: "/")
// Ok("document.txt")

string_editor.after_last("archive.tar.gz", on: ".")
// Ok("gz")
```

### `between(string: String, from start: String, to end: String) -> Result(String, Nil)`

Returns the part of a string between two given substrings. Finds the first occurrence of `start` and then the first occurrence of `end` after `start`.

**Examples:**
```gleam
string_editor.between("<a>link</a>", from: "<a>", to: "</a>")
// Ok("link")

string_editor.between("<h1>title</h1>", from: "<h1>", to: "</h2>")
// Error(Nil)
```

### `count(string: String, of pattern: String) -> Int`

Counts the number of occurrences of a substring in a string.

**Examples:**
```gleam
string_editor.count("hello hello world", of: "hello")
// 2

string_editor.count("gleam is fun", of: "rust")
// 0

string_editor.count("aaaa", of: "aa")
// 2 (non-overlapping matches)
```

### `before_at(string: String, on pattern: String, at index: Int) -> Result(String, Nil)`

Returns the part of a string before the nth occurrence of a given substring (0-indexed).

**Examples:**
```gleam
string_editor.before_at("a.b.c.d", on: ".", at: 1)
// Ok("a.b")

string_editor.before_at("hello world", on: " ", at: 5)
// Error(Nil)
```

### `after_at(string: String, on pattern: String, at index: Int) -> Result(String, Nil)`

Returns the part of a string after the nth occurrence of a given substring (0-indexed).

**Examples:**
```gleam
string_editor.after_at("a.b.c.d", on: ".", at: 1)
// Ok("c.d")

string_editor.after_at("hello world", on: " ", at: 5)
// Error(Nil)
```

### `between_at(string: String, from start: String, to end: String, at index: Int) -> Result(String, Nil)`

Returns the part of a string between the nth occurrence of start and the first occurrence of end after that (0-indexed for start pattern).

**Examples:**
```gleam
string_editor.between_at("<a>1</a><a>2</a>", from: "<a>", to: "</a>", at: 1)
// Ok("2")

string_editor.between_at("<h1>title</h1>", from: "<h1>", to: "</h2>", at: 0)
// Error(Nil)
```

### `before_all(string: String, on pattern: String) -> List(String)`

Returns all parts of a string before each occurrence of a given substring.

**Examples:**
```gleam
string_editor.before_all("a.b.c.d", on: ".")
// ["a", "a.b", "a.b.c"]

string_editor.before_all("hello world", on: "!")
// []
```

### `after_all(string: String, on pattern: String) -> List(String)`

Returns all parts of a string after each occurrence of a given substring.

**Examples:**
```gleam
string_editor.after_all("a.b.c.d", on: ".")
// ["b.c.d", "c.d", "d"]

string_editor.after_all("hello world", on: "!")
// []
```

### `between_all(string: String, from start: String, to end: String) -> List(String)`

Returns all parts of a string between each occurrence of start and the next occurrence of end.

**Examples:**
```gleam
string_editor.between_all("<a>1</a><b>2</b><a>3</a>", from: "<a>", to: "</a>")
// ["1", "3"]

string_editor.between_all("no matches here", from: "<div>", to: "</div>")
// []
```

### `replace_before(string: String, on pattern: String, with replacement: String) -> Result(String, Nil)`

Replaces the part of a string before the first occurrence of a given substring, keeping the pattern itself.

**Examples:**
```gleam
string_editor.replace_before("hello world", on: " ", with: "goodbye")
// Ok("goodbye world")

string_editor.replace_before("no-match", on: "!", with: "x")
// Error(Nil)
```

### `replace_after(string: String, on pattern: String, with replacement: String) -> Result(String, Nil)`

Replaces the part of a string after the first occurrence of a given substring, keeping the pattern itself.

**Examples:**
```gleam
string_editor.replace_after("PORT=3000", on: "=", with: "8080")
// Ok("PORT=8080")

string_editor.replace_after("no-match", on: "!", with: "x")
// Error(Nil)
```

### `replace_between(string: String, from start: String, to end: String, with replacement: String) -> Result(String, Nil)`

Replaces the part of a string between two given substrings, keeping both delimiters. Operates on the first occurrence of `start` and the first occurrence of `end` after it.

**Examples:**
```gleam
string_editor.replace_between("<a>old</a>", from: "<a>", to: "</a>", with: "new")
// Ok("<a>new</a>")

string_editor.replace_between("<h1>title</h1>", from: "<h1>", to: "</h2>", with: "x")
// Error(Nil)
```

## Common Use Cases

### HTML/XML Parsing
```gleam
// Extract content from HTML tags
string_editor.between("<title>My Page</title>", from: "<title>", to: "</title>")
// Ok("My Page")

// Extract all link texts from HTML
string_editor.between_all("<a>Home</a> <a>About</a> <a>Contact</a>", from: "<a>", to: "</a>")
// ["Home", "About", "Contact"]

// Count div tags in HTML
string_editor.count("<div>content</div><div>more</div>", of: "<div>")
// 2
```

### File Path Manipulation
```gleam
// Get filename from path
string_editor.after_last("/home/user/document.txt", on: "/")
// Ok("document.txt")

// Get directory from path
string_editor.before_last("/home/user/document.txt", on: "/")
// Ok("/home/user")

// Get file extension (handles multi-dot filenames)
string_editor.after_last("archive.tar.gz", on: ".")
// Ok("gz")

// Get all directory components
string_editor.after_all("/home/user/projects/myapp", on: "/")
// ["home/user/projects/myapp", "user/projects/myapp", "projects/myapp", "myapp"]

// Count directory levels
string_editor.count("/home/user/projects/myapp", of: "/")
// 4
```

### URL Parsing
```gleam
// Extract domain from URL
string_editor.between("https://example.com/path", from: "://", to: "/")
// Ok("example.com")
```

### Configuration Parsing
```gleam
// Extract values from key=value pairs
string_editor.after("DATABASE_URL=postgres://localhost", on: "=")
// Ok("postgres://localhost")

// Update a value while keeping the key
string_editor.replace_after("PORT=3000", on: "=", with: "8080")
// Ok("PORT=8080")

// Parse all environment variables from a string
string_editor.after_all("PORT=3000\nDB_HOST=localhost\nDB_PORT=5432", on: "=")
// ["3000\nDB_HOST=localhost\nDB_PORT=5432", "localhost\nDB_PORT=5432", "5432"]

// Count configuration entries
string_editor.count("key1=value1,key2=value2,key3=value3", of: "=")
// 3
```

### Log Processing
```gleam
// Extract all timestamps from logs
string_editor.before_all("2023-01-01 INFO: message\n2023-01-02 ERROR: problem", on: " INFO:")
// Would extract timestamp parts before INFO entries

// Count error occurrences
string_editor.count("INFO: ok\nERROR: fail\nINFO: ok\nERROR: fail", of: "ERROR:")
// 2
```

## Error Handling

Functions have different return types based on their purpose:

### Result Functions
Functions that return `Result(String, Nil)` return `Error(Nil)` when:
- The pattern is empty, or is not found in the string (`before`, `after`, `before_last`, `after_last`, `between`, `replace_before`, `replace_after`, `replace_between`)
- The pattern doesn't occur enough times (`before_at`, `after_at`, `between_at`)
- For `between` and `replace_between`, when either the start or end pattern is not found in the correct order

### Count Function
`count()` always returns an `Int` (never fails), returning `0` when no matches are found.

### List Functions
`*_all` functions always return a `List(String)` (never fail), returning an empty list `[]` when no matches are found.

## Performance Notes

All functions are built on `gleam/string` split operations and run in linear
time over the input string.

| Functions | Time | Notes |
| --- | --- | --- |
| `before`, `after`, `replace_before`, `replace_after` | O(n) | `split_once` stops at the first match |
| `before_last`, `after_last` | O(n) | single full split |
| `between`, `between_at`, `replace_between` | O(n) | composed from the functions above |
| `count` | O(n) | single full split, no regex compilation |
| `*_at` | O(n) | splits once, then takes/drops parts |
| `*_all` | O(n + m²) | rebuilds a prefix/suffix per match; m = match count, usually small |

Guidelines:

- For a single extraction, prefer `before`/`after`/`between` — they stop at the
  first match and allocate the least.
- Use `count` rather than `list.length(before_all(...))`.
- `*_all` functions allocate a list of results; for very large inputs with many
  matches, keep their O(m²) rebuild cost in mind.

## Development

```sh
gleam test  # Run the tests
gleam format # Format the code
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request!

## Documentation

Further documentation can be found at <https://hexdocs.pm/string_editor>.
