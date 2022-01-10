# 제 9장. 데이터 가공

# 9.1 집단별로 함수 적용하기

v <- c(172, 172, 170, 170, rnorm(96, 170, 3))
g <- rep(c("Male", "Female"), 50)
c(mean(v[g=="Male"]), mean(v[g=="Female"]))
# 결과는 rnorm()로 생성된 랜덤 값에 따라,
# 그리고 options("digits") 값에 따라 달라진다.
# 책의 결과는 options(digits=4)에서 얻어진 결과다.
set.seed(0)
v <- rnorm(1000, 170, 3)
g <- rep(1:100, 10)
c(mean(v[g==1]), mean(v[g==2]), mean(v[g==3]), mean(v[g==4]))


# 9.1.1 주어진 벡터에 집단을 구분하여 함수 적용하기: tapply
g = c(1,3,1,2,3,2,2,1,2)
g = c(0,7,0,5,7,5,5,0,5)
g = c("A", "C", "A", "B", "C", "B", "B", "A", "B")
g = c('paul','jack', 'paul', 'susan', 'jack', 'susan', 
      'susan', 'paul', 'susan')

v = c(2, 2, 6, 8, 9, 1, 2, 7, 5) 
g = c(1, 3, 1, 2, 3, 2, 2, 1, 2) 
tapply(v, g, FUN = mean) 


# 9.1.2 집단별로 함수 적용하기 : tapply, apply, lapply, sapply

## 함수   의미
## tapply tag-apply
## apply  array(?)-apply
## lapply list-apply
## sapply simpliﬁed-list-apply

dat <- data.frame(gender=c('M','M','M','M','M','F','F','F','F','F'),
                  num=c(1,2,3,1,2,3,1,2,3,1),
                  h=c(170,180,190,180,170,150,160,170,160,150),
                  w=c(80,70,100,80,60,50,50,60,60,50))
dat$BMI <- dat$w/(dat$h/100)^2

table(dat$gender, dat$num)

#library(dplyr); library(tidyr)
#dat %>% group_by(gender, num) %>%
# summarise(mean = mean(h)) %>% spread(key='num', value='mean')
#dat$h의 값을 dat$gender와 dat$num을 기준으로 분리한 후, mean
tapply(dat$h, list(dat$gender, dat$num), mean)

#dat %>% group_by(gender, num) %>% summarise(h=sum(h)) %>% arrange(num)
#dat울 gender, num을 기준으로 분리 후, h를 sum
aggregate(h ~ gender + num, sum, data=dat)

#dat %>% group_by(gender, num) %>% summarise(`h+w`=sum(h+w)) %>% arrange(num)
#dat를 gender, num을 기준으로 분리 후, h+w를 sum
aggregate(h + w ~ gender + num, sum, data=dat)

#dat %>% group_by(gender, num) %>%
# summarise(h=sum(h), w=sum(w)) %>% arrange(num)
#dat를 gender, num을 기준으로 분리 후, h와 w를 각각 sum
aggregate(cbind(h,w)~gender+num, sum, data=dat)

#dat %>% group_by(gender, num) %>% summarise_all(sum) %>% arrange(num)
#dat를 gender, num을 기준으로 분리 후, 나머지 열을 모두 각각 sum
aggregate(. ~ gender + num, sum, data=dat)

#dat %>% group_by(gender, num) %>% summarise_all(length) %>% arrange(num)
#dat를 gender, num을 기준으로 분리 후, 나머지 열을 모두 각각 length
aggregate(dat, list(dat$gender, dat$num), length)

# dat를 dat$gender, dat$num를 기준으로 나눈 후, summary
by(dat, list(dat$gender, dat$num), summary)
# dplyr로 구현하기 힘듦
require(data.table)
datDT <- data.table(dat)
datDT[,{print(paste(gender, num));print(summary(.SD))}, by=c('gender', 'num')]


# 9.1.3 sweep, mapply, rapply
# 9.1.3.1 sweep
mat=matrix(c(1,3,6,2,4,5), 3, 2)
mat
apply(mat, MARGIN=1, FUN=function(x) x-1)
sweep(mat, MARGIN=1, STATS=c(1,1,1), FUN="-") 

aperm(apply(mat, MARGIN=1, FUN=function(x) x-1), c(2,1))

mat[1,] - 1; mat[2,] - 1; mat[3,] - 1
sweep(mat, MARGIN=1, STATS=c(1,4,3), FUN="-")


# 9.1.3.2 maaply
x <- list(c(1,3,2), c(1,4,4,4,5), c(1,0))
lapply(x, sum)
mapply(sum, x, SIMPLIFY=FALSE)

x <- list(c(1,3,2), c(1,4,4,4,5), c(1,0))
sapply(x, sum)
mapply(sum, x, SIMPLIFY=TRUE)

x <- c(12,14,11); y <- c(3,1,5); z <- c('a', 'b', 'c')
mapply("-", x, y) # c(12-3, 14-1, 11-5)
mapply(paste, x, y, z, MoreArgs=list(sep='/')) # paste는 <문자열> 장을 참조한다.

