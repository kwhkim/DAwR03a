## 4장 데이터 구조
## 4.1 벡터
## 4.1.1 벡터 만들기
c(1,3,2,4)
c(pi, 0.001, sin(3)) 
c("John","Mary")

person = c(name = "John", likes = "Mary", loves = "Suzy")
# repeat
rep(1, 10)
rep("ABC", 10)
rep(c("A","B","C"), 3)

# sequence
seq(from=1, to=10) # 1부터 10까지
seq(from=1, to=10, by=2) # 1부터 10까지 2 간격으로 
seq(from=1, to=10, length.out=3) # 1부터 10까지 총길이 3으로
rep(seq(1,4),each=3) # 1부터 4까지 각각 3번 반복
seq(1,10)
1:10

# 벡터 생성 함수 정리

# 벡터 생성 함수 생성된 벡터
c(1,2,3,4)                      # 1,2,3,4을 원소로 하는 벡터
1:6                             # 1,2,3,4,5,6을 원소로 하는 벡터
seq(from=1, to=6)               # 1,2,3,4,5,6을 원소로 하는 벡터
seq(from=1, to=5, by=2)         # 1,3=1+2,5=3+2을 원소로 하는 벡터
seq(from=1, to=7, length.out=3) # 1,4,7(1,2,3)을 원소로 하는 벡터
rep(1,3)                        # 1,1,1(1,2,3)을 원소로 하는 벡터
rep(1:2,times=3)                # 1,2,1,2,1,2(1,1,2,2,3,3)을 원소로 하는 벡터
rep(1:2,length.out=5)           # 1,2,1,2,1(1,2,3,4,5)을 원소로 하는 벡터
rep(1:3,each=2)                 # 1,1,2,2,3,3,(1,2,1,2,1,2)을 원소로 하는 벡터


## 4.1.2 벡터의 내용 출력
vInteger <- as.integer(1:35)
vReal1 <- rnorm(10); vReal2 <- c(1.2475842, 1.43, 10240333211)
vCharacter <- c("안녕?\n또 보다니!", "Hi,\tWait a moment", 
                "오랜만이야?\t!", "Long time no see!", "...")
vFactor <- factor(c('hi', 'mid', 'low', 'low', 'mid'), 
                  levels=c('hi', 'mid', 'low'))
vDate <- as.Date(c("2017-06-14", "2019-03-01", "2019-01-01"))
vPOSIXct <- as.POSIXct(c("2017-06-14 15:00:00", "2019-03-01 12:14:15"))

print(vInteger)
print(vReal1)
print(vReal2)

print(vCharacter)
cat(vCharacter)

print(vFactor)
print(vDate)
print(vPOSIXct)


## 4.1.3 벡터 내용을 간단하게 확인하기
T=TRUE
vec <- sample(1:100, 10000, replace = T)
# print(vec)
head(vec)
tail(vec)
summary(vec)
psych::describe(vec)

vecCut <- cut(vec,breaks=seq(-0.5, 100.5, 10))
table(vecCut)
hist(vec)
hist(vec, breaks=seq(-0.5, 100.5, 1))

vec <- sample(c("John","Mary","Tom"), 100, replace=T)

head(vec)
tail(vec)
summary(vec) # 에러는 나지 않지만 특별한 정보를 주지 않는다
#psych::describe(vec) # 문자열 벡터에는 사용불가
table(vec)
#hist(vec) # 문자열 또는 팩터형 벡터에는 사용 불가
#plot(~factor(vec)) # 문자열을 팩터형으로 바꿔서 사용 가능

# 목적                              방법
# 내용의 일부를 확인하기            head(x)(처음 5개), tail(x)(마지막 5개)
# 전체내용을 요약하기               summary(x), psych::describe(x)
# 분포 파악하기(빈도표, 히스토그램) table(x)(범주형), hist(x)(수치형)


## 4.1.4 벡터 연산
x = 1:5; y = 2:6
x + y
x - y
x * y
x / 3

x = 1:5; y=2:3
x + y  # 1:5 + c(2:3, 2:3, 2)
#Warning message:
#  In x + y : longer object length is not a multiple of shorter object length

x - y
#Warning message:
#  In x - y : longer object length is not a multiple of shorter object length


x = 1:5; y = 2
x + y  # 1:5 + c(2, 2, 2, 2, 2)
x - y

c(1,2,3,c(4,5),c(6,7,8))

length(x)


