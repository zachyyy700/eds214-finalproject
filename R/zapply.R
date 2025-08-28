## Purpose: The R script serves to streamline the creation of new columns, calculate the moving average for each, and create the new respective columns.

## Author: Zachary Loo
## Email: zachyyy700@gmail.com

# for now don't worry about sample_id, will be handled later
zapply <- function(df, start_col, end_col, func, window_size_wks = 9) {
  
  for (i in start_col:end_col) {
    
    new_col <- paste0(names(df[i]), "_rolling")
    
    df[[new_col]] <- sapply( 
      df$sample_date,
      func,
      dates = df$sample_date,
      conc = df[[i]],
      window_size_wks = window_size_wks)
  }
  return(df)
}
