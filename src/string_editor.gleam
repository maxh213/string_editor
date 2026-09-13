import gleam/int
import gleam/list
import gleam/result
import gleam/string

/// Returns the part of a string before the first occurrence of a given substring.
///
/// If the substring is not found, or is empty, it returns `Error(Nil)`.
///
/// ## Examples
///
///   > before("hello world", on: " ")
///   Ok("hello")
///
///   > before("gleam is fun", on: "!")
///   Error(Nil)
///
pub fn before(string: String, on pattern: String) -> Result(String, Nil) {
  case pattern {
    "" -> Error(Nil)
    _ ->
      string
      |> string.split_once(on: pattern)
      |> result.map(fn(parts) { parts.0 })
  }
}

/// Returns the part of a string after the first occurrence of a given substring.
///
/// If the substring is not found, or is empty, it returns `Error(Nil)`.
///
/// ## Examples
///
///   > after("hello world", on: " ")
///   Ok("world")
///
///   > after("gleam is fun", on: "!")
///   Error(Nil)
///
pub fn after(string: String, on pattern: String) -> Result(String, Nil) {
  case pattern {
    "" -> Error(Nil)
    _ ->
      string
      |> string.split_once(on: pattern)
      |> result.map(fn(parts) { parts.1 })
  }
}

/// Returns the part of a string before the last occurrence of a given
/// substring.
///
/// If the substring is not found, or is empty, it returns `Error(Nil)`.
///
/// ## Examples
///
///   > before_last("/home/user/document.txt", on: "/")
///   Ok("/home/user")
///
///   > before_last("gleam is fun", on: "!")
///   Error(Nil)
///
pub fn before_last(string: String, on pattern: String) -> Result(String, Nil) {
  case pattern {
    "" -> Error(Nil)
    _ ->
      case string.split(string, on: pattern) {
        [] | [_] -> Error(Nil)
        [first, ..rest] -> Ok(join_init(rest, pattern, first))
      }
  }
}

fn join_init(parts: List(String), pattern: String, acc: String) -> String {
  case parts {
    [] | [_] -> acc
    [part, ..rest] -> join_init(rest, pattern, acc <> pattern <> part)
  }
}

/// Returns the part of a string after the last occurrence of a given
/// substring.
///
/// If the substring is not found, or is empty, it returns `Error(Nil)`.
///
/// ## Examples
///
///   > after_last("/home/user/document.txt", on: "/")
///   Ok("document.txt")
///
///   > after_last("gleam is fun", on: "!")
///   Error(Nil)
///
pub fn after_last(string: String, on pattern: String) -> Result(String, Nil) {
  case pattern {
    "" -> Error(Nil)
    _ ->
      case string.split(string, on: pattern) {
        [] | [_] -> Error(Nil)
        parts -> list.last(parts)
      }
  }
}

/// Returns the part of a string between two given substrings.
///
/// It finds the first occurrence of `start` and then the first
/// occurrence of `end` after `start`. If either is not found in the
/// correct order, or is empty, it returns `Error(Nil)`.
///
/// ## Examples
///
///   > between("<a>b</a>", from: "<a>", to: "</a>")
///   Ok("b")
///
///   > between("<h1>title</h1>", from: "<h1>", to: "</h2>")
///   Error(Nil)
///
pub fn between(
  string: String,
  // The starting substring
  from start: String,
  // The ending substring
  to end: String,
) -> Result(String, Nil) {
  use after_start <- result.try(after(string, on: start))
  before(after_start, on: end)
}

/// Counts the number of non-overlapping occurrences of a substring in a
/// string. An empty pattern always counts as `0`.
///
/// ## Examples
///
///   > count("hello hello world", of: "hello")
///   2
///
///   > count("gleam is fun", of: "rust")
///   0
///
///   > count("aaaa", of: "aa")
///   2
///
pub fn count(string: String, of pattern: String) -> Int {
  case pattern {
    "" -> 0
    _ -> {
      string
      |> string.split(on: pattern)
      |> list.length
      |> int.subtract(1)
      |> int.max(0)
    }
  }
}

