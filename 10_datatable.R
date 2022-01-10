# 제 10장. 패키지 데이터테이블(data.table)
# 10.1 package:dplyr과 package:data.table의 비교

library(dplyr)
library(data.table)

# data.table의 fwrite와 R의 base 함수 write.csv의 비교
mat <- data.frame(matrix(rnorm(1000000),100000,10))
write.csv(mat, file='dat.csv')
fwrite(mat, file='dat.csv')

# dplyr 과 data.table 주요 작업 흐름 비교
# select %>% slice %>% filter %>% group_by %>% summarise %>%> arrange
# DT[filter(i),summarise(j), by='  '][order( )]

# 10.1.2 데이터

data(mtcars)
df <- mtcars
TB <- as_tibble(mtcars, rownames='rn')
# rownames='rn'으로 하면 행이름을 열 rn으로 보존한다.
DT <- as.data.table(mtcars, keep.rownames=TRUE) 
class(DT)
# keep.rownames = TRUE 로 놓으면 행이름이 열 rn으로 보존된다.
# 데이터테이블과 티블은 행이름(rownames)를 지원하지 않는다.

print(head(TB))
print(head(DT))

# 10.1.3 slice

# 한 행 선택
TB %>% slice(3)
DT[3, ]
DT[3]  
mtcars[3]  # 비교

# 여러 행 선택
TB %>% slice(c(3,5))
DT[c(3,5),]
DT[c(3,5)]

# 변수로 여러 행 선택
rows <- c(1,5,6)
TB %>% slice(rows)
#col = c('disp', 'hp')
TB %>% select(disp)
DT[rows,]
DT[rows]

# DT %>% select(disp)

# 10.1.4 filter

# 조건으로 행 선택
# cyl==4(실린더가 4개)이고 gear==5 인 행
mtcars[mtcars$cyl==4 & mtcars$gear==5,]
TB %>% filter(cyl==4 & gear==5)
DT[cyl==4 & gear==5,]
DT[cyl==4 & gear==5]

# 조건으로 행 선택 : 변수 사용
coln <- c("cyl", "gear")
conds <- c("==4", "==5")
cond <- parse(text=paste0(coln, conds, collapse=" & "))

mtcars[with(mtcars, eval(cond)),]
TB %>% filter(eval(cond))
DT[eval(cond),]
DT[eval(cond)]
DT[get(coln[1])==4 & get(coln[2])==5]

# 데이터 : 축소형
DF2 <- mtcars[2:3,]; # 데이터프레임(data.frame)
TB2 <- as_tibble(TB) %>% slice(2:3) # 티블(tibble)
DT2 <- DT[2:3,] # 데이터테이블(data.table)

# 10.1.5 select

# 열 선택 : 순번으로 
DF2[,c(3,5)]
TB2 %>% select(c(3,5))
DT2[, c(3,5)]

# 열 선택 : 이름으로
DF2[,c("cyl", "hp")]
TB2 %>% select(c(cyl, hp))
DT2[, .(cyl, hp)]
DT2[, list(hp)]
DT2
DT2[, plot(wt, hp)]
DT2[, c("cyl", "hp")]

# 열 선택 : 변수(순번)로
icols = c(3,5)
DF2[, icols]
TB2 %>% select(icols)
DT2[, ..icols]

# 열 선택 : 변수(열이름) 사용
nacols = c('cyl', 'hp')
DF2[, nacols]
TB2 %>% select_at(nacols)
TB2 %>% select(nacols)
DT2[, ..nacols]


## 순번으로 선택
DT2[, 3] #데이터테이블
DT2[ ,3][[1]] #벡터

## 이름으로 선택
DT2[, .(cyl)] #데이터테이블
DT2[, cyl] # 벡터

## 변수로 순번 선택
irows = c(3)
DT2[, ..irows] #데이터테이블
DT2[, ..irows][[1]] #벡터

## 변수로 열이름 선택
nrows = c('cyl')
DT2[, ..nrows] # 데이터테이블
DT2[, ..nrows][[1]] #벡터

