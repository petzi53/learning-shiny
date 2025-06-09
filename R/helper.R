##########################################################
# Project: Some utility scripts for my Quarto books
# Author: Peter Baumgartner
# Version 1.0: June 8, 2025
#
# CONTENT:
## - my_glance_data: glance at a specified number of random data
## - my_qq_plot: create histogram with overlaid dnorm curve
## - my_scatter: create scatterplot with lm and loess curve
## - my_save_data_file: save data file
## - my_pkgs_dl: package downloads
## - private_list_plotter: plot color list as a palette
## - private_t_col: transparent colors
##########################################################



library(glossary)

glossary::glossary_path("../glossary-pb/glossary.yml")


##########################################################
# my_glance_data: Glance at a specified number of random data
# Version 1.0: June 8, 2025
# Purpose:
  # To prevent possible bias with head()/tail() or
  # other function that print some data excerpts
# Used in "Statistics with R"
# See: https://bookdown.org/pbaumgartner/swr-harris/
##########################################################

# df   = dataframe or tibble
# N    = number of records chosen randomly
# seed = set.seed for reproducibility

my_glance_data <- function(df, N = 8, seed = 42){
    df_temp <- first_and_last_row(df)

    set.seed(seed)
    df |>
        dplyr::mutate(obs = dplyr::row_number()) |>
        dplyr::relocate(obs) |>
        dplyr::slice_sample(n = N) |>
        dplyr::bind_rows(df_temp) |>
        dplyr::arrange(obs)
}

first_and_last_row <-  function(df) {
    df |>
        dplyr::mutate(obs = dplyr::row_number()) |>
        dplyr::filter(dplyr::row_number() %in% base::c(1, dplyr::n()))
}

##########################################################
# my_hist_dnorm: Create histogram with overlaid dnorm curve
# Version 1.0: June 8, 2025
# Purpose:
# Compare histogram with normal distribution and density
# Author: Peter Baumgartner
# Used in my personal notes on "Statistics with R"
# See: https://bookdown.org/pbaumgartner/swr-harris/
##########################################################

# df        = data.frame or tibble
# v         = character: numerical column of data.frame:
#             syntax for call = df$v (NA's are allowed)
# x_label   = character: title for x-axis
# nbins     = numeric: number of bins
# col_fill  = character: fill color
# col_color = character: border color of bins
# col_dens  = character: color of density curve
# col_dnorm = character: color of dnorm curve

my_hist_dnorm <- function(df, v, n_bins = 30,
                       col_fill = "gray90",
                       col_color = "black",
                       col_dnorm = "Normal",
                       col_dens = "Density",
                       x_label = "x") {
    p <- df |>
        ggplot2::ggplot(ggplot2::aes(v)) +
        ggplot2::geom_histogram(
            ggplot2::aes(y = ggplot2::after_stat(density)),
            bins = n_bins,
            fill = col_fill,
            color = col_color,
            na.rm = TRUE) +
        ggplot2::geom_density(
            na.rm = TRUE,
            ggplot2::aes(color = col_dens),
            linewidth = 1,
            ) +
        ggplot2::stat_function(
            fun = dnorm,
            args = c(mean = mean(v, na.rm = TRUE),
                    sd = sd(v, na.rm = TRUE)),
            ggplot2::aes(color = col_dnorm),
            na.rm = TRUE,
            linewidth = 1,
            ) +
        ggplot2::theme_bw() +
        ggplot2::xlab(x_label) +
        ggplot2::scale_color_manual(
            name = "Colors",
            values = c("steelblue", "tomato")
        ) +
        ggplot2::theme(legend.position = "top")


    p

}

##########################################################
# my_qq_plot: Create q-q-plot
# Version 1.0: June 8, 2025
# Purpose:
# Generate check normality assumption
# Author: Peter Baumgartner
# Used in my personal notes on "Statistics with R"
# See: https://bookdown.org/pbaumgartner/swr-harris/
##########################################################

