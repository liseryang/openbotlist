--
-- Test Queue

module Tests.Data.TestBayesInvChi where 

import Data.SpiderNet.Bayes

exampleData :: [(Double, Double)]
exampleData = [
    (4.3, 6),
    (2.2, 60),
    (60, 2.2),
    (0.3, 4),
    (32.123, 20),
    (12.4, 5),
    (0.04, 3),
    (0, 0),
    (1, 1)]

runBayesTest = do
  putStrLn "Bayes Test: Inv Chi"
  mapM_ (\x -> putStrLn $ (show x) ++ " res=" ++ (show (invChi2 (fst x) (snd x)))) exampleData
  putStrLn "Done Bayes"