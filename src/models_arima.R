# DEFINE MODELS ----

# 0 Packages ----
library(tidymodels)
library(timetk)
library(modeltime)

# 1 Parameters ----
seasonal_per <- 12

# 2 Sarima Models ----
grid_arima <- expand_grid(p = 0:4,
                          d = 0:1,
                          q = 0:4,
                          P = 0:1,
                          D = 0:1,
                          Q = 0:1)

f_models_arima <- function(p, d, q, P, D, Q, seasonal_per = seasonal_per){
  
  model <- modeltime::arima_reg(
    seasonal_period = seasonal_per,
    non_seasonal_ar = p,
    non_seasonal_differences = d,
    non_seasonal_ma = q,
    seasonal_ar = P,
    seasonal_differences = D,
    seasonal_ma = Q
  ) %>% 
    
    set_engine("arima") %>% 
    
    return(model)
  
}

models_def <- grid_arima %>% 
  
  mutate(model_arima = pmap(list(p,d,q,P,D,Q), f_models_arima))
