##### ~*~*~*~*~*~*~*~*~*~*~*~*~*working toy version below
df <- data.frame()
iterations <- c(1:10)
for(i in iterations) {
  
  if(i == iterations[1]) {
    df[1,1] <- "first iteration!"
  } else {
    df <- rbind(df, paste("not the first iteration", i, sep = "_"))
  }
  
  demofinal <- df[grepl(pattern = "_4", df[,1]),]
  
}
##### ~*~*~*~*~*~*~*~*~*~*~*~*~*