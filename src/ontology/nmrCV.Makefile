## Customize Makefile settings for nmrCV
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile


## Module for ontology: obi
## Since the default extract BOT method imports too many unneeded terms, we customize the import module build process by
## using ROBOT "remove" to remove the terms specified here and in the "obi_remove_list.txt"

$(IMPORTDIR)/obi_import.owl: $(MIRRORDIR)/obi.owl $(IMPORTDIR)/obi_terms.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
        extract -T $(IMPORTDIR)/obi_terms.txt --force true --copy-ontology-annotations true --individuals exclude --method BOT \
        query --update ../sparql/inject-subset-declaration.ru --update ../sparql/inject-synonymtype-declaration.ru --update ../sparql/postprocess-module.ru \
        remove -T $(IMPORTDIR)/obi_remove_list.txt --select "self descendants instances" --signature true \
        $(ANNOTATE_CONVERT_FILE); fi