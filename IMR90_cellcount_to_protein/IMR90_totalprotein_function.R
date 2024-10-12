# step 1: run this function
IMR90_totalprotein <- function(numberCells, vol) {
  library(here)
  linear_model <- readRDS(file = here("IMR90_cellcount_to_protein.rds"))
  data <- data.frame(numbers = numberCells)
  output <- predict(linear_model, newdata = data)*vol
  return(output)
}

# step 2: define the cell counts you want to estimate and the volume of RIPA they were lysed in
myNumbers <- c(250000, 500000)

# step 3: run the below line
IMR90_totalprotein(myNumbers, 100)

# output represents the approximate total ug protein