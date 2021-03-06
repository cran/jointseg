#' Get best candidate change point
#' 
#' Get best candidate change point according to binary segmentation
#' 
#' 
#' @param Y A \code{n*p} matrix, \code{p} signals of length \code{n} to be
#' segmented (centered by column)
#' @param weights a \code{(n-1)*1} vector of weights for the candidate change
#' point positions. Default weights yield the likelihood ratio test (LRT)
#' statistic for the identification of a single change point.
#' @param verbose A \code{logical} value: should extra information be output ?
#' Defaults to \code{FALSE}.
#' @author Morgane Pierre-Jean and Pierre Neuvial
#' @keywords internal
#' @examples
#' 
#' p <- 2
#' sim <- randomProfile(1e4, 1, 1, p)
#' Y <- sim$profile
#' bkp <- jointseg:::oneBkp(Y)
#' par(mfrow=c(p,1))
#' for (ii in 1:p) {
#'     plot(Y[, ii], pch=19, cex=0.2)
#'     abline(v=bkp, col=3)
#'     abline(v=sim$bkp, col=8, lty=2)
#' }
#' 
#' @export oneBkp
oneBkp <- function(Y, weights=NULL, verbose=FALSE){
    ## Initialization
    if (!is.matrix(Y)){
        stop("Y is not a matrix, please check dimension of Y")
    }
    p <- dim(Y)[2]
    n <- as.numeric(nrow(Y))
    if (is.null(weights)) {
        weights=defaultWeights(n)
    } 

    c <- leftMultiplyByXt(Y=Y, w=weights, verbose=verbose)
    cNorm <- rowSums(c^2)
    which.max(cNorm)
}

############################################################################
## HISTORY:
## 2013-01-30
## o Now an internal function (not exported anymore).
## o Added 'jointSeg:::' to example because function is not exported anymore.
## 2013-01-09
## o Replaced 'jump' by 'bkp'.
## 2012-12-27
## o Some code and doc cleanups.
## 2012-12-05
## o Created.
############################################################################

