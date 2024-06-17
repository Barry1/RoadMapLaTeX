.PHONY: PRETTY

ALL: exampleRoadmap.pdf

PRETTY: myroadmap.sty legendtypesetting.def exampleRoadmap.tex roadmapcolors.def
	for a in $^; do latexindent --local --overwriteIfDifferent $$a ; done
#	--outputfile=myroadmap_indented.sty

%.pdf %.fls %.log %.aux %.xdv %.fdb_latexmk::%.tex myroadmap.sty
	latexmk -pdfxe $<