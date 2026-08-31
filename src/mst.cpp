#include <Rcpp.h>
#include <vector>
#include <algorithm>
#include <numeric>
#include <cmath>

// C++ implementation based on ape::mst by Yvonnick Noel, Julien Claude,
// and Emmanuel Paradis.

using namespace Rcpp;

// [[Rcpp::plugins(cpp11)]]

template <typename T>
std::vector<int> ordr(const std::vector<T>& v) {
  std::vector<int> ix(v.size());
  std::iota(ix.begin(), ix.end(), 0);
  std::stable_sort(ix.begin(), ix.end(), [&v](int i1, int i2) {
    return v[i1] < v[i2];
  });
  return ix;
}

IntegerVector orderC(NumericVector x) {
  std::vector<double> xx = as<std::vector<double> >(x);
  return wrap(ordr(xx));
}

NumericVector col_mins(NumericMatrix& m) {
  const int nc = m.ncol();
  NumericVector out(nc);
  for (int i = 0; i < nc; ++i) {
    NumericVector column = m(_, i);
    out[i] = *std::min_element(column.begin(), column.end());
  }
  return out;
}

IntegerMatrix sortIndexC(NumericMatrix& m) {
  IntegerMatrix out(m.nrow(), m.ncol());
  for (int i = 0; i < m.ncol(); ++i) {
    NumericVector column = m(_, i);
    out(_, i) = orderC(column);
  }
  return out;
}

NumericMatrix mx_subset(NumericMatrix& m, IntegerVector& cols) {
  NumericMatrix out(m.nrow(), cols.size());
  for (R_xlen_t i = 0; i < cols.size(); ++i) {
    out(_, i) = m(_, cols[i]);
  }
  return out;
}

//' Minimum spanning tree
//'
//' C++ implementation based on `ape::mst`.
//'
//' @param d An object of class `dist` containing finite distances.
//' @param debug Logical; print intermediate algorithm state.
//' @return A symmetric adjacency matrix of class `mst`.
//' @export
// [[Rcpp::export]]
IntegerMatrix mst(RObject d, bool debug = false) {
  if (!d.inherits("dist")) stop("Please supply a 'dist' object!");

  Function as_matrix("as.matrix");
  NumericMatrix X = as_matrix(d);
  const int n = X.ncol();
  if (n != X.nrow()) stop("The distance matrix must be square.");
  if (n < 1) stop("The distance object must contain at least one observation.");
  for (NumericMatrix::iterator it = X.begin(); it != X.end(); ++it) {
    if (!std::isfinite(*it)) stop("Distances must all be finite.");
  }

  IntegerMatrix N(n, n);
  IntegerVector tree;
  const double max_value = *std::max_element(X.begin(), X.end());
  const double large_value = max_value + std::max(1.0, std::abs(max_value));
  X.fill_diag(large_value);
  int index_i = 0;

  if (debug) {
    Rcout << "\n#### Initialisation ####\n";
    Rcout << "\nmatrix X:\n";
    Rf_PrintValue(X);
    Rcout << "\nnumber of columns: " << n << "\n";
  }

  for (int i = 0; i < n - 1; ++i) {
    tree.push_back(index_i);
    NumericMatrix subset = mx_subset(X, tree);
    NumericVector minima = col_mins(subset);
    IntegerMatrix sorted = sortIndexC(subset);
    IntegerVector nearest = sorted(0, _);
    IntegerVector min_order = orderC(minima);
    const int tree_position = min_order[0];
    const int index_j = tree[tree_position];
    index_i = nearest[tree_position];

    N(index_i, index_j) = 1;
    N(index_j, index_i) = 1;

    for (IntegerVector::iterator j = tree.begin(); j != tree.end(); ++j) {
      X(index_i, *j) = large_value;
      X(*j, index_i) = large_value;
    }

    if (debug) {
      Rcout << "\n##### Iteration " << i << " #####\n";
      Rcout << "\ntree:\n";
      Rf_PrintValue(tree);
      Rcout << "\nadjacency matrix:\n";
      Rf_PrintValue(N);
    }
  }

  N.attr("dimnames") = X.attr("dimnames");
  N.attr("class") = "mst";
  return N;
}
