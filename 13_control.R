# 13장. 흐름 제어와 함수

# 13.1 제어문: 조건과 반복
# 13.1.1 조건문
s = 'here'
if (s == "here") {
  print("Seoul")
} else {
  print("Somewhere else than Seoul")
}

s2 <- ifelse(s=="here",
             "Moon", # if s=="here"
             "Somewhere else than Moon") # if s!="here"

x <- "two"
switch(x,
       one = 1,
       two = 2,
       3)

x <- "two"; z <- 3
switch(x,
       one=1,
       two={
         y <- paste(x,"is entered.")
         z + 1},
       three=z^2)


# 13.1.2 반복문
s=0
for (i in 1:10)
  s = s + i
print(s)

# while
s=0; i=1
while (i <= 10) {
  s=s+i;
  i=i+1
}
print(s)

# repeat
s=0; i=1
repeat {
  s=s+i; i=i+1
  if (i>10) break
}
print(s)


# 13.1.3 다중반복문
for (i in 1:10) {
  for (j in 1:10) {
    for (z in 1:10) {
      if (i+j+z == 15) break }
    if (i+j+z == 15) break }
  if (i+j+z == 15) break }
print(c(i,j,z))

f = function() {
  for (i in 1:10) {
    for (j in 1:10) {
      for (z in 1:10) {
        if (i+j+z == 15) return(c(i,j,z)) 
      }}}}
f()


# 13.1.4 반복문 다시 보기
# 13.1.4.1 반복문의 기본적인 구조
s=0 # 결과를 저장할 변수 s
for (i in 1:10) # 변수 i가 1부터10까지 반복된다.
  s = s + i # 반복되어 수행되는 작업
print(s)

x = c(1, 3, 5, 9, 15)
s = rep(NA, 5) # 결과를 저장할 변수 s
#for (i in 1:5) # 변수 가i 벡터 의x 길이에 맞춰 변한다.
#for (i in 1:length(x))
for (i in seq_along(x))
  s[i] = x[i]^2 # 반복되어 수행되는 작업
print(s)

x = c(1, 3, 5, 9, 15)
s = rep(NA, 5) 

if (length(x)>0) { 
  for (i in 1:length(x)) { 
    s[i] = x[i]^2
  }
}


# 13.1.4.2 반복문의 대체
#01. Vectorized function
x <- c(1, 3, 5, 9, 15)
s <- sqrt(x); s

#02. sapply
x <- c(1, 3, 5, 9, 15)
s <- sapply(x, sqrt); s

#01. if the function is not vectorized
tonum = function(x) {
  switch(x,
         one = 1,
         two = 2,
         3)
}
x <- c("one","three","two","four","two")
s <- tonum(x)
##Error in switch(x, one = 1, two = 2, 3) : EXPR must be a length 1 vector

tonumV = Vectorize(tonum)
s <- tonumV(x)
print(s)

#02. sapply with Vectorized function
x <- c("one","three","two","four","two")
s <- sapply(x, tonumV)
print(s)

# 01a. for
x <- c(1,3,7,2,5)
s <- rep(NA, length(x))
for (i in 1:10) {
  s[i] <- x[i]^2
}

# 01b. sapply
x <- c(1,3,7,2,5)
s <- rep(NA, length(x))
s <- sapply(1:5, function(i) x[i]^2)

# 02a. for
x <- c(1,3,7,2,5)
s <- 0
for (i in 1:10) {
  s <- s + x[i]^2
}

# 02b. sapply
x <- c(1,3,7,2,5)
s <- 0
invisible(sapply(1:5, function(i) s <<- x[i]^2))


# 13.1.4.3 for의 몇 가지 변형
x <- c(1,3,2,4)
result = vector("list", length(x))
#result = c()
for (i in seq_along(x)) {
  result[[i]] = rep(x,x)
  #result = c(result, rep(x,x))
}
result <- unlist(result)

