module Strelka.Core.RequestParser where

import Strelka.Core.Prelude
import Strelka.Core.Model


{-|
Parser of an HTTP request.
Analyzes its meta information, consumes the path segments and the body.
-}
newtype RequestParser m a =
  RequestParser (ReaderT Request (StateT [PathSegment] (ExceptT Text m)) a)
  deriving (Functor, Applicative, Monad, Alternative, MonadPlus, MonadError Text)

instance MonadIO m => MonadIO (RequestParser m) where
  liftIO io =
    RequestParser ((lift . lift . ExceptT . liftM (either (Left . fromString . show) Right) . liftIO . trySE) io)
    where
      trySE :: IO a -> IO (Either SomeException a)
      trySE =
        Strelka.Core.Prelude.try

instance MonadTrans RequestParser where
  lift m =
    RequestParser (lift (lift (lift m)))

{-|
Execute the parser providing a request and a list of segments.
-}
run :: RequestParser m a -> Request -> [PathSegment] -> m (Either Text (a, [PathSegment]))
run (RequestParser impl) request segments =
  runExceptT (runStateT (runReaderT impl request) segments)
