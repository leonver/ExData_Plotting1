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

#Create plots
    png("plot4.png", width=480, height=480)
    par(mfrow = c(2,2))
    
    #create graph top left
        plot(subset.data$datetimes, 
             subset.data$Global_active_power,
             type = "l",
             xlab = "",
             ylab = "Global Active Power (kilowatts)"
        )
    
    #Create graph top Right
        plot(subset.data$datetimes, 
             subset.data$Voltage,
             type = "l",
             xlab = "datetime",
             ylab = "Voltage"
        )
    
    
    #Create graph bottom Left
        plot(subset.data$datetimes, 
             subset.data$Sub_metering_1,
             type = "l",
             xlab = "",
             ylab = "Energy sub metering"
            )
        lines(subset.data$datetimes, 
              subset.data$Sub_metering_2,
              type = "l",
              col= "red")
        lines(subset.data$datetimes, 
              subset.data$Sub_metering_3,
              type = "l",
              col= "lightblue")
        legend("topright",
               legend= c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
               lty = 1,
               lwd = 1,
               col= c("black", "red", "lightblue")
              )
    
    #Create graph bottom Right
        plot(subset.data$datetimes, 
             subset.data$Global_reactive_power,
             type = "l",
             xlab = "datetime",
             ylab = "Global_reactive_power"
        )
    
    dev.off()