# GlobalSuicide Rate: The visuailization of world wide suicidal rate from 1985-2016 using Rshiny

The visualization shows the worldwide suicide rate of the data downloaded from kaggle.

[https://www.kaggle.com/russellyates88/suicide-rates-overview-1985-to-2016](
https://www.kaggle.com/russellyates88/suicide-rates-overview-1985-to-2016)

## prerequisites

To run this program you must have [R](https://www.r-project.org/) and [R studio](https://rstudio.com/) installed.



## How To Run
You can run this in your local machine by executing the below code in Rstudio.

```R
packages = c(
	"dplyr","highcharter", "htmltools", "leaflet","plotly", "shiny", "shinydashboard"
	)
install.packages(packages, repos = "https://cran.rstudio.com/")
library(shiny)
library(plotly)
library(leaflet)
library(shinydashboard)
library(highcharter)

runGitHub("GlobalSuicidal_Visualization", "yeshwanthrr")
```

## Acknowledgments
[SuperZIP demo](https://shiny.rstudio.com/gallery/superzip-example.html)

