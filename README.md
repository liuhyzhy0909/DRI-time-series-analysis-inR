R-time-series-analysis
======================

time series interpolation and cross correlation analysis


User guide for heavy hauler emissions project using R code for TS analysis
by Will Rudebusch 
R code finished March 2014
readme edited Feb 2016

Table of Contents 
Chapter 1 - Engine Data
Section A - Caterpillar Engine Data 
Section B - Liebherr Engine  Data
Section C - Komatsu Engine Data
Chapter 2 - DRX Data 
Chapter 3 - All Other Sensors 
Chapter 4 - Cross Correlation Function 

Zoo documation: http://cran.r-project.org/web/packages/zoo/vignettes/zoo-quickref.pdf

R does not use Excel file format. So everything needs to be saved as a csv. It is also good practice not to use spaces in filenames because you will soon be entering a  command line environment.

For Example 
"L1-Liebherr June2 emission.xls" becomes "L1-Liebherr_June2_emission.csv"

The overall thrust of this approach is to do the following process with each data set:
1) read in the data correctly, throwing out or skipping bad lines
2) make the correct timestamp if one does not exist
3) make a zoo object that uses the data with the timestamps made in the previous step
4) interpolate the data so that it is continuous
5) output this data
6) read in all the interpolated data and lag it against engine RPM using the CCF
7) output this lagged data

Most scripts are separate for debugging purposes. This is typically based on sensor type. 
for example 130528_C2 has drx, langan, engine, all (bgco2, testo, etc) and lag.

'#' denotes a commented line in R

Chapter 1 - Engine Data
We are given there are three types of engine data. Hence, three different scripts were written.

Chapter 1 - Section A - Caterpillar Engine Data
cat_engine.r
based on the caterpillar engine data.
takes arguments engine data files and start times. 
outputs raw engine data data and an interpolated time series (zoo objects). 
note: this code handles both the wireless data and the remote data and attempts to combine the two at the end (based on timestamps)

Example R code 1-A
Set the working directory to where the engine data csv file lives.
setwd("C:/Users/asus/Desktop/heavy_hauler/Data/130527_C1/EngineData")

Read in the csv file, you have to change this every time, don't worry about the other stuff. 
df <- read.table("C1vimsCDL153-253_LAJ00314.csv", skip=2, fill=T, stringsAsFactors=F, sep=",")

This start time is for 13:53:48
start <- 13*60*60+53*60+48
This makes the date 2013-05-27
a <- as.POSIXct(start, origin="2013-05-27")

The remote data is 4HZ so this had to be converted. using the line
c <- as.integer(nrow(df)/4)*4

Chapter 1 - Section B - Liebherr Engine Data
L_engine.r
Based on the Liebherr engine data.
takes arguments engine data file, start time (for each run) and date.
outputs raw engine data data and an interpolated time series (zoo object). 
note: the user must enter the start and stop times of each run that is in the engine data. 
see below for an example.

Example R code 1-B
Set the working directory to where the engine data csv file lives.
setwd("C:/Users/asus/Desktop/heavy_hauler/Data/130602_L1")

Read in the csv file, you have to change this every time, don't worry about the other stuff. 
df <- read.table("L1-Liebherr_June2_emission.csv", skip=2, fill=T, stringsAsFactors=F, sep=",")

This start time is for 09:21:37 on 2013-06-02
a <- as.POSIXct(start, origin="2013-06-02")
start <- 9*60*60+21*60+37

Taking our start/stop times for each run
run1_start <- 0
run1_stop <- (11*60*60+0*60)-start
Run 1 starts at 09:21:37 (time zero) and ends at 11:00:00
run1 <- engine[run1_start:run1_stop]
Now to run 2
run2_start <- run1_stop+1
run2_stop <- nrow(df)
Run 2 starts at run1 plus one second and stops at the end of the data
run2 <- engine[run2_start:run2_stop]

Chapter 1 - Section C - Komatsu engine data
K_engine.r
Based on the Komatsu engine data. Please save each tab as its own run.
takes arguments engine data file, start time (for each run) and date.
outputs raw engine data data and an interpolated time series (zoo object). 
note: the user must enter the start and stop times of each run that is in the engine data. 
see below for an example.

Example R code 1-C
Set the working directory to where the engine data csv file lives.
setwd("C:/Users/asus/Desktop/heavy_hauler/Data/130526_K2/130526_KamatsuK2_Run1")

Read in the csv file, you have to change this every time, don't worry about the other stuff. 
df <- read.table("K2_engine_run1.csv", skip=1, fill=T, stringsAsFactors=F, sep=",")

This start time is for 09:39:29 on 2013-05-26
a <- as.POSIXct(start, origin="2013-05-26")
start <- 9*60*60+39*60+29

by inspection, find the length of the good data. 
I can't think of a way around this.
df <- df[1:6719,]

Write files
write.zoo(engine, file="engine_run1.csv", sep=",")
write.zoo(new_zoo, file="engine_run1_raw.csv", sep=",")

Chapter 2 - DRX Data

drx.r
takes arguments drx data file, start/stop index for each run.
outputs raw drx raw data and an interpolated time series (zoo object). 
note: the user must enter the start and stop times of each run that appear in the drx data. 
see below for an example.