# 열 제외 : 변수 사용
colnm = c('cyl', 'disp') # 열이름 변수로 열 제외
DT2[, !..coln]
colnm2 = colnames(DT2)[!colnames(DT2) %in% colnm]
DT2[, .SD, .SDcols=colnm2]

## 10.1.6 mutate

# 데이터 
DF3 <- DF2[ , c("hp", "qsec")]
TB3 <- TB2 %>% select(hp, qsec)
DT3 <- DT2[, .(hp, qsec)]

DF3[ ,"wt2"] = DF3$hp * DF3$qsec
DF3$wt2 = DF3$hp * DF3$qsec
DF3[["wt2"]] = DF3$hp * DF3$qsec
TB3 %>% mutate(wt2 = hp*qsec)
DT3[, wt2:=hp*qsec]; 
print(DT3)

DF3[ ,c("hp", "qsec")] = data.frame(DF3$hp*2, DF3$qsec*2)
TB3 <- TB3 %>% mutate(hp = hp*2, qsec = qsec*2)
DT3[, c("hp", "qsec") := list(hp*2, qsec*2)]
DT3[, `:=`(hp = hp*2,
           qsec = qsec*2)]
print(DT3)
# 개인적으로
# 위의 방법은 데이터 테이블에서 가장 괴상하고, 기억하기 힘든 문법이라고 생각한다.
# 하지만 다음과 같이 사용하면 된다.
DT3[, hp:=hp/2]
DT3[, qsec:=qsec/2]
print(DT3)

# 새로운 열 생성
coln = 'wt2'
DF3[ ,coln] = DF3$hp * DF3$qsec
DF3[[coln]] = DF3$hp * DF3$qsec
TB3 = TB3 %>% mutate(UQ(rlang::sym(coln)) :=  hp*qsec)
DT3[, `:=`(c(coln), hp*qsec)]

coln = c('hp', 'qsec')
DF3[, coln] = lapply(DF3[, coln], function(x) x*2)
DF3[, coln] = do.call(data.frame, lapply(DF3[, coln], function(x) x*2))
#TB3 <- TB3 %>% mutate_at(coln, funs(.*2))
TB3 <- TB3 %>% mutate_at(coln, ~.*2)
DT3[, `:=`(c(coln), lapply(.SD, function(x) x*2)), .SDcols=coln]
print(DT3)

## 10.1.7 transmute

# 데이터
DF4 = data.frame(wt2 = DF3$hp * DF3$qsec)
TB4 <- TB3 %>% transmute(wt2 = hp*qsec)
DT4 <- DT3[, .(wt3=hp*qsec)]; print(DT4)

# 열 수정
DF4 = data.frame(hp2 = DF3$hp*2, qsec2 = DF3$qsec*2)
DF4 = with(DF3, data.frame(hp2 = hp*2, qsec2 = qsec*2))
TB4 <- TB3 %>% transmute(hp = hp*2, qsec = qsec*2)
TB4 <- TB3 %>% transmute_at(c('hp', 'qsec'), funs(.*2))
DT4 <- DT3[, .(hp2=hp*2, qsec2=qsec*2)]
DT4 <- DT3[, lapply(.SD, function(x) x*2), .SDcols=c('hp', 'qsec')]
print(DT4)

coln = 'wt2'
DF4 = data.frame(DF3$hp * DF3$qsec); colnames(DF4) = coln
TB4 <- TB3 %>% transmute(hp*qsec); colnames(TB4) = coln
DT4 <- DT3[, .(hp*qsec)]; colnames(DT4) = coln
print(DT4)


coln = c('hp', 'qsec')
DF4 <- do.call(data.frame, lapply(DF3[,coln], function(x) x*2))
TB4 <- TB3 %>% transmute_at(coln, funs(.*2))
TB4 <- TB3 %>% transmute_at(coln, ~ . * 2)
DT4 <- DT3[, lapply(.SD, function(x) x*2), .SDcols=coln]
print(DT4)

## funs() was deprecated -> 
TB4 <- TB3 %>% transmute_at(coln, list(~.*2))


