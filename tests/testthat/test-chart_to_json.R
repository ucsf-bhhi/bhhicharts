test_chart_to_json = function(x, path) {
  chart_to_json(x) |>
    writeLines(path)

  invisible(path)
}

test_that("converting single chart to json works", {
  data(example_charts, envir = rlang::current_env())

  withr::local_file(
    "test.json",
    expect_snapshot_file(
      test_chart_to_json(example_charts[[1]], "test.json"),
      "single_chart.json"
    )
  )
})

test_that("converting multiple charts to json works", {
  data(example_charts, envir = rlang::current_env())

  withr::local_file(
    "test.json",
    expect_snapshot_file(
      test_chart_to_json(example_charts, "test.json"),
      "multiple_charts.json"
    )
  )
})
