len = 20

x1 = 1:len              ### x1 INTEGER vector
dim(x1) = c(len/2,2)
x2 = x1 + .1            ### x2 REAL vector
x3 = rep(TRUE,len)      ### x3 LOGICAL vector
dim(x3) = c(len/2,2)
x4 = complex(r=1:len,i=1:len)
dim(x4) = c(len/2,2)    ### x4 COMPLEX vector


mi <- function()colMeans(x1)
mf <- function()colMeans(x2)
ml <- function()colMeans(x3)
mc <- function()colMeans(x4)
