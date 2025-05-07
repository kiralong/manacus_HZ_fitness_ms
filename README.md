# _Manacus_ hybrid zone fitness manuscript repository

> Long _et al._ (2025) **Reduced offspring viability is associated with long-term stability of a narrow avian hybrid zone**. In Prep.

This repository contains code/scripts used in the analysis of hybrid fitness for adult apparent survival and hatching success in the _Manacus_ hybrid zone of western Panama.

## Apparent Survival

The directory `Apparent_survival` contains:

1) MARK_extract_input_file: A directory that contains instructions, installation, examples, and data to take an excel style tsv of mistnetting capture data and generate the input file needed for `Program MARK`. See the MARK_extract_input_file [`README.md`](https://github.com/kiralong/manacus_HZ_fitness_ms/blob/main/Apparent_survival/MARK_extract_input_file/README.md) for more details.
   
2) `MARK` output Graphing: R script and `MARK` output data to make dotplot of the `Program MARK` results. Note that `Program MARK` is a GUI and does not save scripts so the actual aparant survival modeling was done in the `Program MARK` GUI and the output was then graphed with the R script [`graph_survival_dotplot.R`](https://github.com/kiralong/manacus_HZ_fitness_ms/blob/main/Apparent_survival/graph_survival_dotplot.R). See the manuscript for a description of the modeling in `Program MARK`.

## Hatching Success

The directory `hatching_success` contains:

1) `binomial_regression_hatching.R`: R script to fit the success or failure of each egg to hatch within a nest to a generalized linear model with a binomial distribution. Script also graphs the proportion of nests that had eggs hatch or fail to hatch in paired barplots. `binomial_regression_nest_data.csv` can be used with the script to generate the barplot.

2) `fisherexact_test_nests.R`: R script that performs a fisher's exact test on the total proportion of eggs that failed to hatch.

## Author

Kira M. Long