v1 <- c(1,3,2); v2 <-c(3,3,1)

v1 < v2

all(v1 < v2)
any(v1 < v2)

b1 <- c(T, T, F, F)
b2 <- c(F, T, F, T)
b1 & b2 # and
b1 | b2 # or

v1 = c("I", "You", "He")
v2 = c("go", "come", "climbs")

nchar(v1)
paste(v1, v2)
substring(v2, 2, 2)
substring(v2, c(1,2,3), c(2,5,5))

vec <- sample(100,10000,replace=T)

mean(vec)
sum(vec)
sd(vec)

xa = c(1,3,2); xb = c(2,3,2); xc = c(1,1,2)
xa == xb & xb == xc
xa == xb && xb == xc

primes <- c(2,3,5,7,11,13,17,19,7,13)
numbersILike <- c(3,7,14,3)

union(primes, numbersILike)
intersect(primes, numbersILike)
setdiff(numbersILike , primes)

numbersILike2 <- c(3, 7, 14)

setequal(numbersILike , numbersILike2)

is.element(17, primes)
is.element(18, primes)
17 %in% primes
18 %in% primes

v = c(180, 169, 172, 154, 190, 155, 201)


v[5]

v[c(2,3,5)]

vec = 1:10; vec[c(2,3,5,7)]
index = c(2,3,5,7); vec[index]

vec[-1] # 첫 번째 원소 제외
vec[-1:-2] # 첫 번째와 두 번째 원소 제외
vec[index][-1] # index(2,3,5,7)번째 원소 중에서 첫 번째 원소 제외

vHeight = c(Park = 180, Jung = 169, Hyori = 172, 
            DJDoc = 154, Queen = 190, Dooli = 155, MJ = 201)

vHeight['DJDoc']
vHeight[c('Park', 'Hyori')]

vHeight[c(T, F, T, F, T, F, T)] # 벡터 vHeight의 1번째, 3번째, 5번째, 7번째 원소
vHeight[vHeight > 170] # vHeight의 원소 중 170보다 큰 원소

vec = sample(5, 10, replace=T)
vec
## [1] 2 2 3 5 1 4 5 1 4 1
biggerThan3 = vec > 3; vec[biggerThan3]
vec[vec > 3]
vec[c(T,F)]
# c(T, F)는 벡터 vec의 길이만큼 늘어난다(재활용). 따라서 홀수 순번의 원소를 선택한다.


vec = c(2, 2, 3, 5, 1, 4, 5, 1, 4, 1)
#vec
## [1] 2 2 3 5 1 5 5 1 5 1
biggerThan3 = vec > 3; vec[biggerThan3]
vec[vec > 3]
vec[c(T,F)] 


## 4.1.7 데이터 정렬
vec = c(1, 5, 6, 4, 2)

sort(vec)
order(vec)
vec[order(vec)]


## #### 그밖의 참고 자료
## 
## #* <http://adv-r.had.co.nz/Subsetting.html>


## 4.2 행렬, 배열, 데이터프레임, 리스트
## 4.2.1. 행렬
vec = c(7,2,3,4,5,6,8,6,9,10,11,12,11,8,5)
matrix(vec, nrow=3, ncol=5)


matrix(vec, nrow=3, ncol=5, byrow=TRUE)

matrix(vec, 3, 5)

matrix(vec, nrow=7)
#Warning message:
#In matrix(vec, nrow = 7) :
#  data length [15] is not a sub-multiple or multiple of the number of rows [7]

## 4.2.2 배열
vec <- 1:(3*5*4)
arr <- array(vec, c(3,5,4))


## 4.2.3 데이터프레임
data.frame(name=c('김이랑', '마동탁', '까치'),
           ba=c(0.254, 0.231, 0.312),
           비고=c('없음', '없음', '엄지 연인'),
           `!주의점`=c('신인', '없음', '타자'))

## 4.2.4 리스트
list(c(1,2,3), 
     matrix(1:9, 3,3),
     list(c(4,5,6), matrix(11:19,3,3)))


## 4.3 행렬, 배열, 데이터프레임, 리스트의 부분선택하기
## 4.3.3 계층적 구조의 원소 선택하기
mtcars[3,7]
mtcars[c(F,F,T,rep(F, 29)), c(rep(F,6), T, rep(F,6))]
mtcars["Mazda RX4", "disp"]
mtcars[3:4,c(rep(F,6), T, T, rep(F,5))]
mtcars[c("Mazda RX4", "Mazda RX4 Wag"), 7:8]

