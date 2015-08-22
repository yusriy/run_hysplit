procTraj <- function(lat=51.5,lon=-0.1,year=2010,name='london',
                     met='./TrajData/',out='./TrajProc/',hours=96,height=10,
                     hy.path='/Users/Yusri/Documents/Hysplit4_dist/'){
  ## Hours is the back trajectory time e.g., 96 = 4-day back trajectory
  ## height is tart height (m)
  
  lapply(c('openair','plyr','reshape2'),require,character.only=TRUE)
  
  ## Function to run 12 months of trajectories
  ## Assumes 96 hour back trajectories, 1 receptor
  setwd(paste0(hy.path,'/working/'))
  
  ## Remove existing 'tdump' files
  path.files <- paste0(hy.path,'/working/')
  bat.file <- paste0(hy.path,'working/test.bat') ## Name of BAT file to add to/run
  files <- list.files(path=path.files,pattern='tdump')
  lapply(files,function(x) file.remove(x))
  
  start <- paste(year,'-01-01',sep='')
  end <- paste(year,'-12-31 18:00',sep='')
  dates <- seq(as.POSIXct(start,'GMT'),as.POSIXct(end,'GMT'),by='3 hour')
  
  for (i in 1:length(dates)){
    year <- format(dates[i],'%y')
    Year <- format(dates[i],'%Y') # Long format
    month <- format(dates[i],'%m')
    day <- format(dates[i],'%d')
    hour <- format(dates[i],'%H')
    
    x <- paste('echo',year,month,day,hour,'          >CONTROL')
    write.table(x,bat.file,col.names=FALSE,row.names=FALSE,quote=FALSE)
    
    x <- 'echo 1          >>CONTROL'
    write.table(x,bat.file,col.names=FALSE,row.names=FALSE,quote=FALSE,append=TRUE)
    
    x <- paste('echo',lat,lon,height, '          >>CONTROL')
    write.table(x,bat.file,col.names=FALSE,row.names = FALSE,quote=FALSE,append=TRUE)
    
    x <- paste('echo ','-',hours, '   >>CONTROL',sep='')
    write.table(x,bat.file,col.names=FALSE,row.names=FALSE,quote=FALSE,append=TRUE)
    
    x <- 'echo 0          >>CONTROL
          echo 10000.0    >>CONTROL
          echo 3          >>CONTROL'
    
    write.table(x,bat.file,col.names=FALSE,row.names=FALSE,quote=FALSE,append=TRUE)
    
    ## Processing always assumes 3 months of met for consistent tdump files
    months <- as.numeric(unique(format(dates[i],'%m')))
    months <- c(months,months + 1:2)
    months <- months -1
    months <- months[months <= 12]
    if (length(months) ==2) months <- c(min(months) - 1,months)
    
    for (i in 1:3)
      add.met(months[i],Year,met,bat.file)
    
    x <- 'echo ./          >>CONTROL'
    write.table(x,bat.file,col.names=FALSE,row.names=FALSE,quote=FALSE,append=TRUE)
    
    x <- paste('echo tdump', year, month,day,hour, '          >>CONTROL',sep='')
    write.table(x,bat.file,col.names=FALSE,row.names=FALSE,quote=FALSE,append=TRUE)
    
    x <- '\\Users\\Yusri\\Documents\\Hysplit4_dist\\exec\\hyts_std'
    write.table(x,bat.file,col.names=FALSE,row.names=FALSE,quote=FALSE,append=TRUE)
    
    ## Run the file
    system(paste0(hy.path,'working/test.bat'))
    
    
    
  }
  traj <- read.files(hours,hy.path)
  ## Write R object to file
  file.name <- paste(out,name,Year,'.RData',sep='')
  save(traj,file=file.name)
}