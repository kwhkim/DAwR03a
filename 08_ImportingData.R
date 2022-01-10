## 8 R로 데이터 읽어오기

## 8.0.1 주요 내용

install.packages('AER')
library('AER')

## 8.0.1 주요 내용
## • R 내장 데이터 : data()
## • 가장 기본적인 방법 : read.table/write.table, load/save
## • 텍스트로 저장된 파일 읽어오기
##   – read.csv
##   – 빅데이터: data.table::fread, readr::read_csv
## • 바이너리 파일 읽어오기 : read_RDS, feather::read_feather
## • 압축 파일에서 읽어오기
## • 엑셀 파일 : readxl::read_excel
## • 웹에서 표 긁어오기 : htmltab, readHTMLTable
## • JSON 파일 읽기
## • 이미지에서 텍스트 추출하기
## • 정리

## 8.1 R 내장 데이터

data(mtcars)
head(mtcars, n=3)

data("BankWages", package='AER')
head(BankWages, n=3)

## 8.2 들어가기 : write.table/read.table, save/load

dat <- mtcars
head(dat, n=3)
class(dat)

write.table(dat, file='dat.txt')
dat02 <- read.table(file='dat.txt')

all.equal(dat, dat02)


dat <- mtcars

save(dat, file='dat.RData')
datBackup <- dat
rm(dat)
head(dat)
# Error in head(dat) : object 'dat' not found

load(file='dat.RData')

head(dat, n=3)
all.equal(dat, datBackup)
file.size('dat.txt')
file.size('dat.RData')
# ubuntu에서는 3835(아마도 데이터가 크지 않아서) vs 1780


## 8.3 텍스트로 저장된 데이터 화일 읽기

## 8.3.1 직접 텍스트 데이터 화일을 작성해 보기

datMsg <- 
  data.frame(
    name = c("BTS", "트와이스", "케이티 킴"),
    phone = c('010-4342-5842', '010-5821-4433', '010-5532-4432'),
    usageLastMonth = c(38000, 58000,31000),
    message = c('안녕, 날씨 좋다! "가즈아!"라고 말하고 싶다.',
                '달빛 아래 춤추자! \'너무너무너무\'라고 노래 부를래.',
                'Memorable'),
    price = c(30, 10, NA), 
    stringsAsFactors=FALSE)
datMsg

write.table(datMsg, file = "datMsg.txt")
cat(paste0(readLines("datMsg.txt"), collapse = "\n"))

## 8.3.2 확장자 csv

write.csv(datMsg, file='dat.csv')
datMsg02 <- read.csv(file='dat.csv')
all.equal(datMsg, datMsg02)

head(datMsg02, 3)

datMsg03 <- 
  read.csv(file='dat.csv', row.names=1, stringsAsFactors=FALSE)
all.equal(datMsg, datMsg03)

## 8.3.3  수치 데이터를 텍스트 파일로 저장하기

## 8.3.4 문자 데이터를 텍스트 파일로 저장하기
txt = "1,Mary,\"I asked him, \"\"How are you?\"\"\",love
2,Paul,\"I entered room.
He saw me and ran right away\",run
3,Jim,\"\"\"Crazy!\"\" He spoke.
'Wonderful!'
She agreed.\",agree"
read.csv(text = txt, header = FALSE)

txt = "170,63,11
173,,14
168,53,"
dat = read.csv(text = txt, header = FALSE)
dat

txt = ",,
NA,NA,NA
\"NA\",1985,kindness
\"Grande-Butera, Ariana\",1993,heart"
dat1 = read.csv(textConnection(txt), header = FALSE)
library(readr)
dat2 = readr::read_csv(file = txt, col_names = FALSE)
library(data.table)
dat3 = data.table::fread(txt, header = FALSE)

dat2b = read_csv(file = txt, col_names = FALSE, na = "NA")
dat2c = read_csv(file = txt, col_names = FALSE, quoted_na = FALSE)
dat3[4, 1] = "<NA>"
dat1[4, 1] = "<NA>"

dat1
dat2b
dat3


## 8.3.3 텍스트 데이터 파일을 불러읽을 때 고려해야 할 사항

