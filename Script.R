# ==============================================================================
# E2Tree Analysis Script - Regression Extension
# ==============================================================================
# 
# Paper: "Extending Explainable Ensemble Trees to regression contexts"
# Authors: Massimo Aria, Agostino Gnasso, Carmela Iorio, Marjolein Fokkema
#
# This script contains the complete analysis workflow for:
# 1. Boston Housing Dataset
# 2. Auto MPG Dataset
#
# ==============================================================================

# Required Libraries -----------------------------------------------------------
library(randomForest)
library(e2tree)
library(microbenchmark)
library(rio)
library(rpart.plot)
library(dplyr)

# ==============================================================================
# DATA IMPORT
# ==============================================================================

# Load Boston Housing Dataset
load("Boston_housing.rdata")
data_boston <- data  # Rename for clarity

# Load Auto MPG Dataset
load("cars.rdata")
data_cars <- data  # Rename for clarity

# ==============================================================================
# PART 1: BOSTON HOUSING DATASET ANALYSIS
# ==============================================================================

# Data Preparation -------------------------------------------------------------
# The Boston Housing Dataset
# Source: https://www.kaggle.com/datasets/sakshisatre/the-boston-housing-dataset

# Create training (70%) and validation (30%) sets
set.seed(222)
smp_size <- floor(0.70 * nrow(data))
train_ind <- sample(seq_len(nrow(data)), size = smp_size)

training <- data[train_ind, ]
validation <- data[-train_ind, ]

response_training <- training[, 14]
response_validation <- validation[, 14]

# Save datasets
save(training, file = "boston_training.rdata")
save(validation, file = "boston_validation.rdata")

# Exploratory Data Analysis ----------------------------------------------------
summary(data)

# Random Forest Training -------------------------------------------------------
set.seed(222)
ensemble_boston <- randomForest::randomForest(
  MEDV ~ ., 
  data = training, 
  ntree = 500, 
  importance = TRUE, 
  proximity = TRUE
)

# Dissimilarity Matrix Computation ---------------------------------------------
# Benchmark with parallelization (100 replications)
microbenchmark::microbenchmark(
  D_boston = createDisMatrix(
    ensemble_boston, 
    data = training, 
    label = "MEDV", 
    parallel = list(active = TRUE)
  ),  
  times = 100
)

# Optional: Benchmark without parallelization
# microbenchmark::microbenchmark(
#   D_boston = createDisMatrix(
#     ensemble_boston, 
#     data = training, 
#     label = "MEDV", 
#     parallel = list(active = FALSE, no_cores = 1)
#   ),  
#   times = 100
# )

# E2Tree Construction ----------------------------------------------------------
# Algorithm settings
setting <- list(
  impTotal = 0.1,           # Total importance threshold
  maxDec = (1 * 10^-6),     # Maximum decrease threshold
  n = 5,                    # Minimum node size
  level = 5,                # Maximum tree depth
  tMax = 5                  # Maximum iterations
)

tree_boston <- e2tree(
  MEDV ~ ., 
  training, 
  D_boston, 
  ensemble_boston, 
  setting
)

# E2Tree Visualization ---------------------------------------------------------
# Convert e2tree to rpart object for plotting
expl_plot_boston <- rpart2Tree(tree_boston, ensemble_boston)
expl_plot_boston$frame$yval <- round(expl_plot_boston$frame$yval, digits = 2)

# Generate plot
boston_plot <- rpart.plot::rpart.plot(
  expl_plot_boston,
  type = 1,
  extra = 1, 
  fallen.leaves = TRUE, 
  cex = 1, 
  branch.lty = 6, 
  nn = TRUE, 
  roundint = FALSE, 
  digits = 2,
  box.palette = "lightgrey"
)

# Model Comparison -------------------------------------------------------------
versus_boston <- comparison(
  training, 
  tree_boston, 
  D_boston, 
  is_classification = FALSE
)

# Export Results ---------------------------------------------------------------
rio::export(
  tree_boston$tree, 
  file = "Frame_boston.xlsx"
)

# ==============================================================================
# PART 2: AUTO MPG DATASET ANALYSIS
# ==============================================================================

# Data Loading and Preparation -------------------------------------------------
# Auto MPG Dataset
# Source: UCI Machine Learning Repository

# Set column names
colnames(data) <- c(
  "mpg", "cylinders", "displacement", "horsepower", 
  "weight", "acceleration", "model_year", "origin", "cn"
)

# Remove car name column
data <- data[, -9]

# Data type conversions
data <- data %>% 
  mutate_if(is.integer, as.numeric) %>%
  mutate_if(is.factor, as.numeric)

# Convert categorical variables to factors
data$origin <- factor(data$origin)
data$cylinders <- factor(data$cylinders)

# Train-Validation Split -------------------------------------------------------
set.seed(222)
smp_size <- floor(0.70 * nrow(data))
train_ind <- sample(seq_len(nrow(data)), size = smp_size)

training <- data[train_ind, ]
validation <- data[-train_ind, ]

response_training <- training[, 1]
response_validation <- validation[, 1]

# Ensure factor types in both sets
training$origin <- as.factor(training$origin)
validation$origin <- as.factor(validation$origin)

# Save datasets
save(training, file = "cars_training.rdata")
save(validation, file = "cars_validation.rdata")

# Random Forest Training -------------------------------------------------------
set.seed(222)
ensemble_cars <- randomForest::randomForest(
  mpg ~ ., 
  data = training, 
  ntree = 500, 
  importance = TRUE, 
  proximity = TRUE
)

# Dissimilarity Matrix Computation ---------------------------------------------
# Benchmark with parallelization (100 replications)
microbenchmark::microbenchmark(
  D_cars = createDisMatrix(
    ensemble_cars, 
    data = training, 
    label = "mpg", 
    parallel = list(active = TRUE)
  ),
  times = 100
)

# Optional: Benchmark without parallelization
# microbenchmark::microbenchmark(
#   D_cars = createDisMatrix(
#     ensemble_cars, 
#     data = training, 
#     label = "mpg", 
#     parallel = list(active = FALSE)
#   ),
#   times = 100
# )

# E2Tree Construction ----------------------------------------------------------
# Algorithm settings
setting <- list(
  impTotal = 0.1,           # Total importance threshold
  maxDec = (1 * 10^-6),     # Maximum decrease threshold
  n = 2,                    # Minimum node size
  level = 10                # Maximum tree depth
)

tree_cars <- e2tree(
  mpg ~ ., 
  training, 
  D_cars, 
  ensemble_cars, 
  setting
)

# E2Tree Visualization ---------------------------------------------------------
# Convert e2tree to rpart object for plotting
expl_plot_cars <- rpart2Tree(tree_cars, ensemble_cars)
expl_plot_cars$frame$yval <- round(expl_plot_cars$frame$yval, digits = 2)

# Generate plot
cars_plot <- rpart.plot::rpart.plot(
  expl_plot_cars,
  type = 1,
  extra = 1, 
  fallen.leaves = TRUE, 
  cex = 1, 
  branch.lty = 6, 
  nn = TRUE, 
  roundint = FALSE, 
  digits = 2,
  box.palette = "lightgrey"
)

# Model Comparison -------------------------------------------------------------
versus_auto <- comparison(
  training, 
  tree_cars, 
  D_cars, 
  is_classification = FALSE
)

# Export Results ---------------------------------------------------------------
rio::export(
  tree_cars$tree, 
  file = "Frame_AutoMPG.xlsx"
)

# ==============================================================================
# END OF SCRIPT
# ==============================================================================