--
-- Test

module Tests.Data.TestSpiderDatabase where 

import Time
import Data.SpiderDB.Database
import Data.Binary (decodeFile, encodeFile)

runDatabaseTest = do
  putStrLn "Done <spider db test>"
  putStrLn "Running Spider Database Test"
  let db = initSpiderDatabase ([])      
  putStrLn $ show(db)
  encodeFile "test.sdb" (db :: SpiderDatabase)
  newdb <- decodeFile "test.sdb" :: IO SpiderDatabase
  putStrLn $ show(newdb)
  putStrLn "Done"
