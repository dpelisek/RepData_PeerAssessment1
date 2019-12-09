---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---


## Loading and preprocessing the data analysis

```r
# extract the data from the archive
unzip("activity.zip")

# read the data from the file into a dataframe
df <- read.csv("activity.csv", colClasses = c("integer", "Date", "integer"))
```

## What is mean total number of steps taken per day?

```r
stepsPerDay <- aggregate(df$steps, by=list(dt=df$date), FUN=sum)
```

## What is the average daily activity pattern?



## Imputing missing values



## Are there differences in activity patterns between weekdays and weekends?
