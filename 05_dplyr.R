#install.packages("ggplot2")
#install.packages("dplyr")

##5.1

##5.1.1

data(diamonds , package='ggplot2')

dim(head(diamonds , n=4)) 

library(magrittr) 

diamonds %>% head(., n=4) %>% dim(.) 

diamonds %>% head(n=4) %>% dim() 

diamonds %>% head(n=4) %>% dim 

diamonds %>% .$price %>% .[1:10]

diamonds %>% .[["price"]] %>% .[1:10]

class(diamonds) 

library(dplyr) 

diamonds 
options(tibble.print_max = 5, tibble.print_min = 5)

diaTB <- as_tibble(diamonds[1:10, ]) 
diaDF <- as.data.frame(diamonds[1:10, ])

diaDF$pri      # partial matching
diaDF[, 'pri'] # ERROR
diaTB$pri      # NULL
diaTB[, 'pri'] # ERROR


df <- data.frame(a = c('Kim','Lee','Park'))
tb <- tibble(a = c('Kim','Lee','Park'))
class(df$a)
class(tb$a)

## 5.2 dplyr의 방식: 부분 선택(Subsetting)
## 5.2.1 dplyr 패키지

library(dplyr)
data(mtcars) 

tb = as_tibble(mtcars) 

## 5.2.2

tb[2:5, ]
slice(tb, 2:5)

tb %>% .[2:5, ]
tb %>% slice(., 2:5)


tb %>% slice(2:5)
tb %>% slice(c(2:3, 4, 5))

##5.2.3  논리 벡터를 사용하여 행 부분 참조

tb[tb$mpg>30, ]

filter(tb, mpg>30)
tb %>% filter(., mpg>30)
tb %>% filter(mpg>30)

## 5.2.4  열 이름이나 번호로 부분 참조

tb <- tb %>% slice(3:5)
tb[, c(1,3)]
select(tb, c(1,3))
tb %>% select(c(1,3))

tb[, c("cyl", "hp")]
select(tb, c("cyl", "hp"))
select(tb, c(cyl, hp))

tb %>% select(c("cyl", "hp"))
tb %>% select(c(cyl, hp))

tb %>% select("cyl", "hp")
tb %>% select(cyl, hp)

which(colnames(tb)=='hp')
which(colnames(tb)=='qsec') 
tb[, which(colnames(tb)=='hp'):which(colnames(tb)=='qsec')] 

tb %>% select(hp:qsec) 
slice(tb, c(1, 2))
slice(tb, 1, 2)

##5.2.4.1 특정한 조건을 만족하는 열 이름 참조

##  구문                  의미
## starts_with('ab')   ab로 시작하는
## ends_with('yz')     yz로 끝나는
## contains('ef')  ef를 포함하는
## one_of(coln)        문자열 벡터 coln의 각 원소와 일치하는
## matches('..[cd]')   정규표현식 ..[cd]와 대응하는

tb3 <- tb %>% slice(1:3) 
tb3 
tb3 %>% select(starts_with('c')) 
tb3 %>% select(starts_with('ca')) 
tb3 %>% select(ends_with('p')) 
tb3 %>% select(contains('c')) 

colnm <- c('drat', 'qsec') 
tb3 %>% select(one_of(colnm)) 


tb3 %>% select(matches('^(.s|.{4})')) 

## 위아래 한쌍으로 dplyr 함수와 동일한 정규 표현식
tb %>% select(starts_with('c'))
tb[, grep('^c', colnames(tb))]

tb %>% select(ends_with('p'))
tb[, grep('p$', colnames(tb))]

tb %>% select(contains('c'))
tb[, grep('c', colnames(tb))]

## 5.2.5 특정한 열 이름 제외

tb %>% select(-cyl, -qsec)
tb %>% select(-c(cyl, qsec))


tb %>% select(-starts_with('c'))
tb %>% select(-contains('c'))

## 5.3 dplyr의 방식 : 수정

## 5.3.1 새로운 열 추가

library(dplyr)
data(mtcars) 
tb = as_tibble(mtcars) 

tb2 <- tb %>% select(hp, cyl, qsec) %>% slice(1:3)

tb2 %>% mutate(hp/cyl)
tb2 %>% mutate(hpPerCyl = hp/cyl)
tb2 %>% mutate(hpPerCyl = hp/cyl, V2 = hp*qsec)


tb2$`hp/cyl` 
tb3 <- tb2 %>% mutate(hp/cyl) 
tb3$`hp/cyl` 


