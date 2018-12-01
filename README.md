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
> aggregate(mpg~x, mtcars, function(x) c(min=min(x), max=max(x)))

    x mpg.min mpg.max
1  hi    26.0    33.9
2 low    10.4    19.7
3 med    21.0    24.4
```

You can also provide a vector as the final argument. Omitting a final assignment
expression will fill the vector with NAs where a predicate is not matched.

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

elif is also dplyr friendly and provides a function alias more aligned with the 
tidyverse naming convention: `else_if`, although the two are functionally
identical:

```r
library(dplyr)

mtcars <- mtcars %>%
mutate(
  mpg_char = else_if(
    mpg > 25 -> 'hi',
    mpg < 20 -> 'lo', 'med'
  ),
  cyl_char = else_if(
    cyl == 4 -> 'four-banger',
    cyl == 8 -> 'gas-guzzler', 'average'
  ))

> head(mtcars)
   mpg cyl disp  hp drat    wt  qsec vs am gear carb mpg_char    cyl_char
1 21.0   6  160 110 3.90 2.620 16.46  0  1    4    4      med     average
2 21.0   6  160 110 3.90 2.875 17.02  0  1    4    4      med     average
3 22.8   4  108  93 3.85 2.320 18.61  1  1    4    1      med four-banger
4 21.4   6  258 110 3.08 3.215 19.44  1  0    3    1      med     average
5 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2       lo gas-guzzler
6 18.1   6  225 105 2.76 3.460 20.22  1  0    3    1       lo     average
```
