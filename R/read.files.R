read.files <- function(hours = 96, hy.path) {
  ## Find tdump files
  files <- Sys.glob('tdump*')
  output <- file('Rcombined.txt','w')
  
  ## Read through them all, ignoring 1st 7 lines
  for (i in files) {
    input <- readLines(i)
    input <- input[-c(1:7)] # Delete header
    writeLines(input,output)
  }
  close(output)
  
  ## Read the combined txt file
  traj <- read.table(paste0(hy.path,'working/Rcombined.txt'),header=FALSE)
  traj <- subset(traj,select = -c(V2, V7, V8))
  
  traj <- rename(traj, c(V1='receptor',V3='year',V4='month',V5='day',
                         V6='hour',V9='hour.inc',V10='lat',V11='lon',
                         V12='height',V13='pressure'))
  
  ## hysplit uses 2-digit years ...
  year <- traj$year[1]
  if (year < 50) traj$year <- traj$year + 2000 else traj$year <- traj$year + 1900
  
  traj$date2 <- with(traj,ISOdatetime(year,month,day,hour,min=0,sec=0,tz='GMT'))
  ## Arrival time
  traj$date <- traj$date - 3600 * traj$hour.inc
  traj
}

