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
