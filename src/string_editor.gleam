import gleam/string
import gleam/result

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
