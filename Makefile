# Build the CV with the AltaCV class from the AltaCV/ submodule.
# latexmk finds altacv.cls and its figures through TEXINPUTS.

LATEXMK         ?= latexmk
LATEXMKFLAGS    ?= -pdf -interaction=nonstopmode -halt-on-error
PDF             = elvinluff.pdf
SRC             = elvinluff.tex
CLASS           = AltaCV/altacv.cls
DEPS            = $(SRC) avatar.jpg

export TEXINPUTS := $(CURDIR)/AltaCV:$(CURDIR)/AltaCV/figures:$(TEXINPUTS)

.PHONY: all clean distclean submodule

all: $(PDF)

$(PDF): $(DEPS) $(CLASS)
	$(LATEXMK) $(LATEXMKFLAGS) $(SRC)

# Keep the PDF, drop the LaTeX artifacts.
clean:
	latexmk -c

# Drop everything, including the PDF.
distclean: clean
	rm -f $(PDF) elvinluff.xmpi elvinluff.bbl

# Fetch/refresh the template submodule.
submodule:
	git submodule update --init --recursive