/// Returns the part of a string before the nth occurrence of a given substring.
///
/// Index is 0-based. If the pattern doesn't occur enough times, returns `Error(Nil)`.
///
/// ## Examples
///
///   > before_at("a.b.c.d", on: ".", at: 1)
///   Ok("a.b")
///
///   > before_at("hello world", on: " ", at: 5)
///   Error(Nil)
///
pub fn before_at(
  string: String,
  on pattern: String,
  at index: Int,
) -> Result(String, Nil) {
  case pattern == "" || index < 0 {
    True -> Error(Nil)
    False ->
      case string.split_once(string, on: pattern) {
        Error(Nil) -> Error(Nil)
        Ok(#(first, rest)) -> before_at_loop(rest, pattern, index, first)
      }
  }
}

fn before_at_loop(
  rest: String,
  pattern: String,
  index: Int,
  prefix: String,
) -> Result(String, Nil) {
  case index {
    0 -> Ok(prefix)
    _ ->
      case string.split_once(rest, on: pattern) {
        Error(Nil) -> Error(Nil)
        Ok(#(piece, rest)) ->
          before_at_loop(rest, pattern, index - 1, prefix <> pattern <> piece)
      }
  }
}

/// Returns the part of a string after the nth occurrence of a given substring.
///
/// Index is 0-based. If the pattern doesn't occur enough times, returns `Error(Nil)`.
///
/// ## Examples
///
///   > after_at("a.b.c.d", on: ".", at: 1)
///   Ok("c.d")
///
///   > after_at("hello world", on: " ", at: 5)
///   Error(Nil)
///
pub fn after_at(
  string: String,
  on pattern: String,
  at index: Int,
) -> Result(String, Nil) {
  case pattern == "" || index < 0 {
    True -> Error(Nil)
    False -> after_at_loop(string, pattern, index)
  }
}

fn after_at_loop(
  string: String,
  pattern: String,
  index: Int,
) -> Result(String, Nil) {
  case string.split_once(string, on: pattern) {
    Error(Nil) -> Error(Nil)
    Ok(#(_, rest)) ->
      case index {
        0 -> Ok(rest)
        _ -> after_at_loop(rest, pattern, index - 1)
      }
  }
}

/// Returns the part of a string between the nth occurrence of start and the first occurrence of end after that.
///
/// Index is 0-based for the start pattern. If patterns don't occur enough times, returns `Error(Nil)`.
///
/// ## Examples
///
///   > between_at("<a>1</a><a>2</a>", from: "<a>", to: "</a>", at: 1)
///   Ok("2")
///
///   > between_at("<h1>title</h1>", from: "<h1>", to: "</h2>", at: 0)
///   Error(Nil)
///
pub fn between_at(
  string: String,
  from start: String,
  to end: String,
  at index: Int,
) -> Result(String, Nil) {
  case start == "" || end == "" || index < 0 {
    True -> Error(Nil)
    False -> {
      use after_start <- result.try(after_at(string, on: start, at: index))
      before(after_start, on: end)
    }
  }
}

/// Returns all parts of a string before each occurrence of a given substring.
///
/// ## Examples
///
///   > before_all("a.b.c.d", on: ".")
///   ["a", "a.b", "a.b.c"]
///
///   > before_all("hello world", on: "!")
///   []
///
pub fn before_all(string: String, on pattern: String) -> List(String) {
  case pattern == "" {
    True -> []
    False ->
      case string.split(string, on: pattern) {
        [] | [_] -> []
        [first, ..rest] -> before_all_loop(rest, pattern, first, [first])
      }
  }
}

fn before_all_loop(
  parts: List(String),
  pattern: String,
  prefix: String,
  acc: List(String),
) -> List(String) {
  case parts {
    [] | [_] -> list.reverse(acc)
    [part, ..rest] -> {
      let prefix = prefix <> pattern <> part
      before_all_loop(rest, pattern, prefix, [prefix, ..acc])
    }
  }
}

/// Returns all parts of a string after each occurrence of a given substring.
///
/// ## Examples
///
///   > after_all("a.b.c.d", on: ".")
///   ["b.c.d", "c.d", "d"]
///
///   > after_all("hello world", on: "!")
///   []
///
pub fn after_all(string: String, on pattern: String) -> List(String) {
  case pattern {
    "" -> []
    _ -> after_all_loop(string, pattern, [])
  }
}

fn after_all_loop(
  string: String,
  pattern: String,
  acc: List(String),
) -> List(String) {
  case string.split_once(string, on: pattern) {
    Ok(#(_, rest)) -> after_all_loop(rest, pattern, [rest, ..acc])
    Error(Nil) -> list.reverse(acc)
  }
}

/// Returns all parts of a string between each occurrence of start and the next occurrence of end.
///
/// ## Examples
///
///   > between_all("<a>1</a><b>2</b><a>3</a>", from: "<a>", to: "</a>")
///   ["1", "3"]
///
///   > between_all("no matches here", from: "<div>", to: "</div>")
///   []
///
pub fn between_all(
  string: String,
  from start: String,
  to end: String,
) -> List(String) {
  case start == "" || end == "" {
    True -> []
    False -> between_all_loop(string, start, end, [])
  }
}

fn between_all_loop(
  string: String,
  start: String,
  end: String,
  acc: List(String),
) -> List(String) {
  case string.split_once(string, on: start) {
    Error(Nil) -> list.reverse(acc)
    Ok(#(_, rest)) ->
      case string.split_once(rest, on: end) {
        Ok(#(inner, _)) -> between_all_loop(rest, start, end, [inner, ..acc])
        // Every later suffix is a tail of `rest`, so none can contain `end`.
        Error(Nil) -> list.reverse(acc)
      }
  }
}

/// Replaces the part of a string before the first occurrence of a given
/// substring, keeping the pattern itself.
///
/// If the substring is not found, or is empty, it returns `Error(Nil)`.
///
/// ## Examples
///
///   > replace_before("hello world", on: " ", with: "goodbye")
///   Ok("goodbye world")
///
///   > replace_before("gleam is fun", on: "!", with: "x")
///   Error(Nil)
///
pub fn replace_before(
  string: String,
  on pattern: String,
  with replacement: String,
) -> Result(String, Nil) {
  use rest <- result.try(after(string, on: pattern))
  Ok(replacement <> pattern <> rest)
}

/// Replaces the part of a string after the first occurrence of a given
/// substring, keeping the pattern itself.
///
/// If the substring is not found, or is empty, it returns `Error(Nil)`.
///
/// ## Examples
///
///   > replace_after("hello world", on: " ", with: "gleam")
///   Ok("hello gleam")
///
///   > replace_after("gleam is fun", on: "!", with: "x")
///   Error(Nil)
///
pub fn replace_after(
  string: String,
  on pattern: String,
  with replacement: String,
) -> Result(String, Nil) {
  use prefix <- result.try(before(string, on: pattern))
  Ok(prefix <> pattern <> replacement)
}

/// Replaces the part of a string between two given substrings, keeping
/// both delimiters.
///
/// It finds the first occurrence of `start` and then the first
/// occurrence of `end` after `start`. If either is not found in the
/// correct order, or is empty, it returns `Error(Nil)`.
///
/// ## Examples
///
///   > replace_between("<a>old</a>", from: "<a>", to: "</a>", with: "new")
///   Ok("<a>new</a>")
///
///   > replace_between("<h1>title</h1>", from: "<h1>", to: "</h2>", with: "x")
///   Error(Nil)
///
pub fn replace_between(
  string: String,
  from start: String,
  to end: String,
  with replacement: String,
) -> Result(String, Nil) {
  case start == "" || end == "" {
    True -> Error(Nil)
    False ->
      case string.split_once(string, on: start) {
        Error(Nil) -> Error(Nil)
        Ok(#(prefix, rest)) ->
          case string.split_once(rest, on: end) {
            Error(Nil) -> Error(Nil)
            Ok(#(_, suffix)) ->
              Ok(prefix <> start <> replacement <> end <> suffix)
          }
      }
  }
}
