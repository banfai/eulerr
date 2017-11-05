#ifndef eulerr_helpers_
#define eulerr_helpers_

#include <RcppArmadillo.h>

// Set intersect
inline
arma::uvec set_intersect(const arma::uvec& x, const arma::uvec& y) {
  std::vector<int> out;
  std::set_intersection(x.begin(), x.end(), y.begin(), y.end(),
                        std::back_inserter(out));
  return arma::conv_to<arma::uvec>::from(out);
}

// Number of n choose k. (Credited to Ben Voigt.)
template <typename T>
inline
T nck(T n, T k) {
  if (k > n)
    return 0;
  if (k*2 > n)
    k = n - k;
  if (k == 0)
    return 1;

  T out = n;

  for(T i = 2; i <= k; ++i) {
    out *= (n - i + 1);
    out /= i;
  }

  return out;
}

// Bit indexing
// (http://stackoverflow.com/questions/9430568/generating-combinations-in-c)
template <typename T>
inline
arma::umat bit_index(T n) {
  T n_combos = 0;

  for (T i = 1; i < n + 1; ++i)
    n_combos += nck(n, i);

  arma::umat out(n_combos, n, arma::fill::zeros);

  for (T i = 1, k = 0; i < n + 1; ++i) {
    std::vector<bool> v(n);
    std::fill(v.begin(), v.begin() + i, true);
    do {
      for (T j = 0; j < n; ++j) {
        if (v[j]) out(k, j) = true;
      }
      k++;
    } while (std::prev_permutation(v.begin(), v.end()));
  }
  return out;
}

// Signum function
template <typename T>
inline
int sign(T x) {
  return (T(0) < x) - (x < T(0));
}

// Nearly equal
template <typename T>
inline
bool nearly_equal(T a, T b) {
  return (std::abs(a - b) <= std::numeric_limits<T>::epsilon() *
          std::max(std::abs(a), std::abs(b)));
}

// Max of minimums colwise
inline
arma::uword max_colmins(const arma::mat& x) {
  arma::uword n = x.n_cols;
  arma::vec mins(n);

  for (arma::uword i = 0; i < n; ++i)
    mins(i) = x.col(i).min();

  return mins.index_max();
}

// Convert armadillo vector to rcpp vector
template <typename T>
Rcpp::NumericVector arma_to_rcpp(const T& x) {
  return Rcpp::NumericVector(x.begin(), x.end());
}

#endif
