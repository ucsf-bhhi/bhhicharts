
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bhhicharts

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/ucsf-bhhi/bhhicharts/branch/main/graph/badge.svg)](https://app.codecov.io/gh/ucsf-bhhi/bhhicharts?branch=main)
[![R-CMD-check](https://github.com/ucsf-bhhi/bhhicharts/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ucsf-bhhi/bhhicharts/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

bhhicharts helps create interactive charts and provides infrastructure
for embedding them on the BHHI website.

It can take a single chart or set of related charts and render them on a
simple webpage that can then be embedded on the BHHI Drupal site.

## Installation

You can install bhhicharts from
[GitHub](https://github.com/ucsf-bhhi/bhhicharts) with:

``` r
# install.packages("remotes")
remotes::install_github("ucsf-bhhi/bhhicharts")
```

## Use

bhhicharts relies on the [highcharter](https://jkunst.com/highcharter/)
package to create the charts.

### Single chart

After creating a chart:

``` r
library(highcharter)
#> Registered S3 method overwritten by 'quantmod':
#>   method            from
#>   as.zoo.data.frame zoo

scatter_chart = hchart(mtcars, "scatter", hcaes(x = wt, y = mpg, group = cyl)) |> 
  hc_xAxis(title = list(text = "Weight")) |>
  hc_yAxis(title = list(text = "MPG")) |>
  hc_legend(title = list(text = "Cylinders"))
```

It can be rendered in a simple webpage with the BHHI theme and logo
applied. The webpage can then be embedded into the BHHI Drupal site.

``` r
dir = tempdir()

bhhicharts::create_webpage(
  scatter_chart, html_filename = "scatter-chart.html", root_dir = dir
)
```

### Multiple charts

bhhicharts can also render a webpage with a chart picker that allows the
viewer to choose between multiple charts. This can be useful, for
example, to show different visualizations of the data or different
demographic groupings.

After creating another chart and putting the charts in a named list:

``` r
column_chart = mtcars |>
  dplyr::count(cyl, gear) |> 
  hchart("column", hcaes(x = cyl, y = n, group = gear)) |>
  highcharter::hc_plotOptions(column = list(stacking = "normal")) |> 
  highcharter::hc_xAxis(title = list(text = "Cylinders")) |>  
  highcharter::hc_yAxis(title = list(text = "Count")) |>
  highcharter::hc_legend(title = list(text = "Gears"))

charts = list("Column" = column_chart, "Scatter" = scatter_chart)
```

The set of charts can be rendered into a webpage:

``` r
bhhicharts::create_webpage(
  charts, html_filename = "multiple-charts.html", root_dir = dir
)
```
