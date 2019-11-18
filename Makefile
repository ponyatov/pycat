
CWD     = $(CURDIR)
MODULE  = $(notdir $(CWD))
GZ     ?= /tmp

PI  = $(CWD)/Picat/picat
PY  = $(CWD)/bin/python3
PIP = $(CWD)/bin/pip3

install: $(PI) $(PY)

PI_VER = 27b12
PI_GZ  = picat$(PI_VER)_linux64.tar.gz

$(PI): $(GZ)/$(PI_GZ)

$(GZ)/$(PI_GZ):
	wget -c -O $@ http://picat-lang.org/download/$(PI_GZ)

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
	$(PIP) freeze | grep -v 0.0.0 > $@

MERGE  = Makefile README.md .gitignore
MERGE += pycat.ipynb requirements.txt

merge:
	git checkout master
	git checkout shadow -- $(MERGE)

NOW = $(shell date +%d%m%y)
REL = $(shell git rev-parse --short=4 HEAD)

release:
	git tag $(NOW)-$(REL)
	git push -v && git push -v --tags
	git checkout shadow
