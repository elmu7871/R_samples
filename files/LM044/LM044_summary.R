library(data.table)
library(readr)
library(conflicted)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(ggprism)
library(here)

paths <- list.files(path = here("LM044", "LM044-11_data"), full.names = T, recursive = F)

data_pre <- list()

for(i in 1:length(paths)) {
  data_pre[[i]] <- read_csv(paths[i])
  data_pre[[i]]$rep <- paste("rep", i, sep = "")
}

data <- rbindlist(data_pre) %>% as.data.frame()

data$bleo <- data$bleo %>% 
  factor(levels = c("nobleo", "plusbleo"))
data$Alda1 <- data$Alda1 %>% 
  factor(levels = c("Alda0uM", "Alda5uM", "Alda40uM"))

df.summary <- data %>%
  group_by(bleo, Alda1) %>%
  summarise(
    sd = sd(SABGal_norm, na.rm = TRUE),
    SABGal_norm = mean(SABGal_norm)
  )

plot <- ggplot(data, aes(x = Alda1, y = SABGal_norm)) +
  geom_col(data = df.summary, aes(fill = Alda1), color = "black") +
  geom_jitter(aes(color = rep)) +
  ylab("SA-B-Gal norm (AU)") + 
  ggtitle("LM044-11 summary") +
  theme_prism() +
  geom_errorbar(data = df.summary, aes(ymin = SABGal_norm-sd, ymax = SABGal_norm+sd),width = 0.2) +
  facet_grid(~bleo)+
  theme(axis.text.x = element_text(angle=45, hjust = 0.55), legend.position = "none") +
  scale_fill_manual(values = c("grey25", "grey50", "grey90"))

write_csv(data, file = here("LM044", "results", ))

ggsave(plot = plot, filename = "LM044-11_summary.png", path = here("LM044", "results"), device = "png")
