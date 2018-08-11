module Strelka.Core.ResponseBuilder where

import Strelka.Core.Prelude
import Strelka.Core.Model


{-|
A composable abstraction for building an HTTP response.
-}
newtype ResponseBuilder =
  ResponseBuilder (Response -> Response)

instance Monoid ResponseBuilder where
  mempty =
    ResponseBuilder id
  mappend (ResponseBuilder fn1) (ResponseBuilder fn2) =
    ResponseBuilder (fn2 . fn1)

instance Semigroup ResponseBuilder where
  (<>) = mappend


{-|
Execute the builder producing Response.
-}
run :: ResponseBuilder -> Response
run (ResponseBuilder fn) =
  fn (Response (Status 200) [] (OutputStream (const (const (pure ())))))

