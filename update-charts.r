source('download-process.r')
# devtools::install_github("munichrocker/DatawRappr",ref="master")

library(DatawRappr)

print("Starting chart updater")

updateDateFormat <- gsub(
  pattern = " 0",
  replacement = ' ',
  x = format(
    x = max(fl$date_formatted),
    format = "%B %d, %Y"
  )
)

chartIDs <- c(
  'IqRIM', # percent fl pop vaccinated
  '4dy79' # newly reported vaccines - first doses, series complete, boosters
  # 'Iu363', # total vaccinations fl
  # 'i2DLc' # newly reported vaccinations fl
)

apikey <- Sys.getenv("DATAWRAPPER_API")

for (id in chartIDs) {
  print(id)
  dw_edit_chart(
    chart_id = id,
    api_key = apikey,
    annotate = paste0("Updated ",updateDateFormat,'. Federal vaccination data may include residents not covered by Florida Health Department reports, such as federal and military personnel residing or stationed in the state.')
  )
  print("Publishing chart")  
  dw_publish_chart(
    chart_id = id,
    api_key = apikey,
    return_urls = TRUE
  )  
}
