# PureScript-Bingsu

Cool query building library for [Node-SQLite3](https://github.com/justinwoo/purescript-node-sqlite3).

![](https://upload.wikimedia.org/wikipedia/commons/7/75/Patbingsu.jpg)

## Usage

See the tests.

```purs
someAff = void $ B.queryDB db insert { name: "apples", count: 3 }
  where
    insert
         = B.literal "insert into mytable values ("
      <<>> B.param (B.Param :: _ "name" String)
      <<>> B.literal ","
      <<>> B.param (B.Param :: _ "count" Int)
      <<>> B.literal ")"
```
