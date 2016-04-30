##########################################################
# Coursera Exploratory Data Analysis Project 2
# 25/04/2016
# plot2.R
##########################################################

### Data Loading and Preprocessing ###

# Set working directory
# mentioned folder must be created firstly!
#setwd("C:/Users/ai/Documents/Courses/Exploratory Data Analysis/Course project")

# Set variables
dataDir <- "./data"
zipFile <- "./data/Dataset.zip"
zipUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
dataFile1 <- "./data/summarySCC_PM25.rds"
dataFile2 <- "./data/Source_Classification_Code.rds"

# Create /data directory if not exists download the archive
if(!file.exists(dataDir)){dir.create(dataDir)}

# Skips the download step if the archive is already downloaded and unzipped
if (!(file.exists(dataFile1)&file.exists(dataFile2))) {
  download.file(zipUrl, destfile = zipFile)
  unzip(zipFile, exdir=dataDir)
  file.remove(zipFile)
}

# Reading the files
NEI <- readRDS(dataFile1)
SCC <- readRDS(dataFile2)

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
# (fips == "24510")from 1999 to 2008? 
# Use the base plotting system to make a plot answering this question.

baltimoreNEI <- NEI[which(NEI$fips == "24510"), ]

# Aggregate
aggTotalBaltimore <- with(baltimoreNEI, aggregate(Emissions, by = list(year), sum))
colnames(aggTotalBaltimore) <- c("Years","Total")


### Building and saving the plot ###

# Open the graphics device for PNG format 
png(file=paste(dataDir,"/","plot2.png",sep=""), height=480, width=480)

# Generate the required barplot
barplot(height=aggTotalBaltimore$Total/1000, width = 1.0,
        names.arg=aggTotalBaltimore$Year, 
        main=expression('Total PM'[2.5]*' emissions by year in the Baltimore City'),
        xlab="years", 
        ylab=expression('PM'[2.5]*' emission in Kilotons'),
        col='Red')

# Close the png file device
print("Current open device is:")
dev.off()

cat("File 'Plot2.png' was saved to", dataDir)

# Remove ALL objects and clearing memory
#rm(list=ls()) 