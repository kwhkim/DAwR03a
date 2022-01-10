## 7.    팩터 자료형

x <- factor(c('A', 'B', 'A', 'A', 'C', 'B'))
x
class(x)

x <- ordered(c('High', 'Medium', 'Low', 'Medium', 'Low'), 
             levels=c('Low', 'Medium', 'High'))
x
class(x)

## 7.1 팩터형의 중요성

n = 30
x <- sample(1:3, n, replace=TRUE); x
y <- ifelse(x>2, x + rnorm(n), rnorm(n)-x)
lm(y ~ x)

x <- as.factor(x)
lm(y~x)


### 참고.
### 앞의 두 분석 결과의 차이는 다음과 같이 시각적으로 나타낼 수 있다. 
library(ggplot2)
library(dplyr)

# linear regression
n = 30
x = as.numeric(as.character(x))
dat <- data.frame(x=x, y=y)
dat2 <- dat %>% group_by(x) %>% summarise(m=mean(y), sd=sd(y))
p1 <- ggplot(data = dat, aes(x=x, y=y)) +
  geom_point() +
  geom_smooth(method='lm')

#x <- as.factor(x)
dat <- data.frame(x=x, y=y)
p2 <- ggplot(data = dat) +
  geom_rect(data= dat2,
            aes(xmin=x-0.1, xmax=x+0.1, ymin=m-sd, ymax=m+sd), colour='gray70', fill='gray60') +
  geom_point(aes(x=x, y=y)) +
  geom_segment(data = dat2,
               aes(x=x-0.1, xend=x+0.1, y=m, yend=m),
               size=1, col='blue')
gridExtra::grid.arrange(p1, p2, ncol=2)
### 참고 끝.


## 7.2 데이터 전처리에 있어서 팩터형

fac1 <- factor(c('a', 'b', 'b', 'a'))
fac1[5] <- 'b'
fac1[6] <- 'c'
fac1

fac1
fac2 <- factor(c('a', 'b', 'c', 'c', 'b'))
c(fac1, fac2)

x1 <- factor(c("a", "b", "a", "c"))
x2 <- c(1, 3, 2, 5, 2)
c(x1, x2)

str1 <- c('a', 'b', 'b', 'a')
str1[5] <- 'c'
str1
str2 <- c('a', 'd', 'd', 'c')
c(str1, str2)


## 7.3 forcats 패키지

install.packages("forcats")

library(forcats)
x <- as.factor(x)
x

fct_relevel(x, '3', '2', '1')
fac2

newOrder = c("b", "a")
do.call(fct_relevel, c(list(fac2), as.list(newOrder)))

x <- factor(unlist(strsplit(
  'wzwzzwzwzcczwzdzczwzwzdzdddzdyydddddwzwwwdddzzddddzdzzd',''
)))
table(x)
x <- fct_infreq(x)
table(x)

dat = data.frame(animal = factor(rep(c("z", "d", "w", "c", "y"), each = 4)),
                 weight = c(280, 350, NA, NA, 7.1, 5.3, 8, NA, 0.37, 0.44, 0.38, 0.32,
                            12.3, 11.2, 143, NA, 380, NA, NA, NA))
dat = dat %>%
  filter(!is.na(weight))

dat$animal

fct_reorder(dat$animal, dat$weight, mean)

dat %>%
  ggplot(aes(x = animal, y = weight)) + geom_boxplot() + scale_y_log10()

dat %>%
  mutate(x = fct_reorder(animal, weight, mean, na.rm = TRUE, .desc = TRUE)) %>%
  ggplot(aes(x = x, y = weight)) + geom_boxplot() + scale_y_log10()


## 7.3.2 수준을 합치거나 이름을 바꾸는 함수

# dog=개, zebra=얼룩말, whimbrel=중부리도요, catfish = 메기, yak=야크
x2 <- fct_recode(x, 
                 "dog"="d", "zebra"="z", "whimbrel"="w",
                 "catfish"="c", "yak"="y")
x2

x3 <- fct_collapse(x2, 
                   "mammals"=c("dog", "zebra", "yak"),
                   "birds"="whimbrel",
                   "fish"="catfish")
x3


x4 <- fct_lump(x2); x4

f1 = c("d", "z", "w", "c", "y")
f2 = c("dog", "zebra", "whimbrel", "catfish", "yak")
names(f1) <- f2
fct_recode(x[1:14], !!!f1) # 출력을 제한하고자 x[1:14]만 사용


## 7.3.3 새로운 수준을 추가하는 함수

fac1
fac2
c(fac1, fac2)
fct_c(fac1, fac2)

