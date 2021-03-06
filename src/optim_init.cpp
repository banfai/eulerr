// eulerr: Area-Proportional Euler and Venn Diagrams with Circles or Ellipses
// Copyright (C) 2018 Johan Larsson <johanlarsson@outlook.com>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

#define ARMA_NO_DEBUG // For the final version

#include <Rcpp.h>

// Computes the loss, gradient, and hessian simultaneously. For use with nlm()
// [[Rcpp::export]]
Rcpp::NumericVector
optim_init(const Rcpp::NumericVector& par,
           const Rcpp::NumericMatrix& d,
           const Rcpp::LogicalMatrix& disjoint,
           const Rcpp::LogicalMatrix& subset) {
  const unsigned int n = par.size()/2;
  const Rcpp::NumericVector x = Rcpp::head(par, n);
  const Rcpp::NumericVector y = Rcpp::tail(par, n);


  double loss = 0;
  Rcpp::NumericVector grad(2*n, 0.0);
  //Rcpp::NumericMatrix hess(2*n, 2*n);

  for (unsigned int i = 0; i < (n - 1); ++i) {
    for (unsigned int j = i + 1; j < n; ++j) {
      double xd = x(j) - x(i);
      double yd = y(j) - y(i);
      double D = xd*xd + yd*yd - std::pow(d(j, i), 2);
      if ((disjoint(j, i) && (D >= 0.0)) || (subset(j, i) && (D < 0.0))) {
        continue;
      } else {
        // Loss
        loss += D*D;

        // Gradient
        grad[j]     += 4.0*xd*D;
        grad[i]     -= 4.0*xd*D;
        grad[j + n] += 4.0*yd*D;
        grad[i + n] -= 4.0*yd*D;

        // // Upper left hessian
        // hess(j, j) += 4.0*D + 8.0*xd*xd;
        // hess(i, i) += 4.0*D + 8.0*xd*xd;
        // hess(i, j) -= 4.0*D + 8.0*xd*xd;
        //
        // // Lower right hessian
        // hess(j + n, j + n) += 4.0*D + 8.0*yd*yd;
        // hess(i + n, i + n) += 4.0*D + 8.0*yd*yd;
        // hess(i + n, j + n) -= 4.0*D + 8.0*yd*yd;
        //
        // // Lower left hessian
        // hess(j + n, j) += 8.0*xd*yd;
        // hess(i + n, i) += 8.0*xd*yd;
        // hess(j + n, i) -= 8.0*xd*yd;
        // hess(i + n, j) -= 8.0*xd*yd;
      }
    }
  }

  Rcpp::NumericVector out(1, loss);

  out.attr("gradient") = grad;
  //out.attr("hessian") = arma::symmatl(hess);

  return out;
}
