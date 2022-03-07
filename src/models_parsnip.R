# DEFINE PARSNIP WORKFLOWS ----

# 0 Packages ----
library(tidymodels)

f_models_parsnip <- function() {
  
  # 1 - Linear Regression ----
  lm <- workflow() %>% 
    add_model(
      linear_reg() %>% 
        set_engine("lm")
    )
  
  # 2 - XGBoost ----
  xgb <- workflow() %>% 
    add_model(
      boost_tree("regression", learn_rate = 0.25) %>% 
        set_engine("xgboost")
    )
  
  # 3 - Random Forest ----
  rf <- workflow() %>% 
    add_model(
      rand_forest() %>% 
        set_engine("ranger")
    )
  
  # 4 - SVM ----
  svm <- workflow() %>% 
    add_model(
      svm_rbf() %>% 
        set_engine ("kernlab")
    )
  
  models_def <- tribble(
    ~model_id, ~recipe_id,
    "lm", "recipe_primary",
    "xgb", "recipe_primary",
    "rf", "recipe_primary",
    "svm", "recipe_primary",
    "lm", "recipe_lag",
    "xgb", "recipe_lag",
    "rf", "recipe_lag",
    "svm", "recipe_lag"
  ) %>% 
    
    mutate(workflow = map(model_id, ~get(.x)))
  
  return(models_def)
  
}