module Strelka.Core.Executor where

import Strelka.Core.Prelude
import Strelka.Core.Model
import qualified Strelka.Core.RequestParser as A
import qualified Strelka.Core.ResponseBuilder as B
import qualified Data.Text as C
import qualified Data.Text.Encoding as D
import qualified Data.Text.Encoding.Error as E


route :: Monad m => Request -> A.RequestParser m B.ResponseBuilder -> m (Either Text Response)
route request route =
  (liftM . liftM) (B.run . fst) (A.run route request segments)
  where
    segments =
      case request of
        Request _ x _ _ _ ->
          x
