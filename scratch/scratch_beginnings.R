## scratching spaghetti

pacman::p_load("tidyverse", 
               "forecast",
               "lubridate",
               "zoo")
# read in data
bq1_df <- read_csv(here::here("data", "QuebradaCuenca1-Bisley.csv")) |> 
  janitor::clean_names()
bq2_df <- read_csv(here::here("data", "QuebradaCuenca2-Bisley.csv")) |> 
  janitor::clean_names()
bq3_df <- read_csv(here::here("data", "QuebradaCuenca3-Bisley.csv")) |> 
  janitor::clean_names()
prm_df <- read_csv(here::here("data", "RioMameyesPuenteRoto.csv")) |> 
  janitor::clean_names()

# slice because im overwhelmed
bq1_df_sliced <- bq1_df |> 
  slice_head(n = 30)

# try out SMA for K col
sma_result <- TTR::SMA(bq1_df_sliced$k, n = 3)
sma_result

# raw data timeseries
K_original_ts <- ggplot(bq1_df_sliced, aes(sample_date, k)) +
  geom_point() +
  geom_line()
K_original_ts
# create df for sma 
sma_df <- data.frame(Time = seq(1:length(sma_result)), 
                     sma_result)
K_sma_ts <- ggplot(sma_df, aes(Time, sma_result)) + 
  geom_point() +
  geom_line()
K_sma_ts

# join 
test_df <- cross_join(bq1_df_sliced, sma_df)
test_df <- test_df |>
  select(sample_date, k, Time, sma_result) |> 
  slice_head(n = 30)
# plot combined
ggplot(test_df) +
  geom_line(aes(x = sample_date, y = k)) +
  geom_point(aes(x = Time, y = sma_result))

# new train
rm(list = ls())

# use lubridate to extract the week # out of the year
bq1_k_df <- bq1_df |> 
  mutate(year = year(sample_date)) |> 
  mutate(week = week(sample_date)) |> 
  mutate(day = day(sample_date)) |> 
  select(sample_date, k, year, week, day)

# sma im going to cry
bq1_k_df <- bq1_k_df |> 
  mutate(sma_k = rollmean(k, k = 9, fill = NA))

ggplot(bq1_k_df) + 
  geom_line(aes(x = sample_date, y = k), color = "blue") +
  geom_line(aes(x = sample_date, y = sma_k), color = "red")
