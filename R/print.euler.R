# eulerr: Area-Proportional Euler and Venn Diagrams with Circles or Ellipses
# Copyright (C) 2018 Johan Larsson <johanlarsson@outlook.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#' Print Euler diagram fits
#'
#' This function is responsible for printing fits from [euler()] and provides
#' a summary of the fit. Prints a data frame of the original set relationships
#' and the fitted values as well as `diagError` and `stress` statistics.
#'
#' @param x `'euler'` object from [euler()]
#' @param round number of decimal places to round to
#' @param vsep character string to paste in between `euler` objects
#'   when `x` is a nested `euler` object
#' @param ... arguments passed to [base::print.data.frame()]
#'
#' @return Summary statistics of the fitted Euler diagram is printed to
#' screen or a plot is generated.
#' @seealso [euler()], [base::print.data.frame()]
#'
#' @export
print.euler <- function(
  x,
  round = 3,
  vsep = strrep("-", 0.75*getOption("width")),
  ...
) {
  stopifnot(is.numeric(round), length(round) == 1L, round > 0)

  if (!is.null(attr(x, "groups"))) {
    for (i in seq_along(x)) {
      if (i != 1L && !is.null(vsep))
        cat(vsep, "\n")
      cat(names(x)[i], "\n")
      print(x[[i]], round = round, ...)
    }
  } else {
    print(round(data.frame("original" = x$original.values,
                           "fitted" = x$fitted.values,
                           "residuals" = x$residuals,
                           "regionError" = x$regionError),
                digits = round), ...)
    cat("\n")
    cat("diagError:", round(x$diagError, digits = round), "\n")
    cat("stress:   ", round(x$stress, digits = round), "\n")
  }
  invisible(x)
}

