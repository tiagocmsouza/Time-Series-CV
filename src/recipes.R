# RECIPES ----

f_create_recipe <- function(data, recipe_id) {
  
  data <- tryCatch(training(data), 
                   error = function(e) data)
  
  recipe_primary <- recipe(value ~ ., data = data) %>% 
    step_mutate(month = as_factor(month(date))) %>% 
    step_dummy(month, one_hot = FALSE) %>% 
    step_rm(date)
  
  recipe_lag <- recipe(value ~ ., data = data) %>% 
    step_mutate(month = as_factor(month(date))) %>% 
    step_dummy(month, one_hot = FALSE) %>% 
    step_lag(value, lag = lag_vec) %>% 
    step_naomit(all_predictors()) %>% 
    step_rm(date)
  
  return(get(recipe_id))
  
}

f_models_components <- function(models_def, data_splits) {
  
  models_components <- models_def %>% 
    
    expand_grid(data_splits) %>% 
    
    mutate(
      recipe = map2(split, recipe_id, ~ f_create_recipe(.x, .y)),
      workflow = map2(workflow, recipe, ~ .x %>% add_recipe(.y))
    ) %>% 
    
    select(-recipe)
  
  return(models_components)
  
}