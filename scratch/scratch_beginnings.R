## scratching spaghetti

pacman::p_load("tidyverse", 
               "forecast",
               "lubridate",
               "zoo")
# read in data
swapped_df <- read_csv(here::here("data", "QuebradaCuenca1-Bisley.csv")) |> 
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
  filter(year <= 1994) |> 
  mutate(sma_k_bq1 = rollmean(k, k = 9, fill = NA))

ggplot(prm_k_df) + 
  geom_line(aes(x = sample_date, y = k), color = "blue") +
  geom_line(aes(x = sample_date, y = sma_k_prm), color = "red")

# plot 'looks' correct. try to extend to other streams, same parameter
bq2_k_df <- bq2_df |> 
  mutate(year = year(sample_date)) |> 
  mutate(week = week(sample_date)) |> 
  mutate(day = day(sample_date)) |> 
  select(sample_date, k, year, week, day)

bq2_k_df <- bq2_k_df |> 
  filter(year <= 1994) |> 
  mutate(sma_k_bq2 = rollmean(k, k = 9, fill = NA))

# bq3
bq3_k_df <- bq3_df |> 
  mutate(year = year(sample_date)) |> 
  mutate(week = week(sample_date)) |> 
  mutate(day = day(sample_date)) |> 
  select(sample_date, k, year, week, day)

bq3_k_df <- bq3_k_df |> 
  filter(year <= 1994) |> 
  mutate(sma_k_bq3 = rollmean(k, k = 9, fill = NA))

#prm
prm_k_df <- prm_df |> 
  mutate(year = year(sample_date)) |> 
  mutate(week = week(sample_date)) |> 
  mutate(day = day(sample_date)) |> 
  select(sample_date, k, year, week, day)

prm_k_df <- prm_k_df |> 
  filter(year <= 1994) |> 
  mutate(sma_k_prm = rollmean(k, k = 9, fill = NA))

# join
all_streams_k <- left_join(bq1_k_df, bq2_k_df, by = "sample_date") 
all_streams_k <- left_join(all_streams_k, bq3_k_df, by = "sample_date")
all_streams_k <- left_join(all_streams_k, prm_k_df, by = "sample_date")

ggplot(all_streams_k, aes(sample_date)) +
  geom_line(aes(y = sma_k_bq1), color = "blue") +
  geom_line(aes(y = sma_k_bq2), color = "darkgreen") +
  geom_line(aes(y = sma_k_bq3), color = "red") +
  geom_line(aes(y = sma_k_prm), color = "magenta")

# need longer df. have column for stream name.
# i want to combine my four dfs. pivot longer, and have a new col for stream name. leave parameter cols.
# what to join by? 
# also, all four dfs are different lengths

#bq1 & bq2 section
# use ends_with()!
all_streams <- full_join(bq1_df, bq2_df, by = "sample_date") |> 
  rename(k_bq1 = "k.x", no3_n_bq1 = "no3_n.x", mg_bq1 = "mg.x", ca_bq1 = "ca.x", nh4_n_bq1 = "nh4_n.x",
         k_bq2 = "k.y", no3_nbq2 = "no3_n.y", mg_bq2 = "mg.y", ca_bq2 = "ca.y", nh4_n_bq2 = "nh4_n.y") |> 
  select(sample_date, k_bq1, no3_n_bq1, mg_bq1, ca_bq1, nh4_n_bq1, 
         k_bq2, no3_nbq2, mg_bq2, ca_bq2, nh4_n_bq2)
  


all_streams <- full_join(all_streams, )
