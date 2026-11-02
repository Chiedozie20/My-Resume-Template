# Build the resume PDF with pdflatex (two passes, output staged in build/).

# pdflatex binary. Prefer the system TeX Live when present (avoids a broken
# MiKTeX shim earlier on PATH). Override with: make PDFLATEX=/path/to/pdflatex
PDFLATEX ?= $(or $(wildcard /usr/bin/pdflatex),pdflatex)
BUILD_DIR := build
TEX       := main.tex
PARTS     := $(wildcard particulars/*.tex)
OUTPUT    := resume.pdf

.PHONY: all clean

all: $(OUTPUT)

$(OUTPUT): $(TEX) $(PARTS)
	@mkdir -p $(BUILD_DIR)
	$(PDFLATEX) --draftmode -interaction=nonstopmode -synctex=0 \
		-output-directory=$(BUILD_DIR) $(TEX)
	$(PDFLATEX) -interaction=nonstopmode -synctex=1 \
		-output-directory=$(BUILD_DIR) $(TEX)
	cp $(BUILD_DIR)/main.pdf $(OUTPUT)

clean:
	rm -rf $(BUILD_DIR) $(OUTPUT)
