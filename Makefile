.PHONY: all
all: functree treegen

functree: functree.hs
	ghc functree.hs

treegen: treegen.hs
	ghc treegen.hs
