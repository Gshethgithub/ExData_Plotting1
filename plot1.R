##This program will plot the histogram of Global Active Power:
##Author: G. Sheth
##Date: 03/07/2015

##Call needed library packages:
library(datasets)
library(graphics)
library(lubridate)

##Set working directory:
setwd("~/")

##Read in the data:
hpc <- read.table("~/household_power_consumption.txt", header = TRUE, sep= ";")

##Test to see classes of all 9 variables in this data frame:
##getfiverows <- read.table("~/household_power_consumption.txt", header = TRUE, sep= ";", nrows = 5)
##classes <- sapply(getfiverows, class)
##Output:
##Date                  Time   Global_active_power Global_reactive_power 
##"factor"              "factor"             "numeric"             "numeric" 
##Voltage      Global_intensity        Sub_metering_1        Sub_metering_2 
##"numeric"             "numeric"             "numeric"             "numeric" 
##Sub_metering_3 
##"numeric" 

##Cast the variables and add them back into the data frame:
hDate <- strptime(as.character(hpc$Date), format="%d/%m/%Y")
hTime <- strptime(as.character(hpc$Time), format="%H:%M:%S")
hpc <- data.frame(hpc, hDate)
hpc <- data.frame(hpc, hTime)

##Check to see which variable has missing values:
##apply(apply(hpc, 2, is.na), 2, sum)
##Replace question mark with zero:
hpc$Sub_metering_3[hpc$Sub_metering_3 == "?"] <- "0"

##We will only be using data from the dates 2007-02-01 and 2007-02-02. 
##Give me just the data within this date range and put into hpch:
hpch <- hpc[(hpc$hDate=="2007-02-01") | (hpc$hDate=="2007-02-02"),]

##Transform to timestamp:
hpch <- transform(hpch, htimestamp=as.POSIXct(paste(hpch$hDate, hpch$hTime),format="%Y-%m-%d %H:%M:%S"))

##Build histogram:
hist(as.numeric(as.character(hpch$Global_active_power)), main="Global Active Power", col ="red", ylim=c(0, 1200), xlab="Global Active Power (kilowatts)", ylab="Frequency")

##Send histogram to a png file:
dev.copy(png, file = "plot1.png", width=480, height=480)
dev.off()

