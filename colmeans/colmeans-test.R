if (!require(rbenchmark)) {
  install.packages("rbenchmark", repos='http://cran.us.r-project.org')
  require(rbenchmark)
}

N = 1000
len = 100000

x1 = 1:len              ### x1 INTEGER vector
dim(x1) = c(len/2,2)
x2 = x1 + .1            ### x2 REAL vector
x3 = rep(TRUE,len)      ### x3 LOGICAL vector
dim(x3) = c(len/2,2)
x4 = complex(r=1:len,i=1:len)
dim(x4) = c(len/2,2)    ### x4 COMPLEX vector

#invisible(force(x1))
#invisible(force(x2))
#invisible(force(x3))
#invisible(force(x4))

bench = list(
  "integer"=expression(colMeans(x1)),  # .53
  "float"=expression(colMeans(x2)),  # .49
  "logical"=expression(colMeans(x3)),  # .54
  "complex"=expression(colMeans(x4))  #2.77
)

args <- invisible(commandArgs(trailingOnly = TRUE))
args <- if (length(args)) args else names(bench)

do.call(
  benchmark,
  c(bench[names(bench) %in% args],
    list(
      replications = N,
      order='elapsed',
      columns = c('test', 'replications', 'elapsed', 'relative', 'user.self', 'sys.self'))))
