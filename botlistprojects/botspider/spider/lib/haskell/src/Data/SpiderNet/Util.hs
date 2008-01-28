--
--
module Data.SpiderNet.Util where

import System.CPUTime

timeDiff :: IO t -> IO t
timeDiff func = do
   start <- getCPUTime
   v <- func
   end   <- getCPUTime
   let diff = (fromIntegral (end - start)) / (10^12)
   putStrLn $ "running time:" ++ (show (diff :: Double)) ++ " s"
   return v