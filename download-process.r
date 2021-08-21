library(dplyr)

resourceID <- 'unsk-b7fc'
source('download-cdc-api-data/download.r')

rb$date_formatted <- as.Date(rb$date)

fl <- filter(
  .data = rb,
  location == 'FL'
)

o <- 'output'
dir.create(o)

write.csv(
  x = rb,
  file = paste0(o,'/vaccines-by-state-an-date.csv'),
  na = '',
  row.names = F
)

write.csv(
  x = fl,
  file = paste0(o,'/fl-vaccines-by-date.csv'),
  na = '',
  row.names = F
)
