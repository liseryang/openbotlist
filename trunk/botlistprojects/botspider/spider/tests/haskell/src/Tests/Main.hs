{- ***********************************************
   File: QueueClient.hs 
   Author: Berlin Brown
   *********************************************** -}
module Main where

import Tests.AMQP.TestQueueClient

main = do
  putStrLn "Running TestMain"
  putStrLn $ "AMQP Queue Client=" ++ libVers
  connectServerTest
  putStrLn "Done"
