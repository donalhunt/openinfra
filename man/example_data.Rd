% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{example_data}
\alias{example_data}
\title{OSM infrastructure data used in creation of transport infrastructure data packs.}
\format{
A data frame with 29,911 features described by 29 variables.
}
\source{
{\href{https://github.com/udsleeds/openinfra/blob/main/test-code/generate_example_data.R}{generate_example_data.R}}
}
\usage{
example_data
}
\description{
Contains all columns required for IM function, oi_recode_max_speed, oi_recode_road_, oi_active_cycle, oi_is_lit.
}
\examples{
library(sf)
example_data   # Lazy Loading. Data becomes visible as soon as it is requested. 
}
\keyword{dataset}
