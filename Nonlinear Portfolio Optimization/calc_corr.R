#--------------------------------------------------------------------
# Purpose: Feed MySQL Nasdaq schema Correlation (corr) table and 
#          mean stock return (r) table

# Author: Garrett Stephens 
# Create : 12/03/2022
# Edit  : 
#--------------------------------------------------------------------

# Close all existing connections to MySQL ---------------------------
# https://stat.ethz.ch/pipermail/r-help/2006-March/100956.html

# RUN THIS WHEN MAX OUT CONNECTIONS 
#all_cons <- dbListConnections(MySQL())
#for(con in all_cons){
#  dbDisconnect(con)
#}
## check all connections have been closed
#dbListConnections(MySQL())
#list()

### SET UP ----------------------------------------------------------
setwd('C:/Users/gsste/BUAD5022_Opt/Nasdaq')
df <- read.csv('M6-NasdaqReturns.csv')

CurrentTime <- Sys.time()

# Connect to MySQL 
library(RMySQL)

con <- dbConnect(RMySQL::MySQL(), dbname='nasdaq',
                 username='root',password='root')
dbListTables(con)

### CREATE MEAN RETURN BY STOCK TICKER AND QUERY TO MYSQL NASDAQ ----

# convert source to data frame to calculate mean return by stock

#compute the mean of the row respective to stock ticker 
dfMean <- data.frame(df[ ,-c(1,2,3)])
Means <- rowMeans(dfMean)

StDev <- sd(dfMean[1,],na.rm=FALSE)

# install.packages("matrixStats") <-- to use rowSds to find std dev
library(matrixStats)
dfm <- data.matrix(df[ ,-c(1,2,3)]) #needs to be matrix or vector format
SD <- rowSds(dfm)

#query in each stock's mean return into MYSQL 
for ( i in 1:length(Means) ){
  #send this new sql statements to mysql 
  query <- sprintf("insert into r (stock,meanReturn,SD) values ('%s','%s','%s')",
                   df$StockSymbol[i],Means[i],SD[i]);
  dbSendQuery(con, query)
}

### CREATE CORRELATION DATA AND QUERY TO MYSQL NASDAQ SCHEMA --------

# convert to a numeric matrix excluding first columns
dfm <- data.matrix(df[ ,4:123])
# use stock names to name the rows
rownames(dfm) <- df$StockSymbol

# Put in column vectors (transpose)
dft <- t(dfm)

#Compute correlations (pairwise) between each column vector
# the cor() function will expect all data to be in vector format
small <- cor(dft) #subset...
#round(small)

# command to melt the correlation matrix
library(reshape2)
smelt <- melt(small)

dbReadTable(con, "Corr")

for ( i in 1:nrow(smelt) ){
  #send this new sql statements to mysql 
  query <- sprintf("insert into corr (stock1,stock2,cor) values ('%s','%s',%s)",
                   smelt[i, 1],smelt[i, 2],smelt[i, 3]);
  dbSendQuery(con, query)
}

### COMPLETE --------------------------------------------------------

#get R to alert you when script is finished
# install.packages("beepr")
library(beepr)
beep()

TimeAfterRun <- Sys.time()
RunTime <- difftime(CurrentTime, TimeAfterRun, units="mins")
RunTime