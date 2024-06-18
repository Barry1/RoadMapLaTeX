.PHONY: PRETTY GITHUB_SVG_UPDATE

ALL: exampleRoadmap.pdf

PRETTY: myroadmap.sty legendtypesetting.def exampleRoadmap.tex roadmapcolors.def
	for a in $^; do latexindent --local --overwriteIfDifferent $$a ; done
#	--outputfile=myroadmap_indented.sty

%.pdf %.fls %.log %.aux %.xdv %.fdb_latexmk::%.tex myroadmap.sty
	latexmk -pdfxe $<

#%.svg : %.pdf
#	pdf2svg $<

%.dvi : %.tex
	latexmk -dvilua exampleRoadmap.tex

%.svg : %.dvi
	dvisvgm --no-fonts $< $@

GITHUB_SVG_UPDATE:
	git checkout --orphan exampleoutput
	make exampleRoadmap.svg
	git add -f exampleRoadmap.svg
	git commit -m "exampleRoadmap created" exampleRoadmap.svg
	git push --set-upstream origin exampleoutput
	git checkout main
	git branch -D exampleoutput