# 10.1.8. arrange
DF5 <- mtcars[c(2:5), 1:4]
TB5 <- as_tibble(mtcars) %>% slice(2:5) %>% select(1:4)
DT5 <- as.data.table(mtcars, keep.rownames=TRUE)[2:5, c(1:4)]
print(DT5)


DF5[order(DF5$cyl, -DF5$mpg),]
TB5 %>% arrange(cyl, desc(mpg))
DT5[order(cyl, -mpg),]; DT5[order(cyl, -mpg)]

# 10.1.9. group_by

DF6 <- mtcars[c(10:2), c("mpg", "cyl", "disp","hp", "am")]
TB6 <- TB %>% slice(10:2) %>% select(mpg, cyl, disp, hp, am)
DT6 <- DT[10:2, .(mpg, cyl, disp, hp, am)]
print(head(DT6))

# groupby -> summarise
aggregate(mpg ~ cyl, data=DF6, FUN=mean)
TB6 %>% group_by(cyl) %>% summarise(mpg=mean(mpg))
DT6[, mean(mpg), by='cyl'] # cyl는 정렬되지 않는다.
DT6
DT6[, .(mpg=mean(mpg), hp = sd(hp)), by=cyl] # cyl는 정렬되지 않는다.
DT6[, mean(mpg), keyby=cyl] # cyl는 정렬된다.

# 여러 열 : groupby -> summarise
aggregate(cbind(mpg, hp) ~ cyl, data=DF6, FUN=mean)
#aggregate(. -hp ~ cyl, data=DF6, FUN=mean)
TB6 %>% group_by(cyl) %>% summarise(mpg=mean(mpg), hp=mean(hp))
DT6[, .(mpg = mean(mpg), hp = mean(hp)), by=cyl] # data.table, cyl is not sorted
DT6[, .(mpg = mean(mpg), hp = mean(hp)), keyby=cyl] # data.table, cyl is sorted


aggregate(cbind(mpg, hp) ~ am + cyl, data=DF6, FUN=mean)
TB6 %>% group_by(cyl, am) %>% summarise(mpg=mean(mpg), hp=mean(hp))
DT6[, .(mpg = mean(mpg), hp = mean(hp)), by=.(cyl, am)]
DT6[, .(mpg = mean(mpg), hp = mean(hp)), keyby=.(cyl, am)]
DT6[, .(mpg = range(mpg), hp = range(hp)), keyby=.(cyl, am)]

# 모든 열 수정
aggregate(. ~ am + cyl, data=DF6, FUN=mean)
#aggregate(. - hp ~ am + cyl, data=DF6, FUN=mean)
#Error in eval(predvars, data, env) : object '.' not found
TB6 %>% group_by(cyl, am) %>% summarise_all(mean)
DT6[, lapply(.SD, mean), by=.(cyl, am)] # cyl, am에 대해 정렬되지 않음
DT6[, lapply(.SD, mean), keyby=.(cyl, am)] # cyl, am에 대해 정렬

# 집단별로 일반적인 함수 적용
res <- do.call(rbind, by(DF6, list(DF6$cyl), FUN=head, n=2)) # data.frame

# rbind(df1, df2, df3, df4)
# rbind(rbind(rbind(df1, df2), df3), df4)

# data.table::rbindlist
res <- rbindlist(by(DF6, list(DF6$cyl), FUN=head, n=2))
# do 안의 .은 %>% 이전의 결과(TB6 %>% group_by(cyl))
TB6 %>% group_by(cyl) %>% do(head(., n=2))
DT6[, head(.SD, n=2), by=cyl] # data.table
DT6[, head(.SD, n=2), keyby=cyl] # data.table

# 집단별 함수 적용 후 정렬
DF6 <- aggregate(cbind(mpg, hp) ~ am + cyl, data=DF6, FUN=mean);
DF6[order(DF6$mpg),]
TB6 %>% group_by(cyl, am) %>% summarise(mpg=mean(mpg), hp=mean(hp)) %>%
  arrange(mpg)
DT6[, .(mpg = mean(mpg), hp = mean(hp)), by=.(cyl, am)][order(mpg)]
DT6[, .(mpg = mean(mpg), hp = mean(hp)), keyby=.(cyl, am)][order(mpg)]

