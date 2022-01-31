# DEFINE WORKFLOWS ----

# Packages
library(tidymodels)

# 1 - Linear Regression ----
workflow_lm <- workflow() %>% 
  add_model(
    linear_reg() %>% 
      set_engine("lm")
  )

# 2 - XGBoost ----
workflow_xgb <- workflow() %>% 
  add_model(
    boost_tree("regression", learn_rate = 0.25) %>% 
      set_engine("xgboost")
  )

# 3 - Random Forest ----
workflow_rf <- workflow() %>% 
  add_model(
    rand_forest() %>% 
      set_engine("ranger")
  )

# 4 - SVM
workflow_svm <- workflow() %>% 
  add_model(
    svm_rbf() %>% 
      set_engine ("kernlab")
  )