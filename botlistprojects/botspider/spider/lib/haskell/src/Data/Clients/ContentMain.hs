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

Note: I use the term feature and token interchangably, most documents
when talking about bayesian filters use the term feature.

Also see:
 (1) http://www.haskell.org/ghc/docs/latest/html/libraries/containers/Data-Map.html

-}
-- *********************************************************

module Main where

import System.Environment
import qualified Data.Map as Map
import qualified Data.Set as Set
import Data.List
import Text.Regex (splitRegex, mkRegex)
import Data.SpiderNet.Bayes

type WordCat = (String, String)
type WordCatInfo = (WordCat, Int)
type WordInfo = (String, Int)

-- **********************************************
-- Tests
-- **********************************************

goodfile = "../../var/lib/spiderdb/dump/_dump_file_4.extract"
badfile = "../../var/lib/spiderdb/dump/_dump_file_2.extract"

simpleTest1 :: IO ()
simpleTest1 = do
  content <- readFile badfile
  let tokens = splitRegex (mkRegex "\\s*[ \t\n]+\\s*") content
      wordfreq = wordFreqSort tokens
  mapM_ (\x -> (putStrLn $ formatWordFreq x)) wordfreq
  putStrLn $ "Number of tokens found: " ++ (show . length $ wordfreq)

simpleTest2 :: IO ()
simpleTest2 = do
  let badfreq = trainClassify "viagra is bad cialis is good" "bad"
      goodfreq = trainClassify "I like to run with foxes they cool" "good"
      allfreq = badfreq ++ goodfreq
  mapM_ (\x -> (putStrLn $ formatWordCat x)) allfreq

simpleTest3 :: IO ()
simpleTest3 = do
  let aa = [(("1", "aa") :: (String, String), -1), (("2", "aa"), -1), (("3", "bb"), -1)]
      tokensAA = tokensCat aa "aa"
      countAA = catCount aa "aa"
      c = featureProb aa "1" "aa"
  putStrLn $ "-->" ++ (show countAA) ++ " // " ++ (show tokensAA) ++ " // " ++ (show c)

simpleTest4 :: IO ()
simpleTest4 = do
  let aa = [(("dogs dogs", "good") :: (String, String), 3), 
            (("viagra", "bad") :: (String, String), 5), 
            (("fox", "good") :: (String, String), 2), 
            (("dogs", "good"), 4), 
            (("3", "bad"), 5)]
      bb = categories aa
      tokensAA = tokensByFeature aa "dogs" "good"
      c = featureProb aa "dogs" "good"
      d = catCount aa "good"
      x = categoryProb aa "xdogs" "good"
      z = weightedProb aa "dogs" "good" 1.0
  putStrLn $ "-->" ++ (show d) ++ "//" ++ (show bb) ++ "//" ++ (show z) 

simpleTest5 :: IO ()
simpleTest5 = do
  let aa = [(("dogs dogs", "good") :: (String, String), 3), 
            (("viagra", "bad") :: (String, String), 5), 
            (("fox", "good") :: (String, String), 2), 
            (("dogs", "good"), 4), 
            (("3", "bad"), 5)]
      testdata = [ "xdog" ]
      bb = fisherProb aa testdata "bad"
  putStrLn $ "-->" ++ show bb

main :: IO ()
main = do
  putStrLn "*** Content Analysis"
  simpleTest5
  putStrLn "*** Done"