# 그 외의 여러 가지 데이터테이블 사용법
example(data.table)

# 데이터 
mtcars[mtcars$am ==0, ] %>% head

DF7 <- mtcars[c(2:10), c(1,8:10)]
TB7 <- as_tibble(mtcars, rownames='rn') %>%
  slice(2:10) %>%
  select(c(1, 8:10))
DT7 <- as.data.table(mtcars, keep.rownames=TRUE)[2:10, c(1, 8:10)]
DT7[, amch:=ifelse(am==1, "Automatic", "Manual")]
DT7[, vsch:=ifelse(vs==0, "V-shaped", "straight")]
print(head(TB7))
print(head(DT7))

## 10.2 data.table의 키(key) 활용법
key(DT7)                # key 확인
setkey(DT7, qsec)       # key 설정하기
haskey(DT7)             # key를 설정했는가?
key(DT7)                # key 확인
DT7[qsec>0,]
tables()

DT8 <- DT7
setkey(DT8, am, vsch)
key(DT8)
coln <- c("am", "vsch")
setkeyv(DT8, coln)
key(DT8)
tables()

## 10.2.2 J: 키를 활용한 행 선택
key(DT8)   # am, vsch
DT8[J(1),] # am == 1
DT8[am == 1,]
DT8[amch == "Automatic",]

DT8[J(1,"straight"),]
DT8[am == 1 & vsch == "straight",]

DT8[am == 0, ]
DT8[J(0),]

# 10.2.3 mult= : 여러 행이 선택되는 경우
DT8[J(1), mult='first']
DT8[J(1), mult='last']
DT8[J(1), mult='all'] # DT8[J(1)]

## 10.3 data.table을 활용한 병합
## 새로운 데이터
dt1 <- data.table(
  id = c(1,NA,3,4,4,5,6,6),
  x = c('1','2','3','4a','4b','5','6a','6b')
)

dt2 <- data.table(
  id = c(NA,2,3,4,5,5,6,6),
  y = c('1','2','3','4a','5a','5b','6a','6b')
)

## 다음의 3가지 방법의 차이점을 비교해보자
dt1[dt2, on='id']
setkey(dt1, id); dt1[J(dt2$id), ]
dt1[dt2]


TBA <- as_tibble(mtcars, rownames='rn') %>% 
  slice(3:4) %>% 
  select(1:4)
TBB <- as_tibble(mtcars, rownames='rn') %>% 
  slice(4:5) %>% 
  select(1, 8:10)

DTA <- as.data.table(mtcars, keep.rownames=TRUE)[3:4, c(1:4)]
DTB <- as.data.table(mtcars, keep.rownames=TRUE)[4:5, c(1, 8:10)]

print(DTA)
print(DTB)

## 10.3.3 DT[DT2, on= ] : 병합 1

inner_join(TBA, TBB, by='rn')
DTA[DTB, on='rn', nomatch=0]
DTA[DTB, on='rn']
# DTA, DTB

merge(DTA, DTB, by='rn', all=FALSE) # merge.data.table
methods(merge)


full_join(TBA, TBB, by='rn')
merge(DTA, DTB, by='rn', all=TRUE)


left_join(TBA, TBB, by='rn')
DTB[DTA, on='rn']
#merge에서 x는 첫 번째 데이터프레임, y는 두 번째 데이터프레임
merge(DTA, DTB, by='rn', all.x=TRUE)

right_join(TBA, TBB, by='rn')
DTA[DTB, on='rn']
merge(DTA, DTB, by='rn', all.y=TRUE)

semi_join(TBA, TBB, by='rn')
DTA[DTB, .SD, on='rn']
colnames(DTA[DTB, .SD, on='rn'])
colnames(DTA[DTB, on='rn'])
colnames(DTB)


anti_join(TBA, TBB, by='rn')
DTA[!DTB, .SD, on='rn']

DF <- data.frame(rn=rownames(mtcars), mtcars)

TBA <- as_tibble(DF) %>% slice(3:4) %>% select(1:4)
TBB <- as_tibble(DF) %>% slice(4:7) %>% select(1, 3, 9:10)

