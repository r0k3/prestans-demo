VERSION = 1.0
COMPILER = ../bin/compiler/compiler.jar
CALCDEPS = ../bin/closure/calcdeps.py
PRESTANS = ./app/
PREPLATE = ./bin/prestans/preplate2
GSS_COMPILER = ../../bin/compiler/stylesheets.jar
JAVA = java 
CSS_OUTPUT_DIR = static/web/assets
GSS_PROPERTY_EXCEPTION = --allowed-unrecognized-property user-select --allowed-unrecognized-property user-drag --allowed-unrecognized-property -moz-user-drag

PROJ_NAME = meddle
MAIN_JS = Renderer.js

OPT_LEVEL = ADVANCED_OPTIMIZATIONS

deps:	
	cd client/; $(CALCDEPS) -o deps -d goog/ -p $(PROJ_NAME) -p prestans/ --output_file=$(PROJ_NAME)-web-deps.js

dist: dist-web
	@echo "build complete! Good luck with the deployment"

dist-web: deps css-minified
	cd client; $(CALCDEPS) -i $(PROJ_NAME)/ui/web/$(MAIN_JS) -p goog/ -o compiled -c $(COMPILER) -f "--compilation_level=$(OPT_LEVEL)"  -f "--externs=../bin/externs/contrib/maps/google_maps_api_v3_11.js" -f "--externs=../bin/externs/etk/google_appengine_channel.js" -f --js=$(PROJ_NAME)-web-renaming-map.js -p $(PROJ_NAME) -p prestans/ > ../app/static/web/js/$(PROJ_NAME)-ui.js
	cp assets/web/assets/images/* app/static/web/assets/assets/images
	cp assets/web/assets/icons/* app/static/web/assets/assets/icons

css-minified:
	#for file in `ls *css`; do FILENAME=$${file%.*};
	cd assets/web; $(JAVA) -d32 -jar $(GSS_COMPILER) $(GSS_PROPERTY_EXCEPTION) --output-renaming-map-format CLOSURE_COMPILED --rename CLOSURE --output-renaming-map ../../client/$(PROJ_NAME)-web-renaming-map.js --output-file ../../app/$(CSS_OUTPUT_DIR)/style.css style.css

css:
	cd assets/web; $(JAVA) -d32 -jar $(GSS_COMPILER) $(GSS_PROPERTY_EXCEPTION) --pretty-print --output-renaming-map-format CLOSURE_UNCOMPILED --output-renaming-map ../../client/$(PROJ_NAME)-web-renaming-map.js --output-file ../../app/$(CSS_OUTPUT_DIR)/style.css style.css

stubs:
	$(PREPLATE) --prestans-path=$(PRESTANS) --rest-model-path=app/$(PROJ_NAME)/rest/models.py --namespace=$(PROJ_NAME).data.model --output-path=client/$(PROJ_NAME)/data/model --template closure.model
	$(PREPLATE) --prestans-path=$(PRESTANS) --rest-model-path=app/$(PROJ_NAME)/rest/models.py --namespace=$(PROJ_NAME).data.filter --output-path=client/$(PROJ_NAME)/data/filter --template closure.filter

prep:
	mkdir -p app/$(PROJ_NAME)
	mkdir client
	mkdir bin
	mkdir etc
	mkdir docs
	mkdir assets
	git add *

git-repo-setup:
	git submodule add https://github.com/prestans/prestans.git app/prestans
	git submodule add https://github.com/prestans/prestans-client.git client/prestans
	git submodule add https://github.com/eternitytech/closure-compiler.git etc/closure-compiler
	git submodule add https://github.com/prestans/prestans-tools.git bin/prestans-tools

clean:
	rm -f client/meddle-web-deps.js
	rm -f client/meddle-web-renaming-map.js
	rm -f app/static/web/assets/icons/*
	rm -f app/static/web/assets/images/*
	rm -f app/static/web/assets/style.css
	rm -f app/static/web/js/meddle-ui.js
	@echo "all clear! start re-buidling :)"
