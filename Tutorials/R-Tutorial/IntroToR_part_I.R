###############################
### TA2 - Introduction to R ###
###############################

# Make sure you have the most recent version of R installed on your notebook

#########################################
# Before we start: how to open Markdown #
#########################################
# Go to 'file' ---> 'New File' ---> 'R Markdown'
# You may get a message asking to install 1 or more packages. Do it.
# Then you have to select the 'type' of document you want to produce
# Select 'document' (you may notice you can also prepare presentations)
# Type the title of the document (example: "Problem Set 1")
# Type the author(s)
# Select output format (I would say 'pdf') then press 'ok'
# A new document will open. Save it in subfolder within your working folder.
# Then you can start using the document. I will provide a template that you can look at.


# Install useful packages
packs <- c("foreign","dplyr","tidyr","ggplot2","stargazer","reshape2","readr","haven","dummies","Hmisc",
           "lmtest","sandwich", "doBy", "readxl", "multiwayvcov", "miceadds", "car", "purrr", "knitr")

for (i in packs) {
  install.packages(paste("",i,sep=""))
}

# To upload a package use function library("package_name")
library(foreign)
library(dplyr)
library(tidyr)
library(plyr) 
library(ggplot2)
library(stargazer)
library(reshape2)
library(readr)
library(haven)
library(dummies)
library(Hmisc)
library(lmtest)
library(sandwich)
library(doBy)
library(readxl)
library(multiwayvcov)
library(miceadds)
library(car)
library(stringr)
library(datasets)
library(purrr)

### Always clear the working space before you start

rm(list=ls())

### Set your working directory and create subfolders
setwd("C:/Users/ramon/Desktop/UZH/Empirical Methods/Tutorials/R-Tutorial")
# put your own!!

### Create subfolder within main directory
if(!file.exists("data")){
  dir.create("data")
}

### Show what's inside folder "data"
list.files("./data")

### Asking R for help
# What if you see a function and do not know/understand what that is?

# Access the help file with description
?setwd

# Search help files (there will be the one you are looking for, plus many more)
help.search("setwd")

# Get arguments (not so interesting for 'setwd'.. try with standard normal
# distribution 'rnorm', see what happens)
args("rnorm")

#### Importing a dataset from an external source ####

# Store the url as an object
fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"

# Download the file. Important parameters: destination file, for example
download.file(fileUrl,destfile="./data/cameras.csv")
list.files("./data")

# Show downloaded date
dateDownloaded <- date()
dateDownloaded

#### Read dataset into R Studio

# 'read.table' function
cameraData <- read.table("./data/cameras.csv", sep=",", header=TRUE)
head(cameraData)
tail(cameraData)

# Browse your data
View(cameraData)
# ...or click on the right of the dataset ---->

# Remove dataset
rm(cameraData)

# Remove multiple objects --> see what happens there --> (look right)?
rm(fileUrl, dateDownloaded)

# Re-open the file using 'read.csv' funcion
cameraData <- read.csv("./data/cameras.csv")
head(cameraData)

#### Clean and transform data
# Install (if necessary) and load packages dplyr and tidyr

#  Make folder (it should already be there by now)
if(!file.exists("./data")){
  dir.create("./data")
}

# Make handle (not necessary but useful)
fileURL <- "https://github.com/DataScienceSpecialization/courses/blob/master/03_GettingData/dplyr/chicago.rds?raw=true" 

# Download data
download.file(fileURL, destfile = "./data/chicago.rds", mode = "wb", extra='-L')
list.files("./data")

# Read data from R format ('R Data Set'..I think)
chicago <- readRDS("./data/chicago.rds")

# Check dimension of your matrix (how many rows[i.e. observations]? how many columns[i.e. variables]?)
dim(chicago)

# Label variables (why would you do that?)
# Package required: Hmisc

install.packages("Hmisc")
label(chicago$city) <- "City"


Hmisc::label(chicago[[1]]) <- "City"
Hmisc::label(chicago[[3]]) <- "Dew Point Temperature"

# Subset
chicago2 <- subset(chicago, select=c("tmpd", "dptp"))

# Restrictions
chicago3 <- filter(chicago, tmpd > 40)

# Rename var
chicago <- rename(chicago, dewpoint = dptp, pm25 = pm25tmean2)

# Display (from the top/head) the first five columns of the dataset
head(select(chicago, 1:5))

# Display variable names of first 3 columns
names(chicago)[1:3]

# Select which data to display according to variable names
head(select(chicago, city:dptp))

# Set conditions using 'filter' (from dplyr)
chic.f <- filter(chicago, pm25tmean2 > 30)

# Set joint conditions on different variables
chic.f <- filter(chicago, pm25tmean2 > 30 & tmpd > 80)
# Notice this overwrites the previous version of chic.f
head(select(chic.f, 1:3, pm25tmean2, tmpd), 10)

# Sort data by date - choose how to display them (from the top or bottom)
chicago <- arrange(chicago, date)
head(select(chicago, date, pm25tmean2), 3)
tail(select(chicago, date, pm25tmean2), 3)

chicago <- arrange(chicago, desc(date))
head(select(chicago, date, pm25tmean2), 3)
tail(select(chicago, date, pm25tmean2), 3)

# Renaming variables in R (it's much easier in STATA..)
chicago <- rename(chicago, dewpoint = dptp, pm25 = pm25tmean2)
# Check if it worked. You may have to add dplyr:: in front of rename
# as 'rename' function may be in conflict with other packages
chicago <- dplyr::rename(chicago, dewpoint = dptp, pm25 = pm25tmean2)

