
# source functions
source(here::here("R", "moving_avg_function.R"))
source(here::here("R", "zapply.R"))
# load the 4 raw csvs
bq1_df <- read_csv(here::here("data", "QuebradaCuenca1-Bisley.csv"))
bq2_df <- read_csv(here::here("data", "QuebradaCuenca2-Bisley.csv"))
bq3_df <- read_csv(here::here("data", "QuebradaCuenca3-Bisley.csv"))
prm_df <- read_csv(here::here("data", "RioMameyesPuenteRoto.csv"))

# combine four dfs with bind_rows() + narrow down rows and cols
streams_all <- bind_rows(bq1_df, bq2_df, bq3_df, prm_df) |> 
  janitor::clean_names() |> 
  filter(sample_date <= "1994-01-01" & sample_date >= "1988-01-01") |> 
  select(sample_date, sample_id, k, no3_n, mg, ca, nh4_n) 

# use filter() and isolate each stream
streams_bq1 <- streams_all |> 
  filter(sample_id == "Q1")

streams_bq2 <- streams_all |> 
  filter(sample_id == "Q2")

streams_bq3 <- streams_all |> 
  filter(sample_id == "Q3")

streams_prm <- streams_all |> 
  filter(sample_id == "MPR")

# apply zapply to each stream
streams_bq1_rolled <- zapply(streams_bq1, 3, 7, moving_average)
streams_bq2_rolled <- zapply(streams_bq2, 3, 7, moving_average)
streams_bq3_rolled <- zapply(streams_bq3, 3, 7, moving_average)
streams_prm_rolled <- zapply(streams_prm, 3, 7, moving_average)

# recombine into 1 dataframe
streams_rolled <- bind_rows(streams_bq1_rolled, 
                            streams_bq2_rolled, 
                            streams_bq3_rolled, 
                            streams_prm_rolled)

# save streams_long into csv
write_csv(x = streams_rolled,
          file = "data/streams_clean.csv")

