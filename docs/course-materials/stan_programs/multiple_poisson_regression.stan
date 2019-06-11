functions {
  /*
  * Alternative to poisson_log_rng() that
  * avoids potential numerical problems during warmup
  */
  int poisson_log_safe_rng(real eta) {
    real pois_rate = exp(eta);
    if (pois_rate >= exp(20.79))
      return -9;
    return poisson_rng(pois_rate);
  }
}
data {
  int<lower=1> N;
  int<lower=0> complaints[N];
  vector<lower=0>[N] traps;
  
  // declare live_in_super variable
  // declare exposure termv log_sq_foot
}
parameters {
  real alpha;
  real beta;
  // declare parameter beta_super
}
model {
  // add new predictors to expression for eta
  vector[N] eta = alpha + beta * traps;
  
  complaints ~ poisson_log(eta);
  
  beta ~ normal(-0.25, 1);
  alpha ~ normal(log(4), 1);
  
  // add prior on beta_super
} 
generated quantities {
  int y_rep[N];
  for (n in 1:N) {
    // add new predictors here too
    y_rep[n] = poisson_log_safe_rng(alpha + beta * traps[n]);
  }
}
