data {
  // prior SD
  real priorSD;
  int<lower=0,upper=1> NormalPrior;

  // number of tokens in each case
  int<lower=0> T;
  vector[T] t; // years for theme--recipient, fulogit noun phrase
  int<lower=0> n[T];
  int<lower=0> N[T];
  int<lower=0> REPoint;
}
transformed data {
  vector[REPoint] t1;
  int<lower=0> n1[REPoint];
  int<lower=0> N1[REPoint];

  vector[T-REPoint] t2;
  int<lower=0> n2[T-REPoint];
  int<lower=0> N2[T-REPoint];

  t1 = head(t,REPoint);
  n1 = head(n,REPoint);
  N1 = head(N,REPoint);

  t2 = tail(t,T-REPoint);
  n2 = tail(n,T-REPoint);
  N2 = tail(N,T-REPoint);
}
parameters {
  real Int1;
  real Slope1;
  real Slope2;
}
transformed parameters {
  real Int2;
  Int2 = (Int1 + Slope1 * t[REPoint]) - Slope2 * t[REPoint];
}
model {
  vector[REPoint] logit1;
  vector[T-REPoint] logit2;
  if (NormalPrior == 0) {
    Int1 ~ cauchy(0, priorSD);
    Slope1 ~ cauchy(0, priorSD);
    Slope2 ~ cauchy(0, priorSD);
  } else {
    Int1 ~ normal(0, priorSD);
	Slope1 ~ normal(0, priorSD);
	Slope2 ~ normal(0, priorSD);
  }

  logit1 = Int1 + Slope1 * t1;
  logit2 = Int2 + Slope2 * t2;

  n1 ~ binomial_logit(N1, logit1);
  n2 ~ binomial_logit(N2, logit2);
}

