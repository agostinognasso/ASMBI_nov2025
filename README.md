# E2Tree - Extending Explainable Ensemble Trees to Regression Contexts

This repository contains the replication code and data for the paper:

**"Extending Explainable Ensemble Trees to regression contexts"**

*Massimo Aria¹, Agostino Gnasso¹, Carmela Iorio¹, Marjolein Fokkema²*

¹ Department of Economics and Statistics, University of Naples Federico II, Naples, Italy  
² Institute of Psychology, Leiden University, Leiden, The Netherlands

**In press** on *Applied Stochastic Models in Business and Industry*, Wiley

## 🔍 Overview

**E2Tree** (Explainable Ensemble Trees) is a post-hoc explanation tool for Random Forest models that provides both local and global insights into model decision processes. This work extends the original E2Tree methodology from classification to **regression contexts**.

### Key Features

- **Single Tree Representation**: Transforms complex Random Forest ensembles into interpretable single decision trees
- **High Fidelity**: Maintains predictive accuracy while enhancing interpretability
- **Statistical Validation**: Uses Mantel tests to validate correlation between RF and E2Tree structures
- **Parallel Processing**: Optimized computation with parallelization support
- **Dual Focus**: Captures both local predictions and global decision patterns

### Main Contributions

1. Extension of E2Tree methodology to regression problems
2. Novel normalized mean square error (NMSE) measure for node goodness-of-fit
3. Comprehensive evaluation on real-world datasets
4. Statistical validation through Mantel correlation tests

##️ Requirements

### Software Requirements

- **R** version ≥ 4.0.0

### R Package Dependencies

```r
# CRAN Packages
install.packages(c(
  "randomForest",    # Random Forest implementation
  "rpart.plot",      # Tree visualization
  "dplyr",           # Data manipulation
  "rio",             # Data import/export
  "microbenchmark",  # Performance benchmarking
  "e2tree"           # E2Tree package (Version: 0.2.0)
))
```

> **Note on e2tree Package Version**: This analysis uses e2tree version **0.2.0** from CRAN. If newer versions are released, you can always access this specific version through the CRAN package archive at: [https://cran.r-project.org/src/contrib/Archive/e2tree/](https://cran.r-project.org/src/contrib/Archive/e2tree/)
>
> To install a specific version from the archive:
> ```r
> # Install specific version from CRAN archive
> packageurl <- "https://cran.r-project.org/src/contrib/Archive/e2tree/e2tree_0.2.0.tar.gz"
> install.packages(packageurl, repos = NULL, type = "source")
> ```


## Installation

### Step 1: Clone the Repository

```bash
git clone https://github.com/agostinognasso/ASMBI_nov2025.git
cd ASMBI_nov2025
```

### Step 2: Install Dependencies

Open R or RStudio and run:

```r
# Install CRAN packages
install.packages(c("randomForest", "rpart.plot", "dplyr", 
                   "rio", "microbenchmark", "e2tree"))

```

### Step 3: Verify Installation

```r
library(e2tree)
packageVersion("e2tree")
```

## Usage

### Quick Start

```r
# Load the main analysis script
source("Script.R")
```

The script will automatically:
1. Load both datasets (Boston Housing and Auto MPG)
2. Split data into training (70%) and validation (30%) sets
3. Train Random Forest models with 500 trees
4. Compute dissimilarity matrices with parallelization
5. Build E2Tree explanations
6. Generate visualizations
7. Export results to Excel files

### Running Individual Analyses

#### Boston Housing Analysis Only

```r
# Load required libraries
library(randomForest)
library(e2tree)
library(rpart.plot)

# Load data
load("data/Boston_housing.rdata")

# Run Boston Housing analysis
# [See lines 22-133 in Script.R]
```

#### Auto MPG Analysis Only

```r
# Load data
load("data/cars.rdata")

# Run Auto MPG analysis
# [See lines 135-265 in Script.R]
```

### Customizing E2Tree Parameters

You can modify the algorithm settings:

```r
setting <- list(
  impTotal = 0.1,           # Total importance threshold (0-1)
  maxDec = (1 * 10^-6),     # Maximum decrease threshold
  n = 5,                    # Minimum observations per node
  level = 5,                # Maximum tree depth
  tMax = 5                  # Maximum iterations
)
```

## Datasets

### 1. Boston Housing Dataset

- **Source**: [Kaggle - Boston Housing Dataset](https://www.kaggle.com/datasets/sakshisatre/the-boston-housing-dataset)
- **Original Reference**: Harrison & Rubinfeld (1978)
- **Observations**: 506
- **Features**: 13 predictors + 1 response variable (MEDV)
- **Task**: Predict median home values in Boston suburbs

**Key Variables**:
- `CRIM`: Per capita crime rate
- `RM`: Average number of rooms per dwelling
- `LSTAT`: % lower status of the population
- `NOX`: Nitrogen oxide concentration
- `MEDV`: Median value of owner-occupied homes (target)

### 2. Auto MPG Dataset

- **Source**: [UCI Machine Learning Repository](https://archive.ics.uci.edu/dataset/9/auto+mpg)
- **Observations**: 398
- **Features**: 7 predictors + 1 response variable (mpg)
- **Task**: Predict fuel efficiency (miles per gallon)

**Key Variables**:
- `mpg`: Miles per gallon (target)
- `displacement`: Engine displacement
- `weight`: Vehicle weight
- `model_year`: Model year
- `horsepower`: Engine horsepower


## Citation

If you use this code or methodology in your research, please cite:

```bibtex
@article{aria2025e2tree,
  title={Extending Explainable Ensemble Trees to regression contexts},
  author={Aria, Massimo and Gnasso, Agostino and Iorio, Carmela and Fokkema, Marjolein},
  journal={Applied Stochastic Models in Business and Industry},
  year={2025},
  publisher={Wiley},
  note={In press}
}
```

### Related Work

For the original E2Tree classification methodology:

```bibtex
@article{aria2024explainable,
  title={Explainable ensemble trees},
  author={Aria, Massimo and Gnasso, Agostino and Iorio, Carmela and Pandolfo, Giuseppe},
  journal={Computational Statistics},
  volume={39},
  number={1},
  pages={3--19},
  year={2024},
  publisher={Springer}
}
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Authors

- **Massimo Aria** - [ORCID](https://orcid.org/0000-0002-8517-9411) - massimo.aria@unina.it
- **Agostino Gnasso** - [ORCID](https://orcid.org/0000-0002-6875-9735) - agostino.gnasso@unina.it
- **Carmela Iorio** - carmela.iorio@unina.it
- **Marjolein Fokkema** - m.fokkema@fsw.leidenuniv.nl

## Contact

For questions, issues, or collaboration inquiries:

- **Corresponding Author**: Agostino Gnasso (agostino.gnasso@unina.it)
- **GitHub Issues**: [Open an issue](https://github.com/massimoaria/e2Tree-regression/issues)

## Acknowledgments

This research has been financed by:
- PRIN-2022 "SCIK-HEALTH" (Project Code: 2022825Y5E; CUP: E53D2300611006)
- PRIN-2022 PNRR "The value of scientific production for patient care in Academic Health Science Centres" (Project Code: P2022RF38Y; CUP: E53D23016650001)


---

**Note**: This repository contains the replication materials for academic purposes. The datasets are publicly available and used in accordance with their respective licenses.

*Last Updated: November 2025*