# df        = data.frame or tibble
# v         = character: numerical column of data.frame:
#             syntax for call = df$v (NA's are allowed)
# x_label   = character: title for x-axis
# y_label   = character: title for y-axis
# col_qq    = character: color of data
# line_qq.  = character: color of theoretical normal distribution


my_qq_plot <- function(
        df,
        v,
        col_qq = "Data distributed",
        line_qq = "Normally distributed",
        x_label = "x",
        y_label = "y"
        ) {
    p <- df |>
    ggplot2::ggplot(
        ggplot2::aes(sample = v)
    ) +
    ggplot2::stat_qq(
        ggplot2::aes(color = col_qq),
        na.rm = TRUE
    ) +
    ggplot2::stat_qq_line(
        ggplot2::aes(linetype = line_qq),
        linewidth = 1,
        na.rm = TRUE
    ) +
    ggplot2::labs(
        x = x_label,
        y = y_label
    ) +
    ggplot2::scale_color_manual(
        name = "",
        values = ("purple3")
    ) +
    ggplot2::scale_linetype_manual(
        name = "",
        values = ("solid")
    ) +
    ggplot2::guides(
        color = ggplot2::guide_legend(order = 1),
        linetype = ggplot2::guide_legend(order = 2)
    ) +
    ggplot2::theme_bw() +
    ggplot2::theme(legend.position = "top")

    p
}

##########################################################
# my_scatter: Create scatterplot with lm and loess curve
# Version 1.0: June 8, 2025
# Purpose:
# Generate check
# Author: Peter Baumgartner
# Used in my personal notes on "Statistics with R"
# See: https://bookdown.org/pbaumgartner/swr-harris/
##########################################################

# df        = data.frame or tibble
# v         = character: numerical column of data.frame:
#             syntax for call = df$v (NA's are allowed)
# w         = character: numerical column of data.frame
#             syntax for call = df$w (NA's are allowed)
# x_label   = character: title for x-axis
# y_label   = character: title for y-axis
# col_point = character: color of points
# col_lm    = character: color of linear model
# col_loess = character: color of loess curve


my_scatter <- function(
        df,
        v,
        w,
        col_point = "Point",
        col_lm = "Linear",
        col_loess = "Loess",
        x_label = "x",
        y_label = "y"
) {
    p <- df |>
        ggplot2::ggplot(
            ggplot2::aes(
                x = v,
                y = w
            )
        ) +
        ggplot2::geom_point(
            alpha = 0.6,
            ggplot2::aes(color = col_point),
            na.rm = TRUE
        ) +
        ggplot2::geom_smooth(
            formula = y ~ x,
            method = "lm",
            se = FALSE,
            ggplot2::aes(color = col_lm),
            na.rm = TRUE
        ) +
        ggplot2::geom_smooth(
            formula = y ~ x,
            method = "loess",
            se = FALSE,
            ggplot2::aes(color = col_loess),
            na.rm = TRUE
        ) +
        ggplot2::labs(
            x = x_label,
            y = y_label
        ) +
        ggplot2::theme_bw() +
        ggplot2::theme(legend.position = "top") +
        ggplot2::scale_color_manual(
            name = "",
            values = c("purple3", "black", "tomato"),
            breaks = c(col_point, col_lm, col_loess)
        )

    p
}

################################################################
# my_create_folder:
# Version 1.0: June 8, 2025
# check if folder already exists at parameter "path"
# if not, then create folder
# Author: Peter Baumgartner
# path = character string:
#                example: "/Users/xxyyzz/Documents/my-data/"
################################################################
my_create_folder <- function(path){

  if (!base::file.exists(path))
    {base::dir.create(path)}
}


