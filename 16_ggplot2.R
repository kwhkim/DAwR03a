install.packages('ggplot2')
install.packages('dplyr')

library(ggplot2)
library(dplyr)

## 16 ggplot2

## 16.1 들어가기

## 16.2 시각적 맵핑


data(mpg, package='ggplot2')


ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_point()


# ggplot(data= , aes(x=  , y=   , col=  , size=  , shape=   )) +
#   geom_point()


# ggplot(data, aes(x=  , y=   , col=  , size=  , shape=   )) +
#   geom_point() +
#   geom_line()


# ggplot(data, aes(x=  , y=   , col=  , size=  , shape=   )) +
#   geom_point() +
#   geom_line() +
#   geom_smooth(method='lm/glm/gam/loess/MASS::rlm', span=  , formula=  )

# 자동차 연비(1999-2008)
ggplot(mpg, aes(x = class, y = cty)) + geom_point()
ggplot(mpg, aes(x = class, y = cty)) + geom_jitter(width = 0.2, height = 0.5)
ggplot(mpg, aes(x = class, y = cty)) + geom_boxplot()
ggplot(mpg, aes(x = class, y = cty)) + geom_violin()

ggplot(data = mpg, aes(x = cty)) + geom_histogram(bins = 30)
ggplot(data = mpg, aes(x = cty)) + geom_freqpoly(bins = 30)

ggplot(data = mpg, aes(x = cty)) + geom_histogram(binwidth = 5)
ggplot(data = mpg, aes(x = cty)) + geom_freqpoly(binwidth = 5)

ggplot(data = mpg, aes(x=cty)) +
  geom_histogram(breaks = c(0, 5, 10, 15:25, 45))
ggplot(data = mpg, aes(x=cty)) +
  geom_freqpoly(breaks = c(0, 5, 10, 15:25, 45))

ggplot(data=mpg, aes(x=class)) + geom_bar(col='blue', fill='red')
#ggplot(data=mpg, aes(x=class)) + geom_bar(aes(col='blue', fill='red'))라고
#쓰지 않도록 조심하자.
#aes는 자료와 시각적 특성을 대응시키고,
#aes없이 col= 또는 fill=을 쓰면 데이터에 상관없이 색깔과 채움색을 정하는 것이다.

data(mpg, package = "ggplot2")
dat <- table(mpg$class)
df <- as.data.frame(dat)
colnames(df) = c("name", "n")
print(head(df, 3))
ggplot(df, aes(x = name, y = n)) + geom_bar(stat = "identity")
ggplot(df, aes(x = name, y = n)) + geom_col()

g <- ggplot(mpg, aes(x = fl, fill= fl)) + geom_bar()
g
g + scale_fill_manual(
  values = c("orange", "skyblue", "royalblue", "blue", "navy"))
g + scale_fill_manual(
  values = c("orange", "skyblue", "royalblue", "blue", "navy"),
  breaks = c("e", "p"))
g + scale_fill_manual(
  values = c("orange", "skyblue", "royalblue", "blue", "navy"),
  breaks = c('e', 'p'),
  labels = c("Ethanol", "Premium"))
g + scale_fill_manual(
  values = c("orange", "skyblue", "royalblue", "blue", "navy"),
  breaks = c('e', 'p'),
  labels = c("Ethanol", "Premium"),
  name = "fuel type")
g + scale_fill_manual(
  values = c("orange", "skyblue", "royalblue", "blue", "navy"),
  limits = c('e', 'p'),
  breaks = c('e', 'p'),
  labels = c("Ethanol", "Premium"),
  name = "fuel type")

require(dplyr)
mpg$yr = as.Date(as.character(mpg$year), "%Y")
mpg2 <- mpg %>%
  filter(manufacturer %in% c("audi", "dodge", "ford", "jeep"))
ggplot(mpg2, aes(x = yr, y = displ, col = manufacturer)) + geom_jitter() +
  scale_x_date(date_labels = "%Y")
ggplot(mpg2, aes(x = yr, y = displ, col = manufacturer)) + geom_jitter() +
  scale_x_date(date_labels = "%y-%m")
ggplot(mpg2, aes(x = yr, y = displ, col = manufacturer)) + geom_jitter() +
  scale_x_date(date_labels = "%y", date_breaks = "1 year")
ggplot(mpg2, aes(x = yr, y = displ, col = manufacturer)) + geom_jitter() +
  scale_x_date(date_labels = "%y", date_breaks = "2 years")

g <- ggplot(mpg, aes(x=displ, y=hwy, col=drv)) +
  geom_jitter()