## 1. 텍스트 인코딩
##   • readr::guess_encoding()을 통해 유추할 수 있다. 하지만 확실하지 않다.
##   • notepad++11 등의 문서작성 프로그램을 활용하여 인코딩을 확인할 수도
##     있다. 특히 UTF-8BOM과 UTF-8의 구분은 readr::guess_encoding()에
##     서는 불가능하지만 notepad++에서는 가능했다.
## 2. 전체적인 형식 : 아래에서 c(,)로 묶인 원소 중 하나를 선택해야 한다 (예.
##                                               header=TRUE 또는 header=FALSE)
##   • 행이름을 포함하는가? header=c(TRUE,FALSE)
##   • 열이름을 포함하는가? 포함한다면 몇 번째 줄인가? row.names=c(1,NULL)
##   • 열 구분자(delimiter) : sep=c('\t', ',', ' ')’
##   • 주석의 시작은 어떻게 표기하는가? comment.char=
## 3. 데이터를 표기하는 방법
##   • 문자열 : 인용부호(quotation mark; 문자열의 시작과 끝을 나타내는 기호)
## : quote=
##   • 수치형 : 소수점 표기 방법(decimal seperator) : dec= (나라마다 소수점
##                                                표기 방법이 다르다.12)
## 4. 그 밖에
## • stringsAsFactors=c(TRUE,FALSE) : 문자열을 팩터형으로 변환할 것인가?
##   R 버전 4에서 기본값이 TRUE에서 FALSE로 바뀌었다.
## • colClasses=c(NA, 'NULL', 'logical', 'integer', 'numeric', 'complex',
##                'character', 'raw', 'factor', 'Date', 'POSIXct') : 각 열의 데이터 클래스를 직접 정해줄 수 있다.

dat01 <- read.csv('서울시 한강공원 이용객 현황 (2009_2013년).csv',
                  fileEncoding = 'UTF-8')

# fileEncoding의 기본값은 한글 Windows(CP949)와 리눅스 기반(UTF-8)에서 다르다.
# 동일한 OS에서 생성된 파일을 읽을 때 fileEncoding을 생략할 수 있지만,
# 그렇지 않을 때에는 fileEncoding= 을 정확하게 지정해야 한다.
dat02 <- read.csv('서울특별시 공공자전거 대여소별 이용정보(월간)_2017_1_12.csv',
                  fileEncoding = 'CP949')
head(dat02, n=3)

dat03 <- read.csv(
  "http://www.nber.org/data/population-birthplace-diversity/JoEG_BP_diversity_data.csv")
head(dat03, n=3)

## 8.3.6 빅데이터
# read_delim(file = , delim = , col_names = )
# data.table::fread(file = , sep = , header = )

# 확인 사항:
# - TRUE, T, True, true는 logical에서 모두 참으로 인식하는가?
# - 만약 "1999-12-31 12:00"와 "1999-01-01"이 같은 열에 존재한다면 어떻게 되는가?
read.table(file = 'text_data_file_01.csv',
           sep=',', header=FALSE, row.names=NULL,
           colClasses = c(NA, 'NULL', 'logical', 'integer', 'numeric',
                          'complex', 'character', 'raw', 'factor', 'Date', 'POSIXct'))

readr::read_delim(file='text_data_file_01.csv',
                  delim=',',col_names=FALSE, # complex와 raw는 지원하지 않기
                  col_types = '?_lid_c_fDT') # 때문에 건너뛰었다(`_`)


data.table::fread(file='text_data_file_01.csv', header=FALSE,
                  colClasses = c(NA, 'NULL', 'logical', 'integer', 'numeric',
                                 'complex', 'character', 'raw', 'factor', 'Date', 'POSIXct'))

## 8.3.6.2 fwrite()과 fread()
datScript = data.frame(
  A = c('"Hi!" I said', 'I paused.', 'Mike'),
  B = c('그는 말했다. "놀랍지?"', '응!', '"정말로!" 그랬다')
)

datScript$B = iconv(datScript$B, to='UTF-8') # Window

fwrite(datScript, file='datScript.txt', sep=',', qmethod="double")
fread('datScript.txt', sep=',', quote='"', encoding = 'UTF-8')

fwrite(datScript, file='datScript.txt', sep=',', qmethod="escape")
fread('datScript.txt', sep=',', quote='"', encoding = 'UTF-8')

## 8.3.6.3 윈도우에서 인코딩 문제
dat1 <- read.csv('dat_UTF8.txt',
                 sep=',',
                 fileEncoding='UTF-8',
                 header=FALSE,
                 stringsAsFactors=FALSE); dat1
dat2 <- readr::read_delim('dat_UTF8.txt',
                          delim=',',
                          locale = readr::locale(encoding = 'UTF-8'),
                          col_names=FALSE); dat2
dat3 <- data.table::fread('dat_UTF8.txt',
                          sep=',',
                          encoding='UTF-8',
                          header=FALSE); dat3

