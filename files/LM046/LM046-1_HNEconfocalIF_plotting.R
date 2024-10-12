library(ggplot2)
library(dplyr)
library(tidyverse)
library(cowplot)
library(ggprism)
library(here)

data <- readr::read_csv(file = here("LM046", "LM046-1_imaging", "LM046-1_quant.csv"), locale=locale(encoding="latin1"))
data <- data %>%
  separate(col = image, into = c("stim", "rep"), sep = "_", remove = TRUE)
data <- data %>%
  group_by(stim) %>%
  summarise("test" = mean(normSignal), "nCells" = sum(cells))

data$stim <- factor(data$stim, levels = c("LPA", "TGFb", "FC"))

pPlotIDK <- ggplot(data) +
  geom_col(aes(x = stim, y = test, fill = stim), color = "black")  +
  ggtitle("LM046-1 quant") +
  scale_fill_manual(values = c("grey30", "grey50", "grey75")) +
  ylab("HNE norm intensity") +
  theme_prism()

ggsave(plot = pPlotIDK, filename = here("LM046", "LM046-1_normHNE_plot.png"), device = "png")
