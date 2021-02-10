############Grab CA zip Age race sex ##############
rm(list = ls())
library(data.table)
library(ggplot2)
library(tidycensus)

variables <- load_variables(2019, "acs5", cache=T)
var_list <- NULL

for (i in c("B", "C", "D", "E", "F", "G", "H", "I")) {
  for (j in c("03", "04", "05", "06", "07", "08", "09", 10:16, 18:31)) {
    var_list <- c(var_list, paste0("B01001", i, "_0", j))
  }
}

fips_codes <- as.data.table(tidycensus::fips_codes)
fips_codes <- fips_codes[state_code<=56]
fips_codes <- unique(fips_codes$state)

temp <- as.data.table(get_acs(geography = "zcta", variables = var_list, year = 2019))

temp <- temp[, geoid := substr(NAME, 7, 11)]


key <- fread("//mnt/projects/connect-izb/resources/general/census_tract_age_labels.csv")

merge(temp[geoid %in% unique(as.character(hpi$geoid))], key) %>% fwrite("//mnt/projects/connect-izb/resources/general/zip_code_age_race.csv")
