library(data.table)
library(readr)
library(conflicted)
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






dataBleo <- data %>%
  dplyr::filter(bleo == "plusbleo")
dataNobleo <- data%>% 
  dplyr::filter(bleo == "nobleo")

#### Fit Data ####
fit.bleo <- aov(SABGal_norm ~ Alda1, data = dataBleo) %>% 
  add_significance()
fit.nobleo <- aov(SABGal_norm ~ Alda1, data = dataNobleo) %>% 
  add_significance()

#### Run Tukey ###
tukey.bleo <- dataBleo %>% 
  tukey_hsd(SABGal_norm ~ Alda1) %>% 
  add_significance() %>% 
  add_xy_position()
tukey.nobleo <- dataNobleo %>% 
  tukey_hsd(SABGal_norm ~ Alda1) %>% 
  add_significance() %>% 
  add_xy_position()

tukey.bleo$y.position <- c((1.2*max(dataBleo$SABGal_norm)), (1.3*max(dataBleo$SABGal_norm)), (1.1*max(dataBleo$SABGal_norm)))
tukey.nobleo$y.position <- c((1.2*max(dataBleo$SABGal_norm)), (1.3*max(dataBleo$SABGal_norm)), (1.1*max(dataBleo$SABGal_norm)))

tukey.bleo$p.adj.signif[2] <- paste("p = ", tukey.bleo$p.adj[2], sep = "")

df.summary.bleo <- dataBleo %>%
  group_by(bleo, Alda1) %>%
  summarise(
    sd = sd(SABGal_norm, na.rm = TRUE),
    SABGal_norm = mean(SABGal_norm)
  )
df.summary.nobleo <- dataNobleo %>%
  group_by(bleo, Alda1) %>%
  summarise(
    sd = sd(SABGal_norm, na.rm = TRUE),
    SABGal_norm = mean(SABGal_norm)
  )

#### Plot ####

pBleo <- ggplot(dataBleo, aes(x = Alda1, y = SABGal_norm)) +
  geom_boxplot(data = dataBleo, aes(fill = Alda1), color = "black", outliers = FALSE, coef = 0) +
  geom_jitter(aes(color = rep)) +
  ylim(0,0.000145) +
  ylab("SA-B-Gal norm (AU)") + 
  ggtitle("+ bleomycin", subtitle = "ANOVA test") +
  theme_prism() +
  geom_errorbar(data = df.summary.bleo, aes(ymin = SABGal_norm-sd, ymax = SABGal_norm+sd),width = 0.2) +
  theme(axis.text.x = element_text(angle=45, hjust = 0.55), legend.position = "none") +
  scale_fill_manual(values = c("grey25", "grey50", "grey90")) +
  stat_pvalue_manual(tukey.bleo,
                     hide.ns = F)+
  labs(caption = get_pwc_label(tukey.bleo))

pNobleo <- ggplot(dataNobleo, aes(x = Alda1, y = SABGal_norm)) +
  geom_boxplot(data = dataNobleo, aes(fill = Alda1), color = "black", outliers = FALSE, coef = 0) +
  geom_jitter(aes(color = rep)) +
  ylim(0,0.000145) +
  ylab("SA-B-Gal norm (AU)") +
  ggtitle("- bleomycin", subtitle = "ANOVA test") +
  theme_prism() +
  geom_errorbar(data = df.summary.nobleo, aes(ymin = SABGal_norm-sd, ymax = SABGal_norm+sd),width = 0.2) +
  theme(axis.text.x = element_text(angle=45, hjust = 0.55), legend.position = "none") +
  scale_fill_manual(values = c("grey25", "grey50", "grey90")) +
  stat_pvalue_manual(tukey.nobleo,
                     hide.ns = F)+
  labs(caption = get_pwc_label(tukey.nobleo))



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

write_csv(data, file = here("LM044", "results", "LM044_summary.csv"))
write_csv(df.summary, file = here("LM044", "results", "LM044_summary_stats.csv"))

ggsave(plot = f, filename = "LM044-11_summary.png", path = here("LM044", "results"), device = "png", width = 9, height = 6)
