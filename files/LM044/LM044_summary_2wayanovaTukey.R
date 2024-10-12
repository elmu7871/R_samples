library(data.table)
library(readr)
library(conflicted)
conflicted::conflicts_prefer(ggplot2::annotate)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(ggprism)
library(here)
library(ggpubr)
library(rstatix)

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


mod <- aov(SABGal_norm ~ Alda1 * bleo, data = data) %>% 
  tukey_hsd() %>%
  add_xy_position()
  
mod$y.position <- c(0.00014,0.00014,0.00014,0.00014,0.00014,0.00014,0.00014,0.00014,0.00014,0.00014,0.00014,0.00014,0.00014,0.00014,0.00014,0.00014,0.00014,0.00014,0.00014)

mod_plusbleo <- mod[c(grepl(pattern = "plusbleo", mod$group1)),]
mod_plusbleo <- mod_plusbleo %>% 
  separate(col = group1, into = c("group1", "banana1")) %>%
  separate(col = group2, into = c("group2", "banana2")) %>%
  dplyr::select(!banana1) %>%
  dplyr::select(!banana2)
mod_plusbleo$y.position <- c(0.000135,0.000145,0.000125)
  
mod_nobleo <- mod[c(grepl(pattern = , "nobleo", mod$group2)),]
mod_nobleo <- mod_nobleo %>% 
  separate(col = group1, into = c("group1", "banana1")) %>%
  separate(col = group2, into = c("group2", "banana2")) %>%
  dplyr::select(!banana1) %>%
  dplyr::select(!banana2)
mod_nobleo$y.position <- c(0.000135,0.000145,0.000125)


#### Plot ####

pBleo <- ggplot((data %>% dplyr::filter(bleo == "plusbleo")), aes(x = Alda1, y = SABGal_norm)) +
  geom_boxplot(data = data %>% dplyr::filter(bleo == "plusbleo"), aes(fill = Alda1), color = "black", outliers = FALSE, coef = 0) +
  geom_jitter(aes(color = rep)) +
  ylim(0,0.000145) +
  ylab("SA-B-Gal norm (AU)") + 
  theme_prism() +
  ggtitle("plus bleo") +
  stat_pvalue_manual(mod_plusbleo,
                     hide.ns = F)+
  geom_errorbar(data = df.summary.bleo, aes(ymin = SABGal_norm-sd, ymax = SABGal_norm+sd),width = 0.2) +
  theme(axis.text.x = element_text(angle=45, hjust = 0.55), legend.position = "none") +
  scale_fill_manual(values = c("grey25", "grey50", "grey90")) +
  labs(caption = get_pwc_label(mod))

pNobleo <- ggplot((data %>% dplyr::filter(bleo == "nobleo")), aes(x = Alda1, y = SABGal_norm)) +
  geom_boxplot(data = data %>% dplyr::filter(bleo == "nobleo"), aes(fill = Alda1), color = "black", outliers = FALSE, coef = 0) +
  geom_jitter(aes(color = rep)) +
  ylim(0,0.000145) +
  ylab("SA-B-Gal norm (AU)") + 
  theme_prism() +
  ggtitle("no bleo") +
  stat_pvalue_manual(mod_nobleo,
                     hide.ns = F)+
  geom_errorbar(data = df.summary.nobleo, aes(ymin = SABGal_norm-sd, ymax = SABGal_norm+sd),width = 0.2) +
  theme(axis.text.x = element_text(angle=45, hjust = 0.55), legend.position = "none") +
  scale_fill_manual(values = c("grey25", "grey50", "grey90")) +
  labs(caption = get_pwc_label(mod))

title <- ggdraw() + 
  draw_label(
    "LM044-11 summary",
    fontface = 'bold',
    x = 0,
    hjust = 0
  ) +
  theme(
    # add margin on the left of the drawing canvas,
    # so title is aligned with left edge of first plot
    plot.margin = margin(0, 0, 0, 7)
  )

gridded <- plot_grid(pNobleo, pBleo, nrow = 1)

f <- cowplot::plot_grid(
  title, gridded,
  ncol = 1,
  # rel_heights values control vertical title margins
  rel_heights = c(0.1, 1)
)

f

write_csv(data, file = here("LM044", "results", "LM044_summary.csv"))
write_csv(df.summary, file = here("LM044", "results", "LM044_summary_stats.csv"))
write_csv(mod, file = here("LM044", "results", "2wayANOVA_model.csv"))

ggsave(plot = f, filename = "LM044-11_summary_2wayANOVA.png", path = here("LM044", "results"), device = "png", width = 9, height = 6)
