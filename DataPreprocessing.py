#Data Preprocessing
import pandas as pd


suicide_data = pd.read_csv("data\\suicide_data_original.csv")
suicide_data[' gdp_for_year ($) '] = suicide_data[' gdp_for_year ($) '].apply(lambda x: float(x.replace(',', '')))
countries_data = pd.read_csv("data\\countries.csv")

data1 = suicide_data.groupby(['year','country','sex','age'], as_index=False)['suicides_no'].sum()
data1["Population"] = suicide_data[['year','country','sex','age','population']].groupby(['year','country','sex','age'], as_index=False).sum()['population']
data1["GDPyear"] = suicide_data[['year','country','sex','age','population','suicides/100k pop',' gdp_for_year ($) ']].groupby(['year','country','sex','age'], as_index=False).sum()[' gdp_for_year ($) ']
data1["suicides_100k"] = suicide_data[['year','country','sex','age','population','suicides/100k pop']].groupby(['year','country','sex','age'], as_index=False).sum()['suicides/100k pop']

data1['latitude'] = data1['country'].map(countries_data.set_index('name')['latitude'])
data1['longitude'] = data1['country'].map(countries_data.set_index('name')['longitude'])


for i in range(len(data1)):
    if data1['country'][i] == 'Republic of Korea':
        data1['latitude'][i] = 35.907757000000004
        data1['longitude'][i] = 127.766922
    elif data1['country'][i] == 'Russian Federation':
        data1['latitude'][i] = 61.52401
        data1['longitude'][i] = 105.31875600000001
    elif data1['country'][i] == 'Saint Vincent and Grenadines':
        data1['latitude'][i] = 13.252818
        data1['longitude'][i] = -61.197096
    elif data1['country'][i] == 'Cabo Verde':
        data1['latitude'][i] = 15.120142
        data1['longitude'][i] = -23.6051721

data1 = data1.replace({'age':'5-14 years'},'05-14 years')
data1 = data1.sort_values(by=['year','country','sex','age'])

unique_year = data1.groupby(['country'])['year'].nunique()
filter_df = pd.DataFrame(list(unique_year.index),columns=['country'])
filter_df['year'] = pd.DataFrame(list(unique_year))
filter_country = filter_df[filter_df['year']>27]
data_set_bar = data1[data1['country'].isin(list(filter_country['country']))]
data_set_bar.to_csv("data\\suicide_data.csv")
