@echo off
REM ### Run scala application botbert

SET LIB1=lib\jdom.jar
SET LIB2=lib\mysql-connector-java-5.0.3-bin.jar
SET LIB3=lib\sbaz-tests.jar
SET LIB4=lib\sbaz.jar
SET LIB5=lib\scala-actors.jar
SET LIB6=lib\scala-compiler.jar
SET LIB7=lib\scala-dbc.jar
SET LIB8=lib\scala-decoder.jar
SET LIB9=lib\scala-library.jar
SET LIB10=lib\xercesImpl.jar

java -classpath ".;build\botbert.jar;%LIB1%;%LIB2%;%LIB3%;%LIB4%;%LIB5%;%LIB6%;%LIB7%;%LIB8%;%LIB9%;%LIB10%;" BotListScanFeeds -f C:\Berlin\Downloads4\workspaceTrunk\BotListProjects\botbert