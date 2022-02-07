.PHONY: all
all: functree treegen

functree:
	ghc functree.hs

treegen:
	ghc treegen.hs
