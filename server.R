# 
# library(shiny)
# library(leaflet)
# library(highcharter)

source(file.path(".", "load_data.R"), local = TRUE)$value


function(input,output,session){
  
  
  
  output$mymap <- renderLeaflet({

    leaflet(height= 200, options = leafletOptions(attributionControl = FALSE)) %>% 
      addProviderTiles("CartoDB.DarkMatter") %>% 
     setView(0,0,1) 
  }
  
  )
  
  
  #observe datapoints
  observe({
    data_year <- s_data[s_data$year == input$year_data,]
    
    map <- leafletProxy("mymap")
    map %>% 
      clearMarkers() %>%
      clearControls() %>%
      addControl(paste("MORTALITY OBSERVATION FOR THE YEAR ",input$year_data),position = "bottomleft") %>%
      addCircleMarkers(data = data_year,
                       lng = data_year$longitude,
                       lat = data_year$latitude,
                       stroke = TRUE,
                       weight = 1,
                       color = "#d63447",
                       fill = TRUE,
                       fillColor = "#d63447",
                       fillOpacity = 0.6,
                       label = paste(sep="\n", data_year$country, data_year$suicides_no),
                       popup = paste(sep="\n", data_year$country, data_year$suicides_no),
                       radius = data_year$suicides_no*20/max(data_year$suicides_no, na.rm = TRUE) 
                         
      ) 
    
    #print(input$mymap_marker_click)
    
    #comparision chart
    
    #Add title
    output$comp_s100kTitle <- renderUI({
      div(style='color:black; text-align:center;width:100%;
        font-size:12px; font-weight: bold;font-family:"Open Sans",verdana,arial,sans-serif',
          paste("Comparision of suicide/100k"))
    })
    
        
    df_avg_s100k <- filter(data_bar, country== input$in_country)
    df_s110k_count <- df_avg_s100k %>% group_by(year) %>% summarise(suicides = mean(suicides_100k))
    df_s110k_global <- data_bar %>% group_by(year) %>% summarise(suicides = mean(suicides_100k))
    
    output$comp_s100k <- renderHighchart(
      highchart() %>%
        hc_add_series(
          data=df_s110k_count,
          name=input$in_country,
          type="column",
          hcaes(
            x = year,
            y=suicides,
          ),
          color="#5b8c85",
          pointWidth=5
        )%>%
        hc_add_series(
          data=df_s110k_global,
          name="Global",
          type="line",
          hcaes(
            x = year,
            y=suicides,
          ),color = "#dd2c00"
        ) %>%
        #hc_title(text="Comparision of suicide/100k",margin = 5, align = "center",fontsize="10px") %>%
        hc_xAxis(title=list(text="Year"),opposite = FALSE) %>%
        hc_yAxis(title=list(text="Suicides/100k"),opposite = FALSE)
    )
   
    #read bar data
    data_bar_year <- filter(data_bar,year== input$year_data)
    
    #Add title
    output$allbarTitle <- renderUI({
      div(style='color:black; text-align:center;width:100%;
        font-size:12px; font-weight: bold;font-family:"Open Sans",verdana,arial,sans-serif',
          paste("Suicide Rate by Countries for the Year ",input$year_data))
    })
    
    output$allbarPlot <- renderPlotly(
      data_bar_year %>%
        group_by(country,sex) %>%
        plot_ly() %>%
        add_trace(x= ~country,y= ~suicides_no,
                  color = ~sex, type = "bar") %>%
        layout(
          plot_bgcolor='rgba(0,0,0,0)',
          paper_bgcolor = 'rgba(0,0,0,0)',
          barmode = "stack",
               yaxis = list(title = "No of Suicides"),xaxis = list(title = "")
               
               )
      )
    
    
    data_pie_bar <- filter(data_bar,year== input$year_data,country== input$in_country)
    
    #add title
    output$country_pie_barTitle <- renderUI({
      div(style='color:black; text-align:center;width:100%;
        font-size:12px; font-weight: bold;font-family:"Open Sans",verdana,arial,sans-serif',
          paste(input$in_country,"\'s Suicide Rate","\n"," by Age in",input$year_data))
    })
    
    #set margin
    mar <- list(l = 10,r = 10,b = 10,t = 10,pad = 20)
    colors <- c('rgb(207, 117, 0)','rgb(199, 0, 57)','rgb(0, 8, 57)','rgb(144, 12, 63)','rgb(59, 105, 120)','rgb(91, 140, 90)')
    
    output$country_pie_bar <- renderPlotly(
      data_pie_bar %>%
        group_by(country) %>%
        plot_ly(height = 260,width = 240) %>%
        add_pie(labels = ~age,values = ~suicides_no,
                textposition = 'inside',textinfo = 'label+percent',
                insidetextfont = list(color = '#d2c6b2'),
                hoverinfo = 'text',text = ~paste(age,"\n","No of Deaths : ", suicides_no),
                showlegend=FALSE,
                marker = list(colors = colors,
                              line = list(color = '#FFFFFF', width = 1))
        ) %>% 
        layout(#title = paste(input$in_country,"\'s Suicide Rate","\n"," by Gender in",input$year_data),
               
          plot_bgcolor='rgba(0,0,0,0)',
          paper_bgcolor = 'rgba(0,0,0,0)',
          autosize=F,
          margin = mar,
          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE,size=10),
          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE,size=10)
          )
      
      
    )
    
    
  
    
    #implement highchart
    output$suicide_100k <- renderHighchart(
      highchart(type = "chart") %>%
        hc_add_series(data=df_100k_total,
                      type = "line",
                      hcaes(x=year,
                            y=suicide_total,
                            group = country)) %>%
        hc_title(text="Top 10 Countries with Highest Suicide Rate for 100k Population",
                 margin = 20, align = "center",fontsize="10px") %>%
        hc_xAxis(title=list(text="Year"),opposite = FALSE) %>%
        hc_yAxis(title=list(text="Suicides per 100K population"),opposite = FALSE)
      
    ) 
    
    
    
    
    #implement 10 contries chart
    
    output$suicide_total <- renderHighchart(
      highchart(type = "chart") %>%
        hc_add_series(data=df_total,
                      type = "line",
                      hcaes(x=year,
                            y=suicide_total,
                            group = country)) %>%
    hc_title(text="Top 10 Countries with Highest Suicide Rate",
              margin = 20, align = "center",fontsize="10px") %>%
      hc_xAxis(title=list(text="Age"),opposite = FALSE) %>%
      hc_yAxis(title=list(text="No of Suicides"),opposite = FALSE)
    )
    
    
    output$global_gdp_trend <- renderHighchart(
      
      highchart(type = "chart") %>%
        hc_add_series(
          data=data_pop_trend,
          name="Suicide",
          type="line",
          hcaes(
            x = year,
            y=norm_sui,
          ),
          color="#ff7315"
        ) %>%
        hc_add_series(
          data=data_gdp_trend,
          name="GDP",
          type="line",
          hcaes(
            x = year,
            y=norm_gdp,
          ),
          color = "#ffd369"
        ) %>%
        hc_title(text="Correlation of Suicide Rate with GDP",
                 margin = 20, align = "center",fontsize="10px") %>%
        hc_xAxis(title=list(text="Year"),opposite = FALSE) %>%
        hc_yAxis(title=list(text="Rise in Sucides"),opposite = FALSE)
    )
    
    
    
    #Population Trend

    output$global_pop_trend <- renderHighchart(
      
      highchart(type = "chart") %>%
        hc_add_series(
          data=data_pop_trend,
          name="Suicide",
          type="line",
          hcaes(
            x = year,
            y=norm_sui,
          ),
          color="#ff7315"
        ) %>%
        hc_add_series(
          data=data_pop_trend,
          name="Population",
          type="line",
          hcaes(
            x = year,
            y=norm_pop,
          ),
          color="#a278b5"
        ) %>%
        hc_title(text="Correlation of Suicide Rate with Population",
                 margin = 20, align = "center",fontsize="10px") %>%
        hc_xAxis(title=list(text="Year"),opposite = FALSE) %>%
        hc_yAxis(title=list(text="Rise in Suicides"),opposite = FALSE)
    )
    

    
    
  }
  )
  
}