DTA <- as.data.table(DF)[3:4, c(1:4)]
DTB <- as.data.table(DF)[4:7, c(1, 3, 9:10)]

print(DTA)
print(DTB)

merge(DTA, DTB, all=TRUE)
inner_join(TBA, TBB, by='cyl')
DTA[DTB, on='cyl', nomatch=0]
DTB[DTA, on='cyl', nomatch=0, mult='first']
DTB[DTA, on='cyl', nomatch=0, mult='last']
DTB[DTA, on='cyl', nomatch=0, mult='all']

DTC = merge(DTA, DTB, by='cyl')
DTC[, .SD[1], by='cyl']
DTC[, .SD[nrow(.SD)], by='cyl']

mtcars = data.table(mtcars)
mtcarsA = mtcars[, .(gear, cyl, qsec)]
mtcarsB = mtcars[, .(gear, cyl, hp)]
merge(mtcarsA, mtcarsB, by=c('gear', 'cyl'), allow.cartesian = TRUE)

mtcarsC = merge(mtcarsA, mtcarsB, on = c('gear', 'cyl'), allow.cartesian = TRUE)
mtcarsC[, .SD[1], by=c('gear', 'cyl')]
mtcarsC[, .SD[nrow(.SD)], by=c('gear', 'cyl')]

mtcarsB[mtcarsA, on=c('gear', 'cyl'), nomatch=0, mult='first']
mtcarsB[mtcarsA, on=c('gear', 'cyl'), nomatch=0, mult='last']

## DT1[DT2] : 키를 사용한 병합

setkey(mtcarsB, 'gear', 'cyl')
setkey(mtcarsA, 'gear', 'cyl')
mtcarsB[mtcarsA, nomatch=0, mult='first']
mtcarsB[mtcarsA, nomatch=0, mult='last']

mtcarsB[mtcarsA, mult='first']
mtcarsB[mtcarsA, mult='last']

DTA[DTB, on='cyl']
DTA[DTB, on='cyl', mult='first']
DTA[DTB, on='cyl', mult='last']

full_join(TBA, TBB, by='cyl')
merge(DTA, DTB, by='cyl', all=TRUE) # merge.data.table

left_join(TBA, TBB, by='cyl')
DTB[DTA, on='cyl']

right_join(TBA, TBB, by='cyl')
DTA[DTB, on='cyl']

semi_join(TBA, TBB, by='cyl')
DTA[DTB, .SD, on='cyl']

anti_join(TBA, TBB, by='cyl')
DTA[!DTB, .SD, on='cyl']

inner_join(TBA, TBB, by='cyl')
DTA[DTB, on='cyl', nomatch = 0]

setkey(DTA, rn)
setkey(DTB, rn)
DTA[DTB]

# DT1[DT2, on='key'][, .SD[1], by='key']
# DT1[DT2, on='key', mult='first']
# 위의 둘은 항상 같지 않다!

# DT1[DT2, on='key'][, .SD[.N], by='key']
# DT1[DT2, on='key', mult='last']
# 책의 내용과 다르게 위의 둘은 항상 같지 않다!

#inner_join(TBA, TBB, by='cyl')
#inner_join(TBA, TBB, by='cyl') %>% group_by(cyl) %>% .[1,]
#inner_join(TBA, TBB, by='cyl') %>% group_by(cyl) %>% .[nrow(.),]
DTB[DTA, on='cyl', nomatch=0]
DTB[DTA, on='cyl', nomatch=0, mult='first']
DTB[DTA, on='cyl', nomatch=0, mult='last']

## 10.3.7 DT1[DT2, roll= ] : Rolling-join

DTA = data.table(
  date = as.Date(c('2018-12-31', '2019-1-4', '2019-1-9')),
  duration = c(60, 30, 40))
DTB = data.table(
  date = as.Date(c('2018-1-2', '2019-1-5', '2019-1-6')),
  product = c('Cosmetics', 'Toys', 'Books'))

print(DTA)
print(DTB)
print(head(DTA))
print(head(DTB))

DTB[DTA, on='date', roll=-Inf]
# DTB의 date가 rolling된다.

