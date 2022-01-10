## 제 17장. 연습문제 해답
## 데이터 구조
dat1 = data.frame(name=c('Kim', 'Park'),
                  age=c(24, 40),
                  height=c(180,165), stringsAsFactors=FALSE)
dat2 <- dat1

dat1[1,] <- c("Lee", 30, 170); dat1
dat2[1,] <- list("Lee", 30, 170); dat2

dat1$age
dat2$age

tibble(dat1)
tibble(dat2)

dat2 = data.frame(name=c('Kim', 'Park'),
                  age=c(24, 40),
                  height=c(180,165), stringsAsFactors=TRUE)
dat2[1,] <- list("Lee", 30, 170); dat2

## 데이터 불러들이기
dat <- read.csv('서울시 한강공원 이용객 현황 (2009_2013년).csv',
                fileEncoding = 'UTF-8-BOM')
# BOM은 <문자열>의 유니코드, 엔디언, BOM을 참조하자.
# readr::read_csv는 BOM을 적절히 처리하는 듯 보인다
# dat <- read_csv('서울시 한강공원 이용객 현황 (2009_2013년).csv')
dat %>% tibble %>% head(2)

dat02 <- read.csv('서울특별시 공공자전거 대여소별 이용정보(월간)_2017_1_12.csv',
                  quote="'",
                  fileEncoding = 'CP949')
# readr::read_csv을 사용한다면,
# dat02
# <- read_delim('서울특별시 공공자전거 대여소별 이용정보(월간)_2017_1_12.csv',
# quote="'", delim=',',
# locale=locale(encoding = 'cp949'))
head(dat02, n=2)

dat03 <- read.csv(
  "http://www.nber.org/data/population-birthplace-diversity/JoEG_BP_diversity_data.csv",
  sep=";", header=T, row.names=NULL)
head(dat03, n=2)

## EXCEL 화일 읽기
library(readxl)
dat04 <-
  readxl::read_xlsx('서울시 한강공원 이용객 현황 (2009_2013년).xls', sheet=1)
head(dat04, n=3)

## 그 밖의 통계 프로그램 데이터 화일
url = 'http://www.nber.org/data/population-birthplace-diversity/JoEG_BP_diversity_data.dta'
rio::import(url)
foreign::read.dta(url)
haven::read_dta(url)
readstata13::read.dta13(url)

## Web에서 데이터 긁어오기
library(XML); library(curl)
url <- "https://en.wikipedia.org/wiki/List_of_Korean_surnames"
con <- curl(url)
html <- readLines(con)
df <- readHTMLTable(html, header = TRUE, which = 1,
                    stringsAsFactors = FALSE, encoding = "UTF-8")

## 제어와 함수 I.
x = "two"
switch(x,
       "1"="one",
       "2"="two",
       "else!") # 숫자는 따옴표로 감싸야 함을 주의하자.

ch = 'c'
switch(ch, a=, b=1, c=, d=3, 0)
# a= 에 아무 것도 없으므로, 다음 경우(b=)로 넘어간다.
# a=, b=, c=, d=에 모두 해당하지 않는 경우 0이 반환된다.

