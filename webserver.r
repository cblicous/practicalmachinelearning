# first steps building a tiny rook based json service
# with code i googled together
# need to install rook 

library(Rook)
library(jsonlite)

rook <- Rhttpd$new()
rook$start(quiet=TRUE)
# print which port we are on
rook$print()


rook = Rhttpd$new()
rook$add(
  name ="summarize",
  app  = function(env) {
    req = Rook::Request$new(env)
  
    numbers =  c(3,4,2)
    
    results = list()
    results$mean = mean(numbers)
    results$sd = sd(numbers)
    results$numbers = numbers

    res = Rook::Response$new()
    res$write(toJSON(results))
    res$finish()
  }
)

rook$browse("summarize")
