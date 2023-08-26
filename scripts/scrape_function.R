scrape_analysis <- function(files,
                            patterns){
  
  ## Scrape text
  
  if(grepl(x = files$url,
           pattern = ".pdf$")){
    
    text <- pdf_text(files$url)
    
  } else {
    
    webpage <- read_html(files$url)
    
    text <- html_text(html_nodes(webpage, "article"))
    
  }
  
  ## Clean text
  
  text <- str_squish(text)
  
  text <- str_replace_all(string = text,
                          pattern = "\\-\\s+",
                          replacement = "")
  ## Pattern matching
  
  matches <- kwic(tokens(text),
                  pattern = patterns)
  
  ## Write to file
  
  if(files$doc_type == "press_release"){
    
    write_csv(matches,
              sprintf("outputs/matches_%s_press_release.csv",
                      files$year))
    
  } else if(grepl(x = files$doc_type,
                  pattern = "speech")){
    
    write_csv(matches,
              sprintf("outputs/matches_%s_speech_%s.csv",
                      files$year,
                      str_replace_all(string = files$full_name,
                                      pattern = "\\s+",
                                      replacement = "_")))
    
  }
}
