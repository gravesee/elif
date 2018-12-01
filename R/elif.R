#' @importFrom utils head tail
NULL

fixfun <- function(dots) {
  if (length(dots) == 1) {
    return(dots[[1]])
  } else {
    tmp <- dots[[1]]
    return(call("ifelse", tmp[[3]], tmp[[2]], fixfun(dots[-1])))
  }
}

is_assignment <- function(x) {
  if (length(x) > 1) identical(x[[1]], quote(`<-`)) else FALSE
}

is_valid <- function(dots) {
  check <- sapply(dots, is_assignment)
  if (all(head(check, -1)) && !tail(check, 1)) {
    "HAS_DEFAULT"
  } else if (all(check)) {
    "NO_DEFAULT"
  } else {
    stop("invalid arguments passed to `elif`", call. = FALSE)
  }
}

#' elif
#' Generate vectorized if-else logic with pleasing syntax
#' @param ... Expressions separated by commas mapping predicates to values using
#' the #' \code{->} operator reminiscent of pattern matching in other languages.
#' The last #' expression may ommit the right-assignment operator and be treated
#' as a default value. 
#' @param env Where the resultant expression should be evaluated. Defaults
#' to the \code{parent.frame()}.
#' @return the result of the evaulated \code{ifelse} expression evaulated in \code{env}.
#' @examples
#' \dontrun{
#' res <- with(mtcars, elif(
#'  cyl == 4 -> "a",
#'  cyl == 6 -> "b",
#'  cyl == 8 -> "c", "d"))
#' }
#' @export
elif <- function(..., env=parent.frame()) {
  dots <- eval(substitute(alist(...)))
  status <- is_valid(dots)
  if (status == "NO_DEFAULT") {
    dots <- c(dots, expression(NA))
  }
  eval(fixfun(dots), envir = env)
}

#'@export
else_if <- elif
