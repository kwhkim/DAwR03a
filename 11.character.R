## 제 11장. 문자열(character)

#Sys.setlocale("LC_ALL", "Korean")
library(stringi)
library(stringr)

x <- '한글사랑'
Encoding(x) 
Encoding(x) <- 'UTF-8'; x; Encoding(x)
Encoding(x) <- 'latin1'; x; Encoding(x)
Encoding(x) <- ''; x; Encoding(x)
Encoding(x) <- 'bytes'; x; Encoding(x)
Encoding(x) <- ''; x; Encoding(x)
Encoding(x) <- 'CP949'; x; Encoding(x)
Encoding(x) <- 'unknown'; x; Encoding(x)

x <- 'English'
Encoding(x) 
Encoding(x) <- 'UTF-8'; x; Encoding(x)
Encoding(x) <- 'latin1'; x; Encoding(x)
Encoding(x) <- 'CP949'; x; Encoding(x)

Sys.getlocale('LC_CTYPE')

x <- c("한글사랑", "création d'un rôle")
x <- iconv(x, from='CP949', to='UTF-8'); x; Encoding(x)
x <- iconv(x, from='UTF-8', to='latin1'); x; Encoding(x)
x <- c("한글사랑", "création d'un rôle")
x <- stringi::stri_conv(x, from='windows-949', to='UTF-8'); x; Encoding(x)
x <- stringi::stri_conv(x, from='UTF-8', to='latin1'); x; Encoding(x)

# Windows 실행 결과
fn = iconv("테스트.png", to = "UTF-8")
magick::image_read(fn) # 문제 없음
imager::load.image(fn) # 에러
EBImage::readImage(fn) # 에러

## 11.5 문자열 상수
cat("'\\b'는 백슬래쉬를 의미한다.\n")
cat('"어떻게 해?"라고 말했다. \'음...\'\n')
cat("\"어떻게 해?\"라고 말했다. '음...'\n")
cat('좋아요\041\n')
cat('좋아요\x21\n')
cat('\u00a9는 copyright 표시이다.\n')

Unicode::u_char_from_name('COPYRIGHT', type='grep')
## [1] U+00A9 U+2117
# 결과로 나온 뒤에 U+00A9, U+2117에 대해 알아보려면,
source("utils.R")
u_chars("\u00a9\u2117") # 이 함수는 뒤에서 정의된다.

(x <- c('\u00b1\u00bd-\u00be'))
Encoding(x)
charToRaw(x) # 반대는 rawToChar()

scan(what="", sep='\n', quote='')
영어 한글 \\ "How can you", I thought 'Hmmm"\\'

#Read 1 item
#[1] "영어 한글 \\\\ \"How can you\", I thought 'Hmmm\"\\\\'"

scan(what="", sep='\n', quote='') # 윈도우 R의 경우 û, é가 제대로 입력되지 않는다.
불어 brûlée 한자 鬼 \ 와 ", '

#Read 1 item
#[1] "불어 brulee 한자 鬼 \\ 와 \", '"


u_chars('\u2060\ufeff',
        encodings = c("UTF-8", "UTF-16LE", "UTF-32LE"))


## 11.7 유니코드 정규화
x <- c("He sni\ufb00ed. sniffed!", "\u00fc and u\u0308")
cat(x, "\n")
y <- stringi::stri_trans_nfkc(x)
cat(y, "\n")

Sys.getlocale('LC_COLLATE')
x <- c("ä", "A", "D", "P", "Z", "CH", "C", "H", "Ü")
x <- stringi::stri_trans_nfkc(x)
#cat(paste0(x, collpase=" "), "\n")
sort(x)


x <- c("ä", "A", "D", "P", "Z", "CH", "C", "H", "Ü")
Sys.setlocale("LC_COLLATE", "German") # de
## [1] "German"
sort(x)
## [1] "A" "ä" "C" "CH" "D" "H" "P" "Ü" "Z"
Sys.setlocale("LC_COLLATE", "Finnish") # fi
## [1] "Finnish"
sort(x)
## [1] "A" "ä" "C" "CH" "D" "H" "P" "Ü" "Z"
Sys.setlocale('LC_COLLATE', 'English') # en, window
#Sys.setlocale("LC_COLLATE", "en_US") # en, unix
## [1] "en_US"
sort(x)
## [1] "A" "ä" "C" "CH" "D" "H" "P" "Ü" "Z"
Sys.setlocale("LC_COLLATE", "Czech") # cs
## [1] "Czech"
sort(x)
## [1] "A" "ä" "C" "CH" "D" "H" "P" "Ü" "Z"
Sys.setlocale("LC_COLLATE", "Korean") # ko
## [1] "Korean"
sort(x)
## [1] "A" "ä" "C" "CH" "D" "H" "P" "Ü" "Z"

