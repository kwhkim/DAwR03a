## 제 14장. 기술 통계량

Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}


set.seed(0); x <- rnorm(10); x
mean(x)
median(x)
Mode(x) # table을 통해 빈도수를 확인할 수 있다. 
mean(x, trim = 0.2)


max(x)-min(x)
IQR(x)
var(x)
sd(x)


gini = function(x, ...) { #useNA = 'always', 'no', 'ifany'
  1-sum(prop.table(table(x, ...))^2)
}
print(x); gini(x)

x = c(1,3,2,2,4,NA,5,NA)
gini(x)
gini(x, useNA = 'no')
gini(x, useNA = 'ifany')
gini(x, useNA = 'always')

data(mpg, package='ggplot2'); require(dplyr)
table(x)
prop.table(table(x))

mpg$drv <- ordered(mpg$drv, levels=c("f", "r", "4"))
mpg$fl <- factor(mpg$fl)
mpg2 <- mpg %>% select(class, drv, fl, hwy)
summary(mpg2)


mpg2[c(1,4,5,16),1] = NA
mpg2[c(1,4,5,16),2] = NA
prettyR::freq(mpg2)

Hmisc::describe(mpg2)

pastecs::stat.desc(mpg2)


## 그 밖에

# install.packages('skimr')
skimr::skim(mpg2)
# install.packages('DataExplorer')
DataExplorer::create_report(mpg2)

## <관련 데이터 파일 등 정리>
# ## 필요한 데이터 파일
# 
# ## 외부 URL
# 
# ## 생성되는 데이터 파일
# report.html (DataExplorer::create_report(mpg2))
# 



