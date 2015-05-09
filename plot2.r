## this script creates a historgram from data downloaded from the internet.

# Conditional download data from the internet

    # Create a data folder for the data to download
        if (!file.exists("downloaddata")) 
        {
            dir.create("./downloaddata")
        }
    
    #name to give to the dataset to download
        dataset.zip <- "./downloaddata/dataset.zip"
    
    #check if the data is already present in the folder
        if (!file.exists(dataset.zip))
        {
            #location of the file to download
            downloadurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
            #execute download
            download.file(downloadurl, destfile=dataset.zip, mode="wb")
            #extract the data from the zipfile
            unzip(dataset.zip, exdir="./downloaddata")
        }

#Create and adjust org.data set when the data set is not present in memory 
    if (!exists("org.data"))
    {    
        filename <- "./downloaddata/household_power_consumption.txt"
        #read data from csv
            org.data <-  read.csv(file= filename, header=TRUE, sep=";", na.strings="?")
        #convert Date Time to R datetime stamp
            org.data$datetimes <- strptime(paste(org.data$Date, org.data$Time), "%d/%m/%Y %H:%M:%S")
        #convert date R date format
            org.data$Date <- as.Date(org.data$Date, format="%d/%m/%Y")
    }    
    
#Create subset.data when the data set does not exist in memory
    if (!exists("subset.data"))
    {    
        #Create Subset
            subset.data <- org.data[org.data$Date %in% c(as.Date("2007-02-01"), as.Date("2007-02-02")),]
    }     

#Create plot
    png("plot2.png", width=480, height=480)
    plot(subset.data$datetimes, 
         subset.data$Global_active_power,
         type = "l",
         xlab = "",
         ylab = "Global Active Power (kilowatts)"
        )
    dev.off()