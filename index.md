---
title: Backtest Overfitting | Tests in R
author: TimelyPortfolio
license: by-nc-sa
widgets: [mathjax, bootstrap]
github: {user: timelyportfolio, repo: research_lopezdePrado}
url: {lib: ../../libraries}
mode: selfcontained
hitheme: tomorrow
assets:
  css:
  - "http://fonts.googleapis.com/css?family=Raleway:300"
  - "http://fonts.googleapis.com/css?family=Oxygen"
--- dt:10
  
<style>
iframe{
  height:450px;
  width:900px;
  margin:auto auto;
}

body{
  font-family: 'Oxygen', sans-serif;
  font-size: 16px;
  line-height: 24px;
}

h1,h2,h3,h4 {
  font-family: 'Raleway', sans-serif;
}

.container { width: 900px; }

h3 {
  background-color: #D4DAEC;
    text-indent: 100px; 
}

h4 {
  text-indent: 100px;
}

iframe {height: 420px; width: 620px}
</style>




<address>
<strong>Pseudo-Mathematics and Financial Charlatanism:</strong><br>
The Effects of Backtest Overfitting on Out-of-Sample Performance
<p class="muted">Bailey, David H. and Borwein, Jonathan M. and Lopez de Prado, Marcos and Zhu, Qiji Jim<br>   
 October 7, 2013   <br> 
 Available at SSRN: http://ssrn.com/abstract=2308659<br> 
   or http://dx.doi.org/10.2139/ssrn.2308659
</p>
</address>


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

### Expected Maximum Sharpe $E[max_N]$

$$
\begin{aligned}
(1-\gamma)Z^{-1}\left[1-\frac{1}{N}\right]+\gamma Z^{-1}\left[1-\frac{1}{N}e^{-1}\right] \end{aligned}
$$

<h4>R Translation</h4>

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


---


```r
#implement upper bound
upbound <- function(N) {sqrt(2*log(N))}
#make a ugly plot for reasonableness check
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
### Minimum Backtest Length (MinBTL)

$$
\begin{aligned}
\left(\frac{(1-\gamma)Z^{-1}\left[1-\frac{1}{N}\right]+\gamma Z^{-1}\left[1-\frac{1}{N}e^{-1}\right]}{\overline{E[max_N]}}\right)^2 \end{aligned}
$$

<h4> R Translation </h4>

```r
#use emax from earlier for numerator
minBTL <- function( N, eMaxSharpe = 1 ) {
  (emax(N) / eMaxSharpe) ^ 2
}
#then this should equal 5 if correct
minBTL( N = 45, eMaxSharpe = 1 )
```

```
## [1] 4.998
```

---


```r
#make ugly plot for a reasonableness check
x11(8,10)
curve( minBTL, from = 1, to = 1000)
```

![plot of chunk unnamed-chunk-7](assets/fig/unnamed-chunk-7.png) 