library(stringr)
str_sort(x, locale='en') # 영어; English
str_sort(x, locale='de') # 독어; Deutsch
str_sort(x, locale='fi') # 핀란드어; Finnish
str_sort(x, locale='cs') # 체코어; čeština
str_sort(x, locale='ko') # 한국어; Korean

library(stringi)
stri_sort(x, opts_collator = stri_opts_collator(locale='de'))
stri_sort(x, opts_collator = stri_opts_collator(locale='fi'))
stri_sort(x, opts_collator = stri_opts_collator(locale='en'))
stri_sort(x, opts_collator = stri_opts_collator(locale='cs'))
stri_sort(x, opts_collator = stri_opts_collator(locale='ko'))


Sys.setlocale('LC_ALL', 'Korean')

## 11.9 문자열을 다루는 함수들
# 알파벳 15번째 소문자와 대문자는?
c(letters[15], LETTERS[15])


str <- c("BoYs, Be aMbiTioUS!", "Er ist so groß.")
toupper(str)
str_to_upper(str, locale = "de") # Er ist so groß. = He is so big.
str_to_upper(str, locale = "tr") # 터키어: i가 İ로 변한다.

str <- "\U903a9 딸기 !"
nchar(str)
nchar(str, type='bytes')
nchar(str, type='width')

x = '\u2002\u2003spac\u2004\u2005\u2006\u2007es\u2008\u2009\u200a'
trimws(x)
str_trim(x) # u_chars(str_trim(x)) 해 보면 좀 더 확실하다.

str_squish(x)
# 위의 결과에 연이어 %>% u_chars를 해보면
# "\u2004\u2005\u2006\u2007"가 단 하나의 공란(" ")으로
# 바뀌었음을 확인할 수 있다.

paste0("I have ", "a car")
paste0(c("I have ", "I want "), c("a car", "a cake"))

paste(c("ab", "cd"), c("cd", "ab"))
paste(c("ab", "cd"), c("cd", "ab"), sep = "__")

paste(c("ab", "cd"), c("ef", "gh"), collapse = "**")
paste(c("ab", "cd"), c("ef", "gh"), sep = "__", collapse = "")
paste(c("ab", "cd"), c("ef", "gh"), sep = "__", collapse = NULL)

## 11.9.6 sprintf: 실수를 형식에 맞춰 출력하기
x1 <- c(0, -1, exp(1), -pi*10, exp(1)*1e+6)
x2 <- c(0, 1, 314, 9923, -1123224)
x3 <- c(0, 314.413, pi*100, -1123224*0.123)
print(x1); print(x2); print(x3)

sprintf("%6.2f", x1); sprintf("%6.2f", x2); sprintf("%6.2f", x3);

x1 <- "  3.14"; x2 <- "3.14  "

sprintf(c("%10.2f", "%010.2f", "%+10.2f", "%+010.2f"), pi) # 우측 정렬
sprintf(c("%-10.2f", "%-+10.2f"), pi) # 좌측 정렬
sprintf(c("%10.2f", "%+10.2f"), pi*1000000) # 좌측 정렬

## 11.9.7 substring 또는 substr
x <- c("abcdefg", "hijklmnop")
substring(x, 1, 4)
substring(x, 1, 4) <- c("aaaa", "bbbb"); x


library(stringr)
patt = 'xxxx'
str = c("I don't know", "How the xxxx do I know?", "Wow, x is 5!",
        "xxxx xxxx xxxx", "Don't say xxxx to me, xxxx.")
str_detect(str, pattern = fixed(patt))


str_count(str, pattern = fixed(patt))
str_split(str, pattern = fixed(patt))
str_locate(str, pattern = fixed(patt))
str_replace(str, pattern = fixed(patt), replacement='yyyy')

## <관련 데이터 파일 등 정리>
# ## 필요한 데이터 파일
# 테스트.png
# 
# ## 외부 URL
# 
# ## 생성되는 데이터 파일
# 



