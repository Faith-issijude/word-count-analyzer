# word-count-analyzer
A simple Shiny app to analyze word and character count in text.

This is a basic Shiny app that allows users to:

- Paste text into a text box
- Analyze the word count, character count (with and without spaces)
- See the 10 most frequent words in a bar chart

## How to Run

Make sure you have R and the following packages installed:

- shiny
- tidyverse
- tidytext
- dplyr
- purrr
- stringr
- ggplot2
- tibble

Then run:

```r
shiny::runApp()
