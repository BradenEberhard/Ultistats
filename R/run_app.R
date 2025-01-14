#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts.
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(
  onStart = NULL,
  options = list(),  # Autoreload enabled by default
  enableBookmarking = NULL,
  uiPattern = "/",
  ...
) {
  # Ensure that `options` for shinyApp are set for autoreload during development
  
  # Run the shiny app with the provided arguments
  shinyApp(
    ui = app_ui(),
    server = app_server,
  )
}
