# Install required packages from packages.r if not already installed


library(shiny)
library(tidyverse)
library(tidytext)
library(dplyr)      # for mutate()
library(purrr)      # for discard()
library(stringr)    # for str_split()
library(ggplot2)    # for plots
library(tibble)     # for tibble()



# Define UI
ui <- fluidPage(
  titlePanel("Word Count Analyzer"),
  sidebarLayout(
    sidebarPanel(
      textAreaInput("text_input", "Paste your text here:", 
                    rows = 10,
                    placeholder = "Type or paste text to analyze..."),
      actionButton("analyze", "Analyze Text"),
      hr(),
      helpText("This app analyzes text and provides word count, character count, and frequent terms.")
    ),
    mainPanel(
      h3("Text Statistics"),
      verbatimTextOutput("stats"),
      br(),
      h3("Most Frequent Words"),
      plotOutput("word_freq_plot")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Reactive function to analyze text when button is pressed
  analyzed_text <- eventReactive(input$analyze, {
    req(input$text_input)
    
    text <- input$text_input
    
    # Calculate basic stats
    word_count <- ifelse(nchar(text) > 0, 
                         length(strsplit(text, "\\s+")[[1]]), 
                         0)
    char_count <- nchar(text)
    char_no_spaces <- nchar(gsub("\\s", "", text))
    
    # Get word frequencies
    words <- strsplit(tolower(text), "\\W+")[[1]]
    words <- words[words != ""]  # Remove empty strings
    freq_table <- if (length(words) > 0) {
      data.frame(word = words) %>%
        count(word, sort = TRUE) %>%
        head(10)
    } else {
      NULL
    }
    
    list(
      word_count = word_count,
      char_count = char_count,
      char_no_spaces = char_no_spaces,
      freq_table = freq_table
    )
  })
  
  # Output text statistics
  output$stats <- renderPrint({
    stats <- analyzed_text()
    cat("Word count:", stats$word_count, "\n")
    cat("Character count (with spaces):", stats$char_count, "\n")
    cat("Character count (without spaces):", stats$char_no_spaces, "\n")
  })
  
  # Output word frequency plot
  output$word_freq_plot <- renderPlot({
    freq_table <- analyzed_text()$freq_table
    
    if (!is.null(freq_table) && nrow(freq_table) > 0) {
      ggplot(freq_table, aes(x = reorder(word, n), y = n)) +
        geom_col(fill = "steelblue") +
        coord_flip() +
        labs(x = "Word", y = "Frequency") +
        theme_minimal()
    } else {
      plot(1, type = "n", xlab = "", ylab = "", xlim = c(0, 1), ylim = c(0, 1),
           main = "No words to display")
      text(0.5, 0.5, "No words found in text", cex = 1.2)
    }
  })
}

# Run the application
shinyApp(ui = ui, server = server)

shiny::stopApp()

