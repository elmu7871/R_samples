library(ggplot2)
library(dplyr)
library(tidyverse)
library(cowplot)
library(ggthemes)
library(here)
library(ggprism)
library(patchwork)
library(magrittr)

IMR90 <- data.frame(
  value = c(22556.06519, 8903.530656, 60886.79638, 19468.9845, 9067.473639, 224308.0672),
  stim = c("Buffer", "Buffer", "Buffer", "TGF-β", "TGF-β", "TGF-β"),
  type = c("HNE", "mito", "actin", "HNE", "mito", "actin")
)

pIMR90 <- ggplot(IMR90) +
  geom_col(aes(x = stim, y = value, fill = type), position = "dodge")  +
  ggtitle("IMR90 +/- TGFb") +
  theme_few()

A549 <- data.frame(
  value = c(5411.66482,
            24505.50628,
            21655.0061,
            29669.01166,
            26706.21635,
            96538.3833),
  stim = c("Buffer", "Buffer", "Buffer", "TGF-β", "TGF-β", "TGF-β"),
  type = c("HNE", "mito", "actin", "HNE", "mito", "actin")
)

A549_norm <- data.frame(
  value = c(0.220834647,
            1,
            0.883679197,
            1.110940287,
            1,
            3.614828174
  ),
  stim = c("Buffer", "Buffer", "Buffer", "TGF-β", "TGF-β", "TGF-β"),
  type = c("HNE", "mito", "actin", "HNE", "mito", "actin")
)

pA549 <- ggplot(A549) +
  geom_col(aes(x = stim, y = value, fill = type), position = "dodge") +
  ggtitle("A549 +/- TGFb") +
  theme_few()

pA549_norm <- ggplot(A549_norm %>% dplyr::filter(type == "HNE")) +
  geom_col(aes(x = stim, y = value, fill = stim), position = "dodge") +
  theme(axis.text.x = element_text(color = "black", size = 12),
        axis.text.y = element_text(color = "black", size = 12)) +
  ggtitle("A549 +/- TGFb") +
  scale_fill_brewer(palette = "Accent") +
  ylab("HNE norm intensity") +
  theme_few()
pA549_norm

plots <- c(pIMR90, pA549)

bothplots <- cowplot::plot_grid(pIMR90, pA549, nrow = 1)

# ggsave(plot = pA549_norm, filename = here("LM042", "pA549_norm_plot"), device = "png")

# ggsave(plot = bothplots, filename = here("LM042", "normHNE_plot.png"), width = 8, device = "png")


pA549_norm_ggprism <- ggplot(A549_norm %>% dplyr::filter(type == "HNE")) +
  geom_col(aes(x = stim, y = value, fill = stim), color = "black", position = "dodge") +
  theme_prism() +
  scale_fill_manual(values = c("gray30", "gray75")) +
  ylab("norm HNE signal intensity")

pA549_norm_ggprism
 ggsave(plot = pA549_norm_ggprism, filename = here("LM042", "pA549_norm_ggprism_tiny.png"), device = "png", width = 3.5, height = 3)
