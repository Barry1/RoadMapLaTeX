.PHONY: PRETTY

ALL: exampleRoadmap.pdf

PRETTY:
	latexindent --local --overwriteIfDifferent myroadmap.sty
	latexindent --local --overwriteIfDifferent legendtypesetting.def
#	--outputfile=myroadmap_indented.sty

%.pdf %.fls %.log %.aux %.xdv %.fdb_latexmk::%.tex myroadmap.sty
	latexmk -pdfxe $<