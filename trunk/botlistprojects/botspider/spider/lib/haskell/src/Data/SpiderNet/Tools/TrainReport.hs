-- *********************************************************
{-
File: Bayes.hs

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

import Monad (liftM)
import System.Directory (getDirectoryContents)
import List (isPrefixOf, isSuffixOf, genericLength)
import Data.SpiderNet.Bayes
import IO
import Data.SpiderNet.Document
import Data.SpiderNet.Util (timeDiff)

reportOutputFile = "trainreport.csv"
trainDir = "../../var/lib/spiderdb/train"
inputExtractContent = "../../var/lib/spiderdb/dump"
stopWordsDb = "../../var/lib/spiderdb/lexicon/stopwords/stopwords.tdb"

getCatTrainInfo :: [WordCatInfo] -> String -> [String] -> IO DocTrainInfo
getCatTrainInfo traininfo cat wordtokens = do
  let bp = bayesProb traininfo wordtokens cat 1.0
      fp = fisherProb traininfo wordtokens cat
      cfp = contentFeatProb traininfo wordtokens cat
  return DocTrainInfo {
                    trainCatName = cat,
                    trainBayesProb = bp,
                    trainFisherProb = fp,
                    trainFeatureProb = cfp
                  }

runTrainReport :: IO ()
runTrainReport = do
  putStrLn "Train Report"
  stopwords <- readStopWords stopWordsDb
  -- Process only files with 'train' extension
  traininf <- readContentByExt trainDir ".train"
  -- Train inf contains a collection of all data read from the training files.
  let traininfo = buildTrainSet traininf stopwords []
  contentinf <- readContentByExt inputExtractContent ".extract"
  putStrLn $ "Train Set Size=" ++ (show (length traininfo))
  putStrLn $ "Content Extract Size=" ++ (show (length contentinf))
  docreport <- mapM (\contentinfo -> do
                       let content = snd contentinfo
                           contentname = fst contentinfo
                           wordtokens = inputDocumentTokens content stopwords
                           docdens = documentDensity content
                           stopdens = stopWordDensity content stopwords   
                       readpageinfo <- readInfoContentFile contentname
                       doctrain <- mapM (\c -> getCatTrainInfo traininfo c wordtokens) (categories traininfo)
                       return DocumentInfo {
                                    docName = contentname,
                                    docCharLen = genericLength content,
                                    docTokenLen = genericLength wordtokens, 
                                    docWordDensity = docdens,
                                    docStopWordDensity = stopdens,
                                    docTrainInfo = doctrain,
                                    docPageInfo = readpageinfo
                                  }
                    ) contentinf
  -- Print the report to file
  h <- openFile reportOutputFile WriteMode
  mapM_ (\inf -> hPutDocumentInfo h inf) docreport
  hClose h  

hPutDocumentInfo :: Handle -> DocumentInfo -> IO ()
hPutDocumentInfo h info = do
  hPutStr h (show info) >> hFlush h
  hPutStr h (show (docPageInfo info)) >> hFlush h
  hPutStr h (formatTrainInfo (docTrainInfo info))  
  hFlush h >> hPutStr h "\n"
  putStrLn $ " logged info=" ++ (docName info)

main :: IO ()
main = do
  timeDiff $ runTrainReport

-- End of File