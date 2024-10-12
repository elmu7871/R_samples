library(ggplot2)
library(dplyr)
library(tidyverse)
library(cowplot)
library(ggthemes)
library(here)
library(ggprism)
library(patchwork)
library(magrittr)

quant <- read_csv(file = here("LM046", "LM046-2_norm_plotting.csv"))

quant_summary <- quant %>% 
  group_by(stim, type) %>%
  summarise(test = mean(value))

quant_summary$stim <- factor(quant_summary$stim, c("veh", "LPA", "TGFB", "FC"))


pQuant <- ggplot(quant_summary %>% dplyr::filter(type == "HNE")) +
  geom_col(aes(x = stim, y = test, fill = stim), color = "black", position = "dodge") +
  ggtitle("SAEC +/- stim") +
  theme_few()

pQuant

pA549_norm_ggprism <- ggplot(quant_summary %>% dplyr::filter(type == "HNE")) +
  geom_col(aes(x = stim, y = test, fill = stim), color = "black", position = "dodge") +
  theme_prism() +
  scale_fill_manual(values = c("gray15", "gray30", "gray75", "gray85")) +
  ylab("norm HNE signal intensity") + 
  ggtitle("LM046-2 HNE norm")

pA549_norm_ggprism
# ggsave(plot = pA549_norm_ggprism, filename = here("LM046", "LM046-2_HNEplot.png"), device = "png", width = 4.5, height = 4)
