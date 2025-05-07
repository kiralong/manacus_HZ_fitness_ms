# Performing a Fisher's exact test on hatching failure data for the Manacus hybridization project
# This uses the basic R `stats` and nothing fancy

# Checking how the matrix displays
hatch_matrix <- matrix(c(33,5,11,8,10,3), nrow = 2, ncol = 3)
hatch_matrix

#The matrix looks like this:
#     [,1] [,2] [,3]
#[1,]   33   11   10
#[2,]    5    8    3

# This matches a contingency table of row 1 = # eggs fertile and row 2 = # eggs infertile
# Column 1 is counts of eggs for Candei, col 2 is hybrids, and col 3 is vitellinus

# Now to run the fisher's exact test
FE_hatch <- fisher.test(matrix(c(33,5,11,8,10,3), nrow = 2, ncol = 3))
FE_hatch
# p-value = 0.04725

# Since I made the matrix and saved it in the variable `FE_hatch` one could also run it like this:
fisher.test(FE_hatch)

# Let's try with JUST a candei/hybrid comparison and see as well with a 2 x 2 instead of adding extra complications
FE_hatch_can_only <- fisher.test(matrix(c(33,5,11,8), nrow = 2, ncol = 2))
FE_hatch_can_only

# The FE_hatch_can_only output for posterity
# Fisher's Exact Test for Count Data
#
# data:  matrix(c(33, 5, 11, 8), nrow = 2, ncol = 2)
# p-value = 0.02083
# alternative hypothesis: true odds ratio is not equal to 1
# 95 percent confidence interval:
# 1.081167 22.299237
# sample estimates:
# odds ratio
# 4.647665
