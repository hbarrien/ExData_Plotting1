#  --------------- PLOT 3 ---------------

# Set the download URL, the download directory name, the downloaded zip file name, and resulting (unzipped) data directory name
dataDownloadURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
projectDir      <- paste0(getwd(), "/_exploratorydata/")
downloadDir     <- paste0(projectDir, "/prj1/")
downloadZipName <- paste0(downloadDir, "powerconsumptiondata.zip")
dataDirName     <- paste0(downloadDir, "powerconsumption")

# Make sure the project directory exists
if (!file.exists(projectDir))
  dir.create(projectDir)

# Make sure the download directory exists
if (!file.exists(downloadDir))
  dir.create(downloadDir)

# Download and unzip the data files. Overwrite exisiting file, if any
download.file(dataDownloadURL, destfile=downloadZipName)
unzip(zipfile=downloadZipName, exdir=dataDirName)

# Set the working directory name for this project
projectWD <- paste0(dataDirName, "/")

# Read in the data file
dataFname <- paste0(projectWD, "household_power_consumption.txt")
powerConsumptionDT <- read.csv(dataFname, sep = ";", na.strings = "?", header = TRUE, colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))

# Convert date column
powerConsumptionDT$Date <- as.Date( strptime(powerConsumptionDT[,1], "%d/%m/%Y") )
dateRange  <- powerConsumptionDT$Date >= as.Date("2007-02-01") & powerConsumptionDT$Date <= as.Date("2007-02-02")
dataSubset <- powerConsumptionDT[dateRange,]

# Convert the time column
datetime <- paste(as.Date(dataSubset$Date), dataSubset$Time)
dataSubset$Time <- as.POSIXct(datetime)

# Clear memory by removing variables not needed anymore
rm(dataDownloadURL)
rm(projectDir)
rm(downloadDir)
rm(downloadZipName)
rm(dataDirName)
rm(powerConsumptionDT)
rm(dateRange)

# Clear any incomplete rows
dataSubset <- dataSubset[complete.cases(dataSubset),]

# Create a PNG file for plot3: colored lines + legend
png(filename = paste0(projectWD, "plot3.png"), width=480, height=480, units='px')

with(dataSubset, 
     {
       plot( Sub_metering_1 ~ Time, type = "l", ylab = "Energy sub metering", xlab = "" )
       lines(Sub_metering_2 ~ Time, col = "red")
       lines(Sub_metering_3 ~ Time, col = "blue")
     })

legend("topright", col = c("black", "red", "blue"), lty = 1, lwd = 2, 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.off()
