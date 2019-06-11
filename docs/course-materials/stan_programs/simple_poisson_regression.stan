// functions {
//   /*
//   * Alternative to poisson_log_rng() that 
//   * avoids potential numerical problems during warmup
//   */
//   int poisson_log_safe_rng(real eta) {
//     real pois_rate = exp(eta);
//     if (pois_rate >= exp(20.79))
//       return -9;
//     return poisson_rng(pois_rate);
//   }
// }
data {
  int<lower=1> N;
  int<lower=0> complaints[N];
  vector<lower=0>[N] traps;
}
parameters {
  real alpha;
  real beta;
}
transformed parameters {
  // could declare 'eta' here if we want to save it 
}
model {
  // temporary variable because declared in model block
  vector[N] eta = alpha + beta * traps;
  
  // poisson_log(eta) is more efficient and stable alternative to poisson(exp(eta))
  complaints ~ poisson_log(eta);
  
  // weakly informative priors:
  // we expect negative slope on traps and a positive intercept,
  // but we will allow ourselves to be wrong
  beta ~ normal(-0.25, 1);
  alpha ~ normal(log(4), 1);
} 
generated quantities {
  int y_rep[N];

  for (n in 1:N) {
    real eta_n = alpha + beta * traps[n];
    y_rep[n] = poisson_log_rng(eta_n); 
  }
}
