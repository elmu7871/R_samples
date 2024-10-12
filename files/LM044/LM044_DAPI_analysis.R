dapi_rep1 <- read_csv(file = here("LM044", "LM044-11rep1_DAPI.csv"), locale=locale(encoding="latin1"))[,c(2,6)]
colnames(dapi_rep1) <- c("sample", "dapi")

dapi_rep2 <- read_csv(file = here("LM044", "LM044-11rep2_DAPI.csv"), locale=locale(encoding="latin1"))[,c(2,6)]
colnames(dapi_rep2) <- c("sample", "dapi")

dapi_rep3 <- read_csv(file = here("LM044", "LM044-11rep3_DAPI.csv"), locale=locale(encoding="latin1"))[,c(2,6)]
colnames(dapi_rep3) <- c("sample", "dapi")

dapi_rep4 <- read_csv(file = here("LM044", "LM044-11rep4_DAPI.csv"), locale=locale(encoding="latin1"))[,c(2,6)]
colnames(dapi_rep4) <- c("sample", "dapi")

dapi_rep5 <- read_csv(file = here("LM044", "LM044-11rep5_DAPI.csv"), locale=locale(encoding="latin1"))[,c(2,6)]
colnames(dapi_rep5) <- c("sample", "dapi")

gplots::heatmap.2(matrix(dapi_rep1$dapi, nrow = 4, byrow = F), dendrogram='none', Rowv=FALSE, Colv=FALSE,trace='none', col = bluered, cellnote = matrix(dapi_rep1$dapi, nrow = 4, byrow = F))

gplots::heatmap.2(matrix(dapi_rep2$dapi, nrow = 4, byrow = T), dendrogram='none', Rowv=FALSE, Colv=FALSE,trace='none', col = bluered, cellnote = matrix(dapi_rep2$dapi, nrow = 4, byrow = T))

gplots::heatmap.2(matrix(dapi_rep3$dapi, nrow = 4, byrow = T), dendrogram='none', Rowv=FALSE, Colv=FALSE,trace='none', col = bluered, cellnote = matrix(dapi_rep3$dapi, nrow = 4, byrow = T))

gplots::heatmap.2(matrix(dapi_rep4$dapi, nrow = 4, byrow = T), dendrogram='none', Rowv=FALSE, Colv=FALSE,trace='none', col = bluered, cellnote = matrix(dapi_rep4$dapi, nrow = 4, byrow = T))

gplots::heatmap.2(matrix(dapi_rep5$dapi, nrow = 4, byrow = T), dendrogram='none', Rowv=FALSE, Colv=FALSE,trace='none', col = bluered, cellnote = matrix(dapi_rep5$dapi, nrow = 4, byrow = T))

bigmatrix <- rbind(
  matrix(dapi_rep1$dapi, nrow = 4, byrow = F),
  matrix(dapi_rep2$dapi, nrow = 4, byrow = T),
  matrix(dapi_rep3$dapi, nrow = 4, byrow = T),
  matrix(dapi_rep4$dapi, nrow = 4, byrow = T),
  matrix(dapi_rep5$dapi, nrow = 4, byrow = T)
)

gplots::heatmap.2(bigmatrix, breaks = 50, dendrogram='none', Rowv=FALSE, Colv=FALSE,trace='none', col = bluered)

hist(dapi_rep1$dapi, breaks = 20)
hist(dapi_rep2$dapi, breaks = 20)
hist(dapi_rep3$dapi, breaks = 20)
hist(dapi_rep4$dapi, breaks = 20)

sabgal_rep1 <- read_csv(file = here("LM044", "LM044-11rep1_SABGalabs.csv"), locale=locale(encoding="latin1"))[,c(2,4)]
colnames(sabgal_rep1) <- c("sample", "sabgal")

sabgal_rep2 <- read_csv(file = here("LM044", "LM044-11rep2_SABGalabs.csv"), locale=locale(encoding="latin1"))[,c(2,4)]
colnames(sabgal_rep2) <- c("sample", "sabgal")

sabgal_rep3 <- read_csv(file = here("LM044", "LM044-11rep3_SABGalabs.csv"), locale=locale(encoding="latin1"))[,c(2,4)]
colnames(sabgal_rep3) <- c("sample", "sabgal")

sabgal_rep4 <- read_csv(file = here("LM044", "LM044-11rep4_SABGalabs.csv"), locale=locale(encoding="latin1"))[,c(2,4)]
colnames(sabgal_rep4) <- c("sample", "sabgal")

gplots::heatmap.2(matrix(sabgal_rep1$sabgal, nrow = 4, byrow = T), dendrogram='none', Rowv=FALSE, Colv=FALSE,trace='none', col = bluered)

gplots::heatmap.2(matrix(sabgal_rep2$sabgal, nrow = 4, byrow = T), dendrogram='none', Rowv=FALSE, Colv=FALSE,trace='none', col = bluered)

gplots::heatmap.2(matrix(sabgal_rep3$sabgal, nrow = 4, byrow = T), dendrogram='none', Rowv=FALSE, Colv=FALSE,trace='none', col = bluered)

gplots::heatmap.2(matrix(sabgal_rep4$sabgal, nrow = 4, byrow = T), dendrogram='none', Rowv=FALSE, Colv=FALSE,trace='none', col = bluered)
