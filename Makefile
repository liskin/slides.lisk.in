PANDOC ?= pandoc
PANDOCFLAGS ?=

ifdef REVEALJS_RAWGIT
PANDOCFLAGS += --variable=revealjs-url:https://cdn.rawgit.com/hakimel/reveal.js/3.7.0
endif

all: 2018-09-05_testovani_testu.html

REVEALJS_WEB = revealjs-web.yaml
REVEALJS_THEME = revealjs-theme-sky.yaml

%.html: %.md $(REVEALJS_THEME)
	$(PANDOC) --from=markdown --to=revealjs --output=$@ --standalone $(PANDOCFLAGS) $(REVEALJS_THEME) $<

%.web.html: %.md $(REVEALJS_THEME) $(REVEALJS_WEB)
	$(PANDOC) --from=markdown --to=revealjs --output=$@ --standalone $(PANDOCFLAGS) $(REVEALJS_WEB) $(REVEALJS_THEME) $<