################################################################
# my_save_data_file: Save data file for the specified chapter
# Version 1.0: June 8, 2025
# Purpose:
# If folder not exists, create it and save object as .rds file
# Author: Peter Baumgartner
# chapter_folder = character: folder inside "data" folder
#                  example "chap05"
# object = data to save
# file_name = character: example "xy_object.rds"
# I have used the function in my notes on "Statistics with R"
# # See: https://bookdown.org/pbaumgartner/swr-harris/
################################################################

my_save_data_file <- function(chapter_folder, object, file_name){
    data_folder <- base::paste0(here::here(), "/data/")
    if (!base::file.exists(data_folder))
    {base::dir.create(data_folder)}

    chap_folder <-
        base::paste0(
            here::here(),
            paste0("/data/", chapter_folder, "/")
        )
    if (!base::file.exists(chap_folder))
    {base::dir.create(chap_folder)}

    base::saveRDS(object = object,
                  file = paste0(chap_folder, "/", file_name))
}


################################################################
# my_pkgs_downloads: Get number of downloads from RStudio CRAN Mirror
# Version 1.0: June 8, 2025
# Purpose:
# Compare popularity of different packages
# Author: Peter Baumgartner
# pkgs = character vector of package names
# period = "last-day" "last-week", "last-month"
# days: period days = 1, 7, 30
# returns: tibble with packages sorted by download figures
# I have used the function in my notes on "Statistics with R"
# # See: https://bookdown.org/pbaumgartner/swr-harris/
################################################################
my_pkgs_dl <-  function(pkgs, period = "last-week", days = 7) {
    dl_pkgs <- cranlogs::cran_downloads(when = period, packages = pkgs)

    start_date = base::min(dl_pkgs$date)
    end_date = base::max(dl_pkgs$date)

    dl_pkgs |>
        dplyr::group_by(package) |>
        dplyr::summarize(average = trunc(sum(count) / days)) |>
        dplyr::arrange(desc(average)) |>
        dplyr::mutate(
            from = start_date,
            to = end_date
            )
}




################################################################
#
#                  Not my functions (private)                  #
#
################################################################
# private_list_plotter: Plot color list as a palette
# Version 1.0: June 8, 2025
# Purpose:
# Display different color palettes for easy comparison
# Author: Emil Hvitfeldt
# Developed for r-color-palettes and {paletteer} package
# See: https://github.com/EmilHvitfeldt/r-color-palettes/blob/main/R/list_plotter.R
# I have used it in my personal notes on "Statistics with R"
# # See: https://bookdown.org/pbaumgartner/swr-harris/
################################################################


private_list_plotter <- function(color_list, names, package_name) {
  par(mar = c(0, 0, 0, 0) + 0.1)

  plot(
    0,
    0,
    type = "n",
    axes = FALSE,
    bty = "n",
    xlab = "",
    ylab = "",
    xlim = c(0, 1),
    ylim = c(-length(color_list) - 1, 0)
  )

  title(package_name, line = -3)
  for (i in seq_len(length(color_list))) {
    colors_len <- length(color_list[[i]])
    breaks <- seq(from = 0,
                  to = 1,
                  length = colors_len + 1)


    text(0, -i, names[i], pos = 4)
    rect(
      xleft = breaks[1:colors_len],
      xright = breaks[1:colors_len + 1],
      ytop = -0.15 - i,
      ybottom = -0.8 - i,
      col = color_list[[i]],
      border = NA
    )
  }
}

################################################################
# private_t_color: Transparent colors
# Version 1.0: June 8, 2025
# Author: Mark Gardener 2015 www.dataanalytics.org.uk
################################################################

private_t_col <- function(color, percent = 50, name = NULL) {
  #   color = color name
  #   percent = % transparency
  #   name = an optional name for the color

  ## Get RGB values for named color
  rgb.val <- col2rgb(color)

  ## Make new color using input color as base and alpha set by transparency
  t.col <- rgb(rgb.val[1], rgb.val[2], rgb.val[3],
               max = 255,
               alpha = (100 - percent) * 255 / 100,
               names = name)

  ## Save the color
  invisible(t.col)
}

## END

