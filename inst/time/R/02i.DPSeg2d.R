filenames <- sprintf("%s,b=%s.xdr", simName, 1:B)
for (bb in 1:B) {
  filename <- filenames[bb]
  print(filename)
  pathname <- file.path(spath, filename)
  sim <- loadObject(pathname)
  if (!is.na(normFrac)) {
    dat <- setNormalContamination(sim$profile, normFrac)
  } else {
    dat <- sim$profile
  }
   ## drop outliers
  CNA.object <- CNA(dat$c,rep(1,len),1:len)
  smoothed.CNA.obj <- smooth.CNA(CNA.object)
  dat$c <- smoothed.CNA.obj$Sample.1
  stat <- c("log(c)","d")
  for (KK in candK) {
    methTag <- sprintf("DPseg:%s (Kmax=%s)", stat, KK/2)
    filename <- sprintf("%s,b=%s,%s.xdr", simNameNF, bb, methTag)
    pathname <- file.path(tpath, filename)
    if (!file.exists(pathname) || segForce) {
      if(length(grep("log",stat))){dat$c = log2(dat$c)-1; stat= gsub("log\\(c\\)","c", stat)}
      res <- PSSeg(dat, method="DynamicProgramming",K=KK/2, stat=stat, profile=TRUE, verbose=TRUE)
      saveObject(res$prof[, "time"], file=pathname)
    }
  }
}
