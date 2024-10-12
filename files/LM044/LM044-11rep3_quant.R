library(cowplot)
library(readr)
library(conflicted)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(ggprism)
library(here)

dapi <- read_csv(file = here("LM044", "LM044-11rep3_DAPI.csv"), locale=locale(encoding="latin1"))[,c(2,6)]
colnames(dapi) <- c("sample", "dapi")

sabgal <- read_csv(file = here("LM044", "LM044-11rep3_SABGalabs.csv"), locale=locale(encoding="latin1"))[,c(2,4)]
colnames(sabgal) <- c("sample", "sabgal")

data <- left_join(dapi, sabgal, by = "sample")

blanks <- data[c(grepl(pattern = "NA_NA_blank", data$sample)),] %>%
  summarise(dapi = mean(dapi), sabgal = mean(sabgal))

plotdata <- data[!c(grepl(pattern = "NA_NA_blank", data$sample)),]

plotdata$dapi_corr <- plotdata$dapi - blanks$dapi
plotdata$sabgal_corr <- plotdata$sabgal - blanks$sabgal

# plotdata <- plotdata %>% mutate(SABGal_norm = sabgal_corr / dapi_corr)
plotdata <- plotdata %>% mutate(SABGal_norm = sabgal / dapi)
plotdata <- plotdata %>%
  separate(col = sample, into = c("bleo", "Alda1", "rep"), remove = TRUE)

plotdata_summ <- plotdata %>% 
  group_by(bleo, Alda1) %>%
  summarise(SABGal_norm = mean(SABGal_norm))

plotdata$bleo <- plotdata$bleo %>% 
  factor(levels = c("nobleo", "plusbleo"))
plotdata$Alda1 <- plotdata$Alda1 %>% 
  factor(levels = c("Alda0uM", "Alda5uM", "Alda40uM"))
plotdata_summ$Alda1 <- plotdata_summ$Alda1 %>% 
  factor(levels = c("Alda0uM", "Alda5uM", "Alda40uM"))

plot <- ggplot(plotdata_summ) +
  geom_col(aes(x = Alda1, y = SABGal_norm, fill = Alda1), color = "black") +
  ylab("SA-B-Gal norm (AU)") + 
  ggtitle("LM044-11rep3 quantification") +
  theme_prism() +
  facet_grid(~bleo)+
  theme(axis.text.x = element_text(angle=45, hjust = 0.55), legend.position = "none") +
  scale_fill_manual(values = c("grey10", "grey50", "grey90"))

norm <- plotdata_summ %>%
  t()
names <- paste(norm[1,], norm[2,], sep = "_")
norm <- norm %>%
  as.data.frame() 
norm <- norm[3,]
colnames(norm) <- names
norm <- norm %>% mutate(
  Alda0uM = as.numeric(plusbleo_Alda0uM) / as.numeric(nobleo_Alda0uM),
  Alda5uM = as.numeric(plusbleo_Alda5uM) / as.numeric(nobleo_Alda5uM),
  Alda40uM = as.numeric(plusbleo_Alda40uM) / as.numeric(nobleo_Alda40uM)
) %>%
  dplyr::select(Alda0uM, Alda5uM, Alda40uM)
norm <- norm %>% pivot_longer(cols = c(Alda0uM:Alda40uM), values_to = "SABGal_norm")
norm$name <- norm$name %>% 
  factor(levels = c("Alda0uM", "Alda5uM", "Alda40uM"))

pNorm <- ggplot(norm) +
  geom_col(aes(x = name, y = SABGal_norm, fill = name), color = "black") +
  ylab("SA-B-Gal norm (AU)") + 
  ggtitle("LM044-11rep3 quantification") +
  theme_prism() +
  theme(axis.text.x = element_text(angle=45, hjust = 0.55), legend.position = "none") +
  scale_fill_manual(values = c("grey10", "grey50", "grey90"))

ggsave(plot = plot, filename = "LM044-11rep3_quant.png", path = here("LM044"), device = "png", width = 5, height = 4)
ggsave(plot = pNorm, filename = "LM044-11rep3_quant_bleonorm.png", path = here("LM044"), device = "png", width = 5, height = 4)
write_csv(plotdata_summ, file = here("LM044", "LM044-11_data", "LM044-11rep3_processeddata.csv"))

