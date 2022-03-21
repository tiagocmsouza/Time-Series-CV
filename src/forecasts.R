# FORECASTS ----

check_forecast <- function(df_refit) {
  
  check <- df_refit %>% 
    
    select(data_forecast) %>% 
    
    transmute(check = map(data_forecast, ~ .x %>% 
                            select(value) %>% 
                            anyNA()),
              check = as.logical(check)) %>% 
    
    use_series(check) %>% 
    
    any()
  
  return(check)
  
}


f_forecasts <- function(refit_models) {
  
  while(check_forecast(refit_models)) {
    
    refit_models <- refit_models %>% 
      
      mutate(
        pred = map2(fitted_recipe, data_extended, ~ bake(.x, .y) %>% slice_tail(n = 1)),
        pred = map(pred, ~ .x %>% filter(is.na(value)) %>% select(-value)),
        pred = map2(fitted_model, pred, ~ predict(.x, new_data = .y)),
        pred = map2(data_forecast, pred, 
                    ~ .x %>% filter(is.na(value)) %>% 
                      mutate(value = if_else(date == min(date), 
                                             .y %>% use_series(.pred),
                                             value))),
        data_forecast = map2(data_forecast, pred, ~ .x %>% rows_update(.y, by = "date")),
        data_extended = map2(data_extended, pred, ~ .x %>% rows_update(.y, by = "date"))
      ) 
  }
  
  refit_models <- refit_models %>% 
    select(variable,
           data,
           data_forecast)
  
}
