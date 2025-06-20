import gleam/int
import gleam/list
import gleam/result
import gleam/string

/// Returns the part of a string before the first occurrence of a given substring.
///
/// If the substring is not found, it returns `Error(Nil)`.
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
  string
  |> string.split_once(on: pattern)
  |> result.map(fn(parts) { parts.0 })
}

/// Returns the part of a string after the first occurrence of a given substring.
///
/// If the substring is not found, it returns `Error(Nil)`.
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
  string
  |> string.split_once(on: pattern)
  |> result.map(fn(parts) { parts.1 })
}

/// Returns the part of a string between two given substrings.
///
/// It finds the first occurrence of `start` and then the first
/// occurrence of `end` after `start`. If either is not found in the
/// correct order, it returns `Error(Nil)`.
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
  case after(string, on: start) {
    Ok(after_start) -> before(after_start, on: end)
    Error(e) -> Error(e)
  }
}

/// Counts the number of occurrences of a substring in a string.
///
/// ## Examples
///
///   > count("hello hello world", of: "hello")
///   2
///
///   > count("gleam is fun", of: "rust")
///   0
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
    False -> {
      let parts = string.split(string, on: pattern)
      case list.length(parts) > index + 1 {
        True -> {
          parts
          |> list.take(index + 1)
          |> string.join(with: pattern)
          |> Ok
        }
        False -> Error(Nil)
      }
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
    False -> {
      let parts = string.split(string, on: pattern)
      case list.length(parts) > index + 1 {
        True -> {
          parts
          |> list.drop(index + 1)
          |> string.join(with: pattern)
          |> Ok
        }
        False -> Error(Nil)
      }
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
      case after_at(string, on: start, at: index) {
        Ok(after_start) -> before(after_start, on: end)
        Error(e) -> Error(e)
      }
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
    False -> {
      let parts = string.split(string, on: pattern)
      case list.length(parts) {
        1 -> []
        _ -> {
          list.range(1, list.length(parts) - 1)
          |> list.map(fn(i) {
            parts
            |> list.take(i)
            |> string.join(with: pattern)
          })
        }
      }
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
  case pattern == "" {
    True -> []
    False -> {
      let parts = string.split(string, on: pattern)
      case list.length(parts) {
        1 -> []
        _ -> {
          list.range(1, list.length(parts) - 1)
          |> list.map(fn(i) {
            parts
            |> list.drop(i)
            |> string.join(with: pattern)
          })
        }
      }
    }
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
    False -> {
      let after_parts = after_all(string, on: start)
      after_parts
      |> list.filter_map(fn(part) { before(part, on: end) })
    }
  }
}
