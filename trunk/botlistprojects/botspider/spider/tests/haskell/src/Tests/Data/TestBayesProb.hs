--
-- Test Queue

module Tests.Data.TestBayesProb where 

import Data.SpiderNet.Bayes

-- Tuple of tuples
exampleData :: [((String, String), Int)]
exampleData = [
 (("my", "good"), 1),          -- 1
 (("dog", "good"), 1),         -- 2
 (("likes", "good"), 1),       -- 3
 (("chicken", "good"), 1),     -- 4
 (("yes", "good"), 1),         -- 5
 (("viagra", "bad"), 1) ]      -- 1b (bad)

runCatProbTest = do
  putStrLn "Bayes Test: Inv Chi"
  let cat = "good"
      feature = "dog"
  putStrLn $ "Number in Category=" ++ (show $ catCount exampleData cat)
  putStrLn $ "Feature Probability=" ++ (show $ featureProb exampleData feature cat)
  putStrLn $ "Category Probability=" ++ (show $ categoryProb exampleData feature cat)
  putStrLn $ "Weighted Probability=" ++ (show $ weightedProb exampleData feature cat 1.0)
  putStrLn "Done Bayes"

runProbTests = do
  runCatProbTest