Example R code 
setwd("C:/Users/asus/Desktop/heavy_hauler/Data/130527_C1")
setwd("/home/will/R/Data/130602_L1")    
Read in txt file
df <- read.table("130602DRX.txt", skip=29, fill=T, sep=",")

Here we set the start and stop indices for each run
start1 <- 3368
end1 <- 8724
Start/stop rows for run2
start2 <- 8753
end2 <- 15090-5

This uses the fact that drx time stamps are correct. this is all kept the same.
time <- paste(df$V1,df$V2)
time <- as.POSIXct(time, format="%m/%d/%Y%T")
clean_data <- data.frame(time,df$V3,df$V4,df$V5,df$V6,df$V7)
colnames(clean_data)<- c("time","pm1","pm2.5","resp","pm10","total")

and see if you're close
if not start with different values for start1/end1
head(drx_run1);tail(drx_run1)

Chapter 3 - All Other Sensors

Thankfully, all of the other sensors (C02bg, CO2tpi, CO2dil, testo, CPC, HNU and GPS) are so similar and limited to one run,  they can be taken care of in a single script with minimal user input.

all_sensors.r
takes filenames, start time and date for GPS.
outputs combined raw data and an interpolated time series (zoo objects) for each sensor. 

Example R code 
Set working directory for drx and read in file
setwd("C:/Users/asus/Desktop/heavy_hauler/Data/130602_L1")
drx_input <- read.csv(file="drx_run1.csv")

Directory for all the other sensors
setwd("C:/Users/asus/Desktop/heavy_hauler/Data/130602_L1/130602_CATL1_Run1")
All the other sensors files
co2bg_input <- read.table("20130602092645_CO2_BG.txt", skip=2, fill=T, sep=",")
co2dil_input <- read.table("20130602092645_CO2_Dil.txt", skip=2, fill=T, sep=",")
co2tpi_input <- read.table("20130602092645_CO2_TPi.txt", skip=2, fill=T, sep=",")
cpc_input <- read.table("20130602092645_CPC.txt", skip=2, fill=T, sep=",")
hnu_input <- read.table("20130602092645_HNU.txt", skip=1, sep=",")
gps_input <- read.table("20130602092645_GPS.txt",skip=1,fill=T)
testo_input <- read.table("20130602092645_Testo350.txt", skip=2, sep=",")

Need gps_start time manually entered this is for 09:26:47 2013-06-02
start_gps <- as.POSIXct(9*60*60+26*60+47, origin="2013-06-02")

Chapter 4 - Cross Correlation Function

read_in.r
takes in all zoo objects made by the other scripts.
outputs aligned zoo object.

Example R code 
Change these files names for DRX data
setwd("C:/Users/asus/Desktop/heavy_hauler/Data/130527_C1")
setwd("/home/will/R/Data/130527_C1")
drx <- read.zoo("drx_run1_z.csv",header=T,tz="",format="%Y-%m-%d %H:%M:%S", sep=",")

Change wd and file name for sensor data
setwd("C:/Users/asus/Desktop/heavy_hauler/Data/130527_C1/130527_CATC1_Run1")
co2bg <- read.zoo("co2bg_z.csv",header=T,tz="",format="%Y-%m-%d %H:%M:%S", sep=",")
co2dil <- read.zoo("co2dil_z.csv",header=T,tz="",format="%Y-%m-%d %H:%M:%S", sep=",")
co2tpi <- read.zoo("co2tpi_z.csv",header=T,tz="",format="%Y-%m-%d %H:%M:%S", sep=",")
cpc <- read.zoo("cpc_z.csv",header=T,tz="",format="%Y-%m-%d %H:%M:%S", sep=",")
hnu <- read.zoo("hnu_z.csv",header=T,tz="",format="%Y-%m-%d %H:%M:%S", sep=",")
gps <- read.zoo("gps_z.csv",header=T,tz="",format="%Y-%m-%d %H:%M:%S", sep=",")
testo <- read.zoo("testo_z.csv",header=T,tz="",format="%Y-%m-%d %H:%M:%S", sep=",")

Change wd and filename for engine data
setwd("C:/Users/asus/Desktop/heavy_hauler/Data/130527_C1/EngineData")
engine <- read.zoo("run1_engine_r.csv",header=T,tz="",format="%Y-%m-%d %H:%M:%S", sep=",")
engine <- na.omit(engine)

Cnalysis starts here  
Cutting up the data to a known engine idle time
stop <- nrow(engine)
start <- stop-(900)

Cutting up engine zoo object
engine_part <- engine[start:stop]
summary(engine_part$rpm)
plot.zoo(engine_part$rpm)
dev.new()
plot.zoo(engine$rpm)

Cutting up HNU zoo object
hnu_part <- hnu[start:stop]
summary(hnu_part)
plot.zoo(hnu_part)
dev.new()
plot.zoo(hnu)

Cutting up CPC zoo object
cpc_part <- cpc[start:stop]
summary(cpc)
plot.zoo(cpc)
dev.new()
plot.zoo(cpc_part)

Using the max.ccf function to find the maximum cross correlation between these zoo objects.
max.ccf(cpc_part,hnu_part,700)$lag
max.ccf(cpc_part,engine_part$rpm,700)$lag
max.ccf(hnu_part,engine_part$rpm,700)$lag

The lag is found then appled to the time series. Congrats! You're done!
