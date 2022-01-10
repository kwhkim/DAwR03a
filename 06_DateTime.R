## 6 날짜와 시간

download.file("http://cran.nexr.com/src/contrib/ConvCalendar_1.2.tar.gz",
              destfile='ConvCalendar_1.2.tar.gz',
              mode="wb")
dir.create('ConvCalendar_1.2.tar')
system('tar -xvzf ConvCalendar_1.2.tar.gz -C ConvCalendar_1.2.tar')
install.packages('ConvCalendar_1.2.tar/ConvCalendar', repos=NULL, type='source')

library(ConvCalendar)
as.OtherDate(as.Date('1582-10-14'), 'julian')
# 1582-10-04

# http://www.webexhibits.org/calendars/calendar.html

## 6.1 R의 날짜와 시간

dateNow <- Sys.Date()
print(dateNow)
class(dateNow)


timeNow <- Sys.time()
print(timeNow)
class(timeNow)

unclass(dateNow); print.default(dateNow)
unclass(timeNow); print.default(timeNow)

## 6.2 날짜의 표기

## ISO 8601

## 스타일   표기            의미                     예
## 기본형 (+-)YYYYMMDD    년월일                  20200103
## 확장형 (+-)YYYY-MM-DD  년-월-일                2020-01-03
## 기본형 (+-)YYYYDDD     년일(1년의 몇번째 일)   2020003
## 확장형 (+-)YYYY-DDD    년-일(1년의 몇번째 일)  2020-003
## 기본형 (+-)YYYYWwwD    년주일                  2020W013
## 확장형 (+-)YYYY-Www-D  년-W주-일               2020-W01-3


## 6.2.2

## ISO 8601 시간

## 스타일     표기                      의미
## 기본형  hhmmss(,ss)(Z)(+-hh(:)mm)    시분초(,100분의 1초)(Z)(타임존)
## 확장형  hh:mm:ss(,ss)(Z)(+-hh(:)mm)  년-월-일(,100분의 1초)(Z)(타임존)

## 6.3 날짜 표기 변환

x <- Sys.time()

format(x, '%Y-%m-%d %H:%M:%S')
format(x, '%Y-%jT%H:%M:%S')
format(x, '%G-W%V-%u %H:%M:%S')


## 기호   의미
## %Y     4자리 년
## %G     4자리 년 
## %m     2자리 월
## %d     2자리 (월 중) 일(01-31)
## %H     2자리 시간(00-23)
## %M     2자리 분(00-59)
## %S     2자리 초(00-59)
## %j     3자리 (년 중) 일(001-366)
## %V     2자리 (년 중) 주(01-53)
## %u     1자리 (주 중) 일(1-7, 1=월요일)

for (y in 2022:2023)
  print(format(as.Date(paste0(y, '-12-30', sep='')),
               '%Y/%m/%d, %G-W%V-%u %%V=%V %%U=%U %%u=%u %%w=%w %%A=%A %%a=%a'))

## 6.4 날짜시간 표기 인식

## 6.4.1 ISO 8601

## ISO 8601 

##   표기            의미                     예        날짜로 변환
##  (+-)YYYYMMDD    년월일                  20250103    format='%Y%m%d'
##  (+-)YYYY-MM-DD  년-월-일                2025-01-03  format='%Y-%m-%d'
##  (+-)YYYYDDD     년일(1년의 몇번째 일)   2025003     format='%Y%j'
##  (+-)YYYY-DDD    년-일(1년의 몇번째 일)  2025-003    format='%Y-%j'
##  (+-)YYYYWwwD    년주일                  2025W013    parse_iso_8601()
##  (+-)YYYY-Www-D  년-W주-일               2025-W01-3  parse_iso_8601()

install.packages("parsedate")

library(parsedate)
as.Date('20210102', format='%Y%m%d'); as.Date(parse_iso_8601('20210102'))
as.Date('2021-01-02', format='%Y-%m-%d'); as.Date(parse_iso_8601('2021-01-02'))


as.Date('2021002', format='%Y%j'); as.Date(parse_iso_8601('2021002'))
as.Date('2021-002', format='%Y-%j'); as.Date(parse_iso_8601('2021-002'))

as.Date(parse_iso_8601('2022W536'))
as.Date(parse_iso_8601('2022-W53-6'))


