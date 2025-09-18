import gleam/erlang/atom
import gleam/dynamic
import gleam/dynamic/decode
import gleam/erlang/process



@external(erlang, "ets", "new")
pub fn new(name: atom.Atom, props: List(dynamic.Dynamic)) -> Nil

@external(erlang, "ets", "all")
pub fn all() -> Nil

@external(erlang, "ets", "delete")
pub fn drop(table: atom.Atom) -> Nil

@external(erlang, "ets", "delete")
pub fn delete_key(table: atom.Atom, key: dynamic.Dynamic) -> Nil

@external(erlang, "ets", "delete_all_objects")
pub fn delete_all_objects(table: atom.Atom) -> Nil

/// TODO: Check if this should be v or #(k, v)
@external(erlang, "ets", "delete_object")
pub fn delete_object(table: atom.Atom, object: dynamic.Dynamic) -> Nil

@external(erlang, "ets", "insert")
pub fn insert(table: atom.Atom, tuple: #(dynamic.Dynamic, dynamic.Dynamic)) -> Nil

@external(erlang, "ets", "lookup")
pub fn lookup(table: atom.Atom, key: dynamic.Dynamic) -> List(#(dynamic.Dynamic, dynamic.Dynamic))

@external(erlang, "ets", "give_away")
pub fn give_away(table: atom.Atom, pid: process.Pid, gift_data: dynamic.Dynamic) -> Nil


@external(erlang, "gleam_stdlib", "identity")
pub fn cast(a: anything) -> dynamic.Dynamic

@external(erlang, "gleam_stdlib", "identity")
pub fn anytype(data: decode.Dynamic) -> anytype
