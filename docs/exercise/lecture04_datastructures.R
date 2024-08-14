# # Exercise 
# 1. Let `x <- 3 * seq_len(4)`. Select the 2nd element of `x` with (a) positive, (b) negative and (c) logical indices.
x <- 3 * seq_len(4)
x[2]
x[-c(1,3,4)] # or x[-seq_len(4)[-2]]
x[c(FALSE, TRUE, FALSE, FALSE)] # or x[as.logical(c(0,1,0,0))]

# 2. Sort `x` in descending order using (a) a sequence of positive indices and (b) the `sort` function.  
x[c(4,3,2,1)] # or x[4:1]
sort(x, decreasing = TRUE)

# # Exercise
# Using the following code:
#   ```{r, eval=F}
# set.seed(1)
# A <- matrix(rnorm(20), ncol = 2)
# B <- matrix(rnorm(20), ncol = 2)
# ```
set.seed(1)
A <- matrix(rnorm(20), ncol = 2)
B <- matrix(rnorm(20), ncol = 2)

# 1. What are the dimensions of $A$ and $B$? Compute $A^TB$ and $AB^T$.
dim(A) # or ncol(A), nrow(A)
dim(B) # or ncol(B), nrow(B)
t(A) %*% B # or crossprod(A, B) see `?crossprod`
A %*% t(B) # or tcrossprod(A, B)


# 2. Combine $A$ and $B$ row-wise to create $C$.
C <- rbind(A,B)

# 3. Let $D$ be a copy of $C$ centered around the mean
# columnwise.
D <- C - matrix(colMeans(C), ncol=ncol(C), nrow=nrow(C), byrow=TRUE)
# or D <- C
# D[,1] <- D[,1] - mean(D[,1])
# D[,2] <- D[,2] - mean(D[,2])

# The unbiased estimator of the covariance matrix of
# $C$ is defined as $$\frac{1}{n-1}D^TD,$$
#   where $n$ is the number of rows of $D$.
# Compute this quantity.
crossprod(D) / (nrow(D) - 1.0)
# Compare with `cov(C)`.
cov(C)
