# FIT MODELS TO SPLITS / DATA FOR CALIBRATION ----

f_models_fitted <- function(models_components) {
  
  models_fitted <- models_components %>% 
    
    mutate(fit = map2(workflow, split, ~ fit(.x, data = training(.y)))) %>% 
    
    select(-workflow)
  
  return(models_fitted)
  
}


f_data_calibr <- function(models_fitted) {
  
  data_calibr <- models_fitted %>% 
    
    mutate(
      fitted_recipe = map(fit, ~ extract_recipe(.x)),
      fitted_model = map(fit, ~ extract_fit_parsnip(.x)),
      data = map(split, ~ testing(.x)),
      data_test = map2(fitted_recipe, data, ~ bake(.x, .y)),
      pred = map2(fitted_model, data_test, ~ predict(.x, new_data = .y %>% select(-value))),
      across(c(data, pred), ~ map(.x, function(x) slice_tail(x, n = forecast_length))),
      data = map2(data, pred, ~ .x %>% bind_cols(.y))
    ) %>% 
    
    select(variable,
           model_id,
           recipe_id,
           split_id,
           data) %>% 
    
    unnest(data)
  
  return(data_calibr)
  
}
