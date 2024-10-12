library(ggplot2)
library(dplyr)
library(tidyverse)
library(cowplot)
library(ggthemes)
library(here)

data <- readr::read_csv(file = here("LM042", "LM042-2_imaging", "LM042-2_quant.csv"), locale=locale(encoding="latin1"))
data <- data %>%
  separate(col = image, into = c("stim", "rep"), sep = "_", remove = TRUE)
data <- data %>%
  group_by(stim) %>%
  summarise("test" = mean(normSignal), "nCells" = sum(cells))

data$stim <- factor(data$stim, levels = c("veh", "bleo"))

pPlotIDK <- ggplot(data) +
  geom_col(aes(x = stim, y = test, fill = stim))  +
  theme(axis.text.x = element_text(color = "black", size = 12),
        axis.text.y = element_text(color = "black", size = 12)) +
  ggtitle("LM042-2 quant") +
  scale_fill_brewer(palette = "Accent") +
  ylab("HNE norm intensity") +
  theme_few()

ggsave(plot = pPlotIDK, filename = here("LM042", "LM042-2_normHNE_plot.png"), device = "png")
