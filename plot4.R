##########################################################
# Coursera Exploratory Data Analysis Project 2
# 25/04/2016
# plot4.R
##########################################################

### Data Loading and Preprocessing ###

#Load required packages
if (!require("ggplot2")) {
  install.packages("ggplot2")
}

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

# Across the United States, how have emissions from coal combustion-related 
# sources changed from 1999–2008?

# Subset coal combustion related SCC data
coalSCC = SCC[grep("coal", SCC$Short.Name, ignore.case=TRUE),]

# Merge the SCC and NEI datasets
mergedEmissions <- merge(x=coalSCC, y=NEI, by='SCC')

# Aggregate Emissions for coal combustion related SCC by year
aggregatedEmissions <- aggregate(Emissions ~ year, mergedEmissions, sum)

### Building and saving the plot ###

# Open the graphics device for PNG format 
png(file=paste(dataDir,"/","plot4.png",sep=""), height=480, width=480)

# Generate the required plot
gplot <- ggplot(aggregatedEmissions, aes(factor(year), Emissions/1000)) +
         geom_point(aes(size=1,col=Emissions)) +
         geom_line(aes(group=1, col=Emissions))+
         labs(x = "Year") + 
         labs(y = expression("Total Emissions, PM"[2.5]*" in kilotons")) + 
         labs(title = "Emissions from coal combustion-related sources")

print(gplot)

# Close the png file device
print("Current open device is:")
dev.off()

cat("File 'Plot4.png' was saved to", dataDir)

# Remove ALL objects and clearing memory
#rm(list=ls()) 