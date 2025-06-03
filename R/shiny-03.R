# external functions for Mastering shiny chapter 3

freqpoly <- function(x1, x2, binwidth = 0.1, xlim = c(-3, 3)) {
    df <- base::data.frame(
        x = base::c(x1, x2),
        g = base::c(base::rep("x1", base::length(x1)),
                    base::rep("x2", base::length(x2)))
    )

    ggplot2::ggplot(df, ggplot2::aes(x, colour = g)) +
        ggplot2::geom_freqpoly(binwidth = binwidth, linewidth = 1) +
        ggplot2::coord_cartesian(xlim = xlim)
}

t_test <- function(x1, x2) {
    test <- stats::t.test(x1, x2)

    # use sprintf() to format t.test() results compactly
    base::sprintf(
        "p value: %0.3f\n[%0.2f, %0.2f]",
        test$p.value, test$conf.int[1], test$conf.int[2]
    )
}
