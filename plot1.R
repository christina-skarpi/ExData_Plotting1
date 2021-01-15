#!/usr/bin/env Rscript


## Load the nesesairy libraries
library(data.table)
library(dplyr)
library(sqldf)
#install.packages("sqldf")

## Start reading files
setwd("C:/Users/skarpath/Documents/Coursera_Projects_Data_Science_Specialization/4_Exploratory_data_analysis/assignment_week1")

## get the current date of the dataset downloaded just for future reference if needed. 
dateDownload <- date()

# Download the datasets from the link provided and unzip them
datasetlink <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFile <- "dataset.zip"
if (!file.exists(zipFile)){
  download.file(datasetlink, destfile = zipFile, mode='wb')
}
if (!file.exists("./household_power_consumption")){
  unzip(zipFile)
}

filename <- "household_power_consumption.txt"
fileX <- file(filename)

# Read & store from the dataset only the rows with dates between 1-2/02/2007
dataset <- sqldf("select * from fileX where (Date == '1/2/2007') or (Date == '2/2/2007')",
                 file.format = list(header = TRUE, sep = ";"))

# good practice to close the connection
close(fileX)

#plot1

# Open the png device
png(file = "plot1.png", width = 480, height = 480, units = "px")

# Construct the plot1
hist(dataset$Global_active_power, 
     col = "red", 
     main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)", 
     xlim = c(0,6),
     ylim = c(0,1200),
     xaxt='n')
axis(side=1, at=seq(0,6, 2))

dev.off()
