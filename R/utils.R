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

#' Tally set relationships
#'
#' @param sets a data.frame with set relationships and weights
#' @param weights a numeric vector
#'
#' @return Calls [euler()] after the set relationships have been coerced to a
#'   named numeric vector.
#' @keywords internal
tally_combinations <- function(sets, weights) {
  if (!is.matrix(sets))
    sets <- as.matrix(sets)

  id <- bit_indexr(NCOL(sets))
  tally <- double(NROW(id))

  for (i in seq_len(NROW(id))) {
    tally[i] <-
      sum(as.numeric(colSums(t(sets) == id[i, ]) == NCOL(sets))*weights)
    names(tally)[i] <- paste0(colnames(sets)[id[i, ]], collapse = "&")
  }
  tally
}

#' Rescale values to new range
#'
#' @param x numeric vector
#' @param new_min new min
#' @param new_max new max
#'
#' @return Rescaled vector
#' @keywords internal
rescale <- function(x, new_min, new_max) {
  (new_max - new_min)/(max(x) - min(x))*(x - max(x)) + new_max
}

#' Update list with input
#'
#' A wrapper for [utils::modifyList()] that attempts to coerce non-lists to
#' lists before updating.
#'
#' @param x a list to be updated
#' @param val stuff to update `x` with
#'
#' @seealso [utils::modifyList()]
#' @return Returns an updated list.
#' @keywords internal
update_list <- function(old, new) {
  if (is.null(old))
    old <- list()
  if (!is.list(new))
    tryCatch(new <- as.list(new))
  if (!is.list(old))
    tryCatch(old <- as.list(old))
  utils::modifyList(old, new)
}

#' Replace (refresh) a list
#'
#' Unlike `update_list`, this function only modifies, and does not add,
#' items in the list.
#'
#' @param old the original list
#' @param new the things to update `old` with
#'
#' @return A refreshed list.
#' @keywords internal
replace_list <- function(old, new) {
  update_list(old, new[names(new) %in% names(old)])
}

#' Suppress plotting
#'
#' @param x object to call [graphics::plot()] on
#' @param ... arguments to pass to `x`
#'
#' @return Invisibly returns whatever `plot(x)` would normally return, but
#'   does not plot anything (which is the point).
#' @keywords internal
dont_plot <- function(x, ...) {
  tmp <- tempfile()
  grDevices::png(tmp)
  p <- graphics::plot(x, ...)
  grDevices::dev.off()
  unlink(tmp)
  invisible(p)
}

#' Suppress printing
#'
#' @param x object to (not) print
#' @param ... arguments to `x`
#'
#' @return Invisibly returns the output of running print on `x`.
#' @keywords internal
dont_print <- function(x, ...) {
  utils::capture.output(y <- print(x, ...))
  invisible(y)
}

#' Check if object is strictly FALSE
#'
#' @param x object to check
#'
#' @return A logical.
#' @keywords internal
is_false <- function(x) {
  identical(x, FALSE)
}

#' Binary indices
#'
#' Wraps around bit_indexr().
#'
#' @param n number of items to generate permutations from
#'
#' @return A matrix of logicals.
#' @keywords internal
bit_indexr <- function(n) {
  m <- bit_index_cpp(n)
  mode(m) <- "logical"
  m
}

#' regionError
#'
#' @param fit fitted values
#' @param orig original values
#'
#' @return regionError
#' @keywords internal
regionError <- function(fit, orig) {
  abs(fit/sum(fit) - orig/sum(orig))
}

#' diagError
#'
#' @param fit fitted values
#' @param orig original values
#' @param regionError regionError
#'
#' @return diagError
#' @keywords internal
diagError <- function(fit, orig, regionError = NULL) {
  if(!is.null(regionError)) {
    max(regionError)
  } else {
    max(abs(fit/sum(fit) - orig/sum(orig)))
  }
}

#' Get the number of sets in he input
#'
#' @param combinations a vector of combinations (see [euler()])
#'
#' @return The number of sets in the input
#' @keywords internal
n_sets <- function(combinations) {
  combo_names <- strsplit(names(combinations), split = "&", fixed = TRUE)
  length(unique(unlist(combo_names, use.names = FALSE)))
}


#' Set up constraints for optimization
#'
#' @param newpars parameters from the first optimizer
#'
#' @return A list of lower and upper constraints
#' @keywords internal
get_constraints <- function(newpars) {
  h   <- newpars[, 1L]
  k   <- newpars[, 2L]
  a   <- newpars[, 3L]
  b   <- newpars[, 4L]
  phi <- newpars[, 5L]

  n <- length(h)

  xlim <- sqrt(a^2*cos(phi)^2 + b^2*sin(phi)^2)
  ylim <- sqrt(a^2*sin(phi)^2 + b^2*cos(phi)^2)
  xbnd <- range(xlim + h, -xlim + h)
  ybnd <- range(ylim + k, -ylim + k)

  lwr <- upr <- double(5L*n)

  for (i in seq_along(h)) {
    ii <- 5L*(i - 1L)

    lwr[ii + 1L] <- xbnd[1L]
    lwr[ii + 2L] <- ybnd[1L]
    lwr[ii + 3L] <- a[i]/3
    lwr[ii + 4L] <- b[i]/3
    lwr[ii + 5L] <- 0

    upr[ii + 1L] <- xbnd[2L]
    upr[ii + 2L] <- ybnd[2L]
    upr[ii + 3L] <- a[i]*3
    upr[ii + 4L] <- b[i]*3
    upr[ii + 5L] <- pi
  }
  list(lwr = lwr, upr = upr)
}

#' Normalize an angle to [-pi, pi)
#'
#' @param x angle in radians
#'
#' @return A normalized angle.
#' @keywords internal
normalize_angle <- function(x) {
  a <- (x + pi) %% (2*pi)
  ifelse(a >= 0, a - pi, a + pi)
}

#' Normalize parameters (semiaxes and rotation)
#'
#' @param m pars
#'
#' @return `m`, normalized
#' @keywords internal
normalize_pars <- function(m) {
  n <- NCOL(m)
  if (n == 3L) {
    m[, 3L] <- abs(m[, 3L])
  } else {
    m[, 3L:4L] <- abs(m[, 3L:4L])
    m[, 5L] <- normalize_angle(m[, 5L])
  }
  m
}

#' Blend (average) colors
#'
#' @param rcol_in a vector of R colors
#'
#' @return A single R color
#' @keywords internal
mix_colors <- function(rcol_in) {
  rgb_in <- t(grDevices::col2rgb(rcol_in))
  lab_in <- grDevices::convertColor(rgb_in, "sRGB", "Lab", scale.in = 255)
  mean_col <- colMeans(lab_in)
  rgb_out <- grDevices::convertColor(mean_col, "Lab", "sRGB", scale.out = 1)
  grDevices::rgb(rgb_out)
}

#' Setup gpars
#'
#' @param x input
#' @param n required number of items
#' @param default default values
#' @param user user-inputted values
#'
#' @return a `gpar` object
#' @keywords internal
setup_gpar <- function(default = list(), user = list(), n) {
  # set up gpars
  if (is.list(user)) {
    gp <- replace_list(default, user)
  } else {
    gp <- default
  }
  gp <- lapply(gp, function(x) if (is.function(x)) x(n) else x)

  do.call(grid::gpar, lapply(gp, rep_len, n))
}

