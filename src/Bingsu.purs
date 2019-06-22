module Bingsu where

import Prelude

import Data.Symbol (SProxy(..))
import Effect.Aff (Aff)
import Foreign (Foreign)
import Prim.Row as Row
import SQLite3 as SQLite3
import Type.Prelude (class IsSymbol, SProxy, reflectSymbol)

foreign import renameParamLabels :: forall r1 r2. { | r1 } -> { | r2 }

queryDB
  :: forall params
   . SQLite3.DBConnection
  -> ParamQuery params
  -> { | params }
  -> Aff Foreign
queryDB db (ParamQuery query) params_ =
  SQLite3.queryObjectDB db query (renameParamLabels params_)

data Param (name :: Symbol) ty = Param

data ParamQuery (params :: # Type) = ParamQuery String

literal :: String -> ParamQuery ()
literal = ParamQuery

param :: forall name ty r
   . Row.Cons name ty () r
  => IsSymbol name
  => Param name ty -> ParamQuery r
param _ = ParamQuery name
  where
    nameS = SProxy :: SProxy name
    -- parameter labels must be renamed for use with node-sqlite3
    name = "$" <> reflectSymbol nameS

joinThings :: forall r1 r2 r3 r
   . Row.Union r1 r2 r3
  => Row.Nub r3 r
  => ParamQuery r1 -> ParamQuery r2 -> ParamQuery r
joinThings (ParamQuery s1) (ParamQuery s2) = ParamQuery $ s1 <> " " <> s2

infixl 1 joinThings as <<>>
