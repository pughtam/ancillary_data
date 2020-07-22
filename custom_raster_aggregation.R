# Title     : Custom aggregation function in R (do anything you want to those pixels!)
# Objective : Replace baseline raster::aggregate() functions with own operations (no more blackbox!)
# Created by: laviniageorgescu
# Created on: 22/07/2020

####  CUSTOM RASTER AGGREGATE IN R
library(raster)

# how to write a function in R -> https://www.pluralsight.com/guides/beauty-custom-functions-r
#1. Write your own aggregation function
# How custom raster::aggregate functions work as per R docs:
#   ''' The function ‘fun’ should take multiple numbers, and return a
#   single number. For example ‘mean’, ‘modal’, ‘min’ or ‘max’.  It
#   should also accept a ‘na.rm’ argument (or ignore it as one of the
#   'dots' arguments).'''

f.agg <- function(g,...) { # g is the group of pixels from the initial raster;
  f <- do something to g # f is the single pixel resulting from g, after operation
  na.rm = T # raster::aggregate will try to pass na.rm to your function, so best add it here
  return(f)
}
#  - The '...' after g allows for the optional input of more than one parameter, without
#  explicitly specifying it. It's best to leave it there.
#  - The number of pixels g is composed of depends on the aggregation factor chosen. For e.g.,
#  a factor of 10 translates into 10x10 pixels from g, which are equivalent to 1x1 pixels in f.
#2. Run your function!

#3. Put your function into raster::aggregate() under fun=
#   - Now your function replaces the usual options, such as mean, mode, bilinear etc.
agg.r <- aggregate(raster, fact=10, fun=f.agg)

#### NOTE: It is recommended you test this on a small fake raster,
# or a small subset of your intended raster, as aggregation is a time-consuming,
# resource-intensive process.

#### EXAMPLE: Fake raster
# make example raster to test aggregation
library(spatialEco)
rr <- random.raster(n.row = 50, n.col = 50, n.layers = 1, min = 0, max = 1, distribution = "binominal")
# OR
library(raster)
r <- raster(res=2)
# from https://www.r-bloggers.com/m-x-n-matrix-with-randomly-assigned-01/
m <- matrix(sample(0:1,ncell(r), replace=TRUE)) # 0:1 can be set to whichever value range you need
# from https://www.rdocumentation.org/packages/raster/versions/1.0.4/topics/values
r <- setValues(r, m)

#### EXAMPLE: Custom aggregation function - FRACTIONAL COVER
f.agg <- function(g, ...) {
  f <- ncell(g[g==1]) # no of pixels =1
  f.loss <- f/ncell(g) # fraction of f pixels in g subset array
  na.rm = T
  return(f.loss)
}
# test function without aggregation
tt <- f.agg(r)
# try custom aggregate() on 0/1 test raster
agg.r <- aggregate(s, fact=10, fun=f.agg)

# other examples of custom agg func
# https://stackoverflow.com/questions/57710699/pass-multiple-arguments-for-custom-function-to-in-aggregate-function-in-r
# https://stackoverflow.com/questions/56989358/class-based-weighted-raster-aggregation/56991285