library(magrittr)
as.Date('Jan 01 2020', format='%b %d %Y')
as.Date('January 01 2020', format='%B %d %Y')
lc_sys <- Sys.info()[["sysname"]]
lc_sep <- switch(lc_sys,
                 "Darwin"=, "SunOS" = "/",
                 "Linux" =, "Windows" = ";")
# 여기서 switch()는 lc_sys가 "Darwin" 또는 "SunOS"이면 "/"를
# "Linux" 또는 "Windows"이면 ";"를 반환한다.
Sys.getlocale("LC_ALL")


source("utils.R")
printlocales()

if (lc_sys == "Windows") {
  Sys.setlocale("LC_ALL", "English") %>%
    strsplit(lc_sep) # Window
} else {
  Sys.setlocale("LC_ALL", "en_US.UTF-8") %>%
    strsplit(lc_sep) # Linux
}
as.Date("Jan 04 2022", format = "%b %d %Y")
as.Date("January 04 2022", format = "%B %d %Y")

as.Date('March 01 2020', format='%B %d %Y')
as.Date('Mars 01 2020', format='%B %d %Y') 

library(lubridate)
lc <- switch(lc_sys,
             "Darwin"= , "SunOS"= , "Linux" = "fr_FR",
             "Windows" = "French")
mdy('March 01 2022', locale=lc)
mdy('Mars 01 2022', locale=lc) # 로케일을 프랑스로 바꾸도 제대로 인식되지 않음


lc_french <- switch(lc_sys,
                    "Darwin"= , "SunOS" = , "Linux" = "fr_FR",
                    "Windows" = "French")
lc_german <- switch(lc_sys,
                    "Darwin"= , "SunOS" = , "Linux" = "de_DE",
                    "Windows" = "German")

wday(today(), label = TRUE, abbr = FALSE, locale = lc_german)
wday(today(), label = TRUE, abbr = FALSE, locale = lc_french)
month(today(), label = TRUE, abbr = FALSE, locale = lc_german)
month(today(), label = TRUE, abbr = FALSE, locale = lc_french)

if (.Platform$OS.type == "windows") {
  Sys.setlocale("LC_ALL", "English") %>%
    strsplit(";") # Window
} else {
  Sys.setlocale("LC_ALL", "en_US.UTF-8") %>%
    strsplit(";") # Unix
}
as.POSIXct("March 01 2022 11:13:22", format = "%B %d %Y %H:%M:%S")
strptime("March 01 2022 11:13:22", format = "%B %d %Y %H:%M:%S")
mdy_hms("March 01 2022 11:13:22")
mdy_hms("March 01 2022 11:13:22", tz = "Asia/Seoul")

if (.Platform$OS.type == "windows") {
  Sys.setlocale("LC_ALL", "French") %>%
    strsplit(";") # Window
} else {
  Sys.setlocale("LC_ALL", "fr_FR.UTF-8") %>%
    strsplit(";") # Unix
}
as.POSIXct("Mars 01 2022 11:13:22", format = "%B %d %Y %H:%M:%S")
strptime("Mars 01 2022 11:13:22", format = "%B %d %Y %H:%M:%S")
mdy_hms("Mars 01 2022 11:13:22")
mdy_hms("Mars 01 2022 11:13:22", tz = "Asia/Seoul")
           
## 6.5 날짜, 시간 연산
t0 <- as.POSIXct("2022-01-01 00:00:00")
t1 <- as.POSIXct("2023-01-01 00:00:00")
t1 - t0
difftime(t1, t0, units = "weeks")
difftime(t1, t0, units = "hours")

t0s <- format(t0, format = "%Y-%m-%d %H:%S:%M")
t1s <- format(t1, format = "%Y-%m-%d %H:%S:%M")
t1s - t0s

difftime(t1s, t0s, units = "weeks")
difftime(t1s, t0s, units = "hours")

t0s <- format(t0, format = "%d-%m-%Y %H:%S:%M")
t1s <- format(t1, format = "%d-%m-%Y %H:%S:%M")
t1s - t0s

difftime(t1s, t0s, units = "weeks")
difftime(t1s, t0s, units = "hours")

## 6.6 날짜(시간)의 특정한 정보 참조

