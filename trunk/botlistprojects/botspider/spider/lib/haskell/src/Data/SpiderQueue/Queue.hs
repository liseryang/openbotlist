-- ***********************************************
-- Author: Berlin Brown
-- File: QueueUtil.hs
-- Date: 1/10/2008
--
-- Description:
-- Simple 
--
-- References:
-- (1) http://hackage.haskell.org/packages/archive/binary/0.4.1/doc/html/Data-Binary.html
-- (2) http://hackage.haskell.org/cgi-bin/hackage-scripts/package/utf8-string-0.2
-- (3) http://hackage.haskell.org/packages/archive/bytestring/0.9.0.1/doc/html/Data-ByteString.html
-- (4) http://www.haskell.org/ghc/docs/latest/html/libraries/haskell98/Time.html
-- ***********************************************

module Data.SpiderQueue.Queue where

import System.IO

import Data.Word
import Data.Binary
import Data.Binary.Get as BinaryGet
import Data.Binary.Put as BinaryPut
import Text.Printf

--
-- Used qualified names for the different bytestring manipulation
-- modules; using 'Import Qualified' to ensure we are using the correct function.
import qualified Data.ByteString as Eager (ByteString, unpack, pack)
import qualified Data.ByteString.Char8 as CharBS (pack, unpack)
import qualified Data.ByteString.Lazy.Char8 as LazyC (unpack, pack)
import qualified Data.ByteString.Lazy as Lazy (ByteString, unpack, pack, hPut, hGetContents)

--
-- | Simple First in, First Out binary file format
data SpiderQueue = SpiderQueue { 
      magicNumberA :: Word16,
      magicNumberB :: Word16,
      majorVers :: Word16,
      minorVers :: Word16,
      queueLen :: Word16,
      queue :: [QueueObject]
}
data QueueObject = QueueObject {
      dbseglen :: Word32,                  
      dbsegment :: Lazy.ByteString,
      -- Posix time
      ptime :: Word32
}
