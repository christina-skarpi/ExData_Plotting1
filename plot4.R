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

## Converting dates and time
datetime <- strptime(paste(dataset$Date, dataset$Time, sep=" "), "%d/%m/%Y %H:%M:%S") 
dataset$weekday <- weekdays(datetime)

# Open the png device
png(file = "plot4.png", width = 480, height = 480, units = "px")

#Setting the parameteres to have multiple plots in 1 view
par(mfrow = c(2,2), mar = c(3,4,3,2))

#Adding plot1
plot(datetime, dataset$Global_active_power, 
     type="l", 
     xlab="", 
     ylab="Global Active Power", 
     ylim = c(0,6),
     yaxt='n')
axis(side=2, at=seq(0,6,2))

#Adding plot2
plot(datetime, dataset$Voltage, ylab = "Voltage",xlab = "", type="l")

# Creating the plot 3
plot(datetime, dataset$Sub_metering_1, xlab = "", ylab = "Energy sub metering", type = "l")

# Adding the additional elements of the graph and the legend
points(datetime, dataset$Sub_metering_2, type = "l", col = "red")
points(datetime, dataset$Sub_metering_3, type = "l", col = "blue")
legend("topright", bty = "n", cex = 0.75, legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), lwd=0)

# Creating the plot 4
plot(datetime, dataset$Global_reactive_power, ylab = "Global_reactive_power", type = "l")

dev.off()