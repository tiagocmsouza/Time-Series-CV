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