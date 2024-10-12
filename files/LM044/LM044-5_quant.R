library(cowplot)
library(readr)
library(conflicted)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(ggprism)
library(here)

dapi <- read_csv(here("LM044", "LM044-11rep2_DAPI.csv"))
colnames(dapi)[4] <- "DAPI"

sabgal <- read_csv(here("LM044", "LM044-11rep2_SABGalabs.csv"))
colnames(sabgal)[4] <- "SABGal"

# QC
ggplot(sabgal) +
  geom_col(aes(x = Well, y = SABGal))
ggplot(dapi) +
  geom_col(aes(x = Well, y = DAPI))

data <- sabgal %>% left_join(dapi, by = "Well") %>% dplyr::select(c(2,1,4,7))
colnames(data)[c(1,2)] <- c("Well", "Name")

data <- data %>%
  na.omit()

stopifnot(colnames(data) %in% c("Name", "Well", "DAPI", "SABGal"))

data[grepl(pattern = "NA_NA", data$Well),]

data <- data %>% mutate(SABGal_norm = SABGal / DAPI)
data <- data %>%
  separate(col = Name, into = c("bleo", "dose", "rep"), remove = TRUE)

# QC
ggplot(data) +
  geom_col(aes(x = Well, y = SABGal_norm)) 

data_plot <- data %>%
  group_by(bleo, dose) %>%
  summarise(avg = mean(SABGal_norm))

data_plot$bleo <- data_plot$bleo %>% 
  factor(levels = c("H2O", "bleo"))
data_plot$dose <- data_plot$dose %>% 
  factor(levels = c("0uM", "5uM", "40uM"))


plots <- ggplot(data_plot) +
    geom_col(aes(x = bleo, y = avg, fill = dose), position = position_dodge(), color = "black") +
    ylab("SA-B-Gal norm") + 
    ggtitle("LM044-5 IMR90 Alda-1 dosage") +
    theme_prism() +
    theme(axis.text.x = element_text(angle=45, hjust = 0.55)) +
    scale_fill_manual(values = c("grey70", "grey50", "grey25"))

plots

ggsave(plot = plots, filename = "LM044-5_quant.png", path = here("LM044"), device = "png", width = 5, height = 5)
