getMet <- function(year = 2013,month = 1, path_met = 'TrajData/') {
  for (i in seq_along(year)) {
    for (j in seq_along(month)) {
      download.file(url=paste0('ftp://arlftp.arlhq.noaa.gov/pub/archives/reanalysis/RP',
                               year[i],sprintf('%02d',month[j]),'.gbl'),
                    destfile=paste0(path_met,'RP',year[i],sprintf('%02d',month[j]),'.gbl'),
                    mode='wb')
    }
  }
}