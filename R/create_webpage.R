#' Render webpage with chart
#'
#' @param chart_objects Either a single `highcharterzero` object or a list of
#'   `highcharterzero` objects.
#' @param path The location of the rendered html file.
#' @param page_title The text for page's `title` element.
#' @param initial_chart The name of the list element with the initial chart to
#'   show when the page is first loaded.
#' @param chart_picker_text A character vector of the names of the charts to
#'   show in the dropdown selection element.
#' @param view View rendered page in browser. Ignored if not running
#'   interactively.
#'
#' @export
#' @examplesIf interactive()
#' data(example_charts)
#' create_webpage(
#'   example_charts,
#'   "example_charts.html",
#'   "Example Charts",
#'   "chart1",
#'   c("Chart 1", "Chart 2", "Chart 3")
#' )
#'
create_webpage = function(chart_objects, path, page_title, initial_chart = NULL, chart_picker_text = NULL, view = TRUE) {
  if (length(chart_objects) == 1 | highcharter::is.highchart(chart_objects)) {
    initial_chart = chart_objects
  } else {
    initial_chart = chart_objects[[initial_chart]]
  }

  chart_picker = FALSE
  if (
    !is.null(chart_picker_text) &
    length(chart_objects) > 1 &
    !highcharter::is.highchart(chart_objects)
  ) {
    chart_picker_text = purrr::map2(
      names(chart_objects), chart_picker_text,
      ~ list(value = .x, text = .y)
    )
    chart_picker = TRUE
  }

  chart_data_path = NULL
  if (length(chart_objects) > 1 & !highcharter::is.highchart(chart_objects)) {
    fs::dir_create("chart-data")

    chart_data_path = fs::path(
      "chart-data", paste0(fs::path_ext_remove(path), "_data"), ext = "js"
    )

    export_chart_data(chart_objects, chart_data_path)
  }

  add_dependency("css", "styles.css")
  add_dependency("js", "bhhiTheme.js")
  add_dependency("img", "bhhi_logo_lean.png")

  whisker::whisker.render(
    readLines(
      fs::path_package("bhhicharts", "inst","html-template","template.html")
    ),
    list(
      page_title = page_title,
      initial_chart = jsonlite::toJSON(
        initial_chart[["x"]][["hc_opts"]],
        auto_unbox = TRUE,
        null = "null",
        na = "null"
      ),
      chart_picker = chart_picker,
      chart_picker_text = chart_picker_text,
      chart_data = chart_data_path
    )
  ) |>
    writeLines(path)

  if (view & interactive())
    fs::file_show(path)
}

#' Add HTML dependency
#'
#' Copies an HTML dependency from the package template into the current working
#' directory.
#'
#' @param ... Path to the dependency
#'
#' @examplesIf interactive()
#' add_dependency("css", "styles.css")
add_dependency = function(...) {
  path = fs::path(...)

  if (!fs::file_exists(path)) {
    fs::dir_create(fs::path_dir(path))

    fs::file_copy(
      fs::path_package("bhhicharts", "inst", path),
      path
    )
  }
}

is.highchartzero = function(x) {
  inherits(x, "highchartzero")
}
