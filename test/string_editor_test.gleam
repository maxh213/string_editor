import gleeunit
import gleeunit/should
import string_editor

pub fn main() -> Nil {
  gleeunit.main()
}

// `before` tests
pub fn before_test() {
  string_editor.before("hello world", on: " ")
  |> should.equal(Ok("hello"))
}

pub fn before_not_found_test() {
  string_editor.before("hello world", on: "!")
  |> should.equal(Error(Nil))
}

// `after` tests
pub fn after_test() {
  string_editor.after("hello world", on: " ")
  |> should.equal(Ok("world"))
}

pub fn after_not_found_test() {
  string_editor.after("hello world", on: "!")
  |> should.equal(Error(Nil))
}

// `between` tests
pub fn between_test() {
  string_editor.between("<a>b</a>", from: "<a>", to: "</a>")
  |> should.equal(Ok("b"))
}

pub fn between_not_found_start_test() {
  string_editor.between("<a>b</a>", from: "<c>", to: "</a>")
  |> should.equal(Error(Nil))
}

pub fn between_not_found_end_test() {
  string_editor.between("<a>b</a>", from: "<c>", to: "</c>")
  |> should.equal(Error(Nil))
}

pub fn between_multiple_test() {
  string_editor.between("<a>b</a><a>c</a>", from: "<a>", to: "</a>")
  |> should.equal(Ok("b"))
}

// `count` tests
pub fn count_test() {
  string_editor.count("hello hello world", of: "hello")
  |> should.equal(2)
}

pub fn count_zero_test() {
  string_editor.count("gleam is fun", of: "rust")
  |> should.equal(0)
}

pub fn count_overlapping_test() {
  string_editor.count("aaaa", of: "aa")
  |> should.equal(2)
}

// `before_at` tests
pub fn before_at_test() {
  string_editor.before_at("a.b.c.d", on: ".", at: 1)
  |> should.equal(Ok("a.b"))
}

pub fn before_at_index_too_high_test() {
  string_editor.before_at("hello world", on: " ", at: 5)
  |> should.equal(Error(Nil))
}

pub fn before_at_first_occurrence_test() {
  string_editor.before_at("a.b.c.d", on: ".", at: 0)
  |> should.equal(Ok("a"))
}

// `after_at` tests
pub fn after_at_test() {
  string_editor.after_at("a.b.c.d", on: ".", at: 1)
  |> should.equal(Ok("c.d"))
}

pub fn after_at_index_too_high_test() {
  string_editor.after_at("hello world", on: " ", at: 5)
  |> should.equal(Error(Nil))
}

pub fn after_at_last_occurrence_test() {
  string_editor.after_at("a.b.c.d", on: ".", at: 2)
  |> should.equal(Ok("d"))
}

// `between_at` tests
pub fn between_at_test() {
  string_editor.between_at("<a>1</a><a>2</a>", from: "<a>", to: "</a>", at: 1)
  |> should.equal(Ok("2"))
}

pub fn between_at_first_test() {
  string_editor.between_at("<a>1</a><a>2</a>", from: "<a>", to: "</a>", at: 0)
  |> should.equal(Ok("1"))
}

pub fn between_at_not_found_test() {
  string_editor.between_at("<h1>title</h1>", from: "<h1>", to: "</h2>", at: 0)
  |> should.equal(Error(Nil))
}

// `before_all` tests
pub fn before_all_test() {
  string_editor.before_all("a.b.c.d", on: ".")
  |> should.equal(["a", "a.b", "a.b.c"])
}

pub fn before_all_no_matches_test() {
  string_editor.before_all("hello world", on: "!")
  |> should.equal([])
}

pub fn before_all_single_match_test() {
  string_editor.before_all("hello world", on: " ")
  |> should.equal(["hello"])
}

// `after_all` tests
pub fn after_all_test() {
  string_editor.after_all("a.b.c.d", on: ".")
  |> should.equal(["b.c.d", "c.d", "d"])
}

pub fn after_all_no_matches_test() {
  string_editor.after_all("hello world", on: "!")
  |> should.equal([])
}

pub fn after_all_single_match_test() {
  string_editor.after_all("hello world", on: " ")
  |> should.equal(["world"])
}

