#' Convert chart object(s) to JSON
#'
#' Takes a single `highchartzero` object or a named list of `highchartzero`
#' objects and returns a JSON representation of the object(s).
#'
#' @param x A single `highchartzero` object or a named list of `highchartzero`
#'   objects.
#'
#' @return A `json` object from [jsonlite::toJSON()].
#' @export
#' @examples
#' data(example_charts)
#'
#' chart_to_json(example_charts)
#'
#' chart_1 = example_charts[[1]]
#' chart_to_json(chart_1)
#'
chart_to_json <- function(x) {
  UseMethod("chart_to_json")
}

#' @export
chart_to_json.list <- function(x) {
  purrr::map(x, chart_to_json) |>
    jsonlite::toJSON(auto_unbox = TRUE, null = "null", na = "null", json_verbatim = TRUE)
}

#' @export
chart_to_json.highchartzero <- function(x) {
  purrr::pluck(x, "x", "hc_opts") |>
    jsonlite::toJSON(auto_unbox = TRUE, null = "null", na = "null")
}
