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
wordCatFreq :: [WordCat] -> [WordCatInfo]
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

--
-- | bayes classification train 
trainClassify :: String -> String -> [WordCatInfo]
trainClassify content cat = let tokens = splitRegex (mkRegex "\\s*[ \t\n]+\\s*") content
                                wordcats = [(tok, cat) | tok <- tokens] 
                        in wordCatFreq wordcats

--
-- | Return only the tokens in a category.
tokensCat :: [WordCatInfo] -> String -> [WordCatInfo]
tokensCat tokens cat = let getTokCat row = snd (fst row)
                           tokbycat = filter (\x -> ((getTokCat x) == cat)) tokens
                       in tokbycat

tokensByFeature :: [WordCatInfo] -> String -> String -> [WordCatInfo]
tokensByFeature tokens tok cat = filter (\x -> ((fst x) == (tok, cat))) tokens

--
-- | Count of number of features in a particular category
-- Extract the first tuple to get the WordCat type and then the
-- second tuple to get the category.
catCount :: [WordCatInfo] -> String -> Integer
catCount tokens cat = genericLength $ tokensCat tokens cat

-- Find the distinct categories
categories :: [WordCatInfo] -> [String]
categories tokens = let getTokCat row = snd (fst row)                     
                        allcats = Set.toList . Set.fromList $ [ getTokCat x | x <- tokens ]
                    in allcats

featureCount :: [WordCatInfo] -> String -> String -> Integer
featureCount tokens tok cat = genericLength $ tokensByFeature tokens tok cat

--
-- | Feature probality, count in this category over total in category
featureProb :: [WordCatInfo] -> String -> String -> Double
featureProb features tok cat = let fct = featureCount features tok cat
                                   catct = catCount features cat
                               in (fromIntegral fct) / (fromIntegral catct)

--
-- | Calcuate the category probability
categoryProb :: [WordCatInfo] -> String -> String -> Double
categoryProb features tok cat = initfprob / freqsum
    where initfprob = featureProb features tok cat
          freqsum = sum [ (featureProb features tok x) | x <- categories features ]

weightedProb :: [WordCatInfo] -> String -> String -> Double -> Double
weightedProb features tok cat weight = ((weight*ap)+(totals*initprob))/(weight+totals)
    where initprob = categoryProb features tok cat
          ap = 0.5
          totals = fromIntegral $ sum [ (featureCount features tok x) | x <- categories features ]

-- Inverted Chi2 formula
invChi2 :: Double -> Double -> Double
invChi2 chi df = minimum([snd newsum, 1.0])
    where m = chi / 2.0
          initsum = exp (-m)
          trm = exp (-m)
          maxrg = fromIntegral (floor (df / 2.0)) :: Double
          -- Return a tuple with current sum and term, given these inputs
          newsum = foldl (\(trm,sm) elm -> ((trm*(m/elm)), sm+trm)) 
                   (trm,initsum) [1..maxrg]

fisherProb :: [WordCatInfo] -> [String] -> String -> Double
fisherProb features tokens cat = invchi
    where initw = 1.0
          p = foldl (\prb f -> (prb * (weightedProb features f cat initw))) 1.0 tokens
          fscore = (-2) * (log p)
          invchi = invChi2 fscore ((genericLength features) * 2)

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
      testdata = [ "this", "is", "dog" ]
      bb = fisherProb aa testdata "bad"
  putStrLn $ "-->" ++ show bb

main :: IO ()
main = do
  putStrLn "*** Content Analysis"
  simpleTest5
  putStrLn "*** Done"
