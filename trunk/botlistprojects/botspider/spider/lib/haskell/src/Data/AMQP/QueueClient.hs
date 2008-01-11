{- ***********************************************
   File: QueueClient.hs
   Module: Data.AMQP.QueueClient

   See the following reference links:
   (1) http://www.haskell.org/ghc/docs/6.8.2/html/libraries/network/Network.html
   (2) http://hackage.haskell.org/packages/archive/binary/0.4.1/doc/html/Data-Binary.html
   (3) http://hackage.haskell.org/packages/archive/bytestring/0.9.0.1/doc/html/Data-ByteString.html
   
   Simple connection to AMQP Server (like RabbitMQ).

   Based on python AMQP Client Library
   from Barry Pederson.
   (4) http://barryp.org/software/py-amqplib/   
   *********************************************** -}
module Data.AMQP.QueueClient where

import Network
import System.IO

import Data.Word
import Data.Binary
import Data.Binary.Get as BinaryGet
import Data.Binary.Put as BinaryPut

import Data.ByteString as Eager (unpack, pack)
import qualified Data.ByteString.Char8 as C
import qualified Data.ByteString.Lazy.Char8 as LazyC
import Data.ByteString.Lazy as Lazy (ByteString, unpack)
import Text.Printf

import Data.AMQP.AMQPOperations (methodNameMap)

ampqClientVers = "0.0.1"

server = "127.0.0.1"
port = 5672

amqpHeadA = "AMQP"
amqpHeadB = 0x01010901

localeEnUs = "en_US"

type Octet = Word8

data AMQPData = AMQPData {
      amqpHeaderA :: [Octet],
      amqpHeaderB :: Word32
}

data AQMPStartOk = AMQPStartOk {
      -- *****************************************
      {- 
         shortstr = Up to 255 bytes, after encoding (len:byte)
         longstr = Write a string up to 2 ^ 32 bytes after encoding (len:long)
       -}
      -- *****************************************        
      write_longstr :: ByteString
      write_shortstr:: ByteString
      response :: ByteString
      locale :: ByteString
}

-- *********************************************************
{-
   Wait for a frame:
   1. Frame Type (Octet)
   2. Channel (Short)
   3. Size (Long)
   4. Payload (variable length, set to size)
   5. ch
-}
-- *********************************************************
data AMQPFrame = AMQPFrame {
      frameType :: Octet,
      channel :: Word16,
      size :: Word32,
      payload :: ByteString,
      ch :: Octet
}

{- *********************************************************
     Class instances
   ********************************************************* -}
instance Show AMQPFrame where
    show amq = let frame_type = (frameType amq)
              in "<<<AMQP Reader>>>\n" ++
               printf "FrameType: %X\n" (frameType amq) ++
               printf "Channel: %X\n" (channel amq) ++
               printf "Size: %d\n" (size amq) ++
               printf "Ch: %X\n" (ch amq)
               
instance Binary AMQPFrame where
    get = do
      frameType <- getWord8
      chan <- getWord16be
      sz <- getWord32be
      bytes <- BinaryGet.getLazyByteString (fromIntegral sz)
      chw <- getWord8
      return (AMQPFrame { frameType=frameType,
                           channel=chan,
                           size=sz,
                           payload=bytes,
                           ch=chw
                         })

instance Binary AMQPData where

    -- *****************************************************
    {-
    The connection class provides methods for a client to establish a
    network connection to a server, and for both peers to operate the
    connection thereafter.

    GRAMMAR:

        connection          = open-connection *use-connection close-connection
        open-connection     = C:protocol-header
                              S:START C:START-OK
                              *challenge
                              S:TUNE C:TUNE-OK
                              C:OPEN S:OPEN-OK | S:REDIRECT
        challenge           = S:SECURE C:SECURE-OK
        use-connection      = *channel
        close-connection    = C:CLOSE S:CLOSE-OK
                            / S:CLOSE C:CLOSE-OK
     -}
     -- *******************************************************
    put amq = do
      BinaryPut.putByteString (pack (amqpHeaderA amq))
      BinaryPut.putWord32be (amqpHeaderB amq)

amqInstance :: IO AMQPData
amqInstance = return (AMQPData { amqpHeaderA = (Eager.unpack (C.pack amqpHeadA)),
                                 amqpHeaderB = amqpHeadB
                               })

connectSimpleServer = do
  -- Create an instance of the AMQ data to send
  -- across the network.
  amq <- amqInstance    

  -- Connect to the given server through hostname and port number
  h <- connectTo server (PortNumber (fromIntegral port))
  hSetBuffering h NoBuffering
  
  -- Convert the instance of the data into a lazy bytestring type
  let bs_amq = encode amq
  -- Through the use of lazy hPut, write out the data to the socket handle
  LazyC.hPut h bs_amq
  hFlush h

  -- Wait for frame
  bs_reader <- LazyC.hGetContents h
  let amqFrame = decode bs_reader :: AMQPFrame
  putStrLn $ show(amqFrame)
  
  -- Extract the payload, checking the method signature
  let framePayload = (payload amqFrame)
      methodSig = (take 4 (LazyC.unpack framePayload))

  -- Get the method signature values, we expect 10,10
  putStrLn $ printf "#[%x %x %x %x] method_name="
               (methodSig !! 0) (methodSig !! 1)
               (methodSig !! 2) (methodSig !! 3)
  putStrLn $ methodNameMap (10, 10)
  t <- hGetContents h
  print t
