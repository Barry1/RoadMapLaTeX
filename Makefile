.PHONY: PRETTY

PRETTY:
	latexindent --local --overwriteIfDifferent myroadmap.sty
	latexindent --local --overwriteIfDifferent legendtypesetting.def
#	--outputfile=myroadmap_indented.sty 