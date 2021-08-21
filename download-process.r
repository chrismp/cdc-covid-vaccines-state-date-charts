# https://data.cdc.gov/Vaccinations/COVID-19-Vaccinations-in-the-United-States-Jurisdi/unsk-b7fc

library(dplyr)

func.SubtractFromPrev <- function(x){return(x - lag(x))}

resourceID <- 'unsk-b7fc'
source('download-cdc-api-data/download.r')

rb$date_formatted <- as.Date(rb$date)

fl <- filter(
  .data = rb,
  location == 'FL'
)

fl <- fl[order(date_formatted),]
fl$administered <- as.numeric(fl$administered)
fl$new_vaccines_administered <- func.SubtractFromPrev(fl$administered)

# fl$new_case_7day_avg <- mvavg(
#   x = fl$new_case,
#   n = 7
# )
# 
# fl$new_deaths_7day_avg <- mvavg(
#   x = fl$new_death,
#   n = 7
# )

flslim <- fl[,c(
  'date',
  'date_formatted',
  'administered',
  'administered_dose1_recip',
  'administered_dose1_pop_pct',
  'administered_dose1_recip_1',
  'administered_dose1_recip_2',
  'administered_dose1_recip_3',
  'administered_dose1_recip_4',
  'administered_dose1_recip_5',
  'administered_dose1_recip_6',
  'series_complete_yes',
  'series_complete_pop_pct',
  'series_complete_12plus',
  'series_complete_12pluspop',
  'series_complete_18plus',
  'series_complete_18pluspop',
  'series_complete_65plus',
  'series_complete_65pluspop',
  'new_vaccines_administered'
)]


o <- 'output'
dir.create(o)

write.csv(
  x = rb,
  file = paste0(o,'/vaccines-by-state-and-date.csv'),
  na = '',
  row.names = F
)

write.csv(
  x = fl,
  file = paste0(o,'/fl-vaccines-by-date.csv'),
  na = '',
  row.names = F
)

write.csv(
  x = flslim,
  file = paste0(o,'/fl-slim-vaccines-by-date.csv'),
  na = '',
  row.names = F
)