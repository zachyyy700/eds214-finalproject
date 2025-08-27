##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                                                            ~~
##                            SCRATCHING SPAGHETTI                          ----
##                                                                            ~~
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Purpose: The R script serves as spaghetti for the EDS214 Final Project. As spaghetti, this script will be the birth place for any final documents that will be created in docs folder after tinkering with code is finished here.
## Author: Zachary Loo
## Email: zachyyy700@gmail.com

pacman::p_load("tidyverse", 
               "forecast",
               "lubridate",
               "zoo",
               "patchwork",
               "slider",
               "ggthemes")
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
# i want to combine my four dfs. leave parameter cols.
# join by date
# also, all four dfs are different lengths ?

#bq1 & bq2 section
# use ends_with()!
all_streams <- full_join(swapped_df, bq2_df, by = "sample_date") |> 
  rename(k_bq1 = "k.x", no3_n_bq1 = "no3_n.x", mg_bq1 = "mg.x", ca_bq1 = "ca.x", nh4_n_bq1 = "nh4_n.x",
         k_bq2 = "k.y", no3_nbq2 = "no3_n.y", mg_bq2 = "mg.y", ca_bq2 = "ca.y", nh4_n_bq2 = "nh4_n.y") 
  
# join in bq3
all_streams <- full_join(all_streams, bq3_df, by = "sample_date")

all_streams <- rename(all_streams, no3_n_bq3 = "no3_n", mg_bq3 = "mg", ca_bq3 = "ca", na4_n_bq3 = "nh4_n") 

all_streams <- all_streams |> 
  select(sample_date, ends_with(c("bq1", "bq2", "bq3")))

# naming is a pain,
# trying bind_rows()
binded <- bind_rows(bq1_df, bq2_df)
binded <- bind_rows(binded, bq3_df)  
binded <- bind_rows(binded, prm_df)

# this looks good, but how to mutate() the sma into it?
binded3 <- binded3 |> 
  filter(sample_date <= "1994-01-01") |> 
  select(sample_date, sample_id, k, no3_n, mg, ca, nh4_n) |> 
  mutate(sma_k = case_when(sample_id == "Q1" ~ rollmean(k, k = 9, fill = NA),
                           sample_id == "Q2" ~ rollmean(k, k = 9, fill = NA),
                           sample_id == "Q3" ~ rollmean(k, k = 9, fill = NA),
                           sample_id == "MPR" ~ rollmean(k, k = 9, fill = NA)))

p1 <- ggplot(binded3, aes(x = sample_date, y = sma_k, color = sample_id)) +
  geom_line()

# sma_no3_n
binded3 <- binded3 |> 
  mutate(sma_no3_n = case_when(sample_id == "Q1" ~ rollmean(no3_n, k = 9, fill = NA),
                               sample_id == "Q2" ~ rollmean(no3_n, k = 9, fill = NA),
                               sample_id == "Q3" ~ rollmean(no3_n, k = 9, fill = NA),
                               sample_id == "MPR" ~ rollmean(no3_n, k = 9, fill = NA)))

p2 <- ggplot(binded3, aes(x = sample_date, y = sma_no3_n, color = sample_id)) +
  geom_line()

# mg
binded3 <- binded3 |> 
  mutate(sma_mg = case_when(sample_id == "Q1" ~ rollmean(mg, k = 9, fill = NA),
                               sample_id == "Q2" ~ rollmean(mg, k = 9, fill = NA),
                               sample_id == "Q3" ~ rollmean(mg, k = 9, fill = NA),
                               sample_id == "MPR" ~ rollmean(mg, k = 9, fill = NA)))

p3 <- ggplot(binded3, aes(x = sample_date, y = sma_mg, color = sample_id)) +
  geom_line()

# ca 
binded3 <- binded3 |> 
  mutate(sma_ca = case_when(sample_id == "Q1" ~ rollmean(ca, k = 9, fill = NA),
                            sample_id == "Q2" ~ rollmean(ca, k = 9, fill = NA),
                            sample_id == "Q3" ~ rollmean(ca, k = 9, fill = NA),
                            sample_id == "MPR" ~ rollmean(ca, k = 9, fill = NA)))

p4 <- ggplot(binded3, aes(x = sample_date, y = sma_ca, color = sample_id)) +
  geom_line()

# nh4_n
binded3 <- binded3 |> 
  mutate(sma_nh4_n = case_when(sample_id == "Q1" ~ rollmean(nh4_n, k = 9, fill = NA),
                            sample_id == "Q2" ~ rollmean(nh4_n, k = 9, fill = NA),
                            sample_id == "Q3" ~ rollmean(nh4_n, k = 9, fill = NA),
                            sample_id == "MPR" ~ rollmean(nh4_n, k = 9, fill = NA)))

p5 <- ggplot(binded3, aes(x = sample_date, y = sma_nh4_n, color = sample_id)) +
  geom_line()

