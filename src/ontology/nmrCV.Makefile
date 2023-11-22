## Customize Makefile settings for vispro
##
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

##################
#   components   #
##################

$(COMPONENTSDIR)/nmrCV_classes.owl: $(TEMPLATEDIR)/nmrCV_classes.tsv
	if [ $(COMP) = true ] ; then $(ROBOT) template \
		--merge-after --input $(SRC) --add-prefixes config/context.json \
		--template $< --output $@; fi
	if [ $(COMP) = true ] ; then $(ROBOT) annotate -i $@ \
		--ontology-iri $(ONTBASE)/$@ \
		--version-iri $(ONTBASE)/releases/$(VERSION)/$@ \
		--annotation rdfs:comment "This component is derived from the 'src/templates/nmrCV_classes.tsv', which is edited manually by domain experts." \
		convert -f ofn --output $@; fi

$(COMPONENTSDIR)/nmrCV_object_properties.owl: $(TEMPLATEDIR)/nmrCV_object_properties.tsv
	if [ $(COMP) = true ] ; then $(ROBOT) template \
		--merge-after --input $(SRC) --add-prefixes config/context.json \
		--template $< --output $@; fi
	if [ $(COMP) = true ] ; then $(ROBOT) annotate -i $@ \
		--ontology-iri $(ONTBASE)/$@ \
		--version-iri $(ONTBASE)/releases/$(VERSION)/$@ \
		--annotation rdfs:comment "This component is derived from the 'src/templates/nmrCV_object_properties.tsv', which is edited manually by domain experts." \
		convert -f ofn --output $@; fi

##################
# import modules #
##################

## Module for ontology: obi
## We decided to use the ROBOT filter method to exctract the needed terms because the slme BOT method brings in too many unneeded terms due to its high axiomatization

$(IMPORTDIR)/obi_import.owl: $(MIRRORDIR)/obi.owl $(IMPORTDIR)/obi_terms.txt
	if [ $(IMP) = true ]; then $(ROBOT) filter -i $< -T $(IMPORTDIR)/obi_terms.txt --select "self ancestors equivalents" --axioms "disjoint tbox rbox" --signature false --trim true \
		--output $@.tmp.owl; fi
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module_provo.ru \
		filter -T $(IMPORTDIR)/obi_terms.txt --select "self annotations domains ranges equivalents instances ontology" --axioms "disjoint tbox rbox" --signature false --trim true \
		query --update ../sparql/postprocess-module_2.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		merge -i $@.tmp.owl \
		--output $@.tmp.owl && mv $@.tmp.owl $@; fi


## Module for ontology: chmo
## We decided to use the ROBOT filter method to exctract the needed terms because the slme BOT method brings in too many unneeded terms due to the axiomatization

$(IMPORTDIR)/chmo_import.owl: $(MIRRORDIR)/chmo.owl $(IMPORTDIR)/chmo_terms.txt
	if [ $(IMP) = true ]; then $(ROBOT) filter -i $< -T $(IMPORTDIR)/chmo_terms.txt --select "self ancestors equivalents" --axioms "disjoint tbox rbox" --signature false --trim true \
		--output $@.tmp.owl; fi
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module_provo.ru \
		filter --term http://purl.obolibrary.org/obo/CHMO_0002414 --select "self descendants annotations domains ranges equivalents instances ontology" --axioms "disjoint tbox rbox" --signature false --trim true \
		query --update ../sparql/postprocess-module_2.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		merge -i $@.tmp.owl \
		--output $@.tmp.owl; fi
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module_provo.ru \
		filter --term http://purl.obolibrary.org/obo/CHMO_0000628 --select "self descendants annotations domains ranges equivalents instances ontology" --axioms "disjoint tbox rbox" --signature false --trim true \
		query --update ../sparql/postprocess-module_2.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		merge -i $@.tmp.owl \
		--output $@.tmp.owl; fi
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module_provo.ru \
		filter -T $(IMPORTDIR)/chmo_terms.txt --select "self annotations domains ranges equivalents instances ontology" --axioms "disjoint tbox rbox" --signature false --trim true \
		query --update ../sparql/postprocess-module_2.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		merge -i $@.tmp.owl \
		--output $@.tmp.owl && mv $@.tmp.owl $@; fi
