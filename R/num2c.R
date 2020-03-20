#' @describeIn conversion Convert Arabic Numerals to Chinese Numerals.
#'
#' @return \code{num2c} returns a character vector.
#'
#' @examples
#' num2c(721)
#' num2c(-6)
#' num2c(3.14)
#' num2c(721, literal = TRUE)
#' num2c(1.45e12, financial = TRUE)
#' num2c(6.85e12, lang = "sc", mode = "casualPRC")
#' num2c(1.5e9, mode = "SIprefix", single = TRUE)
#'
#' @export
#'
num2c <- function(x, lang = "tc", mode = "casual", financial = FALSE, literal = FALSE, single = FALSE) {
  if (length(x) > 1) {
    return(sapply(x, function(y) num2c(y, lang, mode, financial, single)))
  }
  if (!is.numeric(x)) {
    stop("`x` must be numeric.")
  }

  conv_t <- conv_table(lang, mode, financial)
  maximum <- 10^max(conv_t[["scale_t"]]$n)
  if (abs(x) > 1e18) {
    stop("Absolute value of `x` must not be greater than ", 1e18, ".")
  }

  if (x < 0) {
    neg_chr <- conv_t[["neg"]]
    x <- gsub("-", "", x)
    x <- as.numeric(x)
  } else {
    neg_chr <- ""
  }

  if (single & x >= 11) {
    paste0(neg_chr, integer2c_single(x, conv_t))
  } else if (x %% 1 == 0) {
    if (literal) {
      paste0(neg_chr, integer2c_literal(x, conv_t))
    } else {
      paste0(neg_chr, integer2c(x, conv_t))
    }
  } else {
    if (literal) {
      paste0(neg_chr, integer2c_literal(floor(x), conv_t),
             decimal2c(x %% 1, conv_t))
    } else {
      paste0(neg_chr, integer2c(floor(x), conv_t),
             decimal2c(x %% 1, conv_t))
    }
  }
}