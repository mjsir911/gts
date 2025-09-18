import gleam/erlang/atom
import gleam/dynamic
import gleam/dynamic/decode
import gleam/list
import gleam/option.{type Option, None, Some}
import ets/internal/table_type/set as set_i
import ets/table
import ets/table/set
import ets/internal/table_type/ordered_set as ordered_set_i
import ets/table/ordered_set
import ets/config/write_concurrency
import ets/config/privacy
import ets/internal/ets_bindings.{cast}

pub type TableBuilder(k, v) {
  TableBuilder(
    name: String,
    privacy: Option(privacy.Privacy),
    write_concurrency: Option(write_concurrency.WriteConcurrency),
    read_concurrency: Option(Bool),
    decentralized_counters: Option(Bool),
    compressed: Bool,
  )
}

pub fn new(name: String) -> TableBuilder(k, v) {
  TableBuilder(
    name: name,
    privacy: None,
    write_concurrency: None,
    read_concurrency: None,
    decentralized_counters: None,
    compressed: False,
  )
}

pub fn privacy(
  builder: TableBuilder(k, v),
  privacy: privacy.Privacy,
) -> TableBuilder(k, v) {
  TableBuilder(..builder, privacy: Some(privacy))
}

pub fn write_concurrency(
  builder: TableBuilder(k, v),
  con: write_concurrency.WriteConcurrency,
) -> TableBuilder(k, v) {
  TableBuilder(..builder, write_concurrency: Some(con))
}

pub fn read_concurrency(
  builder: TableBuilder(k, v),
  con: Bool,
) -> TableBuilder(k, v) {
  TableBuilder(..builder, read_concurrency: Some(con))
}

pub fn decentralized_counters(
  builder: TableBuilder(k, v),
  counters: Bool,
) -> TableBuilder(k, v) {
  TableBuilder(..builder, decentralized_counters: Some(counters))
}

pub fn compression(
  builder: TableBuilder(k, v),
  compressed: Bool,
) -> TableBuilder(k, v) {
  TableBuilder(..builder, compressed: compressed)
}

fn privacy_prop(prop: privacy.Privacy) -> dynamic.Dynamic {
  case prop {
    privacy.Private -> "private"
    privacy.Protected -> "protected"
    privacy.Public -> "public"
  }
  |> atom.create
  |> cast
}

pub fn write_concurrency_prop(
  prop: write_concurrency.WriteConcurrency,
) -> dynamic.Dynamic {
  case prop {
    write_concurrency.True -> "true"
    write_concurrency.False -> "false"
    write_concurrency.Auto -> "auto"
  }
  |> atom.create
  |> fn(x) { #(atom.create("write_concurrency"), x) }
  |> cast
}


fn table_exists(builder: TableBuilder(k, v)) -> Bool {
  let tablename = atom.create(builder.name)
  let ret = ets_bindings.whereis(tablename)
  case decode.run(ret, decode.optional(decode.dynamic)) {
    Error(_) -> False // uhhhh
    Ok(retval) -> option.is_some(retval)
  }
}

pub fn build_table(builder: TableBuilder(k, v), table_type: String) -> atom.Atom {
  let name = atom.create(builder.name)

  let props =
    [
      atom.create(table_type),
      atom.create("named_table"),
    ]
    |> list.map(cast)

  let props = case builder.privacy {
    Some(x) -> [privacy_prop(x), ..props]
    _ -> props
  }

  let props = case builder.write_concurrency {
    Some(x) -> [write_concurrency_prop(x), ..props]
    _ -> props
  }

  let props = case builder.read_concurrency {
    Some(x) -> [
      #(atom.create("read_concurrency"), x)
      |> cast,
      ..props
    ]
    _ -> props
  }

  let props = case builder.compressed {
    True -> [
      atom.create("compressed")
      |> cast,
      ..props
    ]
    False -> props
  }

  ets_bindings.new(
    name,
    props
    |> list.map(cast),
  )
  name
}

pub fn set(builder: TableBuilder(k, v)) -> set.Set(k, v) {
  let table = case table_exists(builder) {
    False -> build_table(builder, "set")
    True -> atom.create(builder.name)
  }
  set_i.Set(table.new(table))
}

pub fn ordered_set(builder: TableBuilder(k, v)) -> ordered_set.OrderedSet(k, v) {
  let table = case table_exists(builder) {
    False -> build_table(builder, "ordered_set")
    True -> atom.create(builder.name)
  }
  ordered_set_i.OrderedSet(table.new(table))
}
