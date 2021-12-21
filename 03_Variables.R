## 3장 R의 데이터 타입
## 3.1 R의 변수
## 3.1.1 변수의 이름

myAge = 22
year = 2018
day_of_Month = 3 #Alphabets, numbers, '.', '_'
stock.high = 13322
whatIGotForMy23thBirthday = "flowers"

## 3.1.2 변수 할당
#Assign
a <-3
b = 2
d <- -1
e1 <- e2 <- 7

assign("var1", 3)
varname = "myVariable" # Camel case
assign(varname, 2)

myVariable = 1
varname2 = "my_Another_Variable" # Python
varname3 = "myVariable.3rd" # R
assign(varname2, 2)
assign(varname3, 2)

e2 <- e1 <- 7
e1 = e2 = 7
7 -> e1 -> e2

e1*3
d1 <- e1 *3
(d1 <- e1 *3)

## 3.1.3 변수관리

rm(list = ls())
a = 2
b = function(x) x^2
cc = "Now"
ls()

str(a); str(b); str(cc)
ls.str()
exists("a"); exists("d")

ls()
rm("a")
ls()
rm(list=ls())
ls()

rm(list = setdiff(ls(), lsf.str()))
save.image()
load(".RData")

## 함수                           기능
## ls()                           모든 객체 나열(.로 시작하는 객체 제외)
## rm(list=ls())                  모든 객체 제거(.로 시작하느 객체 제외)
## rm(setdiff(ls(), lsf.str()))   함수를 제외한 모든 객체 제거
## str(x)                         객체 x의 데이터 구조
## ls.str()                       ls()와 str() 동시 실행
## exists('x')                    객체 x의 존재 여부 확인
## rm(x) 또는 rm('x')                객체 x 제거
## save.image()                   모든 객체 저장
## load('.RData')                 .RData 에 저장된 객체 불러오기


## 3.2 R의 데이터타입(자료형)
## 3.2.1 데이터타입(Data types)

## 데이터 타입         예
## 숫자(numeric)       0, 1, -1, 0.45, 3L, 1e-7, 0xFF, pi, exp(1)
## 문자(character)     "Letter", '1', '"Hello?", says he', "("Hi?"='H')"
##                     'Cheer up!\r\nRight Now!', '\x41', '\101', "(C:\git\)"
## 범주(factor)        factor(c('high','low','high'))
## 논리(logical)       TRUE, T, FALSE, F
## 날짜(Date, POSIXct) as.Date("2022-03-12"), as.POSIXct('2022-03-12 10:33')
##                     as.Date("2022/03/12"), as.POSIXct('2022/03/12 10:33')

## 데이터 타입     예      설명
## 정수(integer)   3L      L은 Long integer의 의미인 듯하다
##                 0xFFL   16진수 FF(정수)
##                 0xffL   16진수 FF(정수)
## 숫자(numeric)   0xFF    16진수 FF9
##                 0xff    16진수 FF
##                 2.3e-3  2.3×10−3 = 0.0023
##                 pi      원주율 𝜋 = 3.1415926535897931⋯
##                 exp(1)  자연 상수 𝑒 = 2.7182818284590451⋯
##                         𝑒는 Euler’s constant(오일러의 상수)라는 의미에서 왔다.
## 문자(character) '\r'    Carriage return을 나타내는 제어문자
##                 '\n'    new line을 나타내는 제어문자
##                 '\x41'  아스키 코드 16진수 41에 해당하는 문자(A)
##                 '\101'  아스키 코드 8진수 101에 해당하는 문자(A)
##                 r'(..)' 문자 그대로 문자
## 논리(logical)   TRUE    ’참’을 나타내는 키워드
##                 T       TRUE를 나타내는 약어
##                 FALSE ’거짓’을 나타내는 키워드

3e+07-1
3e+07-5

30000000L - 1L

.Machine$integer.max

.Machine$integer.max + 1
.Machine$integer.max + 1L

.Machine$double.xmin
.Machine$double.xmax


## 3.2.2 변수의 데이터 타입 확인하기

## 데이터타입              확인하는 함수           문자에서 변환하는 함수
## 숫자(numeric)           is.numeric()             as.numeric()
## 정수(integer)           is.integer()             as.integer()
## 문자(character)         is.character()   
## 범주(factor)            is.factor()              as.factoer()
## 순위범주(ordered)       is.ordered()             as.ordered()
## 논리(logical)           is.logical()             as.logical()
## 날짜(Date)              inherits( , "Date")      as.Date()
## 날짜시간벡터(POSIXct)   inherits( , "POSIXct")   as.POSIXct()
## 날짜시간리스트(POSIXlt) is.integer( , "POSIXlt)  as.POSIXlt()



x1 = 23L; class(x1)
x2 = 22.3; class(x2)
x3 = "strings";class(x3)
x4 = factor(c("Hi", "Lo", "Lo")); class(x4)
x5 = as.Date("2020-01-01"); class(x5)
x6 = as.POSIXct("2020-01-01 12:11:11"); class(x6)
"POSIXct" %in% class(x6)
inherits(x6, "POSIXct")

y1 = "23"; as.integer(y1)
y2 = "22.3"; as.numeric(y2)
y3 = "strings"
y4 = c("Hi", "Lo", "Lo"); as.factor(y4)
y5 = "2020-01-01"; as.Date(y5)
y6 = "2020-01-01 12:11:11"; as.POSIXct(y6)

# ls.str()로 데이터 타입이 변화했음을 확인해보자.


## 3.3 연산과 함수
## 3.3.1 수치형
## 3.3.1.1. 산술연산

