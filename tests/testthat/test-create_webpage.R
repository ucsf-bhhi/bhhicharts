test_dependency = function(root_dir, ...) {
  compare_file_text(
    fs::path_package("bhhicharts", "inst", ...),
    fs::path(root_dir, ...)
  )
}

test_that("creating a webpage for one chart works", {
  data("example_charts", envir = rlang::current_env())

  root_dir = tempdir()
  if (!interactive())
    withr::defer(fs::dir_delete(root_dir))

  html_filename = "test.html"
  path = fs::path(root_dir, html_filename)

  create_webpage(
    chart_objects = example_charts[[1]],
    html_filename = html_filename,
    root_dir = root_dir,
    page_title = "test single chart"
  )

  expect_snapshot_file(path, "single_chart.html")

  expect_true(test_dependency(root_dir, "css", "styles.css"))
  expect_true(test_dependency(root_dir, "img", "bhhi_logo_lean.png"))
  expect_true(test_dependency(root_dir, "js", "bhhiTheme.js"))
})

test_that("creating a webpage for multiple charts works", {
  data("example_charts", envir = rlang::current_env())

  root_dir = tempdir()
  html_filename = "test.html"
  path = fs::path(root_dir, html_filename)

  create_webpage(
    chart_objects = example_charts,
    html_filename = html_filename,
    root_dir = root_dir,
    page_title = "test multiple charts",
    chart_picker_text = c("Chart 1", "Chart 2", "Chart 3")
  )

  expect_snapshot_file(path, "multiple_charts.html")

  chart_data_path = fs::path(
    root_dir,
    "chart-data",
    paste0(fs::path_ext_remove(html_filename), "_data"),
    ext = "js"
  )

  expect_snapshot_file(chart_data_path, "multiple_charts_chart_data.js")

  expect_true(test_dependency(root_dir, "css", "styles.css"))
  expect_true(test_dependency(root_dir, "img", "bhhi_logo_lean.png"))
  expect_true(test_dependency(root_dir, "js", "bhhiTheme.js"))
})

test_that("creating a webpage for multiple charts with initial_chart works", {
  data("example_charts", envir = rlang::current_env())

  root_dir = tempdir()
  html_filename = "test.html"
  path = fs::path(root_dir, html_filename)

  create_webpage(
    chart_objects = example_charts,
    html_filename = html_filename,
    root_dir = root_dir,
    initial_chart = "chart2",
    page_title = "test multiple charts with initial chart",
    chart_picker_text = c("Chart 1", "Chart 2", "Chart 3")
  )

  expect_snapshot_file(path, "multiple_charts_initial_chart.html")

  chart_data_path = fs::path(
    root_dir,
    "chart-data",
    paste0(fs::path_ext_remove(html_filename), "_data"),
    ext = "js"
  )

  expect_snapshot_file(chart_data_path, "multiple_charts_initial_chart_chart_data.js")

  expect_true(test_dependency(root_dir, "css", "styles.css"))
  expect_true(test_dependency(root_dir, "img", "bhhi_logo_lean.png"))
  expect_true(test_dependency(root_dir, "js", "bhhiTheme.js"))
})

test_that("creating a webpage for multiple charts with no picker text works", {
  data("example_charts", envir = rlang::current_env())

  root_dir = tempdir()
  html_filename = "test.html"
  path = fs::path(root_dir, html_filename)

  create_webpage(
    chart_objects = example_charts,
    html_filename = html_filename,
    root_dir = root_dir,
    page_title = "test multiple charts with initial chart"
  )

  expect_snapshot_file(path, "multiple_charts_no_picker.html")

  chart_data_path = fs::path(
    root_dir,
    "chart-data",
    paste0(fs::path_ext_remove(html_filename), "_data"),
    ext = "js"
  )

  expect_snapshot_file(chart_data_path, "multiple_charts_no_picker_chart_data.js")

  expect_true(test_dependency(root_dir, "css", "styles.css"))
  expect_true(test_dependency(root_dir, "img", "bhhi_logo_lean.png"))
  expect_true(test_dependency(root_dir, "js", "bhhiTheme.js"))
})
