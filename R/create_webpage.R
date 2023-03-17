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
create_webpage = function(
    chart_objects, html_filename, root_dir = ".", page_title = "Chart",
    initial_chart = NULL, chart_picker_text = NULL, view = TRUE
) {
  ## setup the chart picker
  # chart_picker sets if there will be a chart picker, it's false by default
  chart_picker = FALSE
  # if there's more than 1 chart, we'll need a picker
  if (has_multiple_charts(chart_objects)) {
    # set chart_picker to true so it gets rendered
    chart_picker = TRUE

    ## then set the arguments and text for the html option element
    # if picker text labels aren't provided, use the names of the chart objects
    if (is.null(chart_picker_text))
      chart_picker_text = names(chart_objects)

    # iterate over the chart object names and the label text
    chart_picker_text = purrr::map2(
      names(chart_objects), chart_picker_text,
      function(value, text) {
        # if it's the initial chart, set the selected attribute so the picker
        # loads with that chart selected
        selected = ifelse(
          !is.null(initial_chart) && value == initial_chart, "selected", ""
        )
        list(value = glue::glue("value='{value}' {selected}"), text = text)
      }
    )
  }

  chart_data_path = NULL
  if (has_multiple_charts(chart_objects)) {
    fs::dir_create(root_dir, "chart-data")

    chart_data_path = fs::path(
      root_dir, "chart-data", paste0(fs::path_ext_remove(html_filename), "_data"),
      ext = "js"
    )

    export_chart_data(chart_objects, chart_data_path)

    chart_data_path = build_read_path_rel(root_dir, chart_data_path)
  }

  add_dependency(root_dir, "css", "styles.css")
  add_dependency(root_dir, "js", "bhhiTheme.js")
  add_dependency(root_dir, "img", "bhhi_logo_lean.png")

  html_path = fs::path(root_dir, html_filename)

  whisker::whisker.render(
    readLines(
      fs::path_package("bhhicharts", "inst","html-template","template.html")
    ),
    list(
      page_title = page_title,
      initial_chart = initial_chart_json(chart_objects, initial_chart),
      chart_picker = chart_picker,
      chart_picker_text = chart_picker_text,
      chart_data = chart_data_path
    )
  ) |>
    writeLines(html_path)

  # optionally open the page in a browser
  if (view & interactive())
    fs::file_show(html_path)
}

initial_chart_json = function(chart_objects, initial_chart) {
  # if there's only one chart, the initial chart is just the chart object
  if (!has_multiple_charts(chart_objects)) {
    initial_chart = chart_objects
  } else {
    # if no initial chart is provided, the initial chart is the first chart
    if (is.null(initial_chart)) {
      initial_chart = chart_objects[[1]]
    } else {
      initial_chart = chart_objects[[initial_chart]]
    }
  }

  chart_to_json(initial_chart)
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
add_dependency = function(root_dir, ...) {
  # set the path where the dependency will be written
  write_path = fs::path(root_dir, ...)

  # if the dependency doesn't already exist at that location copy it there
  if (!fs::file_exists(write_path)) {
    # create the directory for the dependency if it doesn't already exist
    fs::dir_create(fs::path_dir(write_path))

    # build the path to read the dependency from, relative to the package files
    read_path_rel = build_read_path_rel(root_dir, write_path)

    fs::file_copy(
      fs::path_package("bhhicharts", "inst", read_path_rel),
      write_path
    )
  }
}

#' Build relative path to dependency
#'
#' Builds the path to the dependency relative to the installed package files.
#'
#' Starts with the write path of the dependency, and strips off the root
#' directory of the write path. The remainder of the path is the relative path
#' of the dependency, which can then be used to find it in the installed package
#' files.
#'
#' @param root_dir The path to the root directory of the webpage.
#' @param write_path The write path of the dependency.
#'
#' @return The relative path of the dependency.
build_read_path_rel = function(root_dir, write_path) {
  # break the write path into its components
  write_path_components = fs::path_split(write_path)[[1]]
  # break the root path into its components
  root_path_components = fs::path_split(root_dir)[[1]]

  # the relative path components are the components of the write path that
  # aren't in the root path
  relative_path_components =
    write_path_components[!(write_path_components %in% root_path_components)]

  # put the relative path components together into a path string
  fs::path_join(relative_path_components)
}
