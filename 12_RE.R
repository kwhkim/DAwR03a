# 제 12장. 정규 표현식


str <- c("인터스텔라의 장면 62.",
         "부모가 되면[5-7],",
         "아이들-내 아이는 10살이다.-이 안심하고 자랄 수 있게 하고 싶다.",
         "2027년 2월 3일.")

## 숫자를 나타내는 문자 "1", "2", "3"
grepl("1", str, fixed=TRUE) | grepl("2", str, fixed=TRUE) | 
  grepl("3", str, fixed=TRUE) 

## 숫자 "1", "2", "3"을 나타내는 정규표현식 "[1-3]"
grepl(pattern = "[1-3]", str)


# 12.1. R과 정규표현식

# 12.2 확장정규표현식(ERE)

# 12.2.4. 미리 설정된 문자 집합: POSIX 브라켓
x <- c('I dare to love you', 'I dare to love you!', 
       'Oh1', 'Dear, my love.2', '!!?!')
grep('[[:punct:]]', x) # 문장부호가 포함되었는가?
grep('[[:punct:]1]', x) # 문장부호 또는 1이 포함되었는가?
grep('[1[:punct:]]', x) # 1 또는 문장부호가 포함되었는가?
grep('[^[:punct:]]', x) # 문장부호가 아닌 문자가 포함되었는가?


x <- c('Idaretoloveyou', 'I dare to love you!', 
       'Oh1', 'Dear, my love.1', '!!?!')
grep('\\w', x)
grep('\\W', x)


grep('\\s', x)
grep('\\S', x) 

# 12.2.6 정규표현식의 탈출문자 \를 활용한 문자
x <- c('\a', '\b')
grep('\a', x)
grep('\\a', x)

x <- c('\x1b', '\x1c')
grep('\\e', x)


grep('\e', x)
#Error: '\e' is an unrecognized escape in character string starting "'\e"


x <- c('\u00b1', '\u00b2')
grep('\u00b1', x)
grep('\\x{00b1}', x)
grep('[\u00b1]', x)
grep('[\\x{00b1}]', x) # grep("[\\x{000b1}]", "{")의 결과를 예측해보자.

# 12.2.8 문자 혹은 문자집합의 반복
x <- "Test On. <h> Hi! </h> Test Off."
grepl("<.+>", x)
grepl("<.+?>", x)

regmatches(x, regexpr("<.+>", x)) 
# stringr::str_extract(x, "<.+>")을 사용하면 편하다.
regmatches(x, regexpr("<.+?>", x))

# 12.2.11 앵커링: 위치를 나타내는 정규표현식
x <- c("hook", "I have a hook", "He shook me")

grepl("hook", x)
grepl("^hook", x)
grepl("hook$", x)

grepl("\\bhook", x)
grepl("\\Bhook", x)


# 12.2.12 괄호(): 우선 순위 변경, 캡쳐, 부분일치
x <- c("abcxabc", "abxab", "abcxab", "abxabc")

grepl("[abc]{2,3}x[abc]{2,3}", x)
grepl("([abc]{2,3})x\\1", x)

x <- c('abba', '2xx2', 'a22z', 'xaxx')
grepl('(\\w)(\\w)\\2\\1', x)

x <- c('axxbba', 'axybba', '2yyxx2', 'cxy22c')
grepl('(\\w)(xx|yy)(\\w)\\3\\1', x)
grepl('(\\w)(?:xx|yy)(\\w)\\2\\1', x)


# 12.2.13 정규표현식 활용 예
names <- c('김남수', '하이연', '정진성', '김우주',
           '박구수', '성우장', '박의수')
grep('^박.*수$', names)

# 12.2.14 정규표현식을 활용한 치환: sub
names <- c('김남수', '하이연', '정진성', '김우주',
           '박구수', '성우장', '박의수')
sub(pattern='^([김박])(.*)([주수])$', 
    replacement="\\1\\2수\\\\김\\2\\3", names)


# 12.3. Perl 호환 정규표현식
# 12.3.1 PCRE과 ERE의 비교
grepl("[\\d]", c("3", "d", "\\"))
grepl("[\\d]", c("3", "d", "\\"), perl=TRUE)

# 12.3.2 PCRE의 모드
grepl("(?i)[abc]", c("a", "A", "e", "E"), perl=TRUE)
grepl("(?i)[abc](?-i)[abc]", c("aa", "AA", "ee", "EE"), perl=TRUE)

grepl("^I", c("You\nI\nHe", "I\nYou\nHe"))
grepl("(?m)^I", c("You\nI\nHe", "I\nYou\nHe"), perl=TRUE)

# 12.3.3 문자 그대로: \Q .. \E
grepl('\\d+*!*+\\d', c("3+*!*+2", "2!!!2"), perl=TRUE)
## Error in grepl("\\d+*!*+\\d", c("3+*!*+2", "2!!!2"), perl = TRUE) :
##   invalid regular expression '\d+*!*+\d'
## ...
grepl('\\d\\Q+*!*+\\E\\d', c("3+*!*+2", "2!!!2"), perl=TRUE)


# 12.4. 패키지 stringr, stringi
library(stringr)
library(stringi)
str <- c("3+*!*+2", "2!!!2")
str %>% str_detect('\\d\\Q+*!*+\\E\\d')


## 12.5 stringi 패키지와 정규표현식을 활용한 문자열 데이터 가공

## 12.6 활용 예
gsub(',', '', '1,000,000,000')

x = c("123.455", "1730,000", "153,421,000.1005050")
as.integer(gsub(",", "", x)) %>% sprintf("%13d ", .)
as.numeric(gsub(",", "", x)) %>% sprintf("%17.3f", .)

x = c('ESG ETF에 100,000,000원을 투자했다.',
      '각 물품의 가격은 250000, 400000, 120000원이다.',
      '각각은 1000,1400,320,5820원이다.',
      '이건 1000,200,300,500원이야.')
str_extract_all(x,
                "(?<!\\d)[-+]?(\\d{4,}|\\d{1,3}(,?\\d{3})*)([.]\\d+)?(?!\\d)")

## 
txt <- "여기에 자료가 있습니다.
자료에는 이름 정보가 숨어 있습니다.
name = 김이박 이름 정보를 찾았습니까?"
stri_extract(txt, regex='(?<=name [=] )[^ ]*')
#regmatches(txt, gregexpr("(?<=name [=] )[^ ]*", txt, perl=TRUE))
str_extract(txt, '(?<=name [=] )[^ ]*')




