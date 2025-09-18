import gleam/io
import ets/builder
import ets/config/write_concurrency
import ets/table/set


pub fn main() {
  let myset: set.Set(String, String) =
    builder.new("example_table")
    |> builder.write_concurrency(write_concurrency.True)
    |> builder.set()

  set.insert(myset, "hello", "world")
  set.insert(myset, "hello2", "world2")

  set.delete(myset, "hello")

  case set.lookup(myset, "hello2") {
    Ok(val) -> io.println("yooo " <> val)
    Error(_) -> Nil
  }

  // io.debug(set)
}
