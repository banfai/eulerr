#ifndef SOLVERS
#define SOLVERS

#include <RcppArmadillo.h>

// Solve a cubic polynomial
arma::cx_vec solve_cubic(const arma::vec& v) {
  std::complex<double> i(0.0, 1.0);
  arma::cx_vec::fixed<3> y;

  double a = v(1)/v(0);
  double b = v(2)/v(0);
  double c = v(3)/v(0);
  double Q = (pow(a, 2) - 3.0*b)/9.0;
  double R = (2.0*pow(a, 3) - 9.0*a*b + 27.0*c)/54.0;

  if (pow(R, 2) < pow(Q, 3)) {
    double theta = acos(R/sqrt(pow(Q, 3)));
    y(0) = -2.0*sqrt(Q)*cos(theta/3.0) -  a/3.0;
    y(1) = -2.0*sqrt(Q)*cos((theta + 2.0*arma::datum::pi)/3.0) - a/3.0;
    y(2) = -2.0*sqrt(Q)*cos((theta - 2.0*arma::datum::pi)/3.0) - a/3.0;
  } else {
    double A = -copysign(1.0, R)*cbrt(std::abs(R) + sqrt(pow(R, 2) - pow(Q, 3)));
    double B;
    if (std::abs(A - 0) < pow(arma::datum::eps, 0.95)) {
      B = 0;
    } else {
      B = Q/A;
    }
    y(0) = A + B - a/3.0;
    y(1) = -0.5*(A + B) - a/3.0 + sqrt(3.0)*i*(A - B)/2.0;
    y(2) = -0.5*(A + B) - a/3.0 - sqrt(3.0)*i*(A - B)/2.0;
  }

  return y;
}

#endif //SOLVERS
