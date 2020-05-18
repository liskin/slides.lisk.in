PANDOC ?= pandoc
PANDOCFLAGS ?=

.PHONY: all
all: 2018-09-05_testovani_testu.html

REVEALJS_WEB = revealjs-web.yaml
REVEALJS_THEME = revealjs-theme-sky.yaml
REVEALJS_TEMPLATE = revealjs-template.html

DEPS = $(REVEALJS_WEB) $(REVEALJS_THEME) $(REVEALJS_TEMPLATE)

%.html: override PANDOCFLAGS += \
	--to=revealjs \
	--template=$(REVEALJS_TEMPLATE) \
	--standalone \
	--no-highlight \
	$(REVEALJS_THEME)
%.web.html: override PANDOCFLAGS += $(REVEALJS_WEB)

%.html: %.md $(DEPS)
	$(PANDOC) $(PANDOCFLAGS) --from=markdown --output=$@ $<

%.web.html: %.md $(DEPS)
	$(PANDOC) $(PANDOCFLAGS) --from=markdown --output=$@ $<

.PHONY: clean
clean:
	git clean -fdX

.PHONY: livereload
livereload:
	python3 -c 'from livereload import Server, shell; server = Server(); server.watch(".", shell("make")); server.serve();'