tb$V2 = with(tb, hp*qsec)
tb[c('V1', 'V2')] = data.frame(tb$hp/tb$cyl, tb$hp*tb$qsec)

## 5.3.2 정렬하기
## dplyr 함수와 기존의 방법 비교
tb %>% arrange(cyl)
tb[order(tb$cyl), ]

tb %>% arrange(desc(cyl))
tb[order(tb$cyl, decreasing = T), ]


tb3 %>% arrange(cyl, desc(qsec))

## 5.3.3 요약하기
tb %>% summarise(mean(hp)) 
tb %>% summarize(V1 = mean(hp))
tb %>% summarise(hpMean = mean(hp), qsecMedian =median(qsec))

tb %>% summarise(newVar1 = mean(hp) + median(qsec))
tb %>% summarise(newVar1 = mean(hp), newVar2 = median(qsec))

tb %>% summarise(v1 = mean(hp), v2 = median(qsec), v3 = v1 + v2)
data.frame(v1 = mean(tb$hp), v2 = median(tb$qsec), v3 = v1 + v2)
# Error in v1 + v2 : non-numeric argument to binary operator

## 5.3.4 집단별로 나누기

tb3 %>% group_by(cyl) 
tb3_grp <- tb3 %>% group_by(cyl) 
class(tb3_grp) 

## 5.3.5 집단별로 요약하기
tb %>% group_by(am) %>% summarise(mean(qsec))

## 5.3.6 집단별로 나눈 티블에 대해 함수 적용하기
tb %>% summarise(range(hp))
#Error: Column `range(hp)` must be length 1 (a summary value), not 2 
## 책과 다른 부분 3 : summarise 에 벡터가 아니라 range 를 넣은 경우 오류가 나온다고 적혀있지만 
## 최근 버전에서는 실제로 결과값이 나옴

tb %>% group_by(am) %>% do(head(., n=2))

tb %>% group_by(am) %>% do(summary(.))
#Error: Results 1, 2 must be data frames, not table
#Run `rlang::last_error()` to see where the error occurred.

tb %>% group_by(am) %>% 
  do(as.data.frame(summary(.))) %>% 
  slice(1:3)

## 5.3.7 dplyr을 활용하여 데이터 가공하기 종합
## 선별 및 가공 절차
##tb %>% select() %>% filter() %>% group_by() %>%
##summarise(), do(), arrange(, .by_group=T)


## 5.4   dplyr의 기타 편의 기능
## 5.4.1  _all
library(dplyr)
mtcars %>% mutate(exp(qsec)) %>% head(3)

mtcars %>% 
  mutate(expMpg=exp(mpg), expCyl=exp(cyl), expDisp=exp(disp), 
         expHp=exp(hp), expDrat=exp(drat), expWt=exp(wt), 
         expQsec=exp(qsec), expVs=exp(vs), expAm=exp(am), 
         expGear=exp(gear), expCarb=exp(carb)) %>% 
  head(n=3)

mtcars %>% mutate_all(exp) %>% head(n=3) 

##5.4.2  _at과 _if
##                  _all         _at      _if
## select       select_all  select_at   select_if
## mutate       mutate_all  mutate_at   mutate_if
## transmute    transmute_all transmute_at  transmute_if
## group_by     group_by_all  group_by_at group_by_if
## summarise    summarise_all summarise_at summarise_if 

options(digits=4)

colnm = c('cyl', 'disp', 'drat', 'carb') 
mtcars %>% mutate_at(colnm, exp) %>% head(n=3) 

mtcars %>% 
  select(starts_with('c'), starts_with('d')) %>% 
  mutate_all(exp) %>% 
  head(n=3)

mtcars %>% 
  mutate_at(vars(starts_with('c'), starts_with('d')), 
            exp) %>% 
  head(n=3)

mtcars %>% 
  mutate_if(function(x) { sum(x)<100 }, exp ) %>% 
  head(n=3)

mtcars %>% 
  transmute(expCarb = exp(carb)) %>% head(n=3) 

mtcars %>% transmute_if(function(x) sum(x)<100, exp) %>% head(n=3)

mtcars %>% transmute_if(funs(sum(.) <100), exp) %>% head(n=3)
##`funs()` is deprecated as of dplyr 0.8.0

mtcars %>% 
  mutate_if(funs(sum(.) >= 100), 
            funs(paste(.,"+",sep=""))) %>% head(n=3)

mtcars %>% transmute_at(vars(starts_with('d')), exp) %>% head(n=3)


