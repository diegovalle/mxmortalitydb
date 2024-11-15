#' Big Municipios not part of a Metro Area
#'
#' This dataset contains all municipios which were not part of a metro area in 2010 but had
#' a larger population than the smallest metro area (> 110,000)
#' \url{http://www.conapo.gob.mx/es/CONAPO/Delimitacion_de_Zonas_Metropolitanas}
#'
#' @section Variables:
#'
#' \itemize{
#' \item \code{state_code} a numeric vector
#' \item \code{mun_code} a numeric vector
#' \item \code{population} a numeric vector
#' \item \code{name} a character vector
#' }
#' @docType data
#' @name big.municipios
#' @usage big.municipios
#' @format A data frame with 66 observations on the following 4 variables.
#' @examples
#' head(big.municipios)
NULL
