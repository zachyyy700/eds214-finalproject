## Purpose: The R script serves as the moving average function for the final quarto document. To calculate the 9-week moving average, a function was created that accepts four parameters: `focal_date`, `dates`, `conc`, and `window_size_wks` which was kept at `window_size_wks` = 9.
## Author: Zachary Loo
## Email: zachyyy700@gmail.com

# To handle the irregular size of each window when calculating each moving average (multiple observations in one week or large gaps between observations), the first step of the function is to create the appropriate window.
moving_average <- function(focal_date, dates, conc, window_size_wks) {
  
  # 1. Which dates are in the window?
  is_in_window <- (dates > focal_date - (window_size_wks / 2) * 7) & 
    (dates < focal_date + (window_size_wks / 2) * 7)
  
  # 2. Find associated concentrations
  window_conc <- conc[is_in_window]
  
  # 3. Calculate mean
  result <- mean(window_conc, na.rm = TRUE) #need na.rm
  
  return(result)
}