### Generating / transforming variables in R
# Option 1
chicago$pm25detrend <- chicago$pm25-mean(chicago$pm25, na.rm=TRUE)

# Option 2
chicago <- mutate(chicago, pm25detrend=pm25-mean(pm25, na.rm=TRUE))

# Option 3
newvar1 <- chicago$pm25-median(chicago$pm25, na.rm=TRUE)
newvar2 <- chicago$pm25-mean(chicago$pm25, na.rm=TRUE)
# Don't change the way obs are sorted!
chicago <- cbind(chicago, newvar1, newvar2)

# Generating a categorical binary variable (example "hot" if tmpd > 80)
# Option 1 (fast way)
chicago <- mutate(chicago, tempcat = factor(1*(tmpd > 80), labels = c("cold", "hot")))
head(select(chicago, tmpd, tempcat), 200) # this displays first 200 obs.

# Option 2 (bit slower)
chicago$tempcat[is.na(chicago$tmpd) == FALSE] <- "cold"
chicago$tempcat[chicago$tmpd>80 & is.na(chicago$tmpd) == FALSE] <- "hot"
# You can use == (exactly equal), >, <, <=, >=, or != (not equal)
# While & sets joint conditions, | means "or"
# You cannot say chicago$tmpd!=NA to say "if tmpd is not missing"
# You need to use is.na(variable_name)==TRUE/FALSE

# Transform categorical into numeric variable
chicago$burning <- as.numeric(chicago$tempcat=="hot")
chicago$cooling <- as.numeric(chicago$tempcat=="cold")

# Erase a variable
chicago$newvar1 <- NULL

#### Showing some summary statistics (jump to Rmd template as well)
## Basic summaries
# Let's first create a folder for figures and tables

if(!file.exists("Figures&Tables")){
  dir.create("Figures&Tables")
}

# Simple table of summary statistics --> you can show in Rmd
stargazer(chicago, type="text")

# Do it also for a subset of your variables and export
stargazer(subset(chicago, select=c(pm25, pm10tmean2, burning)), out="./Figures&Tables/Table1.html")

## Summaries by group
# Example 1: by 'tempcat'
hotcold <- group_by(chicago, tempcat) # group obs. in dataset by 'tempcat'
dplyr::summarize(hotcold, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

# Example 2: by 'year'
chicago <- mutate(chicago, year = as.POSIXlt(date)$year+1900)
years <- group_by(chicago, year)
dplyr::summarize(years, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2, na.rm = TRUE), no2 = median(no2tmean2, na.rm = TRUE))

# Example 3: by 'month'
# I introduce here the "then" operator: %>%
chicago %>% mutate(month = as.POSIXlt(date)$mon + 1) %>% group_by(month) %>% dplyr::summarize(pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2, na.rm = TRUE), no2 = median(no2tmean2, na.rm = TRUE))
# This reads:
# 1- take dataset chicago --> THEN
# 2- create month variable --> THEN
# 3- group obs by month --> THEN
# 4- summarize by group

# BUT, if you want to export in a nice format
# Option 1 -> creates 2 tables (requires 'purrr' package)
chicago %>%
  split(. $tempcat) %>%
  walk(~ stargazer(.))

# Option 2 -> does it in just 1 table
require(reporttools)
tosum <- subset(chicago, select = c(tmpd, dewpoint, pm25, o3tmean2))
group <- chicago[,c('tempcat')]
tableContinuous(vars = tosum, group = group, prec = 1, cap = "Table of summaries by 'tempcat' ", file = "./Figures&Tables/Table2.tex")
# CHALLENGE FOR YOU: I haven't figured out (yet) how to export this table to .html

#### Some basic plots ####
# 'library(datasets)' --> The R Datasets package. We are going to use dataset 'airquality'
# First step: learning some plots functions. Second: learn how to make graphs look nicer

# Basic histogram
hist(airquality$Ozone)

# Scatter plot
with(airquality, plot(Wind, Ozone))

# Display boxplots (default by group)
airquality <- transform(airquality, Month = factor(Month))
boxplot(Ozone ~ Month, airquality, xlab = "Month", ylab = "Ozone")

# Add a title to graph
with(airquality, plot(Wind, Ozone))
title(main = "Ozone and Wind in New York City")
#..or in 1 line
with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in New York City"))

# Change color of a subset of your datapoints
with(subset(airquality, Month == 5), points(Wind, Ozone, col = "blue"))

# Add a legend
with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in New York City", type = "n"))
with(subset(airquality, Month == 5), points(Wind, Ozone, col = "blue"))
with(subset(airquality, Month != 5), points(Wind, Ozone, col = "red"))
legend("topright", pch = 1, col = c("blue", "red"), legend = c("May", "Other Months"))
# alternative to 'topright': "bottomright", "bottom", "bottomleft", "left", "topleft", "top", "topright", "right" and "center"
# you can also change background color using bg='somecolor', e.g. bg='lightblue'
# you can also change the font, e.g. text.font=1 (or 2,3,4)
# you can also add a title, e.g. title="Legend"
# arguments box.lty, box.lwd and box.col can be used to modify the line type, width and color for the legend box border
# example w/ box removal: box.lty=0
# you can even specify if you want it horizontally (default is 'false'), e.g. horiz=TRUE