series1 = highcharter::highchartzero()  |>
  highcharter::hc_add_series(c(8, 10, 16), type = "column", name = "mpg") |>
  highcharter::hc_xAxis(categories = c(4, 6, 8), title = list(text = "cyl"))

series2 = highcharter::highchartzero()  |>
  highcharter::hc_add_series(c(4, 5, 8), type = "column", name = "mpg")  |>
  highcharter::hc_xAxis(categories = c(4, 6, 8), title = list(text = "cyl"))

chart_data = mtcars |>
  dplyr::count(cyl, gear)

series3 = highcharter::highchartzero() |>
  highcharter::hc_add_series(
    data = chart_data,
    type = "column",
    mapping = highcharter::hcaes(x = cyl, y = n, group = gear)
  ) |>
  highcharter::hc_plotOptions(column = list(stacking = "normal")) |>
  highcharter::hc_xAxis(
    categories = levels(chart_data$cyl),
    title = list(text = "cyl")
  ) |>
  highcharter::hc_legend(title = list(text = "gear"))

example_charts = list(chart1 = series1, chart2 = series2, chart3 = series3)

usethis::use_data(example_charts, overwrite = TRUE)