// `between_all` tests
pub fn between_all_test() {
  string_editor.between_all("<a>1</a><b>2</b><a>3</a>", from: "<a>", to: "</a>")
  |> should.equal(["1", "3"])
}

pub fn between_all_no_matches_test() {
  string_editor.between_all("no matches here", from: "<div>", to: "</div>")
  |> should.equal([])
}

pub fn between_all_partial_matches_test() {
  string_editor.between_all("<a>1<a>2</a>", from: "<a>", to: "</a>")
  |> should.equal(["1<a>2", "2"])
}

// Additional edge case and negative tests
pub fn count_empty_string_test() {
  string_editor.count("", of: "test")
  |> should.equal(0)
}

pub fn count_empty_pattern_test() {
  string_editor.count("hello", of: "")
  |> should.equal(0)
}

pub fn count_pattern_longer_than_string_test() {
  string_editor.count("hi", of: "hello world")
  |> should.equal(0)
}

pub fn before_at_negative_index_test() {
  string_editor.before_at("a.b.c", on: ".", at: -1)
  |> should.equal(Error(Nil))
}

pub fn before_at_empty_string_test() {
  string_editor.before_at("", on: ".", at: 0)
  |> should.equal(Error(Nil))
}

pub fn before_at_pattern_not_found_test() {
  string_editor.before_at("hello world", on: "!", at: 0)
  |> should.equal(Error(Nil))
}

pub fn after_at_negative_index_test() {
  string_editor.after_at("a.b.c", on: ".", at: -1)
  |> should.equal(Error(Nil))
}

pub fn after_at_empty_string_test() {
  string_editor.after_at("", on: ".", at: 0)
  |> should.equal(Error(Nil))
}

pub fn after_at_pattern_not_found_test() {
  string_editor.after_at("hello world", on: "!", at: 0)
  |> should.equal(Error(Nil))
}

pub fn between_at_negative_index_test() {
  string_editor.between_at("<a>1</a>", from: "<a>", to: "</a>", at: -1)
  |> should.equal(Error(Nil))
}

pub fn between_at_empty_string_test() {
  string_editor.between_at("", from: "<a>", to: "</a>", at: 0)
  |> should.equal(Error(Nil))
}

pub fn between_at_start_not_found_test() {
  string_editor.between_at("hello world", from: "<div>", to: "</div>", at: 0)
  |> should.equal(Error(Nil))
}

pub fn between_at_end_not_found_after_start_test() {
  string_editor.between_at("<a>content", from: "<a>", to: "</a>", at: 0)
  |> should.equal(Error(Nil))
}

pub fn before_all_empty_string_test() {
  string_editor.before_all("", on: ".")
  |> should.equal([])
}

pub fn before_all_empty_pattern_test() {
  string_editor.before_all("hello", on: "")
  |> should.equal([])
}

pub fn after_all_empty_string_test() {
  string_editor.after_all("", on: ".")
  |> should.equal([])
}

pub fn after_all_empty_pattern_test() {
  string_editor.after_all("hello", on: "")
  |> should.equal([])
}

pub fn between_all_empty_string_test() {
  string_editor.between_all("", from: "<a>", to: "</a>")
  |> should.equal([])
}

pub fn between_all_empty_patterns_test() {
  string_editor.between_all("hello", from: "", to: "")
  |> should.equal([])
}

pub fn between_all_start_not_found_test() {
  string_editor.between_all("hello world", from: "<div>", to: "</div>")
  |> should.equal([])
}

pub fn between_all_end_not_found_test() {
  string_editor.between_all("<div>content", from: "<div>", to: "</div>")
  |> should.equal([])
}

// Test with special characters
pub fn count_special_chars_test() {
  string_editor.count("a\nb\nc\n", of: "\n")
  |> should.equal(3)
}

pub fn before_at_special_chars_test() {
  string_editor.before_at("line1\nline2\nline3", on: "\n", at: 1)
  |> should.equal(Ok("line1\nline2"))
}

// Test with repeated patterns
pub fn before_all_repeated_pattern_test() {
  string_editor.before_all("ababab", on: "ab")
  |> should.equal(["", "ab", "abab"])
}

pub fn after_all_repeated_pattern_test() {
  string_editor.after_all("ababab", on: "ab")
  |> should.equal(["abab", "ab", ""])
}
