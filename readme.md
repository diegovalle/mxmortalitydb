[![Travis-CI Build Status](https://travis-ci.org/diegovalle/mxmortalitydb.svg?branch=master)](https://travis-ci.org/diegovalle/mxmortalitydb)

Mexican Injury Intent Deaths 2004-2014
========================================================

This is a data only package containing all injury intent deaths (accidents, suicides, homicides, legal interventions, and deaths of unspecified intent) registered by the SSA/INEGI from 2004 to 2014. The data source for the database is the [INEGI](http://www.inegi.org.mx/est/contenidos/proyectos/registros/vitales/mortalidad/default.aspx). In addition the data was coded with the Injury Mortality Matrix provided by the [CDC](http://www.cdc.gov/nchs/data/ice/icd10_transcode.pdf). The code used to clean the database is available [as a separate program](https://github.com/diegovalle/death.index)

## Installation

devtools::install_github("diegovalle/mxmortalitydb")

```s
## Uncomment the following lines to install 
## install.packages('devtools')

## library(devtools)

## install_github('mxmortalitydb', 'diegovalle')
```



```s
library(mxmortalitydb)
library(stringr)
library(plyr)
library(ggplot2)
library(grid) ## needed for arrow
```


## Examples

All deaths of unknown intent in Sinaloa (state code 25) where the injury mechanism was a firearm, by year of registration:


```s
## The main data.frame in the package is called injury.intent
ddply(subset(injury.intent, is.na(intent) & mechanism == "Firearm" & state_reg == 
    25), .(year_reg, intent), summarise, count = length(state_reg))
```

```
##   year_reg intent count
## 1     2004   <NA>    11
## 2     2005   <NA>    11
## 3     2006   <NA>     2
## 4     2009   <NA>     8
## 5     2010   <NA>     7
## 6     2011   <NA>    25
## 7     2012   <NA>   197
```


In addition to the __injury.intent__ data.frame several other datasets are available:

* __aggressor.relation.code__ (relationship between the aggressor and his victim, useful for merging aggressor_relationship_code, Spanish)
* __geo.codes__ (names of states and municipios, useful for merging state_reg, state_occur_death and mun_reg, mun_occur_death codes)
* __icd.103__ (list of 103 categories in the WHO mortality, Spanish)
* __metro.areas__ (2010 metro areas as defined by the CONAPO along with 2010 population counts)
* __big.municipios__ (since metro areas are not statistical in nature this is a list of all 
  municipios which are bigger than the smallest metro area but are not part of one)
* __mex.list.group__ (groups of diseases, Spanish)
* __mex.list__ (list of diseases, Spanish)

Homicides merged with the aggressor.relation.code table:


```s
df <- ddply(subset(injury.intent, intent == "Homicide"), .(year_reg, aggressor_relation_code), 
    summarise, count = length(state_reg))
## A couple of other tables are included in the package to interpret some of
## the values in injury.intent
merge(df, aggressor.relation.code)
```

```
##    aggressor_relation_code year_reg count            relationship
## 1                        1     2012    25                   Padre
## 2                        2     2012    64                   Madre
## 3                        3     2012    14                 Hermano
## 4                        4     2012     7                 Hermana
## 5                        5     2012    10                    Hijo
## 6                        6     2012     1                    Hija
## 7                        7     2012     5                  Abuelo
## 8                        8     2012     3                  Abuela
## 9                        9     2012     5                   Nieto
## 10                      10     2012     1                   Nieta
## 11                      11     2012    27         Esposo, Cónyuge
## 12                      12     2012     3         Esposa, Cónyuge
## 13                      13     2012     7                     Tío
## 14                      14     2012     1                     Tía
## 15                      15     2012    19                 Sobrino
## 16                      17     2012    14                   Primo
## 17                      21     2012     1                Bisnieto
## 18                      27     2012     2                  Suegro
## 19                      31     2012     4                   Yerno
## 20                      33     2012     9                  Cuñado
## 21                      34     2012     1                  Cuñada
## 22                      35     2012     1                 Concuño
## 23                      37     2012     6               Padrastro
## 24                      39     2012     2                Hijastro
## 25                      41     2012     1             Hermanastro
## 26                      45     2012     9    Concubino, compañero
## 27                      46     2012     4    Concubina, compañera
## 28                      47     2012     3 Amante, Amasio, Querido
## 29                      49     2012     2                   Novio
## 30                      51     2012     3               Ex esposo
## 31                      57     2012     1                Compadre
## 32                      66     2012     5                Conocido
## 33                      67     2012     5                  Vecino
## 34                      68     2012     6                   Amigo
## 35                      69     2012     1                   Amiga
## 36                      70     2012     3           Otro familiar
## 37                      71     2012     1          Sin parentesco
## 38                      72     2012   438                 Ninguno
## 39                      99     2012 25253         No especificado
```


A plot of female homicide counts (making sure to exclude those that occurred outside Mexico):


```s
## make sure to only count deaths that occurred inside Mexico (codes 33 to 35
## are USA, LATAM and Other)
df <- ddply(subset(injury.intent, sex == "Female" & intent == "Homicide" & !state_occur_death %in% 
    33:35), .(year_reg, intent), summarise, count = length(state_reg))
ggplot(df, aes(year_reg, count)) + geom_line() + labs(title = "Female homicides in Mexico, by year of registration")
```

![plot of chunk unnamed-chunk-5](http://i.imgur.com/369LANr.png) 



Homicides in the Mexico City metro area (ZM Valle de México), by state where the murder was registered


```s
plotMetro <- function(metro.name) {
    require(stringr)
    ## data.frame metro.areas contains the 2010 CONAPO metro areas
    df <- merge(injury.intent, metro.areas, by.x = c("state_reg", "mun_reg"), 
        by.y = c("state_code", "mun_code"))
    ## Homicides in Mexico City, by state of registration
    df2 <- ddply(subset(df, metro_area == metro.name & intent == "Homicide"), .(state_reg, year_reg), 
        summarise, count = length(state_reg))
    ## data.frame geo.codes contains the names of Mexican states (with mun_code
    ## 0) and municipios
    df2 <- merge(df2, subset(geo.codes, mun_code == 0), by.x = "state_reg", 
        by.y = "state_code")
    ggplot(df2, aes(year_reg, count, group = state_reg, color = name)) + geom_line() + 
        labs(title = str_c("Homicides in ", metro.name, ", by state of registration"))
}
plotMetro("Valle de México")
```

```
## Loading required package: stringr
```

![plot of chunk unnamed-chunk-6](http://i.imgur.com/72My7Th.png) 

Since metro.area dataframe containes the 2010 population we can plot changes in homicides rates (the rate will be overstimated by a little bit since we are using 2010 data):

```s
plotChanges <- function(df, metro.areas, country.rate, years) {
  ## Where the municipio where the death occurred is unknown use
  ## the municipio where it was registered as place of occurrance
  df[df$mun_occur_death==999, ]$mun_occur_death  <- 
    df[df$mun_occur_death==999, ]$mun_reg
  
  ## Counts of homicide by state and municipio
  df <- ddply(subset(df, year_reg %in% years & intent.imputed == "Homicide"), 
              .(state_occur_death, mun_occur_death, year_reg), 
              summarise, count = length(state_reg))
  ## Merge the counts with our fake metro areas
  df <- merge(df, metro.areas, by.x = c("state_occur_death", "mun_occur_death"), 
              by.y = c("state_code", "mun_code"))
  ## Now get the counts by metro area (which may contain more than one municipio)
  df <- ddply(df, .(metro_area, year_reg), summarise,
              count = sum(count), 
              population = sum(mun_population_2010),
              rate = count / population * 10^5)
  ## We are only interesed if the metro area at some time had a homicide rate of 15
  df <- subset(df, metro_area %in% subset(df, rate > 15)$metro_area)
  ## Make sure the dataframe is ordered by metro and year
  df <- df[order(df$metro_area, df$year_reg),]
  ## Order the chart by homicide rate in 2012
  df$metro_area <- reorder(df$metro_area, df$rate, function(x) x[[2]])
  ## Data frame for the arrow structure
  arrows <- ddply(df, .(metro_area), summarise, 
                  start =  rate[1],
                  end = rate[2],
                  metro_area = metro_area[1],
                  change = ifelse(rate[1] >= rate[2], "decrease" ,"increase"))
  
  ggplot(df,
         aes(rate, metro_area, group = as.factor(year_reg), color = as.factor(year_reg))) +
    geom_point(aes(size = log(count))) +
    labs(title = "Homicide (and deaths of unknown intent classified as homicide) rates and trends") +
    scale_size("number\nof\nhomicides", breaks = c(log(50),log(500),log(3000)),
               labels = c(50, 500, 3000)) +
    geom_segment(data = arrows, aes(x= start , y = metro_area, 
                                    xend = end, yend = metro_area,
                                    group = change, color = change), 
                 arrow=arrow(length=unit(0.3,"cm")), alpha = .8) +
    scale_color_manual("year\nand\ntrend", 
                       values = c("gray", "black", "blue", "red")) +
    ylab("metro area") +
    xlab("homicide rate") +
    scale_x_log10()+
    geom_vline(xintercept = country.rate, linetype = 2) +
    annotate("text",  y = "Tapachula", x = 26, label = "country\naverage",
             hjust = -0.1, size = 4) +
    theme_bw()
}

## Let's treat the big municipalities which are not part of a metro area
## as if they were one
## rename big.municipios to merge with metro.areas
big.municipios2 <- big.municipios
names(big.municipios2) <- c("state_code", "mun_code",
                            "mun_population_2010", "metro_area")
metro.areas.fake <- rbind.fill(metro.areas, big.municipios2)

## Changes from 2011 to 2012 when the country homicide rate was 24.5
plotChanges(injury.intent, metro.areas.fake, 24.5, c(2011,2012))
## Changes from 2006 to 2012 when the country homicide rate was 24.5
plotChanges(injury.intent, metro.areas.fake, 24.5, c(2011,2012))
```

![plot of chunk unnamed-chunk-6](http://i.imgur.com/72My7Th.png) 
![plot of chunk unnamed-chunk-6](http://i.imgur.com/72My7Th.png) 

## Warning

I encourage you to get acquainted with the database since it may contain some errors (introduced at the source) and some fields may be difficult to interpret because of the large number of missing values (see the aggressor relation example). The field _intent.imputed_ is the result of running a statistical model to impute the intent of deaths of unknown intent, and correct some errors in the way homicides were recorded in Baja California, Sinaloa, and the Federal District. It is mainly useful to the author of this package. Feel free to ignore the column.

Total Imputed Homicides in Mexico:


```s
## make sure to only count deaths that occurred inside Mexico (codes 33 to 35
## are USA, LATAM and Other)
ddply(subset(injury.intent, intent.imputed == "Homicide" & !state_occur_death %in% 
    33:35), .(year_reg), summarise, count = length(state_reg))
```

```
##   year_reg count
## 1     2004 10554
## 2     2005 11129
## 3     2006 11615
## 4     2007 10456
## 5     2008 15391
## 6     2009 21220
## 7     2010 27660
## 8     2011 30312
## 9     2012 28086
```


## License

This package is free and open source software, licensed [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
