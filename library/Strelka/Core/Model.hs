module Strelka.Core.Model where

import Strelka.Core.Prelude


data Request =
  Request !Method ![PathSegment] !(HashMap ParamName ParamValue) !(HashMap HeaderName HeaderValue) !InputStream

data Response =
  Response !Status ![Header] !OutputStream

-- |
-- HTTP Method __in lower-case__.
newtype Method =
  Method ByteString
  deriving (IsString, Show, Eq, Ord, Hashable)

newtype PathSegment =
  PathSegment Text
  deriving (IsString, Show, Eq, Ord, Hashable)

newtype ParamName =
  ParamName ByteString
  deriving (IsString, Show, Eq, Ord, Hashable)

newtype ParamValue =
  ParamValue (Maybe ByteString)
  deriving (Show, Eq, Ord, Hashable)

data Header =
  Header !HeaderName !HeaderValue

-- |
-- Header name __in lower-case__.
newtype HeaderName =
  HeaderName ByteString
  deriving (IsString, Show, Eq, Ord, Hashable)

newtype HeaderValue =
  HeaderValue ByteString
  deriving (IsString, Show, Eq, Ord, Hashable)

newtype Status =
  Status Int

-- |
-- IO action, which produces the next chunk.
-- An empty chunk signals the end of the stream.
newtype InputStream =
  InputStream (IO ByteString)

-- |
-- A function on a chunk consuming and flushing IO actions.
newtype OutputStream =
  OutputStream ((ByteString -> IO ()) -> IO () -> IO ())
