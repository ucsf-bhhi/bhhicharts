test_chart_to_json = function(x) {
  path = tempfile(fileext = ".json")

  chart_to_json(x) |>
    writeLines(path)

  invisible(path)
}

test_that("converting single chart to json works", {
  data(example_charts)

  expect_snapshot_file(
    test_chart_to_json(example_charts[[1]]),
    "single_chart.json"
  )
})

test_that("converting multiple charts to json works", {
  data(example_charts)

  expect_snapshot_file(
    test_chart_to_json(example_charts),
    "multiple_charts.json"
  )
})
