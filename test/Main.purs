module Test.Main where

import Prelude

import Bingsu ((<<>>))
import Bingsu as B
import Data.Either (Either(..))
import Effect (Effect)
import Effect.Aff (error, launchAff_, throwError)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import SQLite3 as SL
import Simple.JSON as JSON
import Test.Assert as Assert

main :: Effect Unit
main = launchAff_ do
  db <- SL.newDB "./test/testdb.sqlite"
  _ <- SL.queryDB db "create table if not exists mytable (name text, count int)" []
  _ <- SL.queryDB db "delete from mytable" []

  _ <- B.queryDB db insert { name: "apples", count: 3 }
  _ <- B.queryDB db insert { name: "bananas", count: 6 }

  f1 <- B.queryDB db getByName { name: "apples" }
  testResult f1 [{ name: "apples", count: 3 }]

  f2 <- B.queryDB db getByName { name: "bananas" }
  testResult f2 [{ name: "bananas", count: 6 }]

  log "tests passed"
  where
    testResult f expected =
      case JSON.read f of
        Left e -> throwError (error $ show e)
        Right (actual :: Array { name :: String, count :: Int }) ->
          assertEqual { actual, expected }
    assertEqual = liftEffect <<< Assert.assertEqual

    insert
         = B.literal "insert into mytable values ("
      <<>> B.param (B.Param :: _ "name" String)
      <<>> B.literal ","
      <<>> B.param (B.Param :: _ "count" Int)
      <<>> B.literal ");"

    getByName
         = B.literal "select * from mytable where name ="
      <<>> B.param (B.Param :: _ "name" String)
      <<>> B.literal "and name ="
      <<>> B.param (B.Param :: _ "name" String)
