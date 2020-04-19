
#data_countries <- read.csv("data\\suicide_grouped.csv")
data_bar <- read.csv("data\\suicide_data.csv")
d_countries <- levels(unique(data_bar$country))


body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),
  
  tabItems(
    tabItem(tabName = "map",
            fluidPage(
              column(9,
                     fluidRow(
                       leafletOutput("mymap",height = "300px",width = "780px"),
                       p(),
                       box(height = 290,width = 780,
                           uiOutput("allbarTitle"),
                           plotlyOutput("allbarPlot",height = "280px",width = "760px"))
                     )
              ),
              column(3,
                     fluidRow(
                       box(height = 600,width = 250,#background = "black",
                           uiOutput("country_pie_barTitle"),
                           plotlyOutput("country_pie_bar",height = 250,width = 240),
                           p(),
                           br(),
                           #infoBoxOutput("progressBox_deaths",width = 12),
                           uiOutput("comp_s100kTitle"),
                           br(),
                           highchartOutput("comp_s100k",height = "200px",width = "240px"),
                           #infoBoxOutput("progressBox_deaths",width = 12),
                           #infoBoxOutput("progressBox_country", width = 11),
                           #infoBoxOutput("progressBox_age",width =11)
                           
                       )
                       
                     )
              )
            )
            
    ),
    
    
    #Second Tab
    
    tabItem(tabName = "charts",
            #h2("Hello"),
            fluidPage(
              column(7,
                     fluidRow(
                       highchartOutput("suicide_100k",height = "300px",width = "600px"),
                       p(),
                       highchartOutput("suicide_total",height = "300px",width = "600px")
                     )
              ),
              column(5,
                     fluidRow(
                       highchartOutput("global_gdp_trend",height = "300px",width = "450px"),
                       p(),
                       highchartOutput("global_pop_trend",height = "300px",width = "450px"),
                     )
              )
            )
            
    )
    
    
  )
  
)




ui <- dashboardPage(
  dashboardHeader(title = "GLOBAL SUICIDE RATE FROM 1985 - 2016"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Map",tabName = "map",icon = icon("map"))
      #menuItem("Charts",tabName = "charts",icon = icon("far fa-chart-bar"))
    ),
    sliderInput("year_data", "YEAR",
                min = 1985, max = 2016, value = 1985, step = 1
    ),
    selectInput('in_country', 'COUNTRY', d_countries, selectize=FALSE),
    sidebarMenu(
      menuItem("Charts",tabName = "charts",icon = icon("far fa-chart-bar"))
    )
    
  ),
  body
)