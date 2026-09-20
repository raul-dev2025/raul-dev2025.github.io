# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS    ?=
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = source
GIT_BRANCH    := $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "default")
BUILDDIR      = build/$(GIT_BRANCH)

# List of targets that are not actual files
.PHONY: help clean html

# Default target: build HTML documentation
html:
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

# Target to clean the build directory
clean:
	rm -rf "$(BUILDDIR)"

clean-ready:
	rm -rf build/ready

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%:
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)