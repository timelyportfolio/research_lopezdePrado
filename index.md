---
title: Backtest Overfitting | Translated in R
author: TimelyPortfolio
license: by-nc-sa
widgets: [mathjax, bootstrap]
github: {user: timelyportfolio, repo: research_lopezdePrado}
mode: selfcontained
hitheme: solarized_light
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
}

h1,h2,h3,h4 {
  font-family: 'Raleway', sans-serif;
}

h3 {
  background-color: #D4DAEC;
    text-indent: 100px; 
}

h4 {
  text-indent: 100px;
}

iframe {height: 300px; width: 900px}
</style>




### Original Paper
<br>
<address>
<strong style="lineheight:40px;">Pseudo-Mathematics and Financial Charlatanism:</strong><p style="lineheight:40px;">The Effects of Backtest Overfitting on Out-of-Sample Performance</p>
<p class="muted" style="line-height:26px;">Bailey, David H. and Borwein, Jonathan M. and Lopez de Prado, Marcos and Zhu, Qiji Jim<br>
October 7, 2013<br>
Available at SSRN: <a href="http://ssrn.com/abstract=2308659">http://ssrn.com/abstract=2308659</a>
</p>
</address>

---

### Constants - R Equivalents


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
### Eq. 4
emax <- function(N) {
  ( ( 1 + digamma(1) ) * qnorm( 1 - 1/N ) ) +  
      (-digamma(1) * qnorm( 1 - (1/N) * exp(-1)))
}

emax( N = 10 )  # should be about = 1.57 to match paper
```

```
## [1] 1.575
```

---

### Plot $E[max_N]$

```r
#implement upper bound
upbound <- function(N) {sqrt(2*log(N))}
#make a ugly plot for reasonableness check
curve(upbound, from = 1, to = 1000, col = "red", lty = 2)
curve(emax, from = 1, to = 1000, add=TRUE)
grid()
```

![plot of chunk unnamed-chunk-4](assets/fig/unnamed-chunk-4.png) 

---

### rChart $E[max_N]$

```r
require(rCharts)
df <- data.frame(
  list(x=c(1,2:1000), y=c(0,emax(2:1000))))
d1 <- dPlot( y ~ x, groups = "x", data = df, type = "line", height = 270, width = 800)
d1$xAxis(type = "addMeasureAxis",orderBy = "x",outputFormat = ",0.0f")
d1$yAxis( outputFormat = ".2f")
d1
```

<iframe src=assets/fig/unnamed-chunk-5.html seamless></iframe>


---
### Check My Math with *Eq. 6*


```r
### Try next example for Eq. 6
# if y = 5
# so solve for annualized Sharpe of 1
# says no more than 45 N should be tried

# first just do this to make sure I understand
N = 45
y = 5
emax( N ) * y^-0.5  #seems like on the right path
```

```
## [1] 0.9998
```


--- 
### Minimum Backtest Length $MinBTL$

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

### Plot $MinBTL$

```r
#make ugly plot for a reasonableness check
curve( minBTL, from = 1, to = 1000)
```

![plot of chunk unnamed-chunk-8](assets/fig/unnamed-chunk-8.png) 


---
### rChart $MinBTL$

```r
df <- data.frame(
  list(x=c(1,2:1000), minBTL=c(0,minBTL(2:1000))))
n1 <- nPlot( minBTL ~ x, data = df, type = "lineChart", height = 270, width = 800)
n1$yAxis( tickFormat = "#!d3.format(',.2f')!#")
n1$chart( useInteractiveGuideline = TRUE )
n1$show("iframe")
```

<iframe src=assets/fig/unnamed-chunk-9.html seamless></iframe>


---
### Thanks
- Ramnath Vaidyanathan
- Bailey, David H. and Borwein, Jonathan M. and Lopez de Prado, Marcos and Zhu, Qiji Jim
