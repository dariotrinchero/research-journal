# Makefile for LaTeX journal

TEXC = latexmk

.PHONY: all bg clean

all:
	pgrep $(TEXC) || $(TEXC)

bg:
	$(TEXC) -pvc -interaction=nonstopmode -view=none

clean:
	$(TEXC) -c
