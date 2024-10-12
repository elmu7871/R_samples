library(here)
library(readr)
library(ggpubr)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(cowplot)

experiment <- "YA_ALDH1-45"
filename <- "YA_ALDH1-45_WBQuant.csv"
targets <- c("p21", "p53", "ALDH2")


westernstuff <- function(experiment, filename, targets) {
  data <- read_csv(here(experiment, filename)) %>% dplyr::select("target", "Name", "signalNorm")
  data <- data[!c(is.na(data$target)),]
  
  
}

plots <- matrix(nrow = length(targets))



stopifnot(colnames(data) == c("target", "Name", "signalNorm") & nrow(data) > 1)

pTarget1 <- ggbarplot(data[grep(pattern = "p21", data$target),], 
                      x = "Name", 
                      y = "signalNorm",
                      fill = "darkslategray4",
                      position = position_dodge(0.8),
                      add = c("mean_se", "point")) +
  ggtitle("p21") +
  theme(legend.position = "none")+
  theme(axis.text.x = element_text(size = 10, angle = 45, vjust = 1, hjust=1), axis.text.y = element_text(size = 10))

pTarget2 <- ggbarplot(data[grep(pattern = "p53", data$target),], 
                      x = "Name", 
                      y = "signalNorm",
                      fill = "darkslategray",
                      position = position_dodge(0.8),
                      add = c("mean_se", "point")) +
  ggtitle("p53") +
  theme(legend.position = "none")+
  theme(axis.text.x = element_text(size = 10, angle = 45, vjust = 1, hjust=1), axis.text.y = element_text(size = 10))

pTarget3 <- ggbarplot(data[grep(pattern = "ALDH2", data$target),], 
                      x = "Name", 
                      y = "signalNorm",
                      fill = "darkslategray3",
                      position = position_dodge(0.8),
                      add = c("mean_se", "point")) +
  ggtitle("p16") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_text(size = 10, angle = 45, vjust = 1, hjust=1), axis.text.y = element_text(size = 10))


plots <- cowplot::plot_grid(pTarget1, pTarget2, pTarget3, nrow = 1)

ggsave(plots, here("LM025", "LM025-2-2_WBquant_plot.png"), device = "png", width = 18, height= 6)
