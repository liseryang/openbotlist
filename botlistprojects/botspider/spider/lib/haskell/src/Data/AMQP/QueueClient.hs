{- ***********************************************
   File: QueueClient.hs 
   Author: Berlin Brown
   *********************************************** -}

module Data.AMQP.QueueClient where

ampqClientVers = "0.1"
amqpPort = 5672
amqpMimePlain = "text/plain"

data Connection = Connection {
    {-
     *************************
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
     *************************
     -}
    host :: String,
    userid :: String,
    password :: String,
    login_method :: String,
    login_response :: String,
    virtual_host :: String,
    locale :: String,
    client_properties :: String
}
