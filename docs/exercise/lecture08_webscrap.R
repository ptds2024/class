# 2. Follow this [workflow](https://smac-group.github.io/ds/section-web-scraping.html#section-workflow). It uses the _SelectorGadget_. Propose an alternative solution using CSS selectors. You will probably need to use the developer tools of your browser.
library(rvest)
real_estate <- read_html("https://www.immoscout24.ch/en/real-estate/rent/city-basel")
# all h3 that are first children seems a good rule
flats <- real_estate %>% html_nodes("h3:first-child") %>% html_text() 
flats <- flats[-c((length(flats)-5):length(flats))] # remove the last six elements

flats_df <- data.frame(
  rooms = gsub(pattern = " room.*", "", flats) %>%
    as.numeric(),
  meter_square = gsub(".*rooms?, | m².*","",flats) %>% 
    as.numeric(),
  price = gsub(".*CHF |.—.*", "", flats) %>%
    gsub(pattern = ",", replacement = "") %>%
    as.numeric()
)

# 3. Repeat exercise 2. using `RSelenium` or `chromote`. 
library(chromote)
b <- ChromoteSession$new()
b$Page$navigate("https://www.immoscout24.ch/en/real-estate/rent/city-basel")
flats <- b$Runtime$evaluate("document.querySelector('html').outerHTML")$result$value %>% 
  read_html() %>% 
  html_nodes("h3:first-child") %>% 
  html_text()
# then as in 2.
b$close()

# 4. Extract the information from the World bank data example using regular expressions. 
url <- "https://data.worldbank.org/indicator/SP.ADO.TFRT"
b <- ChromoteSession$new()
b$Page$navigate(url)
raw_data <- b$Runtime$evaluate("document.querySelector('html').outerHTML")$result$value %>% 
  read_html() %>% 
  html_nodes(".item") %>% 
  html_text()
b$close()

library(countrycode)
country <- gsub("[[:digit:]]*", "", raw_data)
country_iso <- countrycode(country, origin = 'country.name', destination = 'iso3c')
ind <- which(!is.na(country_iso)) # remove missing iso

raw_data2 <- gsub("\\s","a",raw_data)
raw_data2 <- gsub("\\W","a",raw_data2)
data <- gsub("[[:alpha:]]*\\d{4}", "", raw_data2)
data <- as.numeric(data)
library(tibble)
fert_rate <- tibble(ISO = country_iso[ind], value = data[ind])
