% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/eulerr_deprecated.R
\name{eulerr_deprecated}
\alias{eulerr_deprecated}
\alias{prepanel.euler}
\alias{panel.euler}
\alias{panel.euler.circles}
\alias{panel.euler.ellipses}
\alias{panel.euler.labels}
\alias{label}
\alias{label.euler}
\title{Deprecated functions in package \pkg{eulerr}.}
\usage{
prepanel.euler(x, y, ra, rb, phi, subscripts, ...)

panel.euler(x, y, ra, rb, phi, subscripts, fill = superpose.polygon$col,
  lty = superpose.polygon$lty, lwd = superpose.polygon$lwd,
  border = superpose.polygon$border, alpha = superpose.polygon$alpha,
  fill_alpha = 0.4, fontface = "bold", quantities = FALSE,
  labels = NULL, original.values, fitted.values, mode = c("split",
  "overlay"), ...)

panel.euler.circles(x, y, r, border = "black", fill = "transparent",
  fill_alpha = 0.4, ..., identifier = NULL, name.type = "panel", col,
  font, fontface)

panel.euler.ellipses(x, y, ra, rb, phi, fill = "transparent",
  fill_alpha = 0.4, border = "black", mode = c("split", "overlay"),
  identifier = NULL, n = 200, fitted.values, ..., name.type = "panel",
  col, font, fontface)

panel.euler.labels(x, y, ra, rb, phi, labels, quantities = FALSE,
  original.values, fitted.values, ...)

label(x, labels = NULL)

\method{label}{euler}(x, labels = NULL)
}
\description{
The functions listed below are deprecated and will be defunct in
the near future. When possible, alternative functions with similar
functionality are also mentioned. Help pages for deprecated functions are
available at \code{help("_deprecated")}.
}
\section{\code{prepanel.euler}}{

For \code{prepanel.euler()}, use \code{\link[=plot.euler]{plot.euler()}}.
}

\section{\code{panel.euler}}{

For \code{panel.euler()}, use \code{\link[=plot.euler]{plot.euler()}}.
}

\section{\code{panel.euler.circles}}{

For \code{panel.euler.circles()}, use \code{\link[=plot.euler]{plot.euler()}}.
}

\section{\code{panel.euler.ellipses}}{

For \code{panel.euler.ellipses()}, use \code{\link[=plot.euler]{plot.euler()}}.
}

\section{\code{panel.euler.labels}}{

For \code{panel.euler.labels()}, use \code{\link[=plot.euler]{plot.euler()}}.
}

\section{\code{label.euler}}{

For \code{label.euler()}, use \code{\link[=plot.euler]{plot.euler()}}.
}

\keyword{internal}
