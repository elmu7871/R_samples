library(tidyverse)
library(here)

data <- readxl::read_xlsx(here("detritus", "hirsch_data_supplement_file_e1.xlsx"))

data <- data[c(5:nrow(data)),]

colnames(data) <- data[1,]

data <- data[c(2:nrow(data)),]

fourday_young_SftpcAi9 <- data[,c(1:4)]

sevenday_young_SftpcAi9 <- data[,c(7:10)]

fourday_young_SftpcAi9Trf1 <- data[,c(13:16)]

fourday_old_SftpcAi9 <- data[,c(19:22)]

control_SftpcAi9Trf1 <- data[,c(25:28)]

control_old_SftpcAi9 <- data[,c(31:34)]