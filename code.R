

# Bailey, David H. and Borwein, Jonathan M. and Lopez de Prado,
#   Marcos and Zhu, Qiji Jim
# Pseudo-Mathematics and Financial Charlatanism:
#   The Effects of Backtest Overfitting on Out-of-Sample Performance
# October 7, 2013
# Available at SSRN: http://ssrn.com/abstract=2308659
#   or http://dx.doi.org/10.2139/ssrn.2308659


# these are the constants referenced
# Euler–Mascheroni's constant
-digamma(1)
# euler constant
exp(1)

  
### Try to get the right answer for Eq. 4
# if N = 10 paper says 1.57
emax <- function(N) {
  ( ( 1 + digamma(1) ) * qnorm( 1 - 1/N ) ) +  
      (-digamma(1) * qnorm( 1 - (1/N) * exp(-1)))
}

emax(10)  # should be about = 1.57 to match paper

upbound <- function(N) {
  sqrt(2*log(N))
}

#make a plot for reasonableness check
#not trying hard for beauty here
x11(8,10)
curve(upbound, from = 1, to = 1000, col = "red", lty = 2)
curve(emax, from = 1, to = 1000, add=TRUE)
grid()


### Try next example for Eq. 6
# if y = 5
# so solve for annualized Sharpe of 1
# says no more than 45 N should be tried

# first just do this to make sure I understand
N=45
y=5
emax(N) * y^-0.5  #seemingly understand since close

# now try to write a function for min BTL Backtest Length
minBTL <- function( N, eMaxSharpe = 1 ) {
  (emax(N) / eMaxSharpe) ^ 2
}
minBTL( N = 45, eMaxSharpe = 1 )  #then should equal 5 if correct

#not trying hard for beauty here
#but produce chart for a reasonableness check
x11(8,10)
curve( minBTL, from = 1, to = 1000)