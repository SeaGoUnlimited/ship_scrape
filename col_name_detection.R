#' @references https://www.navcen.uscg.gov/?pageName=AISMessagesA for data structure overview
#' @references https://www.seatizenscience.org/applications.html additional supporting data being used in the overall analysis
#' 

#' Parsing the naming convention rules from the \href{https://www.navcen.uscg.gov/?pageName=AISMessagesA}{Class A AIS Position Report (Messages 1, 2, and 3)}
#' 
#' 
raw <- read_html("https://www.navcen.uscg.gov/?pageName=AISMessagesA")
param_rows <- xml_find_all(raw, ".//table[descendant::th[contains(.,'Parameter')] and contains(@border, '1')]//tr[td]")
param_table <- lapply(param_rows, function(i){
  cell_text <- xml_find_all(i, ".//td") %>% xml_text()
  stringi::stri_replace_all_regex(cell_text, "\\p{C}", "", vectorize_all = FALSE) %>%
    stringi::stri_trim_both() %>% rbind %>%
    data.frame(., row.names = NULL)
}) %>% rbind_pages() %>%
  select(parameter = 1, bits = 2, description = 3) %>%
  mutate_all(function(x){
  ifelse(!nchar(x), NA, x)
}) %>% filter(!is.na(description))

# saveRDS(param_table, "column_names.rds")
#' 
#'
