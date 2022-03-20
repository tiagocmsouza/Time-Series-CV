# FIND BEST MODEL ----

f_error_metrics <- function(data_calibr) {
  
  error_metrics <- data_calibr %>% 
    
    group_by(variable, model_id, recipe_id, split_id) %>% 
    
    metrics(value, .pred) %>% 
    
    group_by(variable, model_id, recipe_id, .metric) %>% 
    
    summarize(mean_error = mean(.estimate), .groups = "drop_last")
  
  return(error_metrics)
  
}


f_best_model <- function(error_metrics, chosen_metric) {
  
  best_model <- error_metrics %>% 
    
    filter(.metric == chosen_metric) %>% 
    
    group_by(variable) %>% 
    
    filter(mean_error == min(mean_error)) %>% 
    
    select(variable, model_id, recipe_id)
  
  return(best_model)
  
}