mat <- matrix(1:1000, 1000, 1000, byrow=T)
# R 내장 함수
result <- colSums(mat)

# apply
result <- apply(mat, 2, sum)

# for
result <- rep(NA, 1000) # result <- NA, length(result) <- 1000
for (i in 1:ncol(mat)) {
  result[i] <- sum(mat[,i])
}

# 실험
gc()
mat <- matrix(1:1000, 1000, 1000, byrow=T)
result <- vector(mode="list", 1000)
# R 내장 함수
tColsum <- system.time({for (i in 1:1000)
  result[[i]] <- colSums(mat)})

gc()
mat <- matrix(1:1000, 1000, 1000, byrow=T)
result <- vector(mode="list", 1000)
# for
tFor <- system.time(for(iter in 1:1000) {
  result[[iter]] <- rep(NA, 1000) # result <- NA, length(result) <- 1000
  for (i in 1:ncol(mat)) {
    result[[iter]][i] <- sum(mat[,i]) 
  }})

gc()
mat <- matrix(1:1000, 1000, 1000, byrow=T)
result <- vector(mode="list", 1000)
# apply
tApply <- system.time({for (i in 1:1000)
  result[[i]] <- apply(mat, 2, sum)
})

print(tColsum)
print(tFor)
print(tApply)


# 13.2 함수
# 13.2.1 함수
# 13.2.2 함수 만들기의 예
s=0
for (i in 1:5) {
  s = s + i
}
print(s)

s=0
for (i in 1:10) {
  s = s + i
}
print(s)

s=0
for (i in 1:20) {
  s = s + i
}
print(s)

sumToN = function(n) {
  s=0
  for (i in 1:n) {
    s = s + i }
  print(s); return(s) # 여기서 return은 생략하고 그냥 s로 써도 된다.
}

sumToN(5)
sumToN(10)
sumToN(20)

# 13.2.3 함수의 인자
sumAToB = function(startNum , endNum) {
  s=0
  for (i in startNum:endNum) {
    s = s + i
  }
  print(s)
  return(s)
  8 }

# 13.2.3.1 인자
sumAToB2 = function(startNum=1, endNum=10) {
  s=0
  for (i in startNum:endNum) {
    s = s + i
  }
  print(s)
  return(s)
}

sqPlot = function(x, y, ...) {
  plot(x, y^2, ...)
}
sqPlot((-3):3, (-3):3)
sqPlot((-3):3, (-3):3, col='gray50', pch=3)

# startNum부터 endNum까지 더하는 함수
sumAToB3 = function(..., startNum , endNum) {
  args <- list(...)
  step=ifelse(is.null(args$step), 1, args$step)
  return(sum(seq(from=startNum, to=endNum, by=args$step))) 
}
#sumAToB3(startNum = 1, end = 5)
##Error in seq.default(from = startNum, to = endNum, by = args$step) : 
##  argument "endNum" is missing, with no default 

sumAToB3(startNum = 1, endNum=10, step=2) # 1+3+5+7+9 = 25

boxcox = function(x, lambda=1)
{
  if(length(lambda)!=1) stop("the length of lambda must be one.")
  
  if (lambda != 0) {
    return((x^lambda -1)/lambda)
  } else {
    log(x)
  }
}
boxcox(c(1,3,2))
boxcox(c(1,3,2), 2)
boxcox(c(1,3,2), c(1,2))

boxcox = function(x, lambda=1)
{
  stopifnot(length(lambda)==1)
  
  if (lambda != 0) {
    return((x^lambda -1)/lambda)
  } else {
    log(x)
  }
}
boxcox(c(1,3,2))
boxcox(c(1,3,2), 2)
boxcox(c(1,3,2), c(1,2))
##  Error in boxcox(c(1, 3, 2), c(1, 2)) : length(lambda) == 1 is not TRUE 

# 13.2.4 함수와 인자의 클라스
options(max.print=10)
methods(print) # 또는 methods('print')
methods(summary)

