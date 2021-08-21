source('download-process.r')
# devtools::install_github("munichrocker/DatawRappr",ref="master")

library(DatawRappr)

print("Starting chart updater")

updateDateFormat <- gsub(
  pattern = " 0",
  replacement = ' ',
  x = format(
    x = max(flslim$date_formatted),
    format = "%B %d, %Y"
  )
)

chartIDs <- c(
  'cN1Zb', # percent fl pop vaccinated
  'Iu363', # total vaccinations fl
  'i2DLc' # newly reported vaccinations fl
)

apikey <- Sys.getenv("DATAWRAPPER_API")

for (id in chartIDs) {
  print(id)
  dw_edit_chart(
    chart_id = id,
    api_key = apikey,
    annotate = paste0("Updated ",updateDateFormat,'.')
  )
  print("Publishing chart")  
  dw_publish_chart(
    chart_id = id,
    api_key = apikey,
    return_urls = TRUE
  )  
}