g
g + scale_color_manual(values=c('red','orange', 'blue','navy'))
g + scale_color_grey(start=0.2, end=0.8, na.value='red')
g + scale_color_brewer(palette = "Dark2")

RColorBrewer::display.brewer.all()

require(colorspace)
pal <- choose_palette()

g + scale_color_manual(values = pal(3))
if (file.exists("palette.RData")) {
  load(file = "palette.RData")
} else {
  pal <- choose_palette()
  save(pal, file = "palette.RData")
}

library(colorspace)
g + scale_color_discrete_qualitative(palette='Dark3')
g + scale_color_discrete_diverging(palette='Berlin')

hcl_palettes(plot = TRUE)

h <- ggplot(mpg, aes(x = displ, y = hwy)) + geom_jitter(alpha = 0.5)
h
h + scale_x_reverse()
h + scale_x_sqrt()
h + scale_y_log10(breaks = seq(10, 50, 10), limits = c(20, 40), 
                  labels = c("ten","twenty", "thirty", "fourty", "fifty"), 
                  name = "highway(miles/gallon)")

t <- ggplot(mpg, aes(cty, hwy)) + geom_point()
t
t + facet_grid(. ~ drv)
t + facet_grid(drv ~ .)
t + facet_grid(year ~ drv)
t + facet_grid(. ~ drv + year)
t + facet_grid(drv + year ~ .)
t + facet_wrap(~drv)
t + facet_wrap(~drv + year)

t + facet_grid(drv ~ year, scales = "free")
t + facet_grid(drv ~ year, scales = "free_x")
t + facet_grid(drv ~ year, scales = "free_y")

t
t + facet_grid(drv ~ ., labeller = label_both)
t + facet_grid(drv ~ ., labeller = label_bquote(alpha^.(drv)))

mpg4 <- mpg %>% 
  filter(manufacturer %in%
           c('audi', 'dodge', 'ford', 'honda', 'hyundai', 'jeep', 'toyota'))

g <- ggplot(mpg4, aes(x=displ, y=hwy, shape=manufacturer)) +
  geom_jitter()
g
g + scale_shape_manual(values=c(1,2,3,4,15,16,17))
g + scale_shape_manual(values=c(1,2,3,4,15,16,17),
                       breaks=c('audi', 'dodge', 'ford'))
g + scale_shape_manual(limits=c('audi','dodge','ford'),
                       values=c(1,2,3),
                       breaks=c('audi', 'dodge', 'ford'))

c <- ggplot(mpg, aes(x = hwy))
c + geom_histogram(binwidth = 5)
c + geom_area(stat = "bin")
c + geom_density(kernel = "gaussian")
c + geom_dotplot(binwidth = 0.6)
c + geom_freqpoly()
ggplot(mpg) + geom_qq(aes(sample = hwy))

require(forcats)
d <- ggplot(mpg, aes(class))
d + geom_bar()
# 빈도 순으로 범주 정렬
mpg %>%
  ggplot(aes(fct_infreq(class))) +
  geom_bar()

e <- ggplot(mpg, aes(cty, hwy))
e + geom_point()
e + geom_jitter(height = 2, width = 2)
e + geom_rug(sides = "bl")

e + geom_label(aes(label = cty), nudge_x = 1, nudge_y = 1)
e + geom_text(aes(label = cty),
              nudge_x = 1, nudge_y = 1, check_overlap = TRUE)

e + geom_smooth(method = lm)
e + geom_quantile(quantiles=c(0.1, 0.9))

e1 <- e + geom_jitter(height=2, width=2, alpha=0.5, size=2) +
  geom_quantile(quantiles=c(0.05, 0.95)) +
  geom_rug(sides = 'tr') # top, bottom, left, right
e1 + geom_smooth(method='lm', size=2);
e1 + geom_smooth(method='lm', size=2, se=FALSE); # 신뢰구간 없음

## 16.3.4 2변수: x= 이산형, y=연속형
f <- ggplot(mpg, aes(class, hwy))
f + geom_col()
f + geom_boxplot(alpha = 0.5)
f + geom_dotplot(binaxis = "y", stackdir = "center")
f + geom_dotplot(binaxis = "y", stackdir = "center", binwidth = 0.7)
f + geom_violin(scale = "area")

f <- ggplot(mpg, aes(class, hwy)) + geom_boxplot(alpha=0.5)
f + geom_dotplot(binaxis="y", stackdir="center", binwidth=1, alpha=0.5)
f + geom_jitter(alpha=0.5, width=0.1, height=0.1)

## 16.3.5 2 변수 : 𝑥=이산형, 𝑦=이산형
g <- ggplot(diamonds, aes(cut, color))
g + geom_count()
g + geom_jitter()

