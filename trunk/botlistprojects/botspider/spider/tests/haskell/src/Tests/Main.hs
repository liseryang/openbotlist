{- ***********************************************
   File: QueueClient.hs 
   Author: Berlin Brown
   *********************************************** -}
module Main where

import Tests.AMQP.TestQueueClient

import Time
import Data.Time.Clock.POSIX

main = do
  ct <- getClockTime
  pt <- getPOSIXTime
  putStrLn $ "Running TestMain"
  putStrLn $ "At: " ++ (show ct) ++ " t:" ++ (show (round pt))
  putStrLn $ "AMQP Queue Client=" ++ libVers
  --connectServerTest
  putStrLn "Test Build Queue"
  putStrLn "Done"
