#' player_leaderboard UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_player_leaderboard_ui <- function(id) {
  ns <- NS(id)
  tagList(
    bslib::page_sidebar(
      sidebar = sidebar(
        title="Controls",
        selectInput(ns("year_selector"), "Year", choices = current_year <- c(2021:as.numeric(format(Sys.Date(), "%Y")), "Career"), selected = 2024),
        selectInput(ns("stat_category"), "Category", choices = c("Total", "Per 100 Possessions"), selected = "Total"),
        selectizeInput(inputId = ns("metric_selector"), label = "Metric", choices = get_table_choices(), selected = "Plus Minus")
      ),
      page_fluid(
        layout_column_wrap(
          width = "700px",
          card(DT::dataTableOutput(ns("grade_table")), full_screen=TRUE) |> withSpinner() |> bslib::as_fill_carrier(),
          card(DT::dataTableOutput(ns("metrics_table")), full_screen=TRUE) |> withSpinner() |> bslib::as_fill_carrier(),
          min_height = "1100px"
        ),
        h4("Selected Name:"),
        textOutput(ns("selected_name"))
      )
    )
  )
}
    
#' player_leaderboard Server Functions
#'
#' @noRd 
mod_player_leaderboard_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    pool <- get_db_pool()
    player_link_name <- reactiveValues(player_name = "Jordan Kerr")

    all_player_stats <- get_all_player_stats(pool)  
    metric_table_result <- reactive({
      get_metric_table(input, all_player_stats)
    })
    grade_table <- reactive({
      get_grade_table(input, all_player_stats)
    })

    output$metrics_table <- DT::renderDT(server=FALSE, {
      format_dt(metric_table_result()$metric_table, c("Name", metric_table_result()$metric_name, "O Possessions", "D Possessions", "%"))
    })

    output$grade_table <- DT::renderDT(server=FALSE, {
      format_dt(grade_table(), c("Name", "Overall Percentile", "Thrower Percentile", "Receiver Percentile", "Defense Percentile", "Offensive Possessions", "Defensive Possessions"))
    })

    observe({
      selected_row <- input$grade_table_rows_selected
      if (length(selected_row) > 0) {
        selected_name <- grade_table()[selected_row, "fullName"]
        player_link_name$player_name <- selected_name
      }
    })

    observe({
      selected_row <- input$metrics_table_rows_selected
      if (length(selected_row) > 0) {
        selected_name <- metric_table_result()$metric_table[selected_row, "fullName"]
        player_link_name$player_name <- selected_name
      }
    })

    return(reactive(player_link_name$player_name))

  })
}
    
## To be copied in the UI
# mod_player_leaderboard_ui("player_leaderboard_1")
    
## To be copied in the server
# mod_player_leaderboard_server("player_leaderboard_1")