# 함수                     의미                             지역 설정
# julian(x)                1970년 1월 1일 이후 몇번째 일    "Korean"
# julian(x, origin = )     origin 이후 몇번째 일            "Korean"
# quartes(x)               분기(Q1, Q2, Q3, Q4)             "Korean"
# months(x)                월(1월, 2월, 3월, …)             "Korean"
# months(x)                월(January, Februrary, March, …) "English"
# months(x, abbr = TRUE)   월(1, 2, 3, …)                   "Korean"
# months(x, abbr = TRUE)   월(Jan, Feb, Mar, …)             "English"
# weekdays(x)              요일(월요일, 화요일, 수요일, …)  "Korean"
# weekdays(x)              요일(Monday, Tuesday, Wednesday, …) "English"
# weekdays(x, abbr = TRUE) 요일(월, 화, 수, …)              "Korean"
# weekdays(x, abbr = TRUE) 요일(Mon, Tue, Wed, …)           "English"


## 6.7 날짜(시간) 갱신

## 함수     의미              
## year()   년
## month()  월
## week()   주
## yday()   (년 중) 일(1-366)
## mday()   (월 중) 일(1-31)
## day()    (월 중) 일
## yday()   (주 중) 일(1-7, 1:일)
## hour()   시
## minute() 분
## second() 초
## tz()     타임존
## dst()    써머타임(Daylight Saving Time)의 여부


t <- Sys.time()
t
year(t); year(t) <- 2030; t
month(t); month(t) <- 1; t
week(t); week(t) <- 2; t
day(t); day(t) <- 2; t


yday(t); yday(t) <- 1; t
yday(t); yday(t) <- 366; t
mday(t); mday(t) <- 2; t # same as day(t)
wday(t); wday(t) <- 3; t
wday(t, label=TRUE); wday(t); 
wday(t) <- 1; t 


hour(t); hour(t) <- 12; t
minute(t); minute(t) <- 41; t
second(t); second(t) <- 12; t
tz(t) ; tz(t) <- "GMT"; t
dst(t)
dst(t) <- TRUE
t

#library(parsedate)
format(as.Date(parse_iso_8601('2020-W53-6')), "%A")

options('lubridate.week.start'=1) 

wday(as.Date(parse_iso_8601('2020-W53-6'))) 

options('lubridate.week.start'=2) 

wday(as.Date(parse_iso_8601('2020-W53-6')))


t <- Sys.time()
t
tz(t) <- "GMT" # 또는 force_tz(t, tzone="GMT")
t
with_tz(t, "Asia/Seoul")

## 6.8 몇 가지 유의사항
vdate <- c(Sys.Date(), as.Date(c("2000-01-01", "2022-01-18", "2030-12-31")))
# vposix <- c(Sys.time(), as.POSIXct(c('2000-01-01', '2022-01-18 13:00',
# '2030-12-31 23:59')))
ifelse(vdate > as.Date("2010-10-10"), vdate + 3, vdate - 2)

dplyr::case_when(vdate > as.Date("2010-10-10") ~ vdate + 3, TRUE ~ vdate - 2)

## 6.9 활용 예

t0 <- as.POSIXct("2021-01-01 13:00:00", tz='Europe/Paris'); t0
t1 <- t0; tz(t1) <- "Asia/Seoul"; t1
t2 <- with_tz(t1, tzone='Europe/Paris'); t2
t3 <- t2; hour(t3) <- hour(t3) + 7; t3
t4 <- with_tz(t3, tzone='Asia/Seoul'); t4

print(t1)
print(t2)
t1 == t2

## 6.10   stringi 패키지
## 6.10.1 stringi의 로케일
library(stringi)
stri_locale_set('de') # stri_datetime_xxxx 함수의 기본 로케일을 독일어로

stri_datetime_format(as.POSIXct('2023-01-01 13:00'), 'yyyy MMMM dd EEEE')

Sys.setlocale('LC_ALL', "Korean") # windows
format(as.Date('2024-01-01'), '%Y %B %d %A %a') # 내장함수의 로케일은 여전히 한글

stri_datetime_format(Sys.time(), 'MMMM dd yyyy EEEE', locale='en')

stri_datetime_format(as.POSIXct('2025-01-01 13:00'),
                     stri_datetime_fstr('%B %d %Y %a'), locale='zh')

