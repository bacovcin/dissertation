data {
  // priors for reanalysis point
  real ryMean;
  real ryProMean;
  real rySD;

  // number of tokens in each case
  int<lower=0> N1;
  int<lower=0> N2;
  int<lower=0> N3;
  int<lower=0> N4;

  real x1[N1]; // years for theme--recipient, fulogit noun phrase
  real x2[N2]; // years for theme--recipient, pronoun
  real x3[N3]; // years for recipient--theme, fulogit noun phrase
  real x4[N4]; // years for recipient--theme, pronoun

  // Load in the dependent variables
  int<lower=0,upper=1> y1[N1];
  int<lower=0,upper=1> y2[N2];
  int<lower=0,upper=1> y3[N3];
  int<lower=0,upper=1> y4[N4];
}
parameters {
  real ry; // Year of reanalysis
  real rypro; // Difference for pronouns
  real Int1;
  real Slope1;
  real ProInt1;
  real ProSlope1;
  real RTInt1;
  real RTSlope1;
  real ProRTInt1;
  real ProRTSlope1;
  real Slope2;
  real ProSlope2;
}
transformed parameters {
  real Int2;
  real ProInt2;

  Int2 = (Int1 + Slope1 * ry + RTInt1 + RTSlope1 * ry) - (Slope2 * ry);
  ProInt2 = (Int1 + Slope1 *ry + ProInt1 + ProSlope1 * ry + RTInt1 + RTSlope1 * ry + ProRTInt1 + ProRTSlope1 * ry) - (Slope2 * rypro + ProSlope2 * rypro);
}
model {
  real logit1[N1];
  real logit2[N2];
  real logit3[N3];
  real logit4[N4];

  // Prior for reanalysis points
  ry ~ normal(ryMean,rySD);
  rypro ~ normal(ryProMean,rySD);

  // Intercept has larger SD
  Int1 ~ cauchy(0,10);
  
  // Non-intercept have half the SD of intercepts
  Slope1 ~ cauchy(0,2.5);
  Slope2 ~ cauchy(0,2.5);
  ProInt1 ~ cauchy(0,2.5);
  ProSlope1 ~ cauchy(0,2.5);
  RTInt1 ~ cauchy(0,2.5);
  RTSlope1 ~ cauchy(0,2.5);
  ProRTInt1 ~ cauchy(0,2.5);
  ProRTSlope1 ~ cauchy(0,2.5);
  Slope2 ~ cauchy(0,2.5);
  ProSlope2 ~ cauchy(0,2.5);

  // Calculate the log-odds
  for (j in 1:N1) {logit1[j] = Int1 + Slope1 * x1[j];}
  for (j in 1:N2) {logit2[j] = Int1 + Slope1 * x2[j] + ProInt1 + ProSlope1 * x2[j];}
  for (j in 1:N3) {
	if (x3[j] < ry) {
		logit3[j] = Int1 + Slope1 * x3[j] + RTInt1 + RTSlope1 * x3[j];
	} else {
		logit3[j] = Int2 + Slope2 * x3[j];
	}
  }
  for (j in 1:N4) {
	if (x4[j] < rypro) {
		logit4[j] = Int1 + Slope1 * x4[j] + RTInt1 + RTSlope1 * x4[j] + ProInt1 + ProSlope1 * x4[j] + ProRTInt1 + ProRTSlope1 * x4[j];
	} else {
		logit4[j] = Int2 + Slope2 * x4[j] + ProInt2 + ProSlope2 * x4[j];
	}
  }
  y1 ~ bernoulli_logit(logit1);
  y2 ~ bernoulli_logit(logit2);
  y3 ~ bernoulli_logit(logit3);
  y4 ~ bernoulli_logit(logit4);
}