# combined final plot (maybe, probably not)
final_plot <- (p1 / p2 / p3 / p4 / p5)

final_plot *
  theme_light()

# na values are too plentiful
#testing slide()
rm(list = ls())

rm(binded_slide)

binded_slide <- binded |> 
  filter(sample_date <= "1994-01-01") |> 
  select(sample_date, sample_id, k, no3_n, mg, ca, nh4_n) |> 
  slice_head(n = 30)

# want slide_index_dbl() for 'awareness' of sample_date col
# might need .complete = FALSE arguement to allow partial windows at edges
binded_slide <- binded_slide |> 
  mutate(
    roll_k = slide_index_dbl(.x = k, .i = sample_date, .f = mean, .before = weeks(4), .after = weeks(4), .complete = FALSE)
    )

# i think slider method is better, let's try the whole df now
# can definitely think of a for loop for this
# sample_date must be in ascending order according to slider documentation
# trying bind_rows()

binded <- bind_rows(changed_local_df, bq2_df, bq3_df, prm_df)

test_all <- binded |> 
  filter(sample_date <= "1994-01-01" & sample_date >= "1988-01-01") |> 
  select(sample_date, sample_id, k, no3_n, mg, ca, nh4_n) 

# k to roll_k etc.
test_all_q1 <- test_all |> 
  filter(sample_id == "Q1") |> 
  mutate(
    roll_k = slide_index_dbl(.x = k, .i = sample_date, .f = ~mean(.x, na.rm = TRUE), .before = weeks(4), .after = weeks(4), .complete = FALSE),
    
    roll_no3_n = slide_index_dbl(.x = no3_n, .i = sample_date, .f = ~mean(.x, na.rm = TRUE), .before = weeks(4), .after = weeks(4), .complete = FALSE),
    
    roll_mg = slide_index_dbl(.x = mg, .i = sample_date, .f = ~mean(.x, na.rm = TRUE), .before = weeks(4), .after = weeks(4), .complete = FALSE),
    
    roll_ca = slide_index_dbl(.x = ca, .i = sample_date, .f = ~mean(.x, na.rm = TRUE), .before = weeks(4), .after = weeks(4), .complete = FALSE),
    
    roll_nh4_n = slide_index_dbl(.x = nh4_n, .i = sample_date, .f = ~mean(.x, na.rm = TRUE), .before = weeks(4), .after = weeks(4), .complete = FALSE)
  )

test_all_q2 <- test_all |> 
  filter(sample_id == "Q2") |> 
  mutate(
    roll_k = slide_index_dbl(.x = k, .i = sample_date, .f = ~mean(.x, na.rm = TRUE), .before = weeks(4), .after = weeks(4), .complete = FALSE),
    roll_no3_n = slide_index_dbl(.x = no3_n, .i = sample_date, .f = ~mean(.x, na.rm = TRUE), .before = weeks(4), .after = weeks(4), .complete = FALSE),
    roll_mg = slide_index_dbl(.x = mg, .i = sample_date, .f = ~mean(.x, na.rm = TRUE), .before = weeks(4), .after = weeks(4), .complete = FALSE),
    roll_ca = slide_index_dbl(.x = ca, .i = sample_date, .f = ~mean(.x, na.rm = TRUE), .before = weeks(4), .after = weeks(4), .complete = FALSE),
    roll_nh4_n = slide_index_dbl(.x = nh4_n, .i = sample_date, .f = ~mean(.x, na.rm = TRUE), .before = weeks(4), .after = weeks(4), .complete = FALSE)
  )

test_all_q3 <- test_all |> 
  filter(sample_id == "Q3") |> 
  mutate(
    roll_k = slide_index_dbl(.x = k, .i = sample_date, .f = ~mean(.x, na.rm = TRUE), .before = weeks(4), .after = weeks(4), .complete = FALSE),
    roll_no3_n = slide_index_dbl(.x = no3_n, .i = sample_date, .f = ~mean(.x, na.rm = TRUE), .before = weeks(4), .after = weeks(4), .complete = FALSE),
    roll_mg = slide_index_dbl(.x = mg, .i = sample_date, .f = ~mean(.x, na.rm = TRUE), .before = weeks(4), .after = weeks(4), .complete = FALSE),
    roll_ca = slide_index_dbl(.x = ca, .i = sample_date, .f = ~mean(.x, na.rm = TRUE), .before = weeks(4), .after = weeks(4), .complete = FALSE),
    roll_nh4_n = slide_index_dbl(.x = nh4_n, .i = sample_date, .f = ~mean(.x, na.rm = TRUE), .before = weeks(4), .after = weeks(4), .complete = FALSE)
  )

