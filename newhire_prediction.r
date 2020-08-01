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
`output_df`<- exploratory::read_delim_file("newhire_prediction_employees.csv" , ",", quote = "\"", skip = 0 , col_names = TRUE , na = c('','NA') , locale=readr::locale(encoding = "UTF-8", decimal_mark = "."), trim_ws = TRUE , progress = FALSE) %>%
  readr::type_convert() %>%
  exploratory::clean_data_frame() %>%
    unite(date, month, year, sep = "-", remove = FALSE) %>%
    mutate(date = mdy(date)) %>%
	  group_by(date) %>%
	  summarize(count_sum = sum(count, na.rm = TRUE)) %>%
	    filter(date >= as.Date("2016-07-20")) %>%
	    #change this date each time you run with the current month
	  filter(date <= as.Date("2020-01-04")) %>%
		  mutate(count_sum_pct_diff_prev = (count_sum - lag(count_sum)) / lag(count_sum) * 100) %>%
		  do_prophet(date, count_sum, 12, time_unit = "month", fun.aggregate = sum) %>%
		    select(-trend, -trend_high, -trend_low, -yearly, -yearly_low, -yearly_high, -additive_terms, -additive_terms_lower, -additive_terms_upper, -multiplicative_terms, -multiplicative_terms_lower, -multiplicative_terms_upper, -trend_change) %>%
		    mutate(forecasted_value = round(forecasted_value, digits = 0), forecasted_value_high = round(forecasted_value_high, digits = 0), forecasted_value_low = round(forecasted_value_low, digits = 0))
			# Create local file 
			jsonlite::write_json(output_df,"/var/www/html/jdi-hc-report/api/newhire_prediction_employees.json")
			
