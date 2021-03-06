## ---- include=FALSE------------------------------------------------------
library("knitr")
opts_chunk$set(dev='png', fig.width=5, fig.height=5)

## ---- include=FALSE------------------------------------------------------
library("jointseg")

## ------------------------------------------------------------------------
data <- acnr::loadCnRegionData(dataSet="GSE29172", tumorFraction=1)
str(data)

## ------------------------------------------------------------------------
table(data[["region"]])

## ------------------------------------------------------------------------
idxs <- sort(sample(1:nrow(data), 2e4))
plotSeg(data[idxs, ])

## ------------------------------------------------------------------------
K <- 10
bkp <- c(408,1632,3905, 5890,6709, 10481, 12647,14089,17345,18657)
len <- 2e4
sim <- getCopyNumberDataByResampling(len, bkp=bkp, minLength=500, regData=data)
datS <- sim$profile
str(datS)

## ------------------------------------------------------------------------
plotSeg(datS, sim$bkp)

## ------------------------------------------------------------------------
datS$c <- log2(datS$c)-1

## ------------------------------------------------------------------------
resRBS <- PSSeg(data=datS, K=2*K, method="RBS", stat=c("c", "d"), profile=TRUE)

## ------------------------------------------------------------------------
resRBS$prof[, "time"]

## ------------------------------------------------------------------------
plotSeg(datS, list(true=sim$bkp, est=resRBS$bestBkp))

## ------------------------------------------------------------------------
print(getTpFp(resRBS$bestBkp, sim$bkp, tol=5))

## ------------------------------------------------------------------------
perf <- sapply(0:10, FUN=function(tol) {
    getTpFp(resRBS$bestBkp, sim$bkp, tol=tol,relax = -1)
})
print(perf)

## ------------------------------------------------------------------------
sessionInfo()

## ------------------------------------------------------------------------
citation("jointseg")

