## 제 15장. 간편 시각화
## 15.1 간편 시각화의 예
## 15.1.1 일변수 분포
library(dplyr)
library(ggplot2)
library(lattice)
data('BankWages', package='AER')
data(mtcars)
hist(BankWages$education) # 연속형 변수
plot( ~ gender, data=BankWages) # 이산형 변수


## 15.1.2 이변수 플롯
# 데이터 준비 : 범주 비율이 차이를 두기 위해서
Bank1 <- BankWages %>% slice(1:200) %>% filter(gender == 'male')
Bank2 <- BankWages %>% slice(-(1:200))
Bank <- rbind(Bank1, Bank2)

# 이변수 그림 : x=이산형, y=이산형
plot(job ~ gender, data=Bank)
# 이변수 그림 : x=이산형, y=연속형
plot(education ~ gender, data=Bank)
# 이변수 그림 : x=연속형, y=연속형
plot(qsec ~ hp, mtcars)


## 15.1.3 조건부 일변수 분포
histogram( ~ job | gender, BankWages)
histogram( ~ job | gender * minority, BankWages)

## 15.1.4 조건부 이변수 플롯
# 조건부 이변수 그림 : x=범주형, y=연속형
xyplot(education ~ job | gender, BankWages)
xyplot(education ~ job | gender, BankWages, jitter.x=TRUE)

## 15.1.5 조건부 이변수 플롯
# 조건부 이변수 그림 : x=연속형, y=연속형
xyplot(qsec ~ hp | mpg, mtcars)
mpgequal <- equal.count(mtcars$mpg, number=3, overlap=0)
xyplot(qsec ~ hp | mpgequal, mtcars)

mpgequal <- equal.count(mtcars$mpg, number=5, overlap=0)
xyplot(qsec ~ hp | mpgequal, mtcars)

mpgequal <- equal.count(mtcars$mpg, number=5, overlap=0.2)
xyplot(qsec ~ hp | mpgequal, mtcars)

## 15.2 조건부 이변수 플롯(등구간 구획)
require(dplyr)
mtcars <- mtcars %>%
  mutate(mpgCut = cut(mpg, breaks = 5, include.lowers = TRUE))
xyplot(qsec ~ hp | mpgCut, mtcars)

equal.interval = function(v, breaks=10, na.rm=FALSE, overlap=0) {
  stopifnot(inherits(breaks, 'numeric') &
              inherits(v, 'numeric'))
  if (length(breaks) == 1) {
    int = (max(v, na.rm=na.rm)-min(v, na.rm=na.rm))/breaks
    br1 = min(v, na.rm=na.rm) + seq(0,breaks-1)*int - overlap/2*int
    br2 = min(v, na.rm=na.rm) + seq(1,breaks)*int + overlap/2*int
    return(shingle(v, cbind(br1,br2)))
  } else {
    int = breaks[-1] - breaks[-length(breaks)]
    br2 = breaks[-1] + overlap/2*int
    br1 = breaks[-length(breaks)] -overlap/2*int
    return(shingle(v, cbind(br1, br2)))
  }}

mpgInt = equal.interval(mtcars$mpg, breaks = 6, overlap = 0.2)
xyplot(qsec ~ hp | mpgInt, mtcars)
