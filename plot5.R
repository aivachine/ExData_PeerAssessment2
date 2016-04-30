##########################################################
# Coursera Exploratory Data Analysis Project 2
# 25/04/2016
# plot5.R
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

# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

# Subset Baltimore data
baltimoreNEI <- NEI[which(NEI$fips == "24510" & NEI$type=="ON-ROAD"), ]

# Aggregate Total by year
aggTotalBaltimore <- with(baltimoreNEI, aggregate(Emissions, by = list(year), sum))
colnames(aggTotalBaltimore) <- c("Years","Total")

### Building and saving the plot ###

# Open the graphics device for PNG format 
png(file=paste(dataDir,"/","plot5.png",sep=""), height=480, width=480)

# Generate the required barplot
barplot(height=aggTotalBaltimore$Total, width = 1.0,
        names.arg=aggTotalBaltimore$Year, 
        main=expression('Motor Vehicle Source Emissions in Baltimore from 1999-2008'),
        xlab="years", 
        ylab=expression('PM'[2.5]*' emission'),
        col='Green')

# Close the png file device
print("Current open device is:")
dev.off()

cat("File 'Plot5.png' was saved to", dataDir)

# Remove ALL objects and clearing memory
#rm(list=ls()) 