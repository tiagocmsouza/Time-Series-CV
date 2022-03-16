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

# Step 5: Recipes ----
source("src/recipes.R")

models_components <- f_models_components(models_def, data_splits)
