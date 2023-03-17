is.highchartzero = function(x) {
  inherits(x, "highchartzero")
}

has_multiple_charts = function(chart_objects) {
  # single chart if it's a list of length 1 or a highchartzero object itself
  single_chart =
    (class(chart_objects) == "list" & length(chart_objects) == 1) |
    is.highchartzero(chart_objects)

  # it's multiple charts if it's not a single chart
  !single_chart
}
