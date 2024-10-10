# 2. Follow this [workflow](https://smac-group.github.io/ds/section-web-scraping.html#section-workflow). It uses the _SelectorGadget_. Propose an alternative solution using CSS selectors. You will probably need to use the developer tools of your browser.
library(rvest)
real_estate <- read_html("https://www.immoscout24.ch/en/real-estate/rent/city-basel")
prices <- real_estate %>% html_nodes("span + span") %>% html_text() 
prices <- prices[-c(1,length(prices)-1,length(prices))] # remove the first and two last elements
tmp_m2_rooms <- real_estate %>% html_nodes("strong") %>% html_text() 
m2_rooms <- rep(NA_character_, 2 * length(prices))
m2_rooms[1:3] <- tmp_m2_rooms[1:3]
m2_rooms[5:(2*length(prices))] <- tmp_m2_rooms[4:length(tmp_m2_rooms)]
m2 <- m2_rooms[seq(2, length(m2_rooms), 2)]
rooms <- m2_rooms[seq(1, length(m2_rooms), 2)]

flats_df <- data.frame(
  rooms = gsub(pattern = "\\s*rooms", "", rooms) %>%
    as.numeric(),
  meter_square = gsub("m²","",m2) %>% 
    as.numeric(),
  price = gsub("\\s*CHF\\s*", "", prices) %>%
    gsub(pattern = "\\W", replacement = "") %>%
    as.numeric()
)

# 3. Repeat exercise 2. using `RSelenium` or `chromote`. 
library(chromote)
b <- ChromoteSession$new()
b$Page$navigate("https://www.immoscout24.ch/en/real-estate/rent/city-basel")
tmp_m2_rooms <- b$Runtime$evaluate("document.querySelector('html').outerHTML")$result$value %>% 
  read_html() %>% 
  html_nodes("strong") %>% 
  html_text()
prices <- b$Runtime$evaluate("document.querySelector('html').outerHTML")$result$value %>% 
  read_html() %>% 
  html_nodes("span + span") %>% 
  html_text()
# then as in 2.
b$close()

# Note you can use b$screenshot("browser.png") to take a screenshot of the browser window.
# Result might differ from the one obtained with rvest because the website might have changed or display differently in chromote.

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
