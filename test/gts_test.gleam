import gleeunit
import gleeunit/should
import ets/builder
import ets/table/set
import ets/table/ordered_set

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn set_insert_test() {
  builder.new("test_name")
  |> builder.set()
  |> set.insert("hello", "world")
  |> set.lookup("hello")
  |> should.equal(Ok("world"))
}

pub fn set_multiset_test() {
  let _ = builder.new("test_name3")
  |> builder.set()
  |> set.insert("hello", "world")


  let _ = builder.new("test_name3")
  |> builder.set()
  |> set.lookup("hello")
  |> should.equal(Ok("world"))
}

pub fn ordered_set_test() {
  let myset = builder.new("test_name2")
  |> builder.ordered_set()

  ordered_set.insert(myset, 1, 2)
  ordered_set.insert(myset, 2, 3)

  ordered_set.lookup(myset, 1)
  |> should.equal(Ok([#(1, 2)]))
}
