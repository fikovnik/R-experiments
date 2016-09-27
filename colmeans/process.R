#!/usr/bin/env Rscript

result <- "result.pdf"

require(ggplot2)

loadData <- function(dir) {
  config <- sub("\\./RUN-(.+)", "\\1", dir)
  
  lines <- readLines(paste0(dir, "/run.out"))
  # remove the ordering
  lines <- sapply(lines, function(x)sub("^^[ ]*[0-9]?[ ]*", "", x), USE.NAMES=FALSE)
  # filter out duplicated headers
  lines <- c(lines[1], lines[-grep("test", lines)])
  
  data <- read.table(text=lines, header = T)
  data[, "config"] <- config 
  data
}

dirs <- list.dirs(recursive = FALSE)
dirs <- dirs[grep("RUN-.+", dirs)]
data <- lapply(dirs, loadData)
all <- Reduce(rbind, data)
all <- subset(all, test == "complex" | test == "float")

pdf(result) 

p <- 
  ggplot(all, aes(y=elapsed, x=config, fill=test)) + 
  geom_boxplot() +
  ggtitle("elapsed executions of 1000 colMax of |n| = 100000") +
  labs(x="compiler configuration", y="elapsed time [s]") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

p

invisible(dev.off())

cat(paste0("Result is in ", result, "\n"))