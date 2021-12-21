## 2 R의 패키지
## 2.1 패키지 설치
install.packages(c('psych', 'MASS'))

setRepositories() # 1 for CRAN
chooseCRANmirror() # 54-56 for Korea

options(repos = "http://healthstat.snu.ac.kr/CRAN/")
install.packages("psych", dependencies=TRUE)

## 2.2 패키지 관련 정보
maintainer("psych")
citation("psych")

## 2.3 패키지 불러오기/확인하기/제거하기
library(psych)
describe(mtcars)
search()

detach("package:psych")
describe(mtcars) 
# Error in describe(mtcars) : could not find function "describe"
search()

## 2.4 패키지 관리하기
options(repos = "http://healthstat.snu.ac.kr/CRAN/")
installed.packages()
update.packages("psych")


## 2.5 중복되는 함수와 변수
library(psych)
install.packages("car")  
# 패키지 인스톨 추가했습니다.
library(car)

psych::logit(60)
car::logit(60)
logit(60)

