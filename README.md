# Welcome! 

This repository is a showcase of representative samples of my work in R to share as examples of my R scripting and data analysis skills during the graduate school application process.

Please note that any unpublished data has been obscured to protect our group's unpublished findings. I've done my best to make it clear when this is the case. Any documents with nonsense or generic labels (ie. "HUMAN-1" cells treated with "applejuice" and "orangejuice", plots showing expression of "GENE1", etc) have been edited and do not represent real-world data. I've also placed a clear note at the top of each document which has been altered in this way to further prevent confusion. For that reason, **please do not consider any data in this repository, regardless of how it is labeled, to be reflective of any real-world biology.**

## Guide to this repository

**dose_response** is a generic example of code used to plot plate-based colorimetric dose response to a treatment normalized to DAPI in cultured cells.

**ELISA** is a generic example of code used to process raw data from a sandwich ELISA assay.

**enzyme_activity_assay** is a generic example of code used to process raw absorbance data over time from a colorimetric enzyme activity assay into a plot. 

**gel_contraction** is a generic example of code used to process collagen gel contraction measurements into a plot showing contractive response to different stimuli.

**IMR90_cellcount_to_protein** is a quick tool I made to easily convert a user-input number of IMR-90 cells and lysis buffer volume into an estimation of the total protein mass contained in those cells. This was used in an assay in which the assay's lysis buffer was incompatible with any accessible total protein estimation assay.

**proteinCHKr** is a tool to calculate the percent of an annotated protein's total amino acid content which is either cysteine, histidine, or lysine. I use this as a crude screening tool to support early exploration experiments with 4-hydroxynonenal (4-HNE). 4-HNE forms adducts with these amino acids, so it's helpful to know if a potential target protein has an unusually high or low content of C, H, and/or K.

**qPCR** is a generic example of code which processes qRT-PCR raw data into plots of Cq and log fold change.

**RIP-seq** is the RIP-seq analysis I performed in the Mukherjee lab and presented at the 2021 RNA Society meeting.
