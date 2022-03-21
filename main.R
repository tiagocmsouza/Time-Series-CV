# MAIN FILE ----

# Packages ----
library(tidyverse)
library(tidymodels)
library(lubridate)
library(magrittr)

library(httr)
library(timetk)

# Step 0: Parameters ----
source("src/params.R")

# Step 1: Upload data ----
data <- read_csv("data/data_example.csv")

####################################
####################################
####################################
# Step 2: Define models ----
source("src/models_parsnip.R")

models_def <- f_models_parsnip()

# Step 3: Split Data - train/test & CV----
source("src/datasets.R")

data_complete <- f_data_complete(data)
data_splits <- f_data_splits(data_complete)

# Step 4: Recipes ----
source("src/recipes.R")

models_components <- f_models_components(models_def, data_splits)

# Step 5: Fit models / Data for Calibration ----
source("src/fit_calibrate.R")

models_fitted <- f_models_fitted(models_components)
data_calibr <- f_data_calibr(models_fitted)

# Step 6: Best model ----
source("src/best_model.R")

error_metrics <- f_error_metrics(data_calibr)
best_model <- f_best_model(error_metrics, chosen_metric)

# Step 7: Refit and Performance on Test data ----
source("src/refit_perform.R")

refit_models <- f_refit_models(best_model, models_def, data_complete)
data_perform <- f_data_perform(refit_models)

# Step 8: Forecasts ----
source("src/forecasts.R")

forecasts <- f_forecasts(refit_models)
