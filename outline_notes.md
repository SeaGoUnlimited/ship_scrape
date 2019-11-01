---
title: "Outline"
author: "Carl Boneri"
date: "11/1/2019"
output: 
  html_document: 
    df_print: kable
    fig_caption: yes
    keep_md: yes
    toc: yes
---




# General Overview
Ultimately the goal is to be able to extract the data from the files located in 
sub-directories of the [ais logs site](https://ais.sbarc.org/logs_delimited/) to perform
deeper analysis. 

The directory/tree structure of the site generally follows the pattern of: 

* Year folder, ie 2018  
  * Date folder, ie 180101 for Jan 1, 2018
    * Series of data dumps to text files

**OR**

```
./  
YYYY/  
 ¦--YYmmdd  
     ¦--AIS_SBARC_YYmmdd-nn.txt  
     °--AIS_SBARC_YYmmdd-nn+1.txt  
```

Each `<a>` element also has a sibling text node on the page that shows the last-updated time: 

```r
.fn <- function(start_url = NULL){
  raw <- xml2::read_html(start_url)
  
  links <- xml2::xml_find_all(raw, ".//a[not(contains(@href,'../'))]")
  
  meta_text <- xml2::xml_find_all(links, ".//following-sibling::text()[normalize-space(.)]") %>% 
    xml2::xml_text() %>% stringi::stri_replace_all_regex("(\\s+){2,}(\\-)?", "", vectorize_all = FALSE)
  
  data.frame(
    url_path = xml2::url_absolute(xml_attr(links,"href"), xml2::xml_url(raw)), 
    metadata = meta_text,
    stringsAsFactors = FALSE
  )
}


dat <- .fn(start_url = "https://ais.sbarc.org/logs_delimited/")

knitr::kable(dat, format = "markdown")
```



|url_path                                   |metadata          |
|:------------------------------------------|:-----------------|
|https://ais.sbarc.org/logs_delimited/2018/ |16-Oct-2019 22:38 |
|https://ais.sbarc.org/logs_delimited/2019/ |16-Oct-2019 21:56 |

As we recursively walk down the tree to get to our text files, sub directories of dates would look like the following, but
it's important to note that the metadata doesn't always coincide with the date of the folder name. Notice in the output below
how the folder for data related to 01/01/2018 shows it was actually last updated on 10/16/2019   

```r
dat2 <- .fn("https://ais.sbarc.org/logs_delimited/2018/") %>% head(4)
knitr::kable(dat2, format = "markdown")
```



|url_path                                          |metadata          |
|:-------------------------------------------------|:-----------------|
|https://ais.sbarc.org/logs_delimited/2018/180101/ |16-Oct-2019 23:28 |
|https://ais.sbarc.org/logs_delimited/2018/180102/ |17-Oct-2019 00:01 |
|https://ais.sbarc.org/logs_delimited/2018/180103/ |17-Oct-2019 00:01 |
|https://ais.sbarc.org/logs_delimited/2018/180104/ |17-Oct-2019 00:01 |

And finally we get to our bottom-most children, which are the text files we are after 

```r
dat3 <- .fn("https://ais.sbarc.org/logs_delimited/2018/180101/")
knitr::kable(dat3, format = "markdown")
```



|url_path                                                                 |metadata                 |
|:------------------------------------------------------------------------|:------------------------|
|https://ais.sbarc.org/logs_delimited/2018/180101/AIS_SBARC_180101-00.txt |01-Jan-2018 01:00814075  |
|https://ais.sbarc.org/logs_delimited/2018/180101/AIS_SBARC_180101-01.txt |01-Jan-2018 02:00811116  |
|https://ais.sbarc.org/logs_delimited/2018/180101/AIS_SBARC_180101-02.txt |01-Jan-2018 03:00507680  |
|https://ais.sbarc.org/logs_delimited/2018/180101/AIS_SBARC_180101-03.txt |01-Jan-2018 04:00530170  |
|https://ais.sbarc.org/logs_delimited/2018/180101/AIS_SBARC_180101-04.txt |01-Jan-2018 04:59647327  |
|https://ais.sbarc.org/logs_delimited/2018/180101/AIS_SBARC_180101-05.txt |01-Jan-2018 06:00735555  |
|https://ais.sbarc.org/logs_delimited/2018/180101/AIS_SBARC_180101-06.txt |01-Jan-2018 07:00670431  |
|https://ais.sbarc.org/logs_delimited/2018/180101/AIS_SBARC_180101-07.txt |01-Jan-2018 08:00805753  |
|https://ais.sbarc.org/logs_delimited/2018/180101/AIS_SBARC_180101-08.txt |01-Jan-2018 09:00893844  |
|https://ais.sbarc.org/logs_delimited/2018/180101/AIS_SBARC_180101-09.txt |01-Jan-2018 10:00736120  |
|https://ais.sbarc.org/logs_delimited/2018/180101/AIS_SBARC_180101-10.txt |01-Jan-2018 11:00662706  |
|https://ais.sbarc.org/logs_delimited/2018/180101/AIS_SBARC_180101-11.txt |01-Jan-2018 12:00803804  |
|https://ais.sbarc.org/logs_delimited/2018/180101/AIS_SBARC_180101-12.txt |01-Jan-2018 13:00877942  |
|https://ais.sbarc.org/logs_delimited/2018/180101/AIS_SBARC_180101-13.txt |01-Jan-2018 14:00832553  |
|https://ais.sbarc.org/logs_delimited/2018/180101/AIS_SBARC_180101-14.txt |01-Jan-2018 15:001332394 |
|https://ais.sbarc.org/logs_delimited/2018/180101/AIS_SBARC_180101-15.txt |01-Jan-2018 16:001622538 |
|https://ais.sbarc.org/logs_delimited/2018/180101/AIS_SBARC_180101-16.txt |01-Jan-2018 17:001456121 |
|https://ais.sbarc.org/logs_delimited/2018/180101/AIS_SBARC_180101-17.txt |01-Jan-2018 18:002073603 |
|https://ais.sbarc.org/logs_delimited/2018/180101/AIS_SBARC_180101-18.txt |01-Jan-2018 19:002248602 |
|https://ais.sbarc.org/logs_delimited/2018/180101/AIS_SBARC_180101-19.txt |01-Jan-2018 20:001279206 |
|https://ais.sbarc.org/logs_delimited/2018/180101/AIS_SBARC_180101-20.txt |01-Jan-2018 20:591130581 |
|https://ais.sbarc.org/logs_delimited/2018/180101/AIS_SBARC_180101-21.txt |01-Jan-2018 22:001082704 |
|https://ais.sbarc.org/logs_delimited/2018/180101/AIS_SBARC_180101-22.txt |01-Jan-2018 23:00969817  |
|https://ais.sbarc.org/logs_delimited/2018/180101/AIS_SBARC_180101-23.txt |02-Jan-2018 00:00667369  |





# Process

1) Build index of all links  
    * log the metadata for the last-updated timestamps and file path  
    * log a logical indicating if the data has already been read-in/extracted for the associated file  
2) Filter the index table for only urls that have not been read-in  
3) Loop through urls and parse the data  
4) Update the log file  
5) Bind the output data  					
