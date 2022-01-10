## R에서 하는 벡터/행렬 연산
a = c(1, 5, -2)
b = c(3, -1, 7)
A = matrix(c(1,3,-2, 5, 7, -3, 1, 0, 1), 3, 3)
B = matrix(c(5,2,-1,0,7,-2,3,-5,1), 3, 3)

## 벡터 연산
pracma::dot(a, b) # 두 벡터의 내적
sum(a*b)

pracma::cross(a,b)

outer(a,b); a %o% b
a %*% t(b); tcrossprod(a, b)

## 한 행렬 연산
diag(2)
diag(4)

diag(c(1,-1))
diag(c(2,5,3,1))

A; diag(A)
B; diag(B)

A; t(A)
B; t(B)

# matrix.trace(A)와 sum(diag(A))의 차이는
# matrix.trace(A)는 행렬 A가 정방행렬인지 먼저 확인한다.
A; matrixcalc::matrix.trace(A); sum(diag(A))
A2 <- cbind(A, c(1,2,1))
A2; matrixcalc::matrix.trace(A2); sum(diag(A2))

## 두 행렬의 연산
A; B; A %*% B
A; B; A * B
A; B; A %x% B
A; B; matrixcalc::direct.sum(A, B)

## 선형(행렬) 대수
A; b=c(2,-1,1)
x = solve(A, b)
near(A %*% x, b)

A; solve(A)

A; MASS::ginv(A)

A; matrixcalc::matrix.rank(A)

A; det(A)

qrA = qr(A)
qr.Q(qrA); qr.R(qrA)

# install.packages('matrixcalc')
S = A + t(A)                             # Symmetric matrix
matrixcalc::is.positive.definite(S)      # 양의 정부호행렬
matrixcalc::is.positive.semi.definite(S) # 양의 준정부호행렬
matrixcalc::is.negative.definite(S)      # 음의 정부호행렬
matrixcalc::is.negative.semi.definite(S) # 음의 준정부호행렬

eigen(A)$values # 고유치
eigen(A)$vectors # 고유벡터

A %*% eigen(A)$vectors[,1]; # A와 첫 번째 고유벡터의 곱
eigen(A)$values[1] * eigen(A)$vectors[,1] #첫 번째 고유값과 고유벡터의 곱

# 위의 두 값은 거의 같다!
near(A %*% eigen(A)$vectors[,1],
     eigen(A)$values[1] * eigen(A)$vectors[,1])

A = matrix(c( 1, 5, 1,
              3, 7, 0,
              -2,-3, 1,
              1, 5, 4), byrow=T, nrow=4, ncol=3)
A
svd(A)$u #U
diag(svd(A)$d) # Sigma
svd(A)$v #V

A; svd(A)$u %*% diag(svd(A)$d) %*% t(svd(A)$v)
near(A, svd(A)$u %*% diag(svd(A)$d) %*% t(svd(A)$v))

