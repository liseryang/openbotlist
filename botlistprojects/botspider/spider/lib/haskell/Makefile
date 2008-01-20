###----------------------------------------------
### Makefile
### 9/20/2007
###----------------------------------------------

TOP_DIR := $(shell pwd)

all: content

build-all:
	runhaskell Setup.hs configure
	runhaskell Setup.hs build --verbose

content:
	runhaskell Setup.hs build --verbose
	time ./dist/build/content/content

clean:
	rm -Rf dist

###----------------------------------------------
### End of the Script
###----------------------------------------------
