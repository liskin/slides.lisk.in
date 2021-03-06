PANDOC ?= pandoc
PANDOCFLAGS ?=

SOURCES = $(wildcard ????-??-??_*.md)

.PHONY: all
all: $(SOURCES:.md=.html)

THEME = sky
BACKGROUND =

DEPS = Makefile $(wildcard revealjs-*.*)

%.html: override PANDOCFLAGS += \
	--to=revealjs \
	--template=revealjs-template.html \
	--standalone \
	--no-highlight \
	revealjs-common.yaml \
	$(if $(THEME),revealjs-theme-$(THEME).yaml) \
	$(if $(BACKGROUND),revealjs-background-$(BACKGROUND).yaml)

%.html: %.md $(DEPS)
	$(PANDOC) $(PANDOCFLAGS) --from=markdown --output=$@ $<

2018-09-05_testovani_testu.%: override BACKGROUND = clouds

.PHONY: clean
clean:
	git clean -fdX

.PHONY: livereload
livereload:
	python3 -c 'from livereload import Server, shell; server = Server(); server.watch(".", shell("make")); server.serve();'