## 8.4 바이너리 파일 읽기
saveRDS(mtcars, "mtcars.RDS")
mtcars2 <- readRDS("mtcars.RDS")
all.equal(mtcars, mtcars2)

library(feather)
library(tibble)
write_feather(mtcars, "mtcars.feather")
mtcars3 <- read_feather("mtcars.feather")
all.equal(as_tibble(mtcars), mtcars3)

## 8.5 압출 파일에서 읽어오기
library(readr)
fn_zip = 'crypto2021-05.zip'
fns = as.character(unzip(fn_zip, list = TRUE)$Name)
# zip파일에 압축된 파일 목록
print(fns)

dat <- read_csv(unz(fn_zip, fns[1]), col_types=cols())
# 첫번째 파일(fns[1])을 압축 풀고(unz) read_csv로 읽는다.
# read_csv는 파일 형식에 맞춰서 변경한다.
# read_csv의 col_types=cols()를 생략하면
# 각 컬럼의 데이터 타입(추정)이 출력된다

dat <- fread(cmd = paste('unzip -cq', fn_zip, fns[1]))
# Linux에 unzip이 설치되어 있지 않다면 apt install unzip으로 설치한다.

head(dat, n=3)

lst = vector("list", length(fns))
for (i in seq_along(fns)) {
  lst[[i]] = read_csv(unz(fn_zip, fns[i]), col_types = cols())
  lst[[i]]$src = fns[i]
}
dat <- data.table::rbindlist(lst)
head(dat, n = 3)

## 8.6 EXCEL 파일 읽기
library(readxl)
readxl::read_excel("서울시 한강공원 이용객 현황 (2009_2013년).xls",
                   sheet = 1)

## 8.6.1 엑셀 파일의 모든 시트(sheet) 읽어오기
library(readxl)

rm(list = ls())

fn = "excel_example.xls"
vSh <- excel_sheets(fn)

# li <- vector(mode='list', length=length(vSh)-1)
if (length(vSh) > 0) {
  for (iSh in 1:(length(vSh))) {
    vname <- vSh[iSh]
    if (exists(vname)) {
      cat("\b\b변수 ", vname, "이(가) 이미 존재합니다.\n")
      break
    }
    assign(vname, read_excel(fn, sheet = vSh[iSh]))
  }
} else {
  cat("No Sheet!!!\n")
}

vSh

ls()

## 8.7 그 밖의 통계 파일
install.packages("rio")
library(rio)
install_formats()

library(rio)
library(readxl)
dat_rio2 <- import('excel_example.xls', which=2) # 두번째 시트
dat_xl2 <- read_excel(
  path = 'excel_example.xls',
  sheet = excel_sheets('excel_example.xls')[2])
# 두번째 시트의 이름(excel_sheets()[2])
all.equal(dat_rio2, as.data.frame(dat_xl2))

dat_rio1 <- import('excel_example.xls', which=1)
dat_xl1 <- read_excel('excel_example.xls',
                      sheet=excel_sheets('excel_example.xls')[1])
all.equal(dat_rio1, as.data.frame(dat_xl1))

library(readstata13)
export(dat_rio1, "dat_rio1.dta")
read.dta13("dat_rio1.dta")

import("dat_rio1.dta")
export(dat_rio2, "dat_rio2.dta")

## 8.8 Web에서 데이터 긁어오기(Web scraping)
library(htmltab)
url <-
  "https://en.wikipedia.org/wiki/List_of_most_common_surnames_in_Europe"
surnames <- htmltab(doc = url, which = 13)
surnames[8:10,] %>% tibble # 출력 시 tibble을 하면 데이터 확인이 용이하다

library(curl)
library(XML)
con <- curl(url)
html <- readLines(con)
df <- readHTMLTable(html, header = TRUE, which = 13,
                    stringsAsFactors = FALSE, encoding = "UTF-8")
df[8:10,] %>% tibble

library(xml2)
library(dplyr)
library(rvest)
require(readr)
url <-
  "https://en.wikipedia.org/wiki/List_of_most_common_surnames_in_Europe"
html=read_html(url,encoding='UTF-8')
tables=html %>% html_nodes("table")
# html_table(tables[13])
# 데이터에 따라 종종 에러가 발생한다. 추후 버전에서 수정될 것 같다.
# html_table(tables[13], convert=FALSE)는 좀 더 안정적이다.
df <- html_table(tables[13], convert=FALSE)[[1]] %>% type_convert
# tables[13] : 13번째 테이블
df[8:10,]

