# https://data.cdc.gov/Vaccinations/COVID-19-Vaccinations-in-the-United-States-Jurisdi/unsk-b7fc
# as of july 8, using this: https://data.cdc.gov/Vaccinations/COVID-19-Vaccination-Trends-in-the-United-States-N/rh2h-3yt2

library(dplyr)

# func.SubtractFromPrev <- function(x){return(x - lag(x))}
# func.mvavg <- function(x,n){stats::filter(x,rep(1/n,n), sides=1)}

resourceID <- 'rh2h-3yt2'
source('download-cdc-api-data/download.r')

rb$date_formatted <- as.Date(rb$date)

rb[rb == 0] <- NA
rb[rb == ''] <- NA

fl <- filter(
  .data = rb,
  location == 'FL'
)

fl <- fl[order(date_formatted),]

# flslim <- fl #%>% filter(date_formatted >= '2021-02-13')

# flslim$administered <- as.numeric(flslim$administered)
# flslim$new_vaccines_administered <- func.SubtractFromPrev(flslim$administered)
# flslim$new_vaccines_administered_7day_avg <- func.mvavg(
#   x = flslim$new_vaccines_administered,
#   n = 7
# )
# 
# flslim$administered_dose1_recip <- as.numeric(flslim$administered_dose1_recip)
# flslim$new_administered_dose1_recip <- func.SubtractFromPrev(flslim$administered_dose1_recip)
# flslim$new_administered_dose1_recip_7day_avg <- func.mvavg(
#   x = flslim$new_administered_dose1_recip,
#   n = 7
# )
# 
# flslim$series_complete_yes <- as.numeric(flslim$series_complete_yes)
# flslim$new_series_complete <- func.SubtractFromPrev(flslim$series_complete_yes)
# flslim$new_series_complete_7day_avg <- func.mvavg(
#   x = flslim$new_series_complete,
#   n = 7
# )
# 
# flslim$additional_doses <- as.numeric(flslim$additional_doses)
# flslim$new_additional_doses <- func.SubtractFromPrev(flslim$additional_doses)
# flslim$new_additional_doses_7day_avg <- func.mvavg(
#   x = flslim$new_additional_doses,
#   n = 7
# )

flpop <- 21781128 # https://www.census.gov/quickfacts/FL

# flslim <- flslim[,c(
#   'date',
#   'date_formatted',
#   'administered',
#   'administered_dose1_recip',
#   # 'administered_dose1_pop_pct',
#   'administered_dose1_recip_1',
#   'administered_dose1_recip_2',
#   'administered_dose1_recip_3',
#   'administered_dose1_recip_4',
#   'administered_dose1_recip_5',
#   'administered_dose1_recip_6',
#   'series_complete_yes',
#   # 'series_complete_pop_pct',
#   # 'series_complete_12plus',
#   # 'series_complete_12pluspop',
#   # 'series_complete_18plus',
#   # 'series_complete_18pluspop',
#   # 'series_complete_65plus',
#   # 'series_complete_65pluspop',
#   'new_vaccines_administered',
#   'new_vaccines_administered_7day_avg',
#   'new_administered_dose1_recip',
#   'new_administered_dose1_recip_7day_avg',
#   'new_series_complete',
#   'new_series_complete_7day_avg',
#   'additional_doses',
#   # 'additional_doses_vax_pct',
#   'new_additional_doses',
#   'new_additional_doses_7day_avg'
# )]

fl$flpop <- flpop
# flslim$pct_pop_dose1 <- flslim$administered_dose1_recip / flslim$flpop * 100
# flslim$pct_series_complete <- flslim$series_complete_yes / flslim$flpop * 100
# flslim$pct_additional_doses <- flslim$additional_doses / flslim$flpop * 100

fl$booster_pct <- as.numeric(fl$booster_cumulative) / fl$flpop * 100

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

flslim <- group_by(
  .data = fl,
  date_formatted
) %>%
  mutate(
    administered_dose1_pop_pct_max = max(administered_dose1_pop_pct)
  ) %>%
  ungroup() %>%
  filter(administered_dose1_pop_pct == administered_dose1_pop_pct_max)

write.csv(
  x = flslim,
  file = paste0(o,'/fl-slim-vaccines-by-date.csv'),
  na = '',
  row.names = F
)
