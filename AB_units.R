## 부록 B. 측정단위

# unix, sudo apt-get install libudunits2-dev
# install.packages('units')
library(units)

library(dplyr)
data(mtcars)
#help(mtcars)

datUnits = valid_udunits()
datUnits %>%
  select(symbol, name_singular, definition) %>%  # 책에 오타
  head(3)

require(dplyr)
datUnits %>%
  filter_all(any_vars(grepl('(mile|gallon)', .))) %>% head

# 다음의 코드에서 `name=`에 단위의 이름을 정하고, `def=`로 정의를 적는다.
# mpg는 마일(international_mile)을 US 액량 갤론(US_liquid_gallon)으로 나눠준 단위이다.
install_unit(name = "mpg_US", def = "international_mile / US_liquid_gallon")

x = c(1,2,3)
units(x) = 'mpg_US'
print(x)

units(x) = 'km/L' # 단위 기호를 사용
print(x)

remove_unit(name = 'mpg_US') # 먼저 기존의 단위이름 'mpg_US'를 제거한다
install_unit(name = "mpg_US",
             def = "0.425144 km/L")
# 단위이름 'mpg_US'를 다시 정의한다

data(mtcars) # mtcars를 새로 읽어서 기존의 단위 정보를 제거한다.
# units(mtcars$mpg) = NULL 을 사용할 수도 있다.
units(mtcars$mpg) = 'mpg_US' # mpg의 단위를 mpg_US로 정한다.
units(mtcars$mpg) = 'km/L' # mpg의 단위를 km/L로 변환한다.
print(head(mtcars$mpg))

units(mtcars$wt) = 'klb'
#dat$wt = set_units(dat$wt, 'klb', mode='standard')
#dat$wt = set_units(dat$wt, klb)

units(mtcars$wt) = 'kg'
#dat$wt = set_units(dat$wt, 'kg', mode='standard')
#dat$mpg = set_units(dat$mpg, kg/L)

library(ggplot2)
library(ggforce) # ggplot과 units를 함께 쓰기 위해서 필수!
ggplot(data = mtcars) + geom_histogram(aes(x=wt), bins=10)
# 만약 ggforce가 없다면 Error in Ops.units(x, range[1]) 가 발생한다.

ggplot(data = mtcars) + geom_point(aes(x=wt, y=mpg))

install_unit(name = 'cubic_inch', def = 'in^3')
install_unit(name = 'qsec', def = '4 second / mile')

units(mtcars$disp) = 'cubic_inch'
units(mtcars$hp) = 'horsepower'
units(mtcars$qsec) = 'qsec'



