import ets/table
import ets/internal/ets_bindings.{cast, anytype}
import ets/internal/table_type/ordered_set
import gleam/list

pub type OrderedSet(k, v) =
  ordered_set.OrderedSet(k, v)

/// Return the table for this set object.
pub fn table(set: OrderedSet(k, v)) -> table.Table(k, v) {
  set
  |> table()
}

/// Insert a value into the ets table.
pub fn insert(set: OrderedSet(k, v), key: k, value: v) -> OrderedSet(k, v) {
  ets_bindings.insert(
    set.table
    |> table.name(),
    #(cast(key), cast(value)),
  )
  set
}

/// Retrieve a value from the ets table. Return an error if the value could
/// not be found.
pub fn lookup(set: OrderedSet(k, v), key: k) -> Result(List(#(k, v)), Nil) {
  case
    ets_bindings.lookup(
      set.table
      |> table.name(),
      cast(key),
    )
  {
    [] -> Error(Nil)
    kvs -> Ok(kvs |> list.map(fn (kv) -> #(k, v) {
      let #(key, value) = kv
      #(anytype(key), anytype(value))
    }))
  }
}

/// Delete all objects with key `key` from the table.
pub fn delete(set: OrderedSet(k, v), key: k) -> OrderedSet(k, v) {
  ets_bindings.delete_key(
    set.table
    |> table.name(),
    cast(key),
  )
  set
}
