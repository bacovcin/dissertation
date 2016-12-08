data {
  real PseudoP;
  real DitP;
  // prior SD
  real priorSD;

  // number of tokens in each case
  int<lower=0> N1;
  int<lower=0> N2;

  real x1[N1]; // years for theme--recipient, fulogit noun phrase
  real x2[N2]; // years for theme--recipient, pronoun

  // Load in the dependent variables
  int<lower=0,upper=1> y1[N1];
  int<lower=0,upper=1> y2[N2];
}
parameters {
  real Int;
  real Slope;
  real DitInt;
  real DitSlope;
}

model {
  real logit1[N1];
  real logit2[N2];
  real p1[N1];
  real p2[N2];

  // Prior for scales
  Int ~ cauchy(0,priorSD);
  Slope ~ cauchy(0,priorSD);
  DitInt ~ cauchy(0,priorSD);
  DitSlope ~ cauchy(0,priorSD);

  // Calculate the log-odds
  for (j in 1:N1) {
  	logit1[j] = Int + Slope * x1[j];
	p1[j] = inv_logit(logit1[j]) * PseudoP;
  }
  for (j in 1:N2) {
  	logit2[j] = Int + Slope * x2[j] + DitInt + DitSlope * x2[j];
	p2[j] = inv_logit(logit2[j]) * DitP;
  }

  y1 ~ bernoulli(p1);
  y2 ~ bernoulli(p2);
}
