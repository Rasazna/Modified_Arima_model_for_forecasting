
# Load required packages.
library(janitor)
library(lubridate)
library(hms)
library(tidyr)
library(stringr)
library(readr)
library(dplyr)
library(exploratory)
library(bit64)

# Steps to produce the output
`output_df`<- exploratory::read_delim_file("termination_prediction_contractors.csv" , ",", quote = "\"", skip = 0 , col_names = TRUE , na = c('','NA') , locale=readr::locale(encoding = "UTF-8", decimal_mark = "."), trim_ws = TRUE , progress = FALSE) %>%
  readr::type_convert() %>%
  exploratory::clean_data_frame() %>%
    unite(date, month, year, sep = "-", remove = FALSE) %>%
    mutate(date = mdy(date)) %>%
	  group_by(date) %>%
	  summarize(count_sum = sum(count, na.rm = TRUE)) %>%
	    filter(date >= as.Date("2017-01-20")) %>%
	  #change month to current month
	    filter(date <= as.Date("2019-11-04")) %>%
		  mutate(count_sum_pct_diff_prev = (count_sum - lag(count_sum)) / lag(count_sum) * 100) %>%
		#read prophet documentation for more information
		  do_prophet(date, count_sum, 12, time_unit = "month", fun.aggregate = sum) %>%
		    select(-(trend:trend_change)) %>%
		    mutate(forecasted_value_low = round(forecasted_value_low, digits = 0), forecasted_value_high = round(forecasted_value_high, digits = 0), forecasted_value = round(forecasted_value, digits = 0), forecasted_value_low = case_when(
																																																											   forecasted_value_low > 0 ~ forecasted_value_low,
																																																											    forecasted_value_low < 0 ~ 0,
																																																												 TRUE ~ 0), forecasted_value = as.integer(forecasted_value))
			# Create local file 
			jsonlite::write_json(output_df,"/var/www/html/jdi-hc-report/api/termination_prediction.json")