g <- ggplot(diamonds, aes(cut, color))
g + geom_jitter(alpha = 0.02)
g + geom_jitter(shape = ".")

## 16.3.6    이변수 분포
h <- ggplot(diamonds, aes(carat, price))
h + geom_bin2d(binwidth = c(0.25, 500))
h + geom_density2d()
h + geom_hex()
h + geom_point(alpha=0.2) +
  stat_ellipse(level=0.95, col="red") +
  stat_ellipse(level=0.01, col="red", size=3)

ggplot(diamonds, aes(carat, color)) + geom_bin2d()
ggplot(diamonds, aes(cut, color)) + geom_bin2d()

## 16.3.7     지도
data <- data.frame(murder = USArrests$Murder,
                   state = tolower(rownames(USArrests)))
map <- map_data("state")
k <- ggplot(data, aes(fill = murder))
k + geom_map(aes(map_id = state), map = map) +
  expand_limits(x = map$long, y = map$lat)

## 16.4        보조선
ggplot(mpg, aes(x = cyl, y = cty)) + geom_jitter(aes(col=drv)) +
  geom_hline(yintercept=c(10, 20, 30), linetype='dotted')
ggplot(mpg, aes(x = cyl, y = cty)) +
  geom_rect(xmin=-Inf, xmax=Inf, ymin=15, ymax=25, fill='lightgray') +
  geom_jitter(aes(col=drv))

imax <- which.max(mpg$cty)
ax <- mpg$hwy[imax]; ay <- mpg$cty[imax]
ggplot(mpg, aes(x=hwy, y=cty)) + geom_jitter(aes(col=drv)) +
  geom_segment(x=ax-5 , y=ay, xend=ax-0.5, yend=ay,
               arrow = arrow(length = unit(5, "mm")))


## 16.5.2 좌표계(Coordinate System) 결정하기
r <- ggplot(mpg, aes(x = fl)) + geom_bar()
r + coord_cartesian(xlim = c(-1, 5)) # 첫번째 범주 'c'(x=1)
r + coord_fixed(ratio = 1/10)
r + coord_flip()
r + coord_polar(theta = "x", direction = 1)
r + coord_trans(y = "sqrt")

## 16.5.3 좌표 레이블(Coordinate label)
r
r + labs(x = "fuel type", y = "frequency")

## 16.5.4 좌표 눈금과 눈금 레이블(Breaks and Labels)
(n <- d + geom_bar(aes(fill = fl)))
n + scale_fill_manual(
  values = c("skyblue", "royalblue", "blue", "navy"),
  limits = c("d", "e", "p", "r"), breaks =c("d", "e", "p", "r"),
  name = "fuel", labels = c("D", "E", "P", "R"))
n + scale_fill_discrete(
  #palette = "Blues",
  breaks =c("d", "p"),
  labels = c("D", "E")) +
  guides(fill='none')
t <- ggplot(mpg, aes(cty, hwy)) + geom_point()
t + scale_x_continuous(
  breaks=seq(10,40,10),
  labels=c('ten', 'twenty', 'thirty', 'forty'))

## 16.5.5 확대(Zooming)
t <- ggplot(mpg, aes(displ, hwy)) + geom_point() + geom_smooth(method='lm')
t

t + coord_cartesian(xlim = c(1.5, 2), ylim = c(20, 50))

t + xlim(1.5, 2) + ylim(20, 50)
t + 
  scale_x_continuous(limits = c(1.5, 2)) +
  scale_y_continuous(limits = c(20, 50))

## 16.6 범례(Legends)
t <- ggplot(mpg, aes(x = displ, y = cty, color = cyl)) + geom_point()
t + scale_x_continuous(name = "city miles per gallon")
t + labs(color = "number of cylinders")
t + theme(legend.position = "bottom") # top, bottom, left, right
t + guides(color = "none")
t + guides(color = "colorbar")
t + guides(color = "legend")
t + scale_color_continuous(labels = c("two", "three", "four", "five", "six"))

