is.highchartzero = function(x) {
  inherits(x, "highchartzero")
}

has_multiple_charts = function(chart_objects) {
  !(length(chart_objects) == 1 | is.highchartzero(chart_objects))
}
