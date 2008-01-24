
--
-- Test Queue

module Tests.Data.TestBayesProb where 

import Data.SpiderNet.Bayes

-- Tuple of tuples
exampleDataDef :: [((String, String), Int)]
exampleDataDef = [
 (("my", "bad"), 1),          -- 1
 (("dog", "bad"), 1),         -- 2
 (("likes", "bad"), 1),       -- 3
 (("chicken", "bad"), 1),     -- 4
 (("yes", "bad"), 1),         -- 5
 (("my1", "bad"), 1),          -- 1
 (("dog1", "bad"), 1),         -- 2
 (("likes1", "bad"), 1),       -- 3
 (("chicken1", "bad"), 1),     -- 4
 (("yes1", "bad"), 1),         -- 5
 (("viagra", "bad"), 1) ]      -- 1b (bad)

printFeatureInfo :: [WordCatInfo] -> String -> String -> IO ()
printFeatureInfo exampleData feature cat = do
  putStrLn $ "Number in Category=" ++ (show $ catCount exampleData cat)
  putStrLn $ "Feature Probability=" ++ (show $ featureProb exampleData feature cat)
  putStrLn $ "Category Probability=" ++ (show $ categoryProb exampleData feature cat)
  putStrLn $ "Weighted Probability=" ++ (show $ weightedProb exampleData feature cat 1.0)

runCatProbTest = do
  putStrLn "Bayes Test: Inv Chi"
  let cat = "good"
      feature = "sss"
  --printFeatureInfo exampleDataDef feature cat
  --putStrLn $ "Fisher Probability=" ++ (show $ fisherProb exampleDataDef ["sss", "dog" ] "bad")

  let cl = (trainClassify "Nobody owns the water." "good") ++
           (trainClassify "the quick rabbit jumps fences" "good") ++
           (trainClassify "buy pharmaceuticals now" "bad") ++
           (trainClassify "make quick money at the online casino" "bad") ++
           (trainClassify "the quick brown fox jumps" "good")
  printFeatureInfo cl "fox" "good"
  printFeatureInfo cl "fox" "bad"
  putStrLn $ "Fisher Probability=" ++ (show $ fisherProb cl ["fox", "dog" ] "good")
  putStrLn "Done Bayes"

runProbTests = do
  runCatProbTest