## 9.1.3.3 rapply: recursive apply

rapply(list(c(1,4,2), list(c(1,1,1), c(2,5,2,5))), sum)
rapply(list(c(1,4,2), list(c(1,1,1), c(2,5,2,5))), sum, how='list')


## sweep, mapply, rapply 종합

## 함수    적용대상          결과
## sweep   배열(행렬)        동일한 크기(원소 갯수)의 배열(행렬)
## mapply  리스트(벡터)      첫 번째 원소끼리 함수 적용
## rapply  계층 구조 리스트  모든 리스트 원소에 대해 함수 적용


# 9.2 여러 데이터 프레임 합치기

## • 동일한 형식의 데이터프레임이 DF1, DF2, DF3로 나눠져 있을 때
##   – rbind(DF1, DF2, DF3)
##   – data.table::rbindlist(list(DF1, DF2, DF3))
## • 두 데이터에 공통으로 존재하는 열을 기준으로 두 데이터프레임을 합칠 때
##   – merge(DF1, DF2)
##   – dplyr::left_join(DF1, DF2)

## data.table::rbindlist(list(DF1, DF2), fill = TRUE)
## dplyr::bind_rows(DF1, DF2)
## 
## colnames(DF2) <- colnames(DF1)

# 9.2.2 기준열을 사용하는 경우
library(dplyr)
options(stringsAsFactors=F)
dfCustomer <- data.frame(
  id = c(1,2,3,4,5),
  name = c("김희선","박보검","설현","김수현","전지현"),
  addr = c("서울시","부산시","인천시","강릉시","목포시")
)
dfPurchase <- data.frame(
  name = c("김희선","박보검","김희선","설현","김수현","박보검"),
  product = c("바지","샴푸","텔레비전","바지","바지","샴푸")
)
dfProduct <- data.frame(
  product = c("샴푸","텔레비전","바지"),
  price =c(13800, 560000,80000)
)

full_join(dfCustomer, dfPurchase)


DF1 <- dfCustomer1 <- data.frame(
  id = c(3,4,1,5,2),
  name = c("김희선","박보검","설현","김수현","전지현"),
  phonenumber = c('0104432332', '0106642632', '01059382', '0109958372', '0102929484')
)

DF2 <- dfCustomer2 <- data.frame(
  id = c(2,3,4,5), 
  name = c("박보검","설현","김수현","전지현"),
  addr = c("부산시","인천시","강릉시","목포시")
)

full_join(DF1, DF2)
full_join(DF1, DF2, by='name')


# 9.3 세로형/가로형 변환
library(dplyr)
library(tidyr)
mtcars$name = rownames(mtcars); rownames(mtcars) = NULL
mtcars %>% select(name, mpg, cyl, disp) -> mtcars01
head(mtcars01, 4)

# 9.3.1 패키지 tidyr을 활용한 세로형/가로형 변환
mtcarsLong <- mtcars01 %>% 
  gather(key='key', value='value', mpg, cyl, disp) 
head(mtcarsLong, 4)

mtcarsLong %>% spread(key='key', value='value') -> mtcars02
head(mtcars02, 4)

all.equal(mtcars01, mtcars02)

all.equal(mtcars01 %>% arrange(name), 
          mtcars02 %>% select(name, mpg, cyl, disp) %>% arrange(name))


# 9.3.2 패키지 reshape2의 활용
library(reshape2)
mtcarsLong <- mtcars %>% select(am, name, mpg, cyl, disp) %>%
  gather(-name, -am, 
         mpg, cyl, disp, 
         key='key', value='value', 
         factor_key=TRUE) 
mtcarsWide <- 
  mtcarsLong %>% spread(key='key', value='value') 

mtcarsLong2 <- mtcars %>% select(am, name, mpg, cyl, disp) %>%
  reshape2::melt(id=c("am", "name"),
       measure.vars = c("mpg", "cyl", "disp"),
       variable.name = "key", value.name = 'value')

mtcarsWide2 <- 
  mtcarsLong2 %>% reshape2::dcast(am + name ~ key) -> mtcarsWide2
# melt와 dcast란 함수는 data.table 패키지에도 존재하므로 
# reshape2::melt() 명확하게 하는 것이 좋다.

all.equal(mtcarsLong, mtcarsLong2)
all.equal(mtcarsWide, mtcarsWide2)


dcast(mtcarsLong2, am ~ key, fun.aggregate=mean)

dcast(mtcarsLong2, name + am ~ key, fun.aggregate=mean) %>% head(5)

dcast(mtcarsLong2, key ~ am, fun.aggregate=mean)

dcast(mtcarsLong2, . ~ am + key, fun.aggregate=mean)

dcast(mtcarsLong2, . ~ key + am, fun.aggregate=mean)

dcast(mtcarsLong2, am + key ~ ., fun.aggregate=mean)

