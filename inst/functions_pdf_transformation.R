# functions for transforming the output
# look at the pdf, missing are shifted to the left which is a nightmare
colle_tout <- function(ligne){
  temp <- ligne[1:length(ligne)][ligne[1:length(ligne)] != ""]
  if(length(temp) == 6){
    temp <- temp[2:6]
  }
  toString(temp)
}
transform_tableau <- function(frame){
  as.data.frame(apply(frame, 1, colle_tout))
}

horaire <- function(ligne){
  parse_date_time(ligne[1],
                  "%d%m%Y %I:%M %p",
                  tz = "Asia/Kolkata")
}
horaire_tableau <- function(frame){
  as.data.frame(apply(frame, 1, horaire))
}
