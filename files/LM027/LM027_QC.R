library(here)
library(tidyverse)
library(readr)
library(purrr)

data <- read_csv(file = here("LM027", "LM027_data.csv"))

colnames(data) <- c("blk", "Hu513_DF1", "Hu513_DF2", "Hu513_DF5", "Hu513_DF10", "Ms_DF1", "Ms_DF2", "Ms_DF5")

data_norm <- (data %>% purrr::keep(is.numeric) - data$blk)[,2:8]

data_norm <- data_norm %>%
  rownames_to_column(var = "time")

data_norm <- pivot_longer(data_norm, 
                          cols = Hu513_DF1:Ms_DF5, 
                          names_to = "sample")
data_norm <- data_norm %>% 
  separate(col = sample,
           into = c("sample", "DF"))
data_norm$DF <- data_norm$DF %>%
  gsub(pattern = "DF", replacement = "") %>%
  as.numeric()

data_norm$OD_corrected <- data_norm$value * data_norm$DF

data_norm$DF <- data_norm$DF %>%
  as.character()

data_norm <- data_norm %>%
  unite("sample_species", sample:DF, remove = FALSE)

tmp <- as.character(c(1:122))

data_norm$time <- factor(data_norm$time, levels = tmp)

data_norm %>%
  ggplot(
    aes(
      x=time, y=value, col = sample, group = sample_species
      )
    ) +
  geom_line() +
  geom_point(size = 3) +
  theme_minimal() +
  ggtitle("LM027")

badgraph <- data_norm %>%
  ggplot(aes(x=time, y=OD_corrected, col = sample, group = sample_species)) +
  geom_line(size = 2) +
#  geom_point(size = 3) +
  theme_classic() +
  ggtitle("LM027") +
  theme(axis.text.x = element_blank())

ggsave(plot = badgraph, filename = here("LM027", "LM027_plot.png"), device = "png")

