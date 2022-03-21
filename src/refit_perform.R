# REFIT MODEL AND PERFORMANCE ON TEST DATA ----

f_refit_models <- function(best_model, models_def, data_complete) {
  
  refit_models <- best_model %>% 
    
    left_join(data_complete, by = "variable") %>% 
    
    left_join(models_def, by = c("model_id", "recipe_id")) %>% 
    
    mutate(
      recipe = map2(data_train, recipe_id, ~ f_create_recipe(.x, .y)),
      workflow = map2(workflow, recipe, ~ .x %>% add_recipe(.y)),
      fit = map2(workflow, data_train, ~ fit(.x, data = .y)),
      fitted_recipe = map(fit, ~ extract_recipe(.x)),
      fitted_model = map(fit, ~ extract_fit_parsnip(.x))
    ) %>% 
    
    ungroup()
  
  return(refit_models)
  
}


f_data_perform <- function(refit_models) {
  
  data_perform <- refit_models %>% 
    
    select(variable,
           data_test,
           fitted_recipe,
           fitted_model) %>% 
    
    mutate(
      data_test = map2(fitted_recipe, data_test, ~ bake(.x, .y)),
      pred = map2(fitted_model, data_test, ~ predict(.x, new_data = .y %>% select(-value))),
      across(c(data_test, pred), ~ map(.x, function(x) slice_tail(x, n = forecast_length))),
      data_test = map2(data_test, pred, ~ .x %>% select(value) %>%  bind_cols(.y))
    ) %>% 
    
    select(
      variable,
      data_test
    ) %>% 
    
    unnest(data_test)
  
  return(data_perform)
  
}

