.PHONY: PRETTY GITHUB_SVG_UPDATE PRE_LATEXINDENT PREP_ENV

ALL: exampleRoadmap.pdf

PRETTY: myroadmap.sty legendtypesetting.def exampleRoadmap.tex roadmapcolors.def
	for a in $^; do latexindent --local --overwriteIfDifferent $$a ; done
#	--outputfile=myroadmap_indented.sty

%.pdf %.fls %.log %.aux %.xdv %.fdb_latexmk::%.tex myroadmap.sty
	latexmk -pdfxe -time -pv $<

#%.svg : %.pdf
#	pdf2svg $<

%.dvi : %.tex
	latexmk -dvilua exampleRoadmap.tex

%.svg : %.dvi
	dvisvgm --no-fonts $< $@

PRE_LATEXINDENT:
	sudo apt-get install --yes --no-install-recommends texlive-extra-utils
PREP_ENV: PRE_LATEXINDENT
	sudo apt-get install --yes --no-install-recommends latexmk dvisvgm pdf2svg lacheck texlive-fonts-extra texlive-luatex lacheck chktex

GITHUB_SVG_UPDATE:
	git checkout --orphan exampleoutput
	git config core.editor code
	git config --global user.name "Dr. Bastian Ebeling"
	git config --global user.email 230051+Barry1@users.noreply.github.com
	make exampleRoadmap.svg
	git add -f exampleRoadmap.svg
	git commit -m "exampleRoadmap updated" exampleRoadmap.svg
	git push --force --set-upstream origin exampleoutput
	git checkout main
	git branch -D exampleoutput
