################################################################################
################################################################################
#' ehk21@ic.ac.uk - May 2022
#'
#' Script to run multi-objective optimisation of a specified arable landscape on an HPC cluster
#'
################################################################################
################################################################################

# clear workspace and graphics
rm(list = ls())

################################################################################
# 0) Set working directory, load packages, source functions
################################################################################

# # If testing optimisations on computer:
# # set working directory to Ellen_Knight_code folder 
# setwd("~/Imperial College/research_project-main/research_project-main/Ellen_Knight_code/")
# # must also define iter below

# # load packages
library(sf) # only one to call in this function
# library(raster)
# library(sp) # called in separate_landscape
# library(nsga2R) # for running optimisation
# library(plyr)
# library(dplyr)
# library(rgdal)

################################################################################
# 1) source functions, read in files and set function parameters
################################################################################

# source functions
source("cluster/code/optim_fn.R")

# read in input files
optimLandcovers <- read.csv("cluster/data/optim_landcovers.csv")
landcoverData <- read_sf("cluster/data/SK86/lcm-2020-vec_4558456.gpkg")

################################################################################
# 2) Running code on the cluster:
################################################################################

# Read in job number from the cluster:
iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))

# Set random seed
set.seed(iter)

# set parameters
gridSquare <- c("SK86", 480000, 490000 ,360000, 370000)
shuffleCodes <- c(30,14)
objectives <- c("GroundNestingBumblebees", "TreeNestingBumblebees", "GroundNestingSolitaryBees")
objDim <- length(objectives)
params <- read.csv("cluster/data/params_smaller_pop.csv", header=T)
radius <- params$radius[iter]
popSize <- params$popSize[iter]
generations <- params$generations[iter]

# Create output filename
outputName <- paste0("output", iter)

  
# Call the optim function
  
optim.fn(optimLandcovers=optimLandcovers, landcoverData=landcoverData, 
                 gridSquare=gridSquare, shuffleCodes=shuffleCodes, 
                 radius=radius, obj=objectives, objDim=objDim, popSize=popSize, 
                 generations=generations, outputName=outputName)




