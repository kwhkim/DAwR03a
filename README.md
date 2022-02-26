# DAwR03a
R로 하는 빅데이터 분석: 데이터 전처리와 시각화(제3판)

* 축 : 저자 ASCE(**A**merican **S**ociety of **C**ivil **E**ngineers) [Thomas Fitch Rowland Prize](https://www.asce.org/career-growth/awards-and-honors/thomas-fitch-rowland-prize/thomas-fitch-rowland-prize-past-award-winners) [수상](https://www.mk.co.kr/news/society/view/2022/02/170329/)

![마케팅](ad03.png)

## 표지

![표지](3rd03.png)

## 파일 안내

* `utils.R` : 책에 포함된 여러 함수
  * `u_chars(x)` : 문자열 `x`을 구성하는 문자들에 대한 정보 출력(`Unicode` 패키지 활용).
  * `printlocales()` : 로케일 설정 사항을 보기 좋게 출력
  * `encoding(x) <- "xxx"` : R의 기본 함수인 `Encoding(x) <- "xxx"`는 인코딩을 반영할 수 없을 때에도 아무런 오류를 발생시키지 않는다. `encoding()`의 경우 `Encoding()`과 기능은 동일하지만 만약 적절히 실행이 불가능한 경우에 오류를 발생시킨다.
  
## 사용 방법

```{r}
> source('utils.R', encoding = 'UTF-8')

> u_chars('\ufeff\u132\u67')
        ch codepoint                     label
1 <U+FEFF>      feff ZERO WIDTH NO-BREAK SPACE
2       Ĳ      0132 LATIN CAPITAL LIGATURE IJ
3        g      ..67      LATIN SMALL LETTER G

> printlocales()
  LC_COLLATE = Korean_Korea.949    
    LC_CTYPE = Korean_Korea.949    
 LC_MONETARY = Korean_Korea.949    
  LC_NUMERIC = C                   
     LC_TIME = Korean_Korea.949 

> x = 'abc'
> Encoding(x)
[1] "unknown"
> encoding(x)
[1] "unknown"
> Encoding(x) = 'cp949'
> encoding(x) = 'cp949'
 Error in `encoding<-`(`*tmp*`, value = "cp949") : 
value %in% c("latin1", "UTF-8", "bytes", "", "unknown") is not TRUE 
```

## 데이터 파일/URL/생성하는 파일 등 외부 의존

### 필요한 데이터 파일

* 08_ImportingData.R
  - 서울시 한강공원 이용객 현황 (2009_2013년).csv
  - 서울시 한강공원 이용객 현황 (2009_2013년).xls
  - 서울특별시 공공자전거 대여소별 이용정보(월간)_2017_1_12.csv
  - text_data_file_01.csv
  - dat_UTF8.txt
  - crypto2021-05.zip
  - excel_example.xls
  - s1.json
  - s2.json
  - s1b.json
  - s3a.json
  - s3b.json
  - s3c.json
  - test2.jpg

* 16_ggplot2.R
  - 테스트.png

* 17_Solutions.R
  - 서울시 한강공원 이용객 현황 (2009_2013년).csv
  - 서울특별시 공공자전거 대여소별 이용정보(월간)_2017_1_12.csv
  - 서울시 한강공원 이용객 현황 (2009_2013년).xls


### 외부 URL

* 08_ImportingData.R
  - http://www.nber.org/data/population-birthplace-diversity/JoEG_BP_diversity_data.csv
  - https://en.wikipedia.org/wiki/List_of_most_common_surnames_in_Europe

* 17_Solutions.R
  - http://www.nber.org/data/population-birthplace-diversity/JoEG_BP_diversity_data.csv
  - http://www.nber.org/data/population-birthplace-diversity/JoEG_BP_diversity_data.dta
  - https://en.wikipedia.org/wiki/List_of_Korean_surname


### 생성되는 데이터 파일

* 08_ImportingData.R
  - dat.txt
  - dat.RData
  - datMsg.txt
  - datScript.txt
  - mtcars.RDS
  - mtcars.feather
  - dat_rio1.dta
  - dat_rio2.dta
  - s3c_bak.json

* 10_datatable.R
  - dat.csv

* 14_Descriptive.R
  - report.html (DataExplorer::create_report(mpg2))

* 16_ggplot2.R
  - picRecent.png
  - picp.jpg
  - AC_dbplyr.R
  - flights.db
  - AD_files.R
  - ./__temp
  - ./__temp2
  - ./__temp3
  - dircopy.R
  - __temp.txt






