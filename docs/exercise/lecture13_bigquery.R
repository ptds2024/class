# Install the bigrquery package
# install.packages("bigrquery")

# Load the library and authenticate
library(bigrquery)
bq_auth()

# Run a query
query <- "SELECT country, pollutant, value 
          FROM `bigquery-public-data.openaq.global_air_quality` 
          WHERE country = 'US'
          LIMIT 5"
result <- bq_project_query("programming-tool-1538566586951", query)
data <- bq_table_download(result)
head(data)


query <- "WITH time AS (  
    SELECT DATE(block_timestamp) AS trans_date  
    FROM `bigquery-public-data.crypto_bitcoin.transactions`  
)  
SELECT COUNT(trans_date) AS transactions, trans_date  
FROM time  
GROUP BY trans_date  
ORDER BY trans_date DESC"
result <- bq_project_query("programming-tool-1538566586951", query)
data <- bq_table_download(result)
save(data, file="docs/lecture13_bigquery2.rds")

library(ggplot2)
library(hrbrthemes)
p <- ggplot(data, aes(x=trans_date, y=transactions)) +
  geom_line( color="#69b3a2") + 
  xlab("Time") + ylab("Number of Transactions") +
  theme_ipsum() +
  theme(axis.text.x=element_text(angle=60, hjust=1)) +
  ggtitle("Number of Bitcoin Transactions Over Time")
p
