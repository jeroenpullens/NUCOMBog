\name{getData}
\alias{getData}
\title{getData from monthly output file}
\usage{
getData(type)
}
\arguments{
\item{type} {"GPP" and/or "WTD"}

}
\value{
Creates a list with\item{type}
}
\description{
getData from monthly output file
}
\examples{
getData("GPP")
getData("WTD")
getData(c("GPP","WTD"))
}

