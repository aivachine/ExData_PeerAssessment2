##########################################################
# Coursera Exploratory Data Analysis Project 2
# 25/04/2016
# plot6.R
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

# Compare emissions from motor vehicle sources in Baltimore City 
# with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?

# Subset Baltimore data
baltimoreNEI <- NEI[which(NEI$fips == "24510" & NEI$type=="ON-ROAD"), ]

# Subset Baltimore data
losAngelesNEI <- NEI[which(NEI$fips == "06037" & NEI$type=="ON-ROAD"), ]

# Aggregate Total by year
aggTotalBaltimore <- with(baltimoreNEI, aggregate(Emissions, by = list(year), sum))
colnames(aggTotalBaltimore) <- c("Years","Total")

aggTotalLosAngeles <- with(losAngelesNEI, aggregate(Emissions, by = list(year), sum))
colnames(aggTotalLosAngeles) <- c("Years","Total")

aggTotalBaltimore[["City"]] <- "Baltimore City"
aggTotalLosAngeles[["City"]] <- "Los Angeles"

emissions <- rbind(aggTotalBaltimore, aggTotalLosAngeles)


### Building and saving the plot ###

# Open the graphics device for PNG format 
png(file=paste(dataDir,"/","plot6.png",sep=""), height=480, width=480)

# Generate the required barplot
gplot <-ggplot(data=emissions, aes(x=factor(Years), y=Total ,fill=City)) + 
  facet_grid(. ~ City) + 
  geom_bar(stat="identity")  + 
  scale_fill_manual(values=c("#9999CC","#66CC99"))+
  labs(x="Year")+
  labs(y=expression("PM"[2.5]*" Emission")) + 
  labs(title=expression("Emissions from motor vehicle in Baltimore City vs Los Angeles"))

print(gplot)

# Close the png file device
print("Current open device is:")
dev.off()

cat("File 'Plot6.png' was saved to", dataDir)

# Remove ALL objects and clearing memory
#rm(list=ls()) 