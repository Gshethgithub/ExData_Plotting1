##This program will plot four plots:
##Author: Gopali Sheth
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

##Build plots abd set columns and rows:
##Build columns and rows:
par(mfrow=c(2,2), mar=c(3.9,3.9,3.9,2), tcl = -0.3)
##Topleft plot:
##This gives time series plot for Global active power by weekdays:
ts.plot(as.numeric(as.character(hpch$Global_active_power)), gpars=list(xaxt="n"), ylim=c(0, 6.5), ylab="Global Active Power (kilowatts)", xlab="")
times <- time(as.numeric(as.character(hpch$Global_active_power)))
ticks <- seq(times[1], times[length(times)], by =1400)
axis(1, at = ticks, labels=c("Thur", "Fri", "Sat"))
##Topright plot:
ts.plot(as.numeric(as.character(hpch$Voltage)), gpars=list(xaxt="n"), ylim=c(234, 246), ylab="Voltage", xlab="datetime")
times <- time(as.numeric(as.character(hpch$Global_active_power)))
ticks <- seq(times[1], times[length(times)], by =1400)
axis(1, at = ticks, labels=c("Thur", "Fri", "Sat"))
##Bottomleft plot:
ts.plot(as.numeric(as.character(hpch$Sub_metering_1)), gpars=list(xaxt="n"), ylim=c(0, 38), ylab="Energy sub metering",  xlab="")
times <- time(as.numeric(as.character(hpch$Global_active_power)))
ticks <- seq(times[1], times[length(times)], by =1400)
axis(1, at = ticks, labels=c("Thur", "Fri", "Sat"))
lines(as.numeric(as.character(hpch$Sub_metering_2)), col="red")
lines(as.numeric(as.character(hpch$Sub_metering_3)), col="blue")
##legend("topright", c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), xpd=TRUE, horiz=FALSE, inset=c(10,1), cex=0.6, lwd=2, bty="n", lty=c(1,1,1), col=c("black","red","blue"))
legend("topright", "right", c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), xpd=TRUE, horiz=FALSE, cex=0.3, lwd=3, bty="n", lty=c(1,1,1), col=c("black","red","blue"))
##Bottomleft plot:
ts.plot(as.numeric(as.character(hpch$Global_reactive_power)), gpars=list(xaxt="n"), ylim=c(0.0, 0.5), ylab="Global_reactive_power", xlab="datetime")
##axis(1, at=c(2,1500,2900), labels=c("Thur", "Fri", "Sat"))
times <- time(as.numeric(as.character(hpch$Global_active_power)))
ticks <- seq(times[1], times[length(times)], by =1400)
axis(1, at = ticks, labels=c("Thur", "Fri", "Sat"))


dev.copy(png, file = "plot4.png", width=680, height=780)
dev.off()