# with : 계산만 하고 싶을 때
with(mtcars, mpg/cyl + hp*drat) 
# within : 만약 새로운 열로 저장하고 싶을 때
dat <- within(mtcars, x <- mpg/cyl + hp*drat)
head(dat, n=3)

mtcars[1,]
unlist(mtcars[1,])

## 4.4 행렬, 배열, 데이터프레임, 리스트 수정하기
dat = data.frame(name=c('Kim', 'Lee'), 
                 age=c(23,41), 
                 height=c(180, 165), stringsAsFactors=FALSE); dat
dat[2,1] <- 'Park'; dat
dat$age <- c(24,40); dat

dat[1,] <- c("Lee", 30, 170); dat
dat[1,] <- list("Lee", 30, 170); dat

## 4.4 행렬, 배열, 데이터프레임, 리스트 수정하기
dat = data.frame(name=c('Kim', 'Lee'),
                 age=c(23,41),
                 height=c(180, 165), stringsAsFactors=FALSE); dat
dat[2,1] <- 'Park'; dat
dat$age <- c(24,40); dat
dat[1,] <- c("Lee", 30, 170); dat
dat[1,] <- list("Lee", 30, 170); dat

## 4.6 3차 이상의 다차원 배열
## 4.6.1 다차원 배열의 활용
{d3 <- d2 <- d1 <- 1:10
  dat <- expand.grid(d1, d2, d3)
  colnames(dat) <- c('d1', 'd2', 'd3')
  dat$x <- rnorm(nrow(dat)) }
a <- array(dat$x, dim = c(length(d1), length(d2), length(d3)))

object.size(dat)
object.size(a)
#install.packages('lobstr')
lobstr::obj_size(dat)
lobstr::obj_size(a)

i=2; j=7; k=5;
a[i,j,k]
dat[dat$d1==i & dat$d2==j & dat$d3==k,"x"]


## 4.6.2 다차원 배열 변환하고 요약하기
height <- array(
  c(170, 180, 175, 169, 165, 173, 173, 181, 175, 
    166, 164, 155, 172, 184, 176, 167, 162, 164), 
  dim = c(3,2,3),
  dimnames = list(c("A", "B", "C"), c("M", "F"), c("1", "2", "3"))
)
height

## 4.6.2.1 배열 차원에 이름 붙여주기
names(dimnames(height)) = c("school", "gender", "number")
height

## 4.6.2.2 차원 재배열하기
aperm(height, c(3,2,1))

aperm(height, c(1,3,2))

h2 <- aperm(height, c(2,3,1))

ftable(height, row.vars=c("school", "number"))

ftable(height, row.vars=3) # 번호는 세 번째 차원


## 4.6.2.4 요약하여 차원 줄이기
apply(height, MARGIN=c(1), FUN=mean, na.rm=TRUE)
apply(height, MARGIN="school", FUN=mean, na.rm=TRUE)

apply(height, MARGIN=c(1,2), FUN=mean)

height['A', 'M', '1']
height['A', 'M', '2']
height['A', 'M', '3']


## 4.6.3 두 배열 합치기
heightDEF <- height + 10
dimnames(heightDEF)[[1]] <- c('D', 'E','F')

height2 <- abind::abind(height, heightDEF, along = 1)

height456 <- height -10
dimnames(height456)[[3]] <- c('4', '5', '6')

height3 <- abind::abind(height, height456, along=3)


## 4.6.4 데이터 프레임으로 변환하기
# 'dfHeight <-' 추가했습니다 
dfHeight <- as.data.frame.table(height, responseName = 'height')

## 4.6.5 다시 배열로 변환하기
# resahpe2 인스톨하고 불러오기 추가했습니다.
# install.packages("reshape2")  
library(reshape2)
reshape2::acast(dfHeight, school ~ gender ~ number, value.var = 'height')


## 배열 관련 함수 정리
## 기능              함수
## 차원 재배열       aperm(X, c(1,3,2))
## 큰 표로 출력하기  ftable(X, row.vars= c(1,3))
## 차원 제거         apply(X, MARGIN = c(1,2), FUN= )
## 두 배열 합치기    abind::abind(arr1, arr2, along= )
## 데이터 프레임으로 as.data.frame.table()
## 다시 배열로       reshape2::acast(date=, formula=, fun.aggregate=, value.var=)

