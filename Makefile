NAME    := mux
VERSION := 0.1.0
AUTHOR  := terlar
URL     := https://github.com/$(AUTHOR)/$(NAME)

# Packaging
PKG_DIR  := pkg
PKG_NAME := $(NAME)-$(VERSION)
PKG      := $(PKG_DIR)/$(PKG_NAME).tar.gz
SIG      := $(PKG_DIR)/$(PKG_NAME).tar.gz.asc

# Installation directories
PREFIX  ?= /usr
DESTDIR ?=
BINDIR  ?= $(PREFIX)/bin
MANDIR  ?= $(PREFIX)/share/man

FISH_COMPLETION_DIR ?= $(PREFIX)/share/fish/vendor_completions.d

pkg:
	mkdir $(PKG_DIR)

download: pkg
	wget -O $(PKG) $(URL)/archive/v$(VERSION).tar.gz

.PHONY: build
build: pkg
	git archive --output=$(PKG) --prefix=$(PKG_NAME)/ HEAD

.PHONY: sign
sign: $(PKG)
	gpg --sign --detach-sign --armor $(PKG)
	git add $(PKG).asc
	git commit $(PKG).asc -m "Added PGP signature for v$(VERSION)"
	git push

.PHONY: verify
verify: $(PKG) $(SIG)
	gpg --verify $(SIG) $(PKG)

.PHONY: clean
clean:
	rm -f $(PKG) $(SIG)

.PHONY: all
all: $(PKG) $(SIG)

.PHONY: test
test:
	fish test/runner.fish

.PHONY: tag
tag:
	git push
	git tag -s -m "Tagging $(VERSION)" v$(VERSION)
	git push --tags

.PHONY: release
release: tag download sign

.PHONY: install
install:
	install -m 755 -d "$(DESTDIR)$(BINDIR)"
	install -m 755 -d "$(DESTDIR)$(MANDIR)"
	install -m 755 -d "$(DESTDIR)$(MANDIR)/man1"

	install -m 755 mux "$(DESTDIR)$(BINDIR)/mux"
	install -m 644 man/man1/mux.1 "$(DESTDIR)$(MANDIR)/man1/mux.1"

	-install -m 644 contrib/completion/fish/mux.fish "$(DESTDIR)$(FISH_COMPLETION_DIR)/"

.PHONY: uninstall
uninstall:
	rm "$(DESTDIR)$(MANDIR)/man1/mux.1"
	rm "$(DESTDIR)$(BINDIR)/mux"

.DEFAULT_GOAL:=build
