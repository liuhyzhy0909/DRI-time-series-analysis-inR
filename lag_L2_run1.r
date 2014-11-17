#rm(list=ls(all=TRUE)) 
require(zoo)
Sys.setenv(TZ = "GMT")
## function that finds max correlation
max.ccf <- function(a,b,lag.max=10){
   df <- ccf(a, b, lag.max=lag.max, plot = FALSE, na.action=na.pass)
   cor = df$acf[,,1]
   lag = df$lag[,,1]
   res = data.frame(cor,lag)
   res_max = res[which.max(res$cor),]
   return(res_max)
}
## change these files names for engine data
setwd("/home/will/Dropbox/heavy_hauler/Data/130530_L2")	
#setwd("C:/Users/asus/Dropbox/heavy_hauler/Data/130530_L2")	
drx <- read.zoo("drx_z.csv",header=T,tz="",format="%Y-%m-%d %H:%M:%S", sep=",")
langan <- read.zoo("langan_z.csv",header=T,tz="",format="%Y-%m-%d %H:%M:%S", sep=",")
engine <- read.zoo("engine_z.csv",header=T,tz="",format="%Y-%m-%d %H:%M:%S", sep=",")
#
##change wd and file name for sensor data
setwd("/home/will/Dropbox/heavy_hauler/Data/130530_L2/130530_L2_Run1")	
#setwd("C:/Users/asus/Dropbox/heavy_hauler/Data/130530_L2/130530_L2_Run1")	
co2bg <- read.zoo("co2bg_z.csv",header=T,tz="",format="%Y-%m-%d %H:%M:%S", sep=",")
co2dil <- read.zoo("co2dil_z.csv",header=T,tz="",format="%Y-%m-%d %H:%M:%S", sep=",")
co2tpi <- read.zoo("co2tpi_z.csv",header=T,tz="",format="%Y-%m-%d %H:%M:%S", sep=",")
cpc <- read.zoo("cpc_z.csv",header=T,tz="",format="%Y-%m-%d %H:%M:%S", sep=",")
hnu <- read.zoo("hnu_z.csv",header=T,tz="",format="%Y-%m-%d %H:%M:%S", sep=",")
gps <- read.zoo("gps_z.csv",header=T,tz="",format="%Y-%m-%d %H:%M:%S", sep=",")
testo.etc <- read.zoo("testoEtc_z.csv",header=T,tz="",format="%Y-%m-%d %H:%M:%S", sep=",")
testo.CO <- read.zoo("testoCO_z.csv",header=T,tz="",format="%Y-%m-%d %H:%M:%S", sep=",")
testo.CO2 <- read.zoo("testoCO2_z.csv",header=T,tz="",format="%Y-%m-%d %H:%M:%S", sep=",")
testo.NO <- read.zoo("testoNO_z.csv",header=T,tz="",format="%Y-%m-%d %H:%M:%S", sep=",")
ae51 <- 0
ae52 <- read.zoo("ae52_z.csv",header=T,tz="",format="%Y-%m-%d %H:%M:%S", sep=",")
#
z <- merge(co2bg, co2dil,co2tpi,cpc,ae51,ae52,hnu,drx,
testo.NO,testo.CO2,testo.CO,testo.etc,langan,gps,engine)
hnu.z <- window(z,start=start(hnu),end=end(hnu))
write.zoo(hnu.z, file="interpolated_data.csv", sep=",")
#
lag_matrix <- matrix(NA,14,14)
rownames(lag_matrix) <- c('rpm','testo.CO2','cpc','testo.NO2ppm','velocity.GPS','hnu','co2dil','drx.total','co2tpi','rpm','testo.CO','lagan.CO','ae52','ae51')
colnames(lag_matrix) <- rownames(lag_matrix)
#
lag_matrix[1,2] <- max.ccf(z$rpm,z$testo.CO2,100)$lag
lag_matrix[1,3] <- max.ccf(z$rpm,z$cpc,100)$lag
lag_matrix[1,4] <- max.ccf(z$rpm,z$testo.NO2ppm,100)$lag
lag_matrix[1,5] <- max.ccf(z$rpm,z$velocity,100)$lag
lag_matrix[1,6] <- max.ccf(z$rpm,z$hnu,100)$lag
lag_matrix[1,7] <- max.ccf(z$rpm,z$co2dil,100)$lag
lag_matrix[1,8] <- max.ccf(z$rpm,z$drx.total,100)$lag
lag_matrix[1,9] <- max.ccf(z$rpm,z$co2tpi,100)$lag
lag_matrix[1,10] <- max.ccf(z$rpm,z$rpm,100)$lag
lag_matrix[1,11] <- max.ccf(z$rpm,z$testo.CO,100)$lag
lag_matrix[1,12] <- max.ccf(z$rpm,z$langan.CO,100)$lag
lag_matrix[1,13] <- max.ccf(z$rpm,z$ae51,100)$lag
lag_matrix[1,14] <- max.ccf(z$rpm,z$ae52.bc,100)$lag
##
lag_matrix[2,3] <- max.ccf(z$testo.CO2,z$cpc,100)$lag
lag_matrix[2,4] <- max.ccf(z$testo.CO2,z$testo.NO2ppm,100)$lag
lag_matrix[2,5] <- max.ccf(z$testo.CO2,z$velocity,100)$lag
lag_matrix[2,6] <- max.ccf(z$testo.CO2,z$hnu,100)$lag
lag_matrix[2,7] <- max.ccf(z$testo.CO2,z$co2dil,100)$lag
lag_matrix[2,8] <- max.ccf(z$testo.CO2,z$drx.total,100)$lag
lag_matrix[2,9] <- max.ccf(z$testo.CO2,z$co2tpi,100)$lag
lag_matrix[2,10] <- max.ccf(z$testo.CO2,z$rpm,100)$lag
lag_matrix[2,11] <- max.ccf(z$testo.CO2,z$testo.CO,100)$lag
lag_matrix[2,12] <- max.ccf(z$testo.CO2,z$langan.CO,100)$lag
lag_matrix[2,13] <- max.ccf(z$testo.CO2,z$ae51,100)$lag
lag_matrix[2,14] <- max.ccf(z$testo.CO2,z$ae52.bc,100)$lag
##
lag_matrix[3,4] <- max.ccf(z$cpc,z$testo.NO2ppm,100)$lag
lag_matrix[3,5] <- max.ccf(z$cpc,z$velocity,100)$lag
lag_matrix[3,6] <- max.ccf(z$cpc,z$hnu,100)$lag
lag_matrix[3,7] <- max.ccf(z$cpc,z$co2dil,100)$lag
lag_matrix[3,8] <- max.ccf(z$cpc,z$drx.total,100)$lag
lag_matrix[3,9] <- max.ccf(z$cpc,z$co2tpi,100)$lag
lag_matrix[3,10] <- max.ccf(z$cpc,z$rpm,100)$lag
lag_matrix[3,11] <- max.ccf(z$cpc,z$testo.CO,100)$lag
lag_matrix[3,12] <- max.ccf(z$cpc,z$langan.CO,100)$lag
lag_matrix[3,13] <- max.ccf(z$cpc,z$ae51,100)$lag
lag_matrix[3,14] <- max.ccf(z$cpc,z$ae52.bc,100)$lag
##
lag_matrix[4,5] <- max.ccf(z$testo.NO2ppm,z$velocity,100)$lag
lag_matrix[4,6] <- max.ccf(z$testo.NO2ppm,z$hnu,100)$lag
lag_matrix[4,7] <- max.ccf(z$testo.NO2ppm,z$co2dil,100)$lag
lag_matrix[4,8] <- max.ccf(z$testo.NO2ppm,z$drx.total,100)$lag
lag_matrix[4,9] <- max.ccf(z$testo.NO2ppm,z$co2tpi,100)$lag
lag_matrix[4,10] <- max.ccf(z$testo.NO2ppm,z$rpm,100)$lag
lag_matrix[4,11] <- max.ccf(z$testo.NO2ppm,z$testo.CO,100)$lag
lag_matrix[4,12] <- max.ccf(z$testo.NO2ppm,z$langan.CO,100)$lag
lag_matrix[4,13] <- max.ccf(z$testo.NO2ppm,z$ae51,100)$lag
lag_matrix[4,14] <- max.ccf(z$testo.NO2ppm,z$ae52.bc,100)$lag
##
lag_matrix[5,6] <- max.ccf(z$velocity,z$hnu,100)$lag
lag_matrix[5,7] <- max.ccf(z$velocity,z$co2dil,100)$lag
lag_matrix[5,8] <- max.ccf(z$velocity,z$drx.total,100)$lag
lag_matrix[5,9] <- max.ccf(z$velocity,z$co2tpi,100)$lag
lag_matrix[5,10] <- max.ccf(z$velocity,z$rpm,100)$lag
lag_matrix[5,11] <- max.ccf(z$velocity,z$testo.CO,100)$lag
lag_matrix[5,12] <- max.ccf(z$velocity,z$langan.CO,100)$lag
lag_matrix[5,13] <- max.ccf(z$velocity,z$ae51,100)$lag
lag_matrix[5,14] <- max.ccf(z$velocity,z$ae52.bc,100)$lag
##
lag_matrix[6,7] <- max.ccf(z$hnu,z$co2dil,100)$lag
lag_matrix[6,8] <- max.ccf(z$hnu,z$drx.total,100)$lag
lag_matrix[6,9] <- max.ccf(z$hnu,z$co2tpi,100)$lag
lag_matrix[6,10] <- max.ccf(z$hnu,z$rpm,100)$lag
lag_matrix[6,11] <- max.ccf(z$hnu,z$testo.CO,100)$lag
lag_matrix[6,12] <- max.ccf(z$hnu,z$langan.CO,100)$lag
lag_matrix[6,13] <- max.ccf(z$hnu,z$ae51,100)$lag
lag_matrix[6,14] <- max.ccf(z$hnu,z$ae52.bc,100)$lag
##
lag_matrix[7,8] <- max.ccf(z$co2dil,z$drx.total,100)$lag
lag_matrix[7,9] <- max.ccf(z$co2dil,z$co2tpi,100)$lag
lag_matrix[7,10] <- max.ccf(z$co2dil,z$rpm,100)$lag
lag_matrix[7,11] <- max.ccf(z$co2dil,z$testo.CO,100)$lag
lag_matrix[7,12] <- max.ccf(z$co2dil,z$langan.CO,100)$lag
lag_matrix[7,13] <- max.ccf(z$co2dil,z$ae51,100)$lag
lag_matrix[7,14] <- max.ccf(z$co2dil,z$ae52.bc,100)$lag
##
lag_matrix[8,9] <- max.ccf(z$drx.total,z$co2tpi,100)$lag
lag_matrix[8,10] <- max.ccf(z$drx.total,z$rpm,100)$lag
lag_matrix[8,11] <- max.ccf(z$drx.total,z$testo.CO,100)$lag
lag_matrix[8,12] <- max.ccf(z$drx.total,z$langan.CO,100)$lag
lag_matrix[8,13] <- max.ccf(z$drx.total,z$ae51,100)$lag
lag_matrix[8,14] <- max.ccf(z$drx.total,z$ae52.bc,100)$lag
##
lag_matrix[9,10] <- max.ccf(z$co2tpi,z$rpm,100)$lag
lag_matrix[9,11] <- max.ccf(z$co2tpi,z$testo.CO,100)$lag
lag_matrix[9,12] <- max.ccf(z$co2tpi,z$langan.CO,100)$lag
lag_matrix[9,13] <- max.ccf(z$co2tpi,z$ae51,100)$lag
lag_matrix[9,14] <- max.ccf(z$co2tpi,z$ae52.bc,100)$lag
##
lag_matrix[10,11] <- max.ccf(z$rpm,z$testo.CO,100)$lag
lag_matrix[10,12] <- max.ccf(z$rpm,z$langan.CO,100)$lag
lag_matrix[10,13] <- max.ccf(z$rpm,z$ae51,100)$lag
lag_matrix[10,14] <- max.ccf(z$rpm,z$ae52.bc,100)$lag
##
lag_matrix[11,12] <- max.ccf(z$testo.CO,z$langan.CO,100)$lag
lag_matrix[11,13] <- max.ccf(z$testo.CO,z$ae51,100)$lag
lag_matrix[11,14] <- max.ccf(z$testo.CO,z$ae52.bc,100)$lag
##
lag_matrix[12,13] <- max.ccf(z$langan.CO,z$ae51,100)$lag
lag_matrix[12,14] <- max.ccf(z$langan.CO,z$ae52.bc,100)$lag
##
lag_matrix[13,14] <- max.ccf(z$ae51,z$ae52.bc,100)$lag
#
write.csv(lag_matrix, file="lag_matrix.csv")
#
#max.ccf(z$rpm,z$drx.total,100)$lag
lag_matrix[1,8]
engine.lag <- lag(engine,lag_matrix[1,8])
#
k <- max.ccf(z$testo.NOppm,z$drx.total,100)$lag;k
testo.NO.lag <- lag(testo.NO,k)
#
k <- max.ccf(z$testo.CO2,z$drx.total,100)$lag;k
testo.CO2lag <- lag(testo.CO2,k)
#
k <- max.ccf(z$testo.CO,z$drx.total,100)$lag;k
testo.CO.lag <- lag(testo.CO,k)
#
k <- max.ccf(z$testo.pump,testo.NO.lag$testo.NO2ppm,100)$lag;k
testo.etc.lag <- lag(testo.etc,k)
#
#max.ccf(z$cpc,z$drx.total,100)$lag
ccf(z$cpc,z$drx.total,100,na.action=na.pass)
lag_matrix[3,8]
cpc.lag <- lag(cpc,lag_matrix[3,8])
#
#max.ccf(z$hnu,z$drx.total,100)$lag
lag_matrix[6,8]
hnu.lag <- lag(hnu,lag_matrix[6,8])
#
#max.ccf(z$co2dil,z$drx.total,100)$lag
lag_matrix[7,8]
co2dil.lag <- lag(co2dil,lag_matrix[7,8])
#
#max.ccf(z$drx.total,z$co2tpi,100)$lag
lag_matrix[8,9]
co2tpi.lag <- lag(co2tpi,-lag_matrix[8,9])
#
#max.ccf(z$drx.total,z$rpm,100)$lag
#lag_matrix[8,10]
#w.lag <- lag(w,-lag_matrix[8,10])
#k <- max.ccf(w$rpm,r.lag$rpm,100)$lag;k
#w.lag <- lag(w,k)
#
#k <- max.ccf(gps$velocity,r.lag$mph,100)$lag;k
#max.ccf(z$velocity,z$drx.total,100)$lag
lag_matrix[5,8]
gps.lag <- lag(gps,lag_matrix[5,8])
#
# max.ccf(z$drx.total,z$ae51,100)$lag
#lag_matrix[8,13]
#ae51.lag <- lag(ae51,-lag_matrix[8,13])
#
# max.ccf(z$drx.total,z$ae52.bc,100)$lag
lag_matrix[8,14]
ae52.lag <- lag(ae52,-lag_matrix[8,14])
#
#max.ccf(z$drx.total,z$langan.CO,100)$lag
lag_matrix[8,12]
langan.lag <- lag(langan,-lag_matrix[8,12])
#
zl <- merge(co2bg, co2dil.lag, co2tpi.lag,cpc.lag,ae51,ae52.lag,hnu.lag,drx,
testo.NO.lag,testo.CO2lag,testo.CO.lag,testo.etc.lag,langan.lag,gps.lag,engine.lag)
hnu.zl <- window(zl,start=start(hnu.lag),end=end(hnu.lag))
write.zoo(hnu.zl, file="lag_data.csv", sep=",")
###
old <- read.zoo("interpolated_data.csv",header=T,tz="",format="%Y-%m-%d %H:%M:%S", sep=",")
old <- na.omit(old)
new <- na.omit(zl)
str(old);str(new);lag_matrix
ccf(z$cpc,z$drx.total,100,na.action=na.pass)