DTB[, datePurchase:=date]
DTB[DTA, on='date', roll=-Inf]

DTB[DTA, on='date', roll=Inf]
DTB[DTA, on='date', roll=3]

## 그 밖의 특수 기호 : .SD, .GRP, .N, .I, .BY, .EACHI, ..

library(dplyr)
library(data.table)
df <- data.frame(rn=rownames(mtcars), mtcars)
TB <- as_tibble(df) %>% slice(3:7) %>% select(1:4)
DT <- as.data.table(mtcars, keep.rownames=TRUE)[3:7, c(1:4)]

TB %>% group_by(cyl) %>% summarise_at(vars(mpg, disp), funs(sum(.)))
DT[, lapply(.SD, sum), by=cyl, .SDcols=c('mpg', 'cyl', 'disp')]
#DT[ , lapply(.SD, sum), by=cyl] # 컬럼 rn이 문자이기 때문에 sum을 쓸 수 없다.

# .N = nrow(.SD)
DT[, .N, by=cyl]
DT[, length(mpg), by=cyl] # 위의 결과와 동일.
DT[, nrow(.SD), by=cyl] # 위의 결과와 동일.

# .SDcols
DT[, c(.N, lapply(.SD, mean)), by=cyl, .SDcols=c('mpg', 'cyl', 'disp')]
DT[, c(list(N=.N), lapply(.SD, mean)), by=cyl, 
   .SDcols=c('mpg', 'cyl', 'disp')]

# .I 
DT[, .I, by=cyl]
DT[, .I, keyby=cyl]

DT[, .I[1], by=cyl] 
DT[, .I[1], keyby=cyl]

DT[, .GRP, by=cyl]
DT[, .GRP, keyby=cyl]

DT[, .BY, by=cyl]
DT[, lDisp := ifelse(disp<300, '<300', '>=300')]
DT[, c(.BY), by=c('cyl', 'lDisp')]
#DT[, .BY, by=c('cyl', 'lDisp')]

DT[, c(.BY), by=c('cyl', 'lDisp')]
DT[, .(cyl[1], lDisp[1]), by=c('cyl', 'lDisp')]
#DT[, .BY, by=c('cyl', 'lDisp')]

DT[, do.call(paste0, .BY), by=c('cyl', 'lDisp')]
DT[, .(grpname = do.call(paste0, .BY)), by=c('cyl', 'lDisp')]

data(mtcars)
df <- data.frame(rn=rownames(mtcars), mtcars)
TB_A <- as_tibble(df) %>% slice(3:10) %>% select(1:4, 9)
TB_B <- as_tibble(df) %>% slice(7:10) %>% select(1,3, 8:10)
DT_A <- as.data.table(mtcars, keep.rownames=TRUE)[3:10, c(1:4, 9)]
DT_B <- as.data.table(mtcars, keep.rownames=TRUE)[7:10, c(1, 3, 8:10)]

DT_A[DT_B, on='cyl']
DT_A[DT_B, sum(disp), on='cyl', by='cyl']
DT_A[DT_B, sum(disp), on='cyl', by=.EACHI]

DT_A[DT_B, .SD[1], on='cyl', by=.EACHI]
DT_A[DT_B, on='cyl', mult='first']

DT <- as.data.table(mtcars, keep.rownames=TRUE)[3:7, c(1:4)]
rn = c("Valiant", "Bolt", "Duster 360")
DT[, list(rn)]    # DT[, .(rn)]
DT[, list(..rn)]  # DT[, .(..rn)]
DT[, list(rn[rn %in% ..rn])]

# 해법 1
env <- environment()
DT[rn %in% get('rn', env)]

# 해법 2
`..` <- function (..., .env = sys.parent(2))
{
  get(deparse(substitute(...)), env = .env)
}
DT[rn %in% ..(rn)] # `..`는 위에서 정의된 함수이므로 ..rn으로 쓸 수 없다.

## <관련 데이터 파일 등 정리>
# ## 필요한 데이터 파일

# 
# ## 외부 URL
# 
# ## 생성되는 데이터 파일
# dat.csv
