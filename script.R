# extract the data from the archive
unzip("activity.zip")

# read the data from the file into a dataframe
df <- read.csv("activity.csv", colClasses = c("integer", "Date", "integer"))

# plot histogram of steps per day
ggplot(remove_missing(df, na.rm=T), aes(date, steps)) + geom_bar(stat="identity")

# Calculate and report the mean and median of the total number of steps taken per day
stepsPerDay <- aggregate(df$steps, by=list(dt=df$date), FUN=sum)
spdMean <- mean(stepsPerDay$x, na.rm = TRUE)
spdMedian <- median(stepsPerDay$x, na.rm = TRUE)

# time series plot of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)
avgSteps <- aggregate(df$steps, by=list(interval=df$interval), FUN=mean, na.rm=TRUE)
ggplot(avgSteps, aes(interval, x)) + geom_line()

# 5-minute interval contains the maximum number of steps
subset(avgSteps, x == max(avgSteps$x))$interval

# Calculate and report the total number of missing values in the dataset 
incomplete <- sum(!complete.cases(df))

# Impute missing cases
merged <- merge(df, avgSteps, by="interval")
missing <- is.na(merged$steps)
merged[missing, ]$steps <- merged[missing, ]$x
imputed <- merged[c("steps", "date", "interval")]

# Calculate the total number of steps taken per day
stepsPerDay2 <- aggregate(imputed$steps, by=list(imputed=imputed$date), FUN=sum)

# plot histogram of steps per day
ggplot(imputed, aes(date, steps)) + geom_bar(stat="identity")

# Calculate and report the mean and median of the total number of steps taken per day
spdMean2 <- mean(stepsPerDay2$x, na.rm = TRUE)
spdMedian2 <- median(stepsPerDay2$x, na.rm = TRUE)

# add weekday info
isWeekend <- weekdays(imputed$date) %in% c("Saturday", "Sunday")
imputed$isWeekend <- factor(ifelse(isWeekend, "weekend", "weekday"))

# a time series plot of the 5-minute interval and the average number of steps
# taken, averaged across all weekday days or weekend days
library(lattice)
grouping <- list(interval=imputed$interval, isWeekend = imputed$isWeekend)
avgSteps <- aggregate(imputed$steps, by=grouping, FUN=mean)
xyplot(x ~ interval | isWeekend, avgSteps, type="l", layout=1:2)
