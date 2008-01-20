-- *********************************************************
{-
File: spiderdb.py

Copyright (c) 2007, Botnode.com (Berlin Brown)
http://www.opensource.org/licenses/bsd-license.php

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, 
    this list of conditions and the following disclaimer in the documentation 
    and/or other materials provided with the distribution.
    * Neither the name of the Newspiritcompany.com (Berlin Brown) nor 
    the names of its contributors may be used to endorse or promote 
    products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Description:

Save spider database format in big endian format (network format).

Also see:
 (1) http://www.haskell.org/ghc/docs/latest/html/libraries/containers/Data-Map.html

-}
-- *********************************************************

module Main where

import System.Environment
import qualified Data.Map as Map
import Data.List
import Text.Regex (splitRegex, mkRegex)

type WordCat = (String, String)
type WordCatInfo = (WordCat, Int)
type WordInfo = (String, Int)

--
-- | Find word frequency given an input list using "Data.Map" utilities.
-- With (Map.empty :: Map.Map String Int), set k = String and a = Int
--    Map.empty :: Map k a
-- foldl' is a strict version of foldl = foldl': (a -> b -> a) -> a -> [b] -> a
-- Also see: updmap nm key = Map.insertWith (+) key 1 nm
-- (Original code from John Goerzen's wordFreq)
wordFreq :: [String] -> [WordInfo]
wordFreq inlst = Map.toList $ foldl' updateMap (Map.empty :: Map.Map String Int) inlst
    where updateMap freqmap word = case (Map.lookup word freqmap) of
                                         Nothing -> (Map.insert word 1 freqmap)
                                         Just x  -> (Map.insert word $! x + 1) freqmap

--
-- | Word Category Frequency, modified version of wordFreq to 
-- handle Word Category type.
wordCatFreq :: [WordCat] -> [(WordCat, Int)]
wordCatFreq inlst = Map.toList $ foldl' 
                    updateMap (Map.empty :: Map.Map WordCat Int) inlst
    where updateMap freqmap wordcat = case (Map.lookup wordcat freqmap) of
                                        Nothing -> (Map.insert wordcat 1 freqmap)
                                        Just x  -> (Map.insert wordcat $! x + 1) freqmap

-- | Pretty print the word/count tuple and output a string.
formatWordFreq :: WordInfo -> String
formatWordFreq tupl = fst tupl ++ " " ++ (show $ snd tupl)

formatWordCat :: WordCatInfo -> String
formatWordCat tupl = frmtcat (fst tupl) ++ " " ++ (show $ snd tupl)
    where frmtcat infotupl = (fst infotupl) ++ ", " ++ (snd infotupl)

freqSort (w1, c1) (w2, c2) = if c1 == c2
                             then compare w1 w2
                             else compare c2 c1

-- Given an input list of word tokens, find the word frequency and sort the values.
-- sortBy :: (a -> a -> Ordering) -> [a] -> [a]
wordFreqSort :: [String] -> [(String, Int)]
wordFreqSort inlst = sortBy freqSort . wordFreq $ inlst

goodfile = "../../var/lib/spiderdb/dump/_dump_file_4.extract"
badfile = "../../var/lib/spiderdb/dump/_dump_file_2.extract"

simpleTest1 :: IO ()
simpleTest1 = do
  content <- readFile badfile
  let tokens = splitRegex (mkRegex "\\s*[ \t\n]+\\s*") content
      wordfreq = wordFreqSort tokens
  mapM_ (\x -> (putStrLn $ formatWordFreq x)) wordfreq
  putStrLn $ "Number of tokens found: " ++ (show . length $ wordfreq)

main :: IO ()
main = do
  putStrLn "*** Content Analysis"
  let example = [("Fox", "Good"), ("Sex", "Bad")]
      wordcatfreq = wordCatFreq example
  mapM_ (\x -> (putStrLn $ formatWordCat x)) wordcatfreq
  putStrLn "*** Done"
