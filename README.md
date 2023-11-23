
![Build Status](https://github.com/nmrML/nmrCV/workflows/CI/badge.svg)
# nuclear magnetic resonance CV

Description: This artefact is an MSI-approved controlled vocabulary primarily developed under COSMOS EU and PhenoMeNal EU governance. The nmrCV is supporting the nmrML XML format with standardized terms. nmrML is a vendor agnostic open access NMR raw data standard. Its primaly role is analogous to the mzCV for the PSI-approved mzML XML format. It uses BFO2.0 as its Top level. This CV was derived from two predecessors (The NMR CV from the David Wishart Group, developed by Joseph Cruz) and the MSI nmr CV developed by Daniel Schober at the EBI. This simple taxonomy of terms (no DL semantics used) serves the nuclear magnetic resonance markup language (nmrML) with meaningful descriptors to amend the nmrML xml file with CV terms. Metabolomics scientists are encouraged to use this CV to annotrate their raw and experimental context data, i.e. within nmrML. The approach to have an exchange syntax mixed of an xsd and CV stems from the PSI mzML effort. The reason to branch out from an xsd into a CV is, that in areas where the terminology is likely to change faster than the nmrML xsd could be updated and aligned, an externally and decentrallised maintained CV can accompensate for such dynamics in a more flexible way. A second reason for this set-up is that semantic validity of CV terms used in an nmrML XML instance (allowed CV terms, position/relation to each other, cardinality) can be validated by rule-based proprietary validators: By means of cardinality specifications and XPath expressions defined in an XML mapping file (an instances of the CvMappingRules.xsd ), one can define what ontology terms are allowed in a specific location of the data model.

More information can be found at http://obofoundry.org/ontology/nmrCV

## Versions

### Stable release versions

The latest version of the ontology can always be found at:

http://purl.obolibrary.org/obo/nmrCV.owl

(note this will not show up until the request has been approved by obofoundry.org)

### Editors' version

Editors of this ontology should use the edit version, [src/ontology/nmrCV-edit.owl](src/ontology/nmrCV-edit.owl)

## Contact

Please use this GitHub repository's [Issue tracker](https://github.com/nmrML/nmrCV/issues) to request new terms/classes or report errors or specific concerns related to the ontology.

## Acknowledgements

This ontology repository was created using the [Ontology Development Kit (ODK)](https://github.com/INCATools/ontology-development-kit).