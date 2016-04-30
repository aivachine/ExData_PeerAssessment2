##########################################################
# Coursera Exploratory Data Analysis Project 2
# 25/04/2016
# plot3.R
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

# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
# which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
# Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make 
# a plot answer this question.

baltimoreNEI <- NEI[which(NEI$fips == "24510"), ]


### Building and saving the plot ###

# Open the graphics device for PNG format 
png(file=paste(dataDir,"/","plot3.png",sep=""), height=480, width=600)

# Generate the required plot
gplot <-ggplot(data=baltimoreNEI, aes(x=factor(year), y=Emissions,fill=type)) + 
  facet_grid(. ~ type) + 
  geom_bar(stat="identity")  + 
  scale_fill_manual(values=c("#CC6666","#FFFF66","#9999CC","#66CC99"))+
  labs(x="Year")+
  labs(y=expression("PM"[2.5]*" Emission")) + 
  labs(title=expression("Total Emissions in Baltimore City by Source Type (1999-2008)"))

print(gplot)

# Close the png file device
print("Current open device is:")
dev.off()

cat("File 'Plot3.png' was saved to", dataDir)

# Remove ALL objects and clearing memory
#rm(list=ls()) 