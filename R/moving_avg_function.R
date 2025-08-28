##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                                                            ~~
##                  FUNCTION FOR CALCULATING MOVING AVERAGES                ----
##                                                                            ~~
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Purpose: The R script serves as the source function for the final quarto document.
## Author: Zachary Loo
## Email: zachyyy700@gmail.com

moving_average <- function(focal_date, dates, conc, window_size_wks) {
  # Steps for calculating moving avg over single focal date
  # 1. Which dates are in the window?
  is_in_window <- (dates > focal_date - (window_size_wks / 2) * 7) & 
    (dates < focal_date + (window_size_wks / 2) * 7)
  # 2. Find associated concentrations
  window_conc <- conc[is_in_window]
  # 3. Calculate mean
  result <- mean(window_conc, na.rm = TRUE) #need na.rm
  
  return(result)
}
