# string_editor

[![Package Version](https://img.shields.io/hexpm/v/string_editor)](https://hex.pm/packages/string_editor)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/string_editor/)

A Gleam library for string manipulation and extraction. Extract substrings before, after, or between specific patterns.

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
  
  // Extract text between two patterns
  let assert Ok("content") = string_editor.between("<div>content</div>", from: "<div>", to: "</div>")
  
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
string_editor.after("/home/user/document.txt", on: "/")
// Ok("document.txt")

// Get file extension
string_editor.after("document.txt", on: ".")
// Ok("txt")

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
- The pattern is not found in the string (`before`, `after`, `between`)
- The pattern doesn't occur enough times (`before_at`, `after_at`, `between_at`)
- For `between` functions, when either the start or end pattern is not found in the correct order

### Count Function
`count()` always returns an `Int` (never fails), returning `0` when no matches are found.

### List Functions
`*_all` functions always return a `List(String)` (never fail), returning an empty list `[]` when no matches are found.

## Performance Analysis

Here's an analysis of the performance characteristics of each function:

### `before()` and `after()` Functions

**Time Complexity:** O(n) where n is the length of the input string
- Uses `string.split_once()` which performs a single pass through the string
- Stops at the first occurrence of the pattern
- Minimal string allocations for the result

**Space Complexity:** O(k) where k is the length of the result substring
- Returns only the required portion of the string
- Minimal intermediate allocations
- Memory usage primarily scales with output size

**Performance Characteristics:**
- **Best case:** Pattern found early in string - O(p) where p is position of pattern  
- **Worst case:** Pattern not found - O(n) full string scan
- **Memory usage:** Utilizes Gleam's standard string operations

### `between()` Function

**Time Complexity:** O(n) where n is the length of the input string
- Makes two sequential calls to the underlying split operations
- First finds the start pattern, then searches the remainder for the end pattern
- Still linear overall as each character is examined at most twice

**Space Complexity:** O(k) where k is the length of the extracted content
- Creates one intermediate string (the portion after the start pattern)
- Final result is a substring of that intermediate string
- Memory usage remains proportional to output, not total input

**Performance Characteristics:**
- **Best case:** Both patterns found early - O(p₁ + p₂) where p₁, p₂ are pattern positions
- **Worst case:** End pattern not found - O(n) where n is length after start pattern  
- **Implementation:** Built on top of the `after()` and `before()` functions

### `count()` Function

**Time Complexity:** O(n) where n is the length of the input string
- Uses `string.split()` which performs a single pass through the string
- Counts splits by getting list length and subtracting 1
- Handles edge cases (empty patterns) in constant time

**Space Complexity:** O(m) where m is the number of splits
- Creates a list of string parts during splitting
- Memory scales with both the number of pattern occurrences and the size of the split parts
- No regex compilation overhead for simple pattern matching

**Performance Characteristics:**
- **Best case:** Pattern not found - O(n) scan with minimal memory
- **Worst case:** Many small patterns - O(n) time but higher memory for split results
- **Counting approach:** Gets list length rather than iterating through results

### Indexed Functions (`*_at`)

**Time Complexity:** O(n) where n is the length of the input string
- All use `string.split()` for initial parsing - single pass through string
- List operations (`take`, `drop`, `join`) are O(m) where m is number of splits
- Overall complexity remains O(n) as splits are bounded by string length

**Space Complexity:** O(m) where m is the number of parts after splitting
- Creates list of all split parts, even if only using subset
- Result size is O(k) where k is length of extracted content
- Uses more memory than basic functions when there are many pattern matches

**Performance Characteristics:**
- **Best case:** Low index with early patterns - O(n) time, minimal extra memory
- **Worst case:** High index with many splits - O(n) time, O(m) space for all parts
- **Index validation:** Bounds checking happens before processing

### Multi-Instance Functions (`*_all`)

**Time Complexity:** O(n + m²) where n is string length, m is number of splits
- Initial split operation: O(n)
- For each result position (m-1 results), rebuilds string from parts: O(m)
- Overall: O(n + m²) where m is typically much smaller than n

**Space Complexity:** O(m × k) where m is matches, k is average result length
- Stores all results in a list
- Each result requires reconstructing string from parts
- Memory scales with both number of matches and their sizes

**Performance Characteristics:**
- **Best case:** Few patterns, short results - approaches O(n) 
- **Worst case:** Many patterns creating large results - O(n + m²) time, O(m × k) space
- **Batch processing:** Single split operation shared across all results

### `between_all()` Function

**Time Complexity:** O(n + m² + r) where n is input length, m is start matches, r is total results
- Leverages `after_all()` for start pattern extraction: O(n + m²)
- Filters each result through `before()`: O(r) where r ≤ m
- Combined complexity: O(n + m² + r)

**Space Complexity:** O(m × k + r × j) where k is average after_all result size, j is final result size
- Intermediate storage for all `after_all` results
- Final filtered results list
- Memory peaks during intermediate step, then reduces after filtering

**Performance Characteristics:**
- **Best case:** Few start patterns, most have matching end patterns - O(n + m²)
- **Worst case:** Many start patterns, few matching end patterns - O(n + m²) time, with higher intermediate memory usage
- **Filtering approach:** Built-in filtering reduces final memory footprint

### Real-World Performance Implications

**Suitable for simple use cases involving:**
- **Log parsing:** Extract basic timestamps, error codes, or specific fields from log entries (`count` for error frequency, `*_all` for batch extraction)
- **Configuration files:** Parse simple key-value pairs or extract section content (`after_all` for all values, `count` for validation)
- **HTML/XML processing:** Extract content from known, simple tag structures (`between_all` for multiple tags, `*_at` for specific positions)
- **URL manipulation:** Extract basic domains, paths, or query parameters (`count` for segment counting, `before_at`/`after_at` for path navigation)
- **CSV/TSV processing:** Navigate simple columnar data (`*_at` for specific columns, `count` for field validation)
- **Template processing:** Extract and count basic placeholders (`between_all` for all variables, `count` for validation)

**Scaling characteristics:**
- **Large files:** Basic functions (`before`, `after`, `between`) scale linearly
- **Multiple extractions:** `*_all` functions have O(m²) component but m is typically small
- **Memory constrained environments:** Use basic functions when possible; `*_all` functions require more memory
- **Batch processing:** `*_all` functions more efficient than repeated individual calls

**Function Selection Guidelines:**
- **Single extraction:** Use `before`, `after`, `between` for best performance
- **Specific position:** Use `*_at` functions when you know the index
- **Multiple results:** Use `*_all` functions for batch extraction
- **Counting only:** Use `count` - most memory efficient for frequency analysis
- **Large strings with many patterns:** Consider memory usage of `*_all` functions

**Comparison with alternatives:**
- **vs. Regular expressions:** May be faster for simple pattern matching due to no regex compilation step
- **vs. Manual string iteration:** Comparable performance with built-in error handling and cleaner syntax
- **vs. Split-based approaches:** Basic functions may be more efficient (stop at first match); `*_all` functions use full split but avoid repeated parsing
- **vs. Multiple individual calls:** `*_all` functions may be more efficient than repeated calls for batch extractions

### Optimization Tips

1. **Pattern placement:** Consider placing the most unique part of your pattern first (may improve performance in some cases)
2. **Function selection:** 
   - Use `count` instead of `length(before_all(...))` for counting
   - Use `*_at` when you know the specific index needed
   - Use `*_all` for batch operations instead of multiple individual calls
3. **For `between()` operations:** More unique start patterns improve performance
4. **Memory considerations:** 
   - Basic functions have lower memory overhead
   - `*_all` functions create intermediate lists - consider this for large datasets
   - `count` uses less memory when you only need frequency information
5. **Pattern considerations:** Shorter, more specific patterns can reduce false matches

## Development

```sh
gleam test  # Run the tests
gleam format # Format the code
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request!

## Documentation

Further documentation can be found at <https://hexdocs.pm/string_editor>.
