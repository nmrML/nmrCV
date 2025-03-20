## Customize Makefile settings for nmrCV
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

## Adjust version IRI path to be in line with the nmrML website where the versions are going to be published (GH pages)
## and add a dcterms:created annotation although it is redundant since we use date based versioning
ANNOTATE_ONTOLOGY_VERSION = annotate -V http://nmrml.org/cv/$(VERSION)/$@ --annotation owl:versionInfo $(VERSION) --annotation http://purl.org/dc/terms/created $(VERSION)

## Module for ontology: obi
## Since the default extract BOT method imports too many unneeded terms, we customize the import module build process by
## using ROBOT "remove" to remove the terms specified here and in the "obi_remove_list.txt"

$(IMPORTDIR)/obi_import.owl: $(MIRRORDIR)/obi.owl $(IMPORTDIR)/obi_terms.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
        extract -T $(IMPORTDIR)/obi_terms.txt --force true --copy-ontology-annotations true --individuals exclude --method BOT \
        query --update ../sparql/inject-subset-declaration.ru --update ../sparql/inject-synonymtype-declaration.ru --update ../sparql/postprocess-module.ru \
        remove -T $(IMPORTDIR)/obi_remove_list.txt --select "self descendants instances" --exclude-term NCBITaxon:9606 --signature true \
        $(ANNOTATE_CONVERT_FILE); fi
        
        
## Module for ontology: chebi

# We use ROBOT filter instead of the default ODK ROBOT extract method because the latter pulls in too much from ChEBI.
# Using ROBOT filter like this allows us to only import the terms we need under their very general CHEBI 'root' parents.
# This ROBOT filter approach entails, that not all axioms of the imported terms are imported as well, 
# e.g. currently only 'part of' and 'has role' relations between the terms specified in the chebi_import.txt are 
# imported.
# If other axioms are needed in the future the nmrCV editors need to make sure to include the needed object properties 
# and classes used in these, which is quite a time consuming task, but needed, as ROBOT extract pulls in too much 
# and the CHEBI module would otherwise be too big to load. 
# Since we also define classes based on the roles borne by some CHEBI terms, e.g. a 'chemical shift reference compound'
# is equivalent to "'molecular entity' and ('has role' some ''NMR chemical shift reference compound [role]')" 
# we additionally run a reasoning step to materialize the subclassOf axioms needed to group these CHEBI terms under 
# the classes we define.
 
$(IMPORTDIR)/chebi_import.owl: $(MIRRORDIR)/chebi.owl $(IMPORTDIR)/chebi_terms_combined.txt
	if [ $(IMP) = true ] && [ $(IMP_LARGE) = true ]; then $(ROBOT) \
	    filter -i $< -T $(IMPORTDIR)/chebi_terms_combined.txt --signature false --select "annotations self" \
            --exclude-term http://purl.obolibrary.org/obo/CHEBI_24431 \
            --exclude-term http://purl.obolibrary.org/obo/CHEBI_24432 \
            --exclude-term http://purl.obolibrary.org/obo/CHEBI_50906 \
		query --update ../sparql/inject-subset-declaration.ru --update ../sparql/inject-synonymtype-declaration.ru \
		    --update ../sparql/postprocess-module.ru \
		$(ANNOTATE_CONVERT_FILE); fi
	$(ROBOT) reason --reasoner ELK -i $(SRC) --exclude-duplicate-axioms true --exclude-tautologies all --equivalent-classes-allowed asserted-only \
	--annotate-inferred-axioms true --axiom-generators "SubClass" convert -f ofn --output $(SRC)