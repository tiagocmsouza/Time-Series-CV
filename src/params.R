# PARAMETERS ----

# Number of periods to forecast
forecast_length <- 20 
# Number of periods in test sample
test_size <- 24
# Initial number of periods included in a split
initial_periods <- 36
# Lags
lag_vec <- c(1,12)
lag_max <- max(lag_vec)
# Number of splits in output
splits_number <- 10