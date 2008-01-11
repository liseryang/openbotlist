###----------------------------------------------
### Makefile
### 9/20/2007
###----------------------------------------------

TOP_DIR := $(shell pwd)

all: TestQueueClient

TestQueueClient:
	runhaskell Setup.hs configure
	runhaskell Setup.hs build --verbose

clean:
	rm -Rf dist

###----------------------------------------------
### End of the Script
###----------------------------------------------
