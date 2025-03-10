
#----------------------------------------------------------------------------
# Build a preview of the docs published at https://enterprise-contract.github.io/
# including the current changes in this local repo.
#
# Usage:
#   make ec-docs-preview
#
# See also the hack/local-build.sh script in the
# enterprise-contract.github.io repo which does something similar
#
HACBS_DOCS_DIR=../enterprise-contract.github.io/antora
HACBS_DOCS_REPO=git@github.com:enterprise-contract/enterprise-contract.github.io.git
$(HACBS_DOCS_DIR):
	mkdir $(HACBS_DOCS_DIR) && cd $(HACBS_DOCS_DIR) && git clone $(HACBS_DOCS_REPO) .

CURRENT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD)
ec-docs-preview: $(HACBS_DOCS_DIR) ## Build a preview of the documentation
	cd $(HACBS_DOCS_DIR) && \
	  yq e -i '.content.sources[] |= select(.url == "*ec-cookbook*").url |= "../../ec-cookbook"' antora-playbook.yml && \
	  yq e -i '.content.sources[] |= select(.url == "*ec-cookbook*").branches |= "$(CURRENT_BRANCH)"' antora-playbook.yml && \
	  npm ci && npm run build
