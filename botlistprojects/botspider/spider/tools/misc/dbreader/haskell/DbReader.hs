--
-- Author: Berlin Brown
-- File: DbReader.hs
--
-- Also see: 
-- (1) http://www.zvon.org/other/haskell/Outputio/index.html
-- (2) http://hackage.haskell.org/packages/archive/binary/0.4.1/doc/html/Data-Binary.html
--
-- Useful endian loading functions:
-- getWord8, getWord16be, getWord32be
--

module Main where

import Data.Word
import Data.Binary
import qualified Data.ByteString.Lazy.Char8 as BSLC8
import Data.ByteString.Lazy (ByteString)
import Data.Binary.Get as BinaryGet
import Data.Binary.Put as BinaryPut
import IO
import Text.Printf
import System.Environment

data SpiderDatabase =  SpiderDatabase { 
      magicNumberA :: Word16,
      magicNumberB :: Word16,
      majorVers :: Word16,
      minorVers :: Word16,
      headerTag :: Word16,
      poolLen :: Word16,
      spiderpool :: [URLSet]
    }
data URLSet = URLSet {
      urlinfo :: URLInfo,
      titleinfo :: TitleInfo,
      descrinfo :: DescrInfo,
      keywordsinfo :: KeywordsInfo
}
data URLInfo = URLInfo {
      tag :: Word8,
      urlid :: Word16,
      urllen :: Word16,
      url :: ByteString
}
data TitleInfo = TitleInfo {
      titletag :: Word8,      
      titlelen :: Word16,
      title :: ByteString
}
data DescrInfo = DescrInfo {
      descrtag :: Word8,      
      descrlen :: Word16,
      descr :: ByteString
}
data KeywordsInfo = KeywordsInfo {
      keywordstag :: Word8,      
      keywordslen :: Word16,
      keywords :: ByteString
}
instance Show SpiderDatabase where
    show db = let magicb = (magicNumberB db)
                  header = (headerTag db)
                  poolct = (poolLen db)
              in "<<<Database Content>>>\n" ++
                 (((printf "Magic: %X %X\n") (magicNumberA db)) (magicNumberB db)) ++
                 printf "URL Pool Count: %d\n" poolct ++
                 "<<<End>>>"

instance Binary URLInfo where
    put _ = do BinaryPut.putWord8 0
    get = do
      urltag <- getWord8
      idx <- getWord16be
      len <- getWord16be
      strdata <- BinaryGet.getLazyByteString (fromIntegral len)
      return (URLInfo {tag=urltag, urlid=idx, 
                       urllen=len, url=strdata})
instance Binary DescrInfo where
    put _ = do BinaryPut.putWord8 0
    get = do
      tag <- getWord8
      len <- getWord16be
      strdata <- BinaryGet.getLazyByteString (fromIntegral len)
      return (DescrInfo {descrtag=tag,
                         descrlen=len, 
                         descr=strdata})
instance Binary TitleInfo where
    put _ = do BinaryPut.putWord8 0
    get = do
      tag <- getWord8
      len <- getWord16be
      strdata <- BinaryGet.getLazyByteString (fromIntegral len)
      return (TitleInfo {titletag=tag,
                         titlelen=len, 
                         title=strdata})
instance Binary KeywordsInfo where
    put _ = do BinaryPut.putWord8 0
    get = do
      tag <- getWord8
      len <- getWord16be
      strdata <- BinaryGet.getLazyByteString (fromIntegral len)
      return (KeywordsInfo {keywordstag=tag,
                         keywordslen=len, 
                         keywords=strdata})

instance Binary SpiderDatabase where
    put _ = do BinaryPut.putWord8 0
    get = do 
      magicnumbera <- BinaryGet.getWord16be
      magicnumberb <- BinaryGet.getWord16be
      major <- BinaryGet.getWord16be
      minor <- BinaryGet.getWord16be
      header <- BinaryGet.getWord16be
      poolct <- BinaryGet.getWord16be
      return (SpiderDatabase {magicNumberA=magicnumbera,
                              magicNumberB=magicnumberb,
                              majorVers=major,
                              minorVers=minor,
                              headerTag=header,
                              poolLen=poolct                         
                             })

main = do
  putStrLn "Running Spider Database Reader"
  args <- getArgs
  db :: SpiderDatabase <- decodeFile (args !! 0)
  putStrLn $ show db
  putStrLn "Done"