## 8.9 JSON
jsonlite::fromJSON("s1.json")
jsonlite::fromJSON("s2.json")
RJSONIO::fromJSON(content = "s1.json")
RJSONIO::fromJSON(content = "s2.json")
rjson::fromJSON(file = "s1.json")
rjson::fromJSON(file = "s2.json")

RJSONIO::fromJSON("s1b.json", encoding = 'UTF-8')
rjson::fromJSON("s1b.json")
jsonlite::fromJSON("s1b.json")

RJSONIO::fromJSON("s3a.json")
RJSONIO::fromJSON("s3b.json")
RJSONIO::fromJSON("s3c.json")

rjson::fromJSON(file="s3a.json")
rjson::fromJSON(file="s3b.json")
rjson::fromJSON(file="s3c.json")

jsonlite::fromJSON("s3a.json")
jsonlite::fromJSON("s3b.json")
jsonlite::fromJSON("s3c.json")

data(diamonds, package='ggplot2')
dat = diamonds

library(rbenchmark)
benchmark(RJSONIO::toJSON(dat),
          rjson::toJSON(dat),
          jsonlite::toJSON(dat),
          replications = 10,
          columns= c("test", "replications", "elapsed", "relative"))

jtxt = unclass(jsonlite::toJSON(dat))
benchmark(jsonlite::fromJSON(jtxt),
          RJSONIO::fromJSON(jtxt, asText = TRUE),
          rjson::fromJSON(jtxt),
          replications = 10,
          columns= c("test", "replications", "elapsed", "relative"))

dat = rio::import("s3c.json")
rio::export(dat, "s3c_bak.json")
# s3c2.json에 대해서도 확인해보자

## 8.10 이미지에서 텍스트 인식
# Linux 기반 OS의 경우:
# https://tesseract-ocr.github.io/tessdoc/Installation.html
# 에서 각 버전에 맞는 방법을 찾을 수 있다.
install.packages('tesseract')

library(tesseract)
tesseract_info()

tesseract_download('eng')
tesseract_download('kor')
txtHan <- ocr("test2.jpg", engine = "kor")
txtEng <- ocr("test2.jpg", engine = "eng")

txtHan %>% strsplit('\n') %>% .[[1]] %>% head(3)
txtEng %>% strsplit('\n') %>% .[[1]] %>% head(3)

txtBoth <- ocr('test2.jpg', engine='kor+eng')
txtBoth %>% strsplit('\n') %>% .[[1]] %>% head(3)

## Hangul traineddata 다운로드
if (!file.exists(
  file.path(tesseract_info()$datapath, 'Hangul.traineddata'))) {
  download.file(url=
                  'https://github.com/tesseract-ocr/tessdata/blob/main/script/Hangul.traineddata?r
aw=true',
                dest = file.path(tesseract_info()$datapath, 'Hangul.traineddata'),
                mode = 'wb') }

txtBoth2 <- ocr('test2.jpg', engine = 'Hangul')
txtBoth2 %>% strsplit('\n') %>% .[[1]] %>% head(3)

resXML <- ocr('test2.jpg', engine = 'Hangul', HOCR=TRUE)
resDF <- ocr_data('test2.jpg', engine = 'Hangul')

Encoding(resDF$word) = "UTF-8"
head(resDF, 3)

tesseract_params() %>% head(3)

teNum <- tesseract(
  language = 'kor',
  options = list(tessedit_char_whitelist = "0123456789"))
# 언어 'kor'의 훈련데이터를 사용하여 숫자만 인식하도록 설정
txtNum <- ocr('test2.jpg', engine = teNum)
cat(txtNum)


## <관련 데이터 파일 등 정리>
# ## 필요한 데이터 파일
# 서울시 한강공원 이용객 현황 (2009_2013년).csv
# 서울시 한강공원 이용객 현황 (2009_2013년).xls
# 서울특별시 공공자전거 대여소별 이용정보(월간)_2017_1_12.csv
# text_data_file_01.csv
# dat_UTF8.txt
# crypto2021-05.zip
# excel_example.xls
# s1.json
# s2.json
# s1b.json
# s3a.json
# s3b.json
# s3c.json
# test2.jpg
# 
# ## 외부 URL
# http://www.nber.org/data/population-birthplace-diversity/JoEG_BP_diversity_data.csv
# https://en.wikipedia.org/wiki/List_of_most_common_surnames_in_Europe
# 
# ## 생성되는 데이터 파일
# dat.txt
# dat.RData
# datMsg.txt
# datScript.txt
# mtcars.RDS
# mtcars.feather
# dat_rio1.dta
# dat_rio2.dta
# s3c_bak.json


