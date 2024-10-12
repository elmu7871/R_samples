library(tidyverse)
library(conflicted)
library(here)

data <- read_csv(here("LM041", "cellcount_concs.csv"))
data$Sample <- data$Sample %>% 
  factor(levels = c( "c10k",  "c25k",  "c50k" , "c75k" , "c100k", "c200k", "c300k", "c400k", "c500k" ,"c600k" ,"c700k", "c800k", "c900k", "c1M", "c2M"))
data$numbers <- c(10000,25000,50000,75000,100000,200000,300000,400000,500000,600000,700000,800000,900000,1000000,2000000) # probably should have done this in the csv but whatever

# QC. expect a direct linear relationship. and it looks nicely linear!
ggplot(data) +
  geom_point(aes(x = numbers, y = Concentration))

# fit model
linear_model <- lm(Concentration ~ numbers, data)

plot(data$numbers, data$Concentration)
abline(linear_model)
summary(linear_model)

saveRDS(linear_model, file = here("IMR90_cellcount_to_protein.rds"))

# make quick function for later use
myNumbers <- c(274976, 982638, 610884)

IMR90_totalprotein <- function(numberCells, vol) {
  library(here)
  linear_model <- readRDS(file = here("IMR90_cellcount_to_protein.rds"))
  data <- data.frame(numbers = numberCells)
  output <- predict(linear_model, newdata = data)*vol
  return(output)
}

IMR90_totalprotein(myNumbers, 100)