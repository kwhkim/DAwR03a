# utils.R

u_chars = function(s, encodings) {
  stopifnot(class(s) == "character")
  stopifnot(length(s)==1)
  if (Encoding(s) != 'UTF-8' && Encoding(s) != "unknown") {
    s = iconv(s, from = Encoding(s), to='UTF-8')  } 
  
  dat = data.frame(ch = unlist(strsplit(s, ""))) # 글자 단위로 분리
  cps = sapply(dat$ch, utf8ToInt)                # unicode codepoint
  cps_hex = sprintf("%02x", cps)                 # 16진수로 변환
  
  # 16진수 표현 방법 "  ..ff", "  a1ff", "011f3e"
  # 처음 두 자리수는 거의 사용되지 않으므로 0일 때 공란으로 표시
  # 다음 두 자리수는 ASCII의 경우 사용되지 않으므로 0일 때 .으로 표시
  cps_hex = 
    ifelse(nchar(cps_hex) > 2,
           stringi::stri_pad(cps_hex, width = 4, side = 'left', pad = '0'),
           stringi::stri_pad(cps_hex, width = 4, side = 'left', pad = '.'))
  dat$codepoint = 
    ifelse(nchar(cps_hex) > 4,
           stringi::stri_pad(cps_hex, width=6, side='left', pad='0'),
           stringi::stri_pad(cps_hex, width=6, side='left', pad=' '))
  
  # encodings가 주어졌다면, 주어진 인코딩으로 변환 결과
  if (!missing(encodings)) {
    for (encoding in encodings) {
      ch_enc = vector(mode='character', length=nrow(dat))
      for (i in 1:nrow(dat)) {
        ch = dat$ch[i]
        ch_enc[i] = 
          paste0(sprintf("%02x", 
                         as.integer(unlist(
                           iconv(ch, from = 'UTF-8', 
                                 to=encoding, toRaw=TRUE)))),
                 collapse = ' ')
      }
      dat$enc = ch_enc
      names(dat)[length(names(dat))] = paste0('enc.', encoding)  
    }
  }
  dat$label = Unicode::u_char_label(cps); 
  dat
}



# get_printlocales = function()  {
#   lc_sys <- Sys.info()[["sysname"]]
#   lc_sep <- switch(lc_sys,
#                    "Darwin"=, "SunOS" = "/",
#                    "Linux" =, "Windows" = ";")
# 
#   printlocales = function(category = "LC_ALL") {
#     mat = Sys.getlocale("LC_ALL") %>%
#       strsplit(lc_sep) %>%
#       unlist %>% strsplit('=') %>% do.call(rbind, .)
#     apply(mat, 1, function(x) sprintf("%12s = %-20s", x[1], x[2])) %>%
#       paste0(collapse= '\n') %>% cat
#     invisible(mat)
#   }
# 
#   return(printlocales)
# }

# %>% 를 사용하지 않은 버전
get_printlocales = function()  {
  lc_sys <- Sys.info()[["sysname"]]
  lc_sep <- switch(lc_sys,
                   "Darwin"=, "SunOS" = "/",
                   "Linux" =, "Windows" = ";") 
  
  printlocales = function(category = "LC_ALL") {
    mat = 
      do.call(rbind, strsplit(unlist(strsplit(Sys.getlocale("LC_ALL"), lc_sep)), '='))
    lc_category = mat[,1]
    cat(
      paste0(
        apply(mat, 1, function(x) sprintf("%12s = %-20s", x[1], x[2])),
        collapse='\n'))
    invisible(mat)
  }
  
  return(printlocales)
}

printlocales = get_printlocales()


encoding = Encoding
`encoding<-` = function(x, value) {
  stopifnot(value %in% c("latin1", "UTF-8", "bytes", "", "unknown"))
  Encoding(x) = value
  x
}


