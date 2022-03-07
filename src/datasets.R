# CREATE DATASETS ----

# 0 Packages ----
library(tidymodels)
library(timetk)
library(modeltime)

f_data_complete <- function(data) {
  
  data_complete <- data %>% 
    
    group_nest(variable) %>% 
    
    mutate(
      data_split = map(data, ~ .x %>% timetk::time_series_split(
        date_var = date,
        initial = initial_periods,
        assess = test_size,
        lag = lag_max,
        cumulative = TRUE,
        slice = 1)),
      data_train = map(data_split, ~ .x %>% training()),
      data_test = map(data_split, ~ .x %>% testing()),
      data_extended = map(data, ~ .x %>% timetk::future_frame(
        .date_var = date,
        .length_out = forecast_length,
        .bind_data = TRUE)),
      data_forecast = map(data_extended, ~ .x %>% filter(is.na(value)))
    ) %>% 
    
    select(-data_split)
  
  return(data_complete)
  
}

f_data_splits <- function(data_complete) {
  
  data_splits <- data_complete %>% 
    
    transmute(
      variable = variable,
      split = map(data_train, ~ .x %>% timetk::time_series_cv(
        date_var = date,
        initial = initial_periods,
        assess = forecast_length,
        lag = lag_max,
        cumulative = TRUE,
        slice_limit = splits_number))) %>% 
    
    unnest(split) %>% 
    
    rename(split_id = id, 
           split = splits)
  
  return(data_splits)
  
}