## 16.7 제목과 테마(Title and Theme)
## 16.7.2 제목, 부제목, 설명문
t <- ggplot(mpg, aes(cty, hwy, color=cyl)) + geom_point()
t + labs(title='1. Fuel economy data')
t + labs(title='2. Fuel Economy Data',
         subtitle='from 1999 and 2008
for 38 popular models of car')
# 줄을 바꾸기 위해 '\n'을 사용할 수도 있다.
t + labs(title='3. Fuel Economy Data',
         subtitle='from 1999 and 2008\nfor 38 popular models of car',
         caption='Fig. x. This dataset contains a subset of
the fuel economy data that the EPA makes available
on http://fueleconomy.gov.')


## 16.7.3 테마(Themes)
t <- ggplot(mpg, aes(cty, hwy, color=cyl)) + geom_point()
t2 <- t + labs(subtitle='from 1999 and 2008
for 38 popular models of car',
               caption='Fig. x. This dataset contains a subset of
the fuel economy data that the EPA makes available
on http://fueleconomy.gov.')
t2 + theme_bw()
t2 + theme_gray()
t2 + theme_dark()
t2 + theme_classic()
t2 + theme_light()
t2 + theme_linedraw()
t2 + theme_minimal()
t2 + theme_void()

##  16.7.4 텍스트의 정렬, 줄간격, 서체 조정
t2 <- ggplot(mpg, aes(cty, hwy, color=cyl)) + geom_point() +
  labs(caption='Fig. x. This dataset contains a subset of
the fuel economy data that the EPA makes available
on http://fueleconomy.gov.')
t2 + theme(plot.caption = element_text(hjust = 0))
t2 + theme(plot.caption = element_text(hjust = 0.5))
t2 + theme(plot.caption = element_text(hjust = 1))
t2 + theme(plot.caption = element_text(angle = 0))
t2 + theme(plot.caption = element_text(angle = 10))
t2 + theme(plot.caption = element_text(lineheight=.8, face='bold'))
t2 + theme(axis.text.x = element_text(angle = 45))
t2 + theme(axis.text.x = element_text(angle = 90))

## 16.7.5 텍스트에 수학기호 등 입력하기
library(latex2exp)
t <- ggplot(mpg, aes(cty, hwy, color=cyl)) + geom_point()
# 그리스 문자 알파는 "\u03b1", "$\\alpha$", 또는 r"($\alpha$)"로 쓸 수 있다
t +labs(x = "\u03b2 has been adjusted") #\u03b2 = Greek small letter beta
t +labs(color = TeX("$\\alpha$-level ($\\beta\\,=\\,1$)"))
t +labs(caption = TeX(r"($\alpha(\beta\,=\,1)$ has been adjusted)"))

t +annotate('text', x=20, y=20, # 위치
            label=TeX(r'($\int_{0}^{1} \sin(x) dx$)'),
            hjust = 0 # 정렬 방법
)

## 16.8 결과 정리 및 저장
p1 <- ggplot(mtcars, aes(x = mpg, y = wt, col = factor(vs))) + geom_point()
p2 <- ggplot(mtcars, aes(x = factor(vs), fill = factor(am))) + geom_bar()
p3 <- ggplot(mtcars, aes(x = wt, y = qsec, col = factor(gear))) + geom_line()
p4 <- ggplot(mtcars, aes(x = disp, y = drat)) + geom_point(col = "red") +
  theme_minimal()
gridExtra::grid.arrange(p1, p2, p3, p4, ncol = 2)

cowplot::plot_grid(p1, p2, labels = c("A", "B"), align = "h")

## 16.8.2 시각화 결과 저장
p <- mtcars %>%
  transmute(cyl = factor(cyl), gear = factor(gear)) %>%
  ggplot(aes(x = cyl, fill = gear)) + geom_bar()

mtcars %>%
  transmute(cyl = factor(cyl), hp = hp, am = factor(am)) %>%
  ggplot(aes(x = cyl, y = hp, fill = am)) + geom_boxplot()

ggsave(filename = "picRecent.png")
ggsave(filename = "picp.jpg", plot = p)

## 16.9.2 몇 가지 팁
p +
  theme(
    axis.text.x = element_text(
      angle = 90, vjust = 0.5, hjust=1))

x_label_vertical = function() {
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
}
p + x_label_vertical()

legend_alpha1 = function() {
  guides(colour = guide_legend(override.aes = list(alpha = 1)))
}
ggplot(mtcars, aes(x=mpg, y=hp, col=factor(cyl))) + 
  geom_point(alpha=0.3) + legend_alpha1()
ggplot(mtcars, aes(x=mpg, y=hp, col=factor(cyl))) + 
  geom_point(alpha=0.3) # 범례의 색 비교

library(gghighlight)
ggplot(mpg, aes(cty, hwy, color=drv)) +
  geom_point() +
  facet_wrap(~ drv) +
  gghighlight()

## <관련 데이터 파일 등 정리>
# ## 필요한 데이터 파일
# 테스트.png
# 
# ## 외부 URL
# 
# ## 생성되는 데이터 파일
# picRecent.png
# picp.jpg


