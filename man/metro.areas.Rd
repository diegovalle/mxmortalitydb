% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/metro.areas.R
\docType{data}
\name{metro.areas}
\alias{metro.areas}
\title{Mexican Metro Areas (2010)}
\format{
A data frame with 366 observations on the following 5 variables.
}
\usage{
metro.areas
}
\description{
This dataset contains all municipios which are part of a metro area as defined by the CONAPO
\url{http://www.conapo.gob.mx/es/CONAPO/Delimitacion_de_Zonas_Metropolitanas}
}
\section{Variables}{


\itemize{
\item{\code{metro_area}}{a character vector}
\item{\code{mun_population_2010}}{: municip populatin in 2010, a numeric vector}
\item{\code{metro_population_2010}}{: metro area population in 2010, a numeric vector}
\item{\code{state_code}}{a numeric vector}
\item{\code{mun_code}}{a numeric vector}
}
}

\examples{
head(metro.areas)
}
