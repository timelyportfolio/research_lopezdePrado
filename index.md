---
title: Backtest Overfitting | Tests in R
author: TimelyPortfolio
license: by-nc-sa
widgets: [mathjax, bootstrap]
github: {user: timelyportfolio, repo: research_lopezdePrado}
url: {lib: ../../libraries}
mode: selfcontained
hitheme: tomorrow
--- dt:10




<blockquote> Bailey, David H. and Borwein, Jonathan M. and Lopez de Prado,
   Marcos and Zhu, Qiji Jim
 Pseudo-Mathematics and Financial Charlatanism:
   The Effects of Backtest Overfitting on Out-of-Sample Performance
 October 7, 2013
 Available at SSRN: http://ssrn.com/abstract=2308659
   or http://dx.doi.org/10.2139/ssrn.2308659
</blockquote>

---


```r
# these are the constants referenced
# Euler–Mascheroni's constant
-digamma(1)
```

```
## [1] 0.5772
```

```r
# euler constant
exp(1)
```

```
## [1] 2.718
```

---


```r
### Try to get the right answer for Eq. 4
# if N = 10 paper says 1.57
emax <- function(N) {
  ( ( 1 + digamma(1) ) * qnorm( 1 - 1/N ) ) +  
      (-digamma(1) * qnorm( 1 - (1/N) * exp(-1)))
}

emax(10)  # should be about = 1.57 to match paper
```

```
## [1] 1.575
```

```r

upbound <- function(N) {
  sqrt(2*log(N))
}
```


---


```r
#make a plot for reasonableness check
#not trying hard for beauty here
x11(8,10)
curve(upbound, from = 1, to = 1000, col = "red", lty = 2)
curve(emax, from = 1, to = 1000, add=TRUE)
grid()
```

![plot of chunk unnamed-chunk-4](assets/fig/unnamed-chunk-4.png) 


---


```r
### Try next example for Eq. 6
# if y = 5
# so solve for annualized Sharpe of 1
# says no more than 45 N should be tried

# first just do this to make sure I understand
N=45
y=5
emax(N) * y^-0.5  #seemingly understand since close
```

```
## [1] 0.9998
```


---

```r
# now try to write a function for min BTL Backtest Length
minBTL <- function( N, eMaxSharpe = 1 ) {
  (emax(N) / eMaxSharpe) ^ 2
}
minBTL( N = 45, eMaxSharpe = 1 )  #then should equal 5 if correct
```

```
## [1] 4.998
```

---


```r

#not trying hard for beauty here
#but produce chart for a reasonableness check
x11(8,10)
curve( minBTL, from = 1, to = 1000)
```

![plot of chunk unnamed-chunk-7](assets/fig/unnamed-chunk-7.png) 

