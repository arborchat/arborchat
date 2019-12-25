.PHONY: graphs

GRAPHVIS_RENDERED_DIR=./graphviz-rendered
GRAPHVIS_RENDER_FORMAT=png
GRAPHVIS_RAW_DIR=./graphviz-raw

graphs:
	mkdir -p $(GRAPHVIS_RENDERED_DIR); \
	for raw in $(shell ls $(GRAPHVIS_RAW_DIR)); do \
	    dot -T$(GRAPHVIS_RENDER_FORMAT) -o $(GRAPHVIS_RENDERED_DIR)/$$raw.$(GRAPHVIS_RENDER_FORMAT) $(GRAPHVIS_RAW_DIR)/$$raw; \
    done
