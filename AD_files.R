library(magrittr)
list.dirs(path='.', full.names=TRUE, recursive=TRUE) %>% head(5)

unlink("__temp2", recursive=TRUE) # 화일 또는 디렉토리 삭제
dir.exists('__temp') # 디렉토리 존재 확인
dir.create('__temp') # 디렉토리 만들기
# shell('ren __temp __temp2') # 디렉토리 이름 바꾸기 Windows
system('mv __temp __temp2') # Linux

# 디렉토리 복사: dir.create(), file.copy()
dir.create('__temp3')

## Warning in dir.create("__temp3"): '__temp3' already exists
file.copy('__temp2', '__temp3', recursive=TRUE)

getwd() # 현재 디렉토리 확인
setwd('.') # 현재 디렉토리 수정

## D.2 스크립트
txt <- "
dir.copy = function(from, to, checkto= TRUE,
overwrite=FALSE,
recursive=FALSE, ...) {
if (!dir.exists(from)) {
cat('Directory', from, 'DOES NOT exist.\n')
stop() }
if (checkto == TRUE) {
if (dir.exists(to)) {
cat('Directory', to,
'exists. checkto=FALSE to copy files to the EXISTING directory.\n')
stop() }
} else {
if (!dir.exists(to)) dir.create(to)
}
if (length(list.files(from, recursive=recursive, ...))==0) {
error('No files to be copied')
} else {
file.copy(from=from, to=to,
overwrite=overwrite,
recursive=recursive, ...)
}}"
writeLines(txt, "dircopy.R")
source('dircopy.R')

## D.3 파일

txt = 'This is test!'
writeLines(text = txt, con = '__temp.txt')
fn = '__temp.txt'; file.info(fn)
# size : 화일 크기(바이트)
# isdir : 디렉토리 여부
# mode : 읽기/쓰기/실행 가능 여부
# (예. 666 = 모든 사용자 쓰기/읽기 가능
# 777 = 모든 사용자 쓰기/읽기/실행 가능)
# mtime : 마지막 수정 시간
# ctime : 마지막 상태 변화(status change) 시간
# atime : 마지막 접근 시간
# exe : 실행 가능한 파일인가?

dir(path='.') %>% head(5) # 현재 디렉토리의 화일들
dir(path='.', recursive = TRUE) %>% head(3) # 현재와 하위 디렉토리의 화일들

file.exists(fn) # 화일 존재 여부 확인
fnCopy=paste0('_',fn)
file.copy(from=fn, to=fnCopy) # 화일 복사, 성공하면 TRUE
file.rename(from=fnCopy, to=paste0('_',fnCopy)) # 화일 이름 수정
file.remove(paste0('__',fn)) # 화일 삭제

fn <- file.choose() # 화일 선택기

basename('../../git/..')
basename(normalizePath('../../git/..'))


## <관련 데이터 파일 등 정리>
# ## 필요한 데이터 파일
# 
# ## 외부 URL
# 
# ## 생성되는 데이터 파일/디렉토리
# ./__temp
# ./__temp2
# ./__temp3
# dircopy.R
# __temp.txt
