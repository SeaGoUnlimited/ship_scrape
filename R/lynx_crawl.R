#' Download \href{https://brewinstall.org/Install-lynx-on-Mac-with-Brew/}{Lynx for MacOS}
#' 
#' 
lynx.exists <- function(...){
  # determine if lynx is installed
  has_lynx <- tryCatch({
    check <- system("lynx -version", intern = TRUE, ignore.stderr = TRUE)
    if(length(check)){
      TRUE
    }
  }, error = function(e){
    FALSE
  })
  
  if(!has_lynx){
    # determine the OS type
    on_os <- Sys.info()[['sysname']]
    msgs <- list(
      Windows = "You can find installation instructions at https://invisible-island.net/lynx/#installers",
      Linux = "From the terminal run(without $) $ sudo apt-get install lynx",
      Darwin = "install with brew info here: https://brewinstall.org/Install-lynx-on-Mac-with-Brew/"
    )
    for_cat <- match(on_os, names(msgs))
    if(is.na(for_cat)){
      return("Unsure of your OS, visit https://invisible-island.net/lynx/")
    }else {
      return(msgs[[for_cat]])
    }
  }else {
    return(TRUE)
  }
}



#' Spider all links
#' 
#' 
#' \code{lynx.cmd}

lynx.cmd <- function(urls = NULL, recursive = TRUE, ...){
  if(lynx.exists()){
    if(length(urls) > 1){
      urls <- stri_join(urls, collapse = " ")
    }
    api_cmd <- sprintf("lynx -dump -listonly %s 2>&1", urls)
    req <- system(api_cmd, intern = TRUE)
    dumped_urls <- grep("https?:", req, perl = TRUE, value = TRUE)
    dumped_urls <- stringi::stri_replace_all_regex(dumped_urls, "^(\\s+)[0-9]{1,}\\.(\\s+)", "", vectorize_all = FALSE)
    dumped_urls <- dumped_urls[-1]
    
    if(any(file_ext(dumped_urls) == "txt")){
      dumped_urls <- dumped_urls[file_ext(dumped_urls) == "txt"]
    }
    
    if(recursive && !any(file_ext(dumped_urls) == "txt")){
      lynx.cmd(dumped_urls)
    }else {
      return(dumped_urls)
    }
  }
}




#' > microbenchmark::microbenchmark(
#'  +     .get_link('https://ais.sbarc.org/logs_delimited/'),
#'  +     lynx.cmd('https://ais.sbarc.org/logs_delimited/'),
#'  +     times = 1L
#'  + )
#'Unit: seconds
#'                                               expr         min          lq        mean      median          uq         max neval
#' .get_link("https://ais.sbarc.org/logs_delimited/") 100.4392742 100.4392742 100.4392742 100.4392742 100.4392742 100.4392742     1
#' lynx.cmd("https://ais.sbarc.org/logs_delimited/")  12.5287214  12.5287214  12.5287214  12.5287214  12.5287214  12.5287214      1


# 
# lynx.parse <- function(start_url = NULL){
#   if(lynx.exists()){
#     # the trailing / can cause issues, so remove
#     start_url <- gsub("\\/$", "", start_url, perl = TRUE)
#     # build the command line rule and capture the output to string of urls
#     cmd_line <- sprintf("lynx -dump -listonly %s 2>&1", start_url)
#     req <- system(cmd_line, intern = TRUE)
#     # output will look like: "   2. https://ais.sbarc.org/logs_delimited/2018/180101/"
#     # so need to clean a bit and also first remove the empty nodes
#     dumped_urls <- grep("https?:", req, perl = TRUE, value = TRUE)
#     dumped_urls <- stringi::stri_replace_all_regex(dumped_urls, "^(\\s+)[0-9]{1,}\\.(\\s+)", "", vectorize_all = FALSE)
#     
#     # now ensure we don't revisit something we already indexed, ie crawl backwards
#     n_parts_in <- stringi::stri_count_regex(start_url, "\\/")
#     n_parts_found <- stringi::stri_count_regex(dumped_urls, "\\/")
#     
#     dumped_urls[which(n_parts_found > n_parts_in)]
#   }
#     
# }
# 
# 
# lynx.recurse <- function(start_url = NULL){
#   urls <- lynx.parse(start_url = start_url)
#   if(!all(grepl("\\.txt", basename(urls), ignore.case = TRUE))){
#     url_block <- stri_join(urls, collapse = " ")
#     lynx.parse(start_url = url_block)
#   }else {
#     return(urls)
#   }
# }
# 
# 
# 