test_all_prm <- test_all |> 
  filter(sample_id == "MPR") |> 
  mutate(
    roll_k = slide_index_dbl(.x = k, .i = sample_date, .f = ~mean(.x, na.rm = TRUE), .before = weeks(4), .after = weeks(4), .complete = FALSE),
    roll_no3_n = slide_index_dbl(.x = no3_n, .i = sample_date, .f = ~mean(.x, na.rm = TRUE), .before = weeks(4), .after = weeks(4), .complete = FALSE),
    roll_mg = slide_index_dbl(.x = mg, .i = sample_date, .f = ~mean(.x, na.rm = TRUE), .before = weeks(4), .after = weeks(4), .complete = FALSE),
    roll_ca = slide_index_dbl(.x = ca, .i = sample_date, .f = ~mean(.x, na.rm = TRUE), .before = weeks(4), .after = weeks(4), .complete = FALSE),
    roll_nh4_n = slide_index_dbl(.x = nh4_n, .i = sample_date, .f = ~mean(.x, na.rm = TRUE), .before = weeks(4), .after = weeks(4), .complete = FALSE)
  )

# bind rows
all_means_and_streams <- bind_rows(test_all_q1, test_all_q2, test_all_q3, test_all_prm)

p1 <- ggplot(all_means_and_streams, aes(sample_date)) +
  geom_line(aes(y = roll_k, color = sample_id)) +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        legend.position = "none")
p1

p2 <- ggplot(all_means_and_streams, aes(sample_date)) +
  geom_line(aes(y = roll_no3_n, color = sample_id)) +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        legend.position = "none")
p2

p3 <- ggplot(all_means_and_streams, aes(sample_date)) +
  geom_line(aes(y = roll_mg, color = sample_id)) +
  labs(color = "Stream ID") +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank())
p3

p4 <- ggplot(all_means_and_streams, aes(sample_date)) +
  geom_line(aes(y = roll_ca, color = sample_id)) +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        legend.position = "none")
p4

p5 <- ggplot(all_means_and_streams, aes(sample_date)) +
  geom_line(aes(y = roll_nh4_n, color = sample_id)) +
  theme(legend.position = "none")
p5

p_all <- (p1 / p2 / p3 / p4 / p5)
p_all 

# Problem Solving. Max's Way
# 1. Create tiny example
# 2. Solve by hand
# 3. Put solution into function
# 4 Apply function to whole data
# maybe just try to apply to nh4 plot?
moving_average <- function(focal_date, dates, conc, window_size_wks) {
  # Steps for calculating moving avg over single focal date
  # 1. Which dates are in the window?
  is_in_window <- (dates > focal_date - (window_size_wks / 2) * 7) & 
    (dates < focal_date + (window_size_wks / 2) * 7)
  # 2. Find associated concentrations
  window_conc <- conc[is_in_window]
  # 3. Calculate mean
  result <- mean(window_conc, na.rm = TRUE) #need na.rm?
  
  return(result)
}

tiny_nh4_n_df <- test_all |> 
  select(sample_date, sample_id, nh4_n) |> 
  slice_head(n = 16)

# first call for one focal date
moving_average(focal_date = tiny_nh4_n_df$sample_date[2],
               dates = tiny_nh4_n_df$sample_date,
               conc = tiny_nh4_n_df$nh4_n,
               window_size_wks = 9)
# getting nh4 means col using sapply()
tiny_nh4_n_df$calc_rolling <- sapply(
  tiny_nh4_n_df$sample_date,
  moving_average,
  dates = tiny_nh4_n_df$sample_date,
  conc = tiny_nh4_n_df$nh4_n,
  window_size_wks = 9
)

# apply to nh4 to each test_all, ig ill just add same col
test_all_q1$nh4_n_rolling <- sapply(
  test_all_q1$sample_date,
  moving_average,
  dates = test_all_q1$sample_date,
  conc = test_all_q1$nh4_n,
  window_size_wks = 9
)

test_all_q2$nh4_n_rolling <- sapply(
  test_all_q2$sample_date,
  moving_average,
  dates = test_all_q2$sample_date,
  conc = test_all_q2$nh4_n,
  window_size_wks = 9
)

test_all_q3$nh4_n_rolling <- sapply(
  test_all_q3$sample_date,
  moving_average,
  dates = test_all_q3$sample_date,
  conc = test_all_q3$nh4_n,
  window_size_wks = 9
)

test_all_prm$nh4_n_rolling <- sapply(
  test_all_prm$sample_date,
  moving_average,
  dates = test_all_prm$sample_date,
  conc = test_all_prm$nh4_n,
  window_size_wks = 9
)

nh4_all_binded <- bind_rows(test_all_q1, test_all_q2, test_all_q3, test_all_prm)
ggplot(nh4_all_binded, aes(x = sample_date)) + 
  geom_line(aes(y = nh4_n_rolling, color = sample_id))
# same result. with nh4 plot. could scrap & use slider or use the function and apply to other groups
# for final product: consider adjusting y scale limits & color palette