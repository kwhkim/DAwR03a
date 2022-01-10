## 부록 C. dplyr을 SQL로 번역하기

# install.packages('dplyr')
# install.packages('nycflights13')

# install.packages('sqldf')
# install.packages('RSQLite')

library(dplyr)
library(nycflights13)
library(sqldf)
library(RSQLite)

head(flights, 3)

dat <- flights
a1 <- dat %>% select(carrier, origin, dest)
a2 <- sqldf('SELECT carrier, origin, dest FROM dat')
all.equal(a1, as_tibble(a2))

(r1 <- dat %>% head(5))
r2 <- as_tibble(sqldf('SELECT * FROM dat LIMIT 5'))
all.equal(r1,r2)
# [1] "Component “time_hour”: 'tzone' attributes are inconsistent ('America/New_York' and '')"

r1$time_hour  # timezone EST
r2$time_hour  # timezone KST

(r1 <- dat %>% select(carrier) %>% filter(!duplicated(carrier)))
r2 <- as_tibble(sqldf('SELECT DISTINCT carrier FROM dat'))
all.equal(r1, r2)

## C.2 dbplyr 패키지를 사용한 자동 번역

con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
flights <- copy_to(con, nycflights13::flights)
airports <- copy_to(con, nycflights13::airports)
flights %>%
  select(contains("delay")) %>%
  show_query()

DBI::dbGetQuery(con,
                'SELECT `dep_delay`, `arr_delay` FROM `nycflights13::flights`') %>%
  head(3)


dbFilename <- "flights.db"
if (file.exists(dbFilename)) file.remove(dbFilename)
con2 <- DBI::dbConnect(drv=SQLite(), dbname=dbFilename)
dbListTables(con2)
data(flights)
dbWriteTable(con2, "flights", flights)
dbListTables(con2)
dbDisconnect(con2)


con2 <- DBI::dbConnect(drv=SQLite(), dbname=dbFilename)
DBI::dbGetQuery(con2, 'SELECT `dep_delay`, `arr_delay` FROM flights') %>% head(3)
dbDisconnect(con2)


## <관련 데이터 파일 등 정리>
# ## 필요한 데이터 파일
# 
# ## 외부 URL
# 
# ## 생성되는 데이터 파일
# flights.db

