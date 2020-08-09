#include <Rcpp.h>
#include <vector>
#include <algorithm>
#include <numeric>

// This is a transcript of ape::mst by Yvonnick Noel, Julien Claude, and Emmanuel Paradis, 
// cf. https://github.com/cran/ape/blob/master/R/mst.R

using namespace Rcpp;

template <typename T>
std::vector<int> ordr(const std::vector<T> &v) {
  std::vector<int> ix(v.size());
  std::iota(ix.begin(), ix.end(), 0);
  std::stable_sort(ix.begin(), ix.end(), [&v](int i1, int i2) {return v[i1] < v[i2];});
  return ix;
}

IntegerVector orderC(NumericVector x) {
  std::vector<double> xx = as<std::vector<double>>(x);
  std::vector<int> i = ordr(xx);
  return wrap(i);
}

NumericVector col_mins(NumericMatrix& m) {
  int nc = m.ncol();
  NumericVector o(nc);
  for (int i = 0; i < nc; i++) {
    NumericVector c = m(_,i);
    o[i] = *std::min_element(c.begin(), c.end());
  }
  return o;
}

IntegerMatrix sortIndexC(NumericMatrix& m) {
  IntegerMatrix o(m.rows(), m.cols());
  for (int i = 0; i < m.cols(); i++) {
    NumericVector c = m(_,i);
    o(_,i) = orderC(c);
  }
  return o;
}

NumericMatrix mx_subset(NumericMatrix& m, IntegerVector& cols) {
  NumericMatrix o(m.rows(), cols.size());
  IntegerVector::iterator i;
  int c;
  for (i = cols.begin(), c = 0; i != cols.end(); i++, c++) {
    o(_, c) = m(_, *i);
  }
  return o;
}
//' Minimum spanning tree
//' 
//' This is a C++ transcript of function \code{mst} in package \code{ape} by Yvonnick Noel, Julien Claude, and Emmanuel Paradis, 
//' cf. \href(https://github.com/cran/ape/blob/master/R/mst.R){Github archive of mst.R}.
//'
//' @param d An object of type 'dist'.
//' @return An adjacency matrix belonging to class 'mst'.
//' @export
// [[Rcpp::export]]
IntegerMatrix mstC(RObject d) {
  if (!d.inherits("dist")) stop("Please supply a 'dist' object!");
  Function d2m("as.matrix");
  NumericMatrix X = d2m(d);
  int n = X.cols();
  IntegerMatrix N(n, n);
  IntegerVector tree;
  double large_value = *std::max_element(X.begin(), X.end()) + 1;
  X.fill_diag(large_value);
  int index_i = 0;
  
  for (int i = 0; i < (n - 1); i++) {
    tree.push_back(index_i);
    // std::cout << index_i << "\n";
    NumericMatrix s = mx_subset(X, tree);
    NumericVector m = col_mins(s);
    IntegerMatrix a0 = sortIndexC(s);
    IntegerVector a = a0(0, _);
    IntegerVector b0 = orderC(m);
    int b = b0[0];
    int index_j = tree[b];
    index_i = a[b];
    
    N(index_i, index_j) = 1;
    N(index_j, index_i) = 1;
    
    IntegerVector::iterator j;
    
    for (j = tree.begin(); j != tree.end(); j++) {
      X(index_i, *j) = 1;
      X(*j, index_i) = 1;
    }
  }
  N.attr("dimnames") = X.attr("dimnames");
  N.attr("class") = "mst";
  return N;
}

// // [[Rcpp::export]]
// // slightly slower than mx_subset
// NumericMatrix mx_subset_a(NumericMatrix& m, IntegerVector& cols) {
//   arma::uvec ci = as<arma::uvec>(cols);
//   arma::mat ma = as<arma::mat>(m);
//   arma::mat ma_s = ma.cols(ci);
//   return wrap(ma_s);
// }
// 
// // [[Rcpp::export]]
// // slightly quicker (~10%) than mx_subset
// arma::mat mx_subset_a2(arma::mat& m, arma::uvec& cols) {
//   return(m.cols(cols));
// }