3 + 2
5 - 4
3 * 2
72 / 2
3 ^ 4 ; 3 ** 4
3 ^ (1/2); sqrt(3)
3 - 2 + 2 * 4 / 2 ^ ( 1 + 1)
7 / 3 # 나눗셈(Float division)
7 %/% 3 # 정수나누기, 몫(Integer division)
7 %% 3 # 나머지(Remainder)

## 3.3.1.2 함수
exp(1)
log(180, base=2)
log2(180)
log10(180)
sin(2)

ts <- runif(30)
approx_entropy(ts) # 아직 패키지를 불러들이기 않았다
## Error in approx_entropy(ts): 함수 "approx_entropy"를 찾을 수 없습니다
pracma::approx_entropy(ts) # 함수 앞에 패키지명

library(pracma)
approx_entropy(ts)

detach("package:pracma")


## 3.3.1.3 연산
"+"(3,2)
"*"(3,2)
"%p%" = function(x,y) { 2^x + y^2 }
3 %p% 2
"%p%"(3,2)

"+" = function(x, y) x*y
3+2; 3+3
"+"
# 원상회복하려면 rm("+")
rm("+")

## 3.3.1.4 비교연산
7 < 3
7 > 3
7 == 3
7 != 3

sqrt(2)^2 == 2
print(sqrt(2)^2)
print(sqrt(2)^2, digits = 21)

all.equal(sqrt(2)^2, 2)
all.equal(1e-23, 1e-24)

dplyr::near(1e-23, 1e-24)
near <- dplyr::near
near(1e-23, 1e-24)

## 3.3.2 문자
print("Letter")
cat('Letter')

print("\"Hello\", says he")
cat("\"Hello\", says he")

print('Cheer up!\r\nRight Now!')
cat('Cheer up!\r\nRight Now!')

nchar('hello?') # 문자 갯수
paste('Here is', 'an apple.') # 문자열 연결
substring('hello?', 2, 3) # 문자열의 일부분


## 3.3.3 날짜/시간

Sys.Date() # 현재 날짜
Sys.time() # 현재 날짜와 시간(POSIXct 형식)

as.Date("2022/12/31") # 문자열 "2018/12/31"을 날짜 형식으로
as.POSIXct("2022/12/31 23:59:59") # 문자열 "2018/12/31 23:59:59"을 날짜시간 형식으로

Sys.Date() - as.Date("2022-01-01") # 2018년 1월 1일과 현재 날짜의 차이
# 현재 날짜 시간과 2019년 12월 31일 23시 59분 59초의 차이
as.POSIXct("2021/12/31 23:59:59")-Sys.time()

# 현재 날짜 시간과 2018년 12월 31일 23시 59분 59초와의 차이
difftime(as.POSIXct("2020/12/31 23:59:59"), Sys.time()) 
# 현재 날짜 시간과 2018년 12월 31일 23시 59분 59초와의 차이(분 단위로)
difftime(as.POSIXct("2020/12/31 23:59:59"), Sys.time(), units='mins')
# 현재 날짜 시간과 2018년 12월 31일 23시 59분 59초와의 차이(초 단위로)
difftime(as.POSIXct("2020/12/31 23:59:59"), Sys.time(), units='secs')
# units은 다음 중 하나: 'auto', 'secs', 'mins', 'hours', 'days', 'weeks'

as.numeric(as.POSIXct("2020/12/31 23:59:59"))-as.numeric(Sys.time())

'2022-01-01'-'2021-12-31'
## Error in "2022-01-01" - "2021-12-31": 이항연산자에 수치가 아닌 인수입니다

as.Date('2022-01-01')-as.Date('2021-12-31')

## 3.3.4 논리형
(7 < 3) & (4 > 3)
(7 < 3) | (4 > 3)
!(7 < 3)
xor(T, T) # XOR
x = NA
isTRUE(x == 3) # robust to NAs

TRUE <- c(3,2) 
#Error in TRUE <- c(3, 2) : invalid (do_set) left-hand side to assignment
T <- c(3,2) 
T 

## 3.3.5 데이터 타입에 따른 연산과 함수
## 데이터 타입       대표적인 연산과 함수 
## 숫자(numeric)     ^(**), *, /, +, -, <, ==, >, exp(), log()
## 문자(str)         nchar(), paste(), substring()
## 날짜(Date)        Sys.Date(), -, difftime()
## 날짜시간(POSIXct) Sys.time(), -, difftime()
## 논리(logical)     &, |, !, xor(), &&, ||

1.32e+308
1.32e+308*10

## 3.4.1 발생원인

NA + 3
NA == 3
NA == NA

log(-1)
log(NaN)
NaN/0

1e+200*1e+200
Inf+3; 3+Inf; 3-Inf; Inf-3; Inf+Inf; Inf-Inf; 3/Inf
Inf+3; 3/Inf; Inf-Inf


## 3.4.2 몇가지 유의사항
x <- c(2, 5, NA, 3)
vec <- c(3, 7, 0, NA, -3)
ifelse(is.na(x), NA, x %in% vec)

x <- 1e-16
c(log(1+x), log1p(x), exp(x)-1, expm1(x)) ## log(1+x)의 결과값이 책(0e+00)과 다름

## 3.4.3 NULL
c(1, NULL, 2)

colnames(mtcars)
mtcars$name; mtcars[['name']]


mpg$cyl <- NULL

NULL==3; NULL!=3; NULL==NA; NULL!=NA

is.null(NULL)

NULL + c(3,2)
NULL + NA


