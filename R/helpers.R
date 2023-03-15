create_webpage = function(chart_objects, path, page_title, initial_chart = NULL, chart_picker_text = NULL, template = "html/template.html") {
  if (length(chart_objects) == 1 | is.highchart(chart_objects)) {
    initial_chart = chart_objects
  } else {
    initial_chart = chart_objects[[initial_chart]]
  }

  chart_picker = FALSE
  if (!is.null(chart_picker_text) & length(chart_objects) > 1 & !is.highchart(chart_objects)) {
    chart_picker_text = map2(
      names(chart_objects), chart_picker_text,
      ~ list(value = .x, text = .y)
    )
    chart_picker = TRUE
  }

  chart_data_path = NULL
  if (length(chart_objects) > 1 & !is.highchart(chart_objects)) {
    if (!dir_exists("chart-data"))
      dir_create("chart-data")
    chart_data_path = path(
      "chart-data", paste0(path_ext_remove(path), "_data"), ext = "js"
    )
    map(chart_objects, pluck, "x", "hc_opts") %>%
      export_chart_data(chart_data_path)
  }

  whisker::whisker.render(
    readLines(template),
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
  ) %>%
    writeLines(path)
}

export_chart_data = function(chart_objects, path) {
  chart_objects %>%
    jsonlite::toJSON(auto_unbox = TRUE, null = "null", na = "null") %>%
    sprintf("chartData=%s", .) %>%
    writeLines(path)
}
