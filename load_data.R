#s_data <- read.csv("data\\suicide_grouped.csv")

#needs to be changed later
data_bar <- read.csv("data\\suicide_data.csv")
data_pie <- data_bar %>% group_by(year,country,sex,latitude,longitude) %>% summarise(suicides_no=sum(suicides_no))
s_data <- data_bar %>% group_by(year,country,latitude,longitude) %>% summarise(suicides_no=sum(suicides_no))


#highcharter data
data_total <- data_bar %>% group_by(year,country) %>% summarise(suicide_total=sum(suicides_no))
data_mean <- data_total %>% group_by(country) %>% summarise(suicides_avg = mean(suicide_total))
data_mean <- data_mean[order(-data_mean$suicides_avg),] %>% slice(1:10)
countries_top <- data_mean %>% slice(1:10)


df_total <- NULL
for(i in 1:10){
  temp <- filter(data_total,country==countries_top$country[i])
  df_total<-rbind(df_total,temp)
}


data_total_100k <- data_bar %>% group_by(year,country) %>% summarise(suicide_total=sum(suicides_100k))
data_mean_100k <- data_total_100k %>% group_by(country) %>% summarise(suicides_avg = mean(suicide_total))
data_mean_100k <- data_mean_100k[order(-data_mean_100k$suicides_avg),] %>% slice(1:10)
countries_top_100k <- data_mean_100k %>% slice(1:10)

#df_country <- filter(data_total_100k,country==countries_top$country[1])
df_100k_total <- NULL
for(i in 1:10){
  temp <- filter(data_total_100k,country==countries_top_100k$country[i])
  df_100k_total<-rbind(df_100k_total,temp)
}

#right bar graph
# data_age_trend <- data_bar %>% group_by(year,sex,age) %>% summarise(suicides = mean(suicides_no))
# 
# df_age_trend <- data_age_trend %>% group_by(sex,age) %>% summarise(avg_suicides = mean(suicides))





#right and bottom line chart

normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

# normalize <- function(x) {
#     return ((x - mean(x)) / sd(x))
#   }

data_gdp_trend <- data_bar %>% group_by(year) %>% summarise(avg_suicides = mean(suicides_no),
                                                            avg_GDP= mean(GDPyear)) 

data_gdp_trend['norm_gdp'] = normalize(data_gdp_trend$avg_GDP)
data_gdp_trend['norm_suicide'] = normalize(data_gdp_trend$avg_suicides)


#bottom

data_pop_trend <- data_bar %>% group_by(year) %>% summarise(avg_suicides = mean(suicides_no),
                                                            avg_population= mean(Population)) 

data_pop_trend['norm_pop'] = normalize(data_pop_trend$avg_population)
data_pop_trend['norm_sui'] = normalize(data_pop_trend$avg_suicides)

