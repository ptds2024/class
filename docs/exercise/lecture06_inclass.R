x <- c(rnorm(100), "a")
typeof(x)
x <- x[-101]
as.double(x)

x <- -1000
if (x < 0){
  x <- -x
}
if (x %% 2 == 0){
  print(paste(x, "is an even number"))
}

x <- 2L
if(is.integer(x)) {
  if (x %% 2 == 0){
    cat(x, "is an even number\n")
  }else{
    cat(x, "is an odd number\n")
  }
}

number1 <- 20
number2 <- 5
operator <- readline(prompt="Please enter any ARITHMETIC OPERATOR: ")
switch(operator,
       "+" = cat("Addition of two numbers is: ", number1 + number2),
       "-" = cat("Subtraction of two numbers is: ", number1 - number2),
       "*" = cat("Multiplication of two numbers is: ", number1 * number2),
       "/" = cat("Division of two numbers is: ", number1 / number2)
)

x <- 1:10
ifelse((x %% 2) == 0, print("even number"), print("odd number"))

i = 1
while (i <= 6){
  print(i)
  i = i-1
}

f <- function() {
  x <- 15
  x * x
}
f()
x <- 15
f()

x <- 10
y <- 15
x + y

`+` <- function(x, y) 10 * x * y
x + y
base::`+`(x,y)
