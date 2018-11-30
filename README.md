## elif

This is a small package that exposes a single function to make managing
if-else logic in R more pleasing to look at.

## Usage

```r
library(elif)

x <- with(mtcars, elif(
  mpg < 20 -> "low",
  mpg < 25 -> "med", "hi"
))
```

This produces the following output:

```r
> t(sapply(split(mtcars$mpg, x), range))

    min  max
low 10.4 19.7
med 21.0 24.4
hi  26.0 33.9
```

You can also provide a vector as the final argument like so:

```r
y <- with(mtcars, elif(
  mpg < 20 -> "low",
  mpg < 25 -> "med", cyl
))

> table(y)
y
  4 low med 
  6  18   8 
```
