
CWD     = $(CURDIR)
MODULE  = $(notdir $(CWD))
GZ     ?= /tmp
SRC    ?= $(CWD)/src

PI  = $(CWD)/Picat/picat
PY  = $(CWD)/bin/python3
PIP = $(CWD)/bin/pip3

install: $(PI) $(PY) doc

doc: doc/wambook.pdf doc/book.pdf doc/manual.pdf
doc/wambook.pdf:
	wget -c -O $@ http://wambook.sourceforge.net/wambook.pdf
doc/book.pdf:
	wget -c -O $@ http://picat-lang.org/picatbook2015/constraint_solving_and_planning_with_picat.pdf
doc/manual.pdf:
	wget -c -O $@ http://picat-lang.org/download/picat_guide.pdf

PI_VER = 27b12
PI_GZ  = picat$(PI_VER)_linux64.tar.gz
PI_SRC = picat$(PI_VER)_src.tar.gz

$(PI): $(GZ)/$(PI_GZ)
	tar zx < $< && touch $@

$(GZ)/$(PI_GZ):
	wget -c -O $@ http://picat-lang.org/download/$(PI_GZ)

src: $(SRC)/README
$(SRC)/README: $(GZ)/$(PI_SRC)
	rm -rf $(SRC) ; mkdir $(SRC) ; cd $(SRC) ; tar zx < $< ; mv Picat/* ./ ; touch README
$(GZ)/$(PI_SRC):
	wget -c -O $@ http://picat-lang.org/download/picat27b12_src.tar.gz

$(PY):
	python3 -m venv
	$(PIP) install -U pip
	$(MAKE) update

update: requirements.txt
	git pull -v
	$(PIP) install -U -r $<
	$(MAKE) $<

.PHONY: requirements.txt
requirements.txt:
	$(PIP) freeze | egrep -v "(terminado|0.0.0)" > $@

MERGE  = Makefile README.md .gitignore
MERGE += pycat.ipynb requirements.txt apt.txt postBuild
MERGE += src

merge:
	git checkout master
	git checkout shadow -- $(MERGE)

NOW = $(shell date +%d%m%y)
REL = $(shell git rev-parse --short=4 HEAD)

release:
	git tag $(NOW)-$(REL)
	git push -v && git push -v --tags
	git checkout shadow
