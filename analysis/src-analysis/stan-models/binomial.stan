data {
  // prior SD
  real priorSD;
  int<lower=0,upper=1> NormalPrior;

  // number of tokens in each case
  int<lower=0> T;
  vector[T] t; // years for theme--recipient, fulogit noun phrase
  int<lower=0> n[T];
  int<lower=0> N[T];
}
parameters {
  real Int;
  real Slope;
}
model {
  vector[T] mylogit;

  if (NormalPrior == 0) {
    Int ~ cauchy(0, priorSD);
    Slope ~ cauchy(0, priorSD);
  } else {
    Int ~ normal(0, priorSD);
	Slope ~ normal(0, priorSD);
  }

  mylogit = Int + Slope * t;
  n ~ binomial_logit(N, mylogit);
}
