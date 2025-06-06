## R/neiss-data.R

url_basic <- "https://raw.githubusercontent.com/petzi53/learning-shiny/refs/heads/master/"
url_injuries <- paste0(url_basic, "neiss/injuries.tsv.gz")
url_population <- paste0(url_basic, "neiss/population.tsv")
url_products <- paste0(url_basic, "neiss/products.tsv")

injuries <-  vroom::vroom(url_injuries, show_col_types = FALSE)
population <-  vroom::vroom(url_population, show_col_types = FALSE)
products <-  vroom::vroom(url_products, show_col_types = FALSE)

prod_codes <- stats::setNames(products$prod_code, products$title)
