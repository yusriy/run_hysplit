
source('R/add.met.R')
source('R/getMet.R')
source('R/procTraj.R')
source('R/read.files.R')

for(i in 2010:2011){
  procTraj(lat=36.134,lon=-5.347,year=i,
           name='gibraltar',hours=96,
           met='/Users/Yusri/Documents/Work/Data analysis/ozone_paper/TrajData/',
           out='/Users/Yusri/Documents/Work/Data analysis/ozone_paper/TrajProc/',
           hy.path='/Users/Yusri/Documents/Hysplit4_dist/')
}