#' Write chart(s) JS to disk
#'
#' Converts a single `highchartzero` object or a named list of `highchartzero`
#' objects to JSON and writes the JSON to disk.
#'
#' @inheritParams chart_to_json
#' @param path The location of the JSON file.
export_chart_data = function(x, path) {
  chart_json = chart_to_json(x)

  sprintf("chartData=%s", chart_json) |>
    writeLines(path)
}
