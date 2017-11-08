## Houskeeping
library(readr)
library(dplyr)
library(lubridate)
if(!file.exists("./data")){dir.create("./data")}

## Download data 
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,destfile="./data/power.zip")

## Read data into a tibble
data <- read_delim("./data/power.zip",";")

## Change dates
data$Date <- dmy(data$Date)

## Save typing finger muscles and extract rows from 2/1/07 and 2/2/07
data <- rename(data,date=Date,time=Time,actpower = Global_active_power,reactpower = Global_reactive_power, volt=Voltage, inten = Global_intensity,submet1 = Sub_metering_1, submet2 = Sub_metering_2,submet3 = Sub_metering_3 )
data <- filter(data,year(date)==2007 & month(date)==2 & (day(date)==1 | day(date)==2))

## Add a datetime vector
data <- mutate(data,datetime = ymd_hms(as.POSIXct(paste(date,time))))

## Plot 3
## Put stratified time series lines and legend into plot3.png
png("plot3.png",width=480,height=480,bg="transparent")
with(data,plot(datetime,submet1, type="n",xlab="",ylab="Energy sub metering") +
       lines(datetime,submet1,type="l",col="black") +
       lines(datetime,submet2,type="l",col="red") +
       lines(datetime,submet3,type="l",col="blue"))
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=1,col=c("black","red", "blue"))
dev.off()