## 6.10.2 stringi의 날짜시간 함수
(x <- stri_datetime_format(as.Date('2023-02-14'),
                           format= "dd 'de' MMMM 'de' yyyy, cccc[VV]",
                           locale = 'es', tz = 'Europe/Madrid'))

stri_datetime_parse(x, # "01 de abril de 2022"
                    format= "dd 'de' MMMM 'de' yyyy",
                    locale = 'es', tz= 'Europe/Madrid')

(x <- stri_datetime_format(as.Date('2023-02-14'),
                           format= "dd-MMM-yyyy, ccc[VVVV]",
                           locale = 'es', tz= 'Europe/Madrid'))

stri_datetime_parse(x, # 14-feb-2023, mar[hora de España]
                    format= "dd-MMMM-yyyy",
                    locale = 'es', tz= 'Europe/Madrid')


## 6.11 국경일과 공휴일
library(httr)
library(dplyr)
year = 2004 # 2004부터 가능
api_key = "VNaEEzyFV1RPkG70I4pG..."
api_url = "http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/"
api_srv = "getHoliDeInfo"
res = GET(paste0(
  api_url, api_srv,
  "?serviceKey=", api_key,
  "&solYear=", year,
  "&numOfRows=100"),
  add_headers(.headers = c('Accept-Encoding' = 'gzip, deflate')))

if (.Platform$OS.type=='windows') {
  #cat(iconv(rawToChar(res$content), from='UTF-8', to='CP949'))
  dat = jsonlite::parse_json(
    iconv(rawToChar(res$content), from='UTF-8', to='CP949'))
} else {
  dat = jsonlite::parse_json(rawToChar(res$content))
}
dat2 = lapply(dat$response$body$item$item, data.frame)
if (dat$response$header$resultCode == "00") {
  datAll = do.call(bind_rows, dat2)
}
datAll %>% slice(5:10)


## 6.12 음력
if (.Platform$OS.type == "windows") {
  remotes::install_github("kwhkim/hongkong") # Windows
} else {
  remotes::install_github("chainsawriot/hongkong") # UNIX
}
library(hongkong)
lunarCal(as.Date("2004-05-26"))

birthBuddha <- as.lunar("2004-04-08")
# as.lunar()는 as.Date()와 같이 음력 날짜를 생성한다.
lunarCal(birthBuddha)

## 6.13   먼 미래, 먼 과거, 그리고 기원
## 6.13.1 미래
as.Date("10000-01-01")
x = as.Date("9999-12-31") + 1
x

as.Date('12222-02-14')
y = as.Date('2222-02-14') + 10000 * 365.2425; y
format(y, '%Y-%m-%d %A')

## 6.13.2 더욱 더 먼 미래와 과거

as.Date(.Machine$integer.max)
# print.default(as.Date('2000-01-01'))
# as.Date(10957, origin = '1970-01-01') # 2000-01-01
as.Date(.Machine$integer.max, origin = '1970-01-01')

(x = as.Date(.Machine$integer.max, origin = "1970-01-01") + 1)
x + 1

## 6.13.3 기원, 그리고 역사연도와 천문연도
z = as.Date("0000-01-04")
(z = as.Date("0000-01-04") - 365)

format(z, "%05Y") # 자리 수 채우는 0
format(z, "%_5Y") # 자리 수 채우는 공란
format(z, "%04Y")

as.Date("-0001-01-04")
as.Date("-001-01-04")

## 천문연도는 `uuuu`를 쓰고, 역사 연도는 `yyyy`를 쓴다.
c(stri_datetime_format(z, "uuu-MM-dd"),
  stri_datetime_format(z, "uuuu-MM-dd"),
  stri_datetime_format(z, "yyyy-MM-dd"))
## 역사연도는 마이너스가 붙지 않으므로 기원전/기원후를 추가해야 한다.
c(stri_datetime_format(z, "GG yyyy-MM-dd", locale='ko'),
  stri_datetime_format(z, "GGGG yyyy-MM-dd", locale='ko'))


print.default(as.POSIXct("2022-01-01"))
as.POSIXct(1640962800, origin = "1970-01-01")
as.POSIXct(1640962800 + 1, origin = "1970-01-01")

as.POSIXct(.Machine$double.xmax, origin = "1970-01-01")
as.POSIXct(.Machine$double.xmax/1e+292, origin = "1970-01-01")





