---
title: "Injury Intent Deaths 2004-2023 in Mexico"
author: "Diego Valle-Jones"
date: "January 05, 2024"
output: 
 github_document:
          toc: true
          fig_width: 8
          fig_height: 5
---

Injury Intent Deaths 2004-2023 in Mexico
========================================================

|              |          |
|--------------|---------------|
| __Author:__ | Diego Valle-Jones |
| __License:__ | [MIT](http://en.wikipedia.org/wiki/MIT_License) |
| __Website:__ | [https://github.com/diegovalle/mxmortalitydb](https://github.com/diegovalle/mxmortalitydb) |

## What does it do?

This is a data only package containing all injury intent deaths (accidents, suicides, homicides, legal interventions, and deaths of unspecified intent) registered by the SSA/INEGI from 2004 to 2023. The data source for the database is the [INEGI](http://www.inegi.org.mx/est/contenidos/proyectos/registros/vitales/mortalidad/default.aspx). In addition the data was coded with the Injury Mortality Matrix provided by the [CDC](http://www.cdc.gov/nchs/data/ice/icd10_transcode.pdf). The code used to clean the database is available [as a separate program](https://github.com/diegovalle/death.index)

## Installation

For the moment this package is only available from github. For the development version:

```r
if (!require(devtools)) {
    install.packages("devtools")
}
devtools::install_github('diegovalle/mxmortalitydb')
```


```r
library(mxmortalitydb)
library(ggplot2)
suppressPackageStartupMessages(library(dplyr))
```

## Examples

Deaths by homicide in Mexico


```r
injury.intent %>%
  filter(intent == "Homicide") %>%
  group_by(year_reg, intent) %>%
  summarise(count = n())
```

```
## `summarise()` has grouped output by 'year_reg'. You can override using the
## `.groups` argument.
```

```
## # A tibble: 20 × 3
## # Groups:   year_reg [20]
##    year_reg intent   count
##       <int> <fct>    <int>
##  1     2004 Homicide  9330
##  2     2005 Homicide  9926
##  3     2006 Homicide 10454
##  4     2007 Homicide  8868
##  5     2008 Homicide 14007
##  6     2009 Homicide 19804
##  7     2010 Homicide 25757
##  8     2011 Homicide 27213
##  9     2012 Homicide 25967
## 10     2013 Homicide 23063
## 11     2014 Homicide 20013
## 12     2015 Homicide 20763
## 13     2016 Homicide 24560
## 14     2017 Homicide 32082
## 15     2018 Homicide 36687
## 16     2019 Homicide 36662
## 17     2020 Homicide 36773
## 18     2021 Homicide 35700
## 19     2022 Homicide 33291
## 20     2023 Homicide 32253
```

All deaths of unknown intent in Sinaloa (state code 25) where the injury mechanism was a firearm, by year of registration:


```r
## The main data.frame in the package is called injury.intent
injury.intent %>%
  filter(is.na(intent)  & 
           mechanism == "Firearm" & 
           state_reg == 25 ) %>%
  group_by(year_reg, intent) %>%
  summarise(count = n())
```

```
## `summarise()` has grouped output by 'year_reg'. You can override using the
## `.groups` argument.
```

```
## # A tibble: 17 × 3
## # Groups:   year_reg [17]
##    year_reg intent count
##       <int> <fct>  <int>
##  1     2004 <NA>      11
##  2     2005 <NA>      11
##  3     2006 <NA>       2
##  4     2009 <NA>       8
##  5     2010 <NA>       7
##  6     2011 <NA>      25
##  7     2012 <NA>     197
##  8     2013 <NA>       8
##  9     2014 <NA>       1
## 10     2015 <NA>       1
## 11     2016 <NA>       3
## 12     2017 <NA>       1
## 13     2019 <NA>       2
## 14     2020 <NA>       2
## 15     2021 <NA>      20
## 16     2022 <NA>       4
## 17     2023 <NA>       2
```

In addition to the injury.intent data.frame several other datasets are available:

* __aggressor.relation.code__ (relationship between the aggressor and his victim, useful for merging aggressor_relationship_code, Spanish)
* __geo.codes__ (names of states and municipios, useful for merging state_reg, state_occur_death and mun_reg, mun_occur_death codes)
* __icd.103__ (list of 103 deceases by the WHO, Spanish)
* __metro.areas__ (2010 metro areas as defined by the CONAPO along with 2010 population counts)
* __big.municipios__ (since metro areas are not statistical in nature this is a list of all 
  municipios which are bigger than the smallest metro area but are not part of one)
* __mex.list.group__ (groups of deceases, Spanish)
* __mex.list__ (list of deceases, Spanish)

Homicides merged with the aggressor.relation.code table:


```r
df <- injury.intent %>%
  filter(intent == "Homicide") %>%
  group_by(year_reg, aggressor_relation_code) %>%
  summarise(count = n())
```

```
## `summarise()` has grouped output by 'year_reg'. You can override using the
## `.groups` argument.
```

```r
## A couple of other tables are included in the package to
## interpret some of the values in injury.intent
merge(df, aggressor.relation.code)
```

```
##     aggressor_relation_code year_reg count            relationship
## 1                         1     2012    25                   Padre
## 2                         1     2017     7                   Padre
## 3                         1     2016    13                   Padre
## 4                         1     2021     4                   Padre
## 5                         1     2018     6                   Padre
## 6                         1     2014   107                   Padre
## 7                         1     2015     7                   Padre
## 8                         1     2022     9                   Padre
## 9                         1     2020     6                   Padre
## 10                        1     2023    10                   Padre
## 11                        1     2013    18                   Padre
## 12                        1     2019     4                   Padre
## 13                        2     2016     9                   Madre
## 14                        2     2021     4                   Madre
## 15                        2     2017     2                   Madre
## 16                        2     2015    11                   Madre
## 17                        2     2022     5                   Madre
## 18                        2     2012    64                   Madre
## 19                        2     2023     3                   Madre
## 20                        2     2014    16                   Madre
## 21                        2     2020     1                   Madre
## 22                        2     2019     6                   Madre
## 23                        2     2018     8                   Madre
## 24                        2     2013    17                   Madre
## 25                        3     2015     9                 Hermano
## 26                        3     2022    14                 Hermano
## 27                        3     2012    14                 Hermano
## 28                        3     2017    13                 Hermano
## 29                        3     2014    13                 Hermano
## 30                        3     2019     5                 Hermano
## 31                        3     2023    15                 Hermano
## 32                        3     2013    16                 Hermano
## 33                        3     2020     4                 Hermano
## 34                        3     2021     7                 Hermano
## 35                        3     2018    14                 Hermano
## 36                        3     2016    11                 Hermano
## 37                        4     2012     7                 Hermana
## 38                        4     2017     5                 Hermana
## 39                        4     2019     4                 Hermana
## 40                        4     2015     2                 Hermana
## 41                        4     2013     6                 Hermana
## 42                        4     2018     4                 Hermana
## 43                        4     2016     4                 Hermana
## 44                        4     2021     5                 Hermana
## 45                        4     2014     9                 Hermana
## 46                        4     2022     2                 Hermana
## 47                        5     2017     9                    Hijo
## 48                        5     2019     7                    Hijo
## 49                        5     2016    13                    Hijo
## 50                        5     2021    16                    Hijo
## 51                        5     2018    11                    Hijo
## 52                        5     2023     9                    Hijo
## 53                        5     2012    10                    Hijo
## 54                        5     2013    14                    Hijo
## 55                        5     2022    11                    Hijo
## 56                        5     2015    10                    Hijo
## 57                        5     2020     5                    Hijo
## 58                        5     2014    20                    Hijo
## 59                        6     2013     2                    Hija
## 60                        6     2015     1                    Hija
## 61                        6     2022     1                    Hija
## 62                        6     2012     1                    Hija
## 63                        6     2014     2                    Hija
## 64                        6     2019     1                    Hija
## 65                        6     2018     2                    Hija
## 66                        6     2016     3                    Hija
## 67                        7     2013     4                  Abuelo
## 68                        7     2015     1                  Abuelo
## 69                        7     2012     5                  Abuelo
## 70                        7     2019     1                  Abuelo
## 71                        7     2016     1                  Abuelo
## 72                        7     2014     2                  Abuelo
## 73                        8     2022     3                  Abuela
## 74                        8     2013     5                  Abuela
## 75                        8     2016     1                  Abuela
## 76                        8     2012     3                  Abuela
## 77                        8     2014     8                  Abuela
## 78                        9     2017     3                   Nieto
## 79                        9     2012     5                   Nieto
## 80                        9     2018     1                   Nieto
## 81                        9     2013    29                   Nieto
## 82                        9     2019     2                   Nieto
## 83                        9     2021     3                   Nieto
## 84                        9     2014    19                   Nieto
## 85                        9     2022     2                   Nieto
## 86                        9     2016     4                   Nieto
## 87                        9     2015     3                   Nieto
## 88                       10     2012     1                   Nieta
## 89                       10     2013     2                   Nieta
## 90                       10     2019     1                   Nieta
## 91                       10     2014     1                   Nieta
## 92                       11     2014    22         Esposo, Cónyuge
## 93                       11     2023     8         Esposo, Cónyuge
## 94                       11     2017     9         Esposo, Cónyuge
## 95                       11     2021     9         Esposo, Cónyuge
## 96                       11     2022    17         Esposo, Cónyuge
## 97                       11     2019     7         Esposo, Cónyuge
## 98                       11     2020     9         Esposo, Cónyuge
## 99                       11     2013    29         Esposo, Cónyuge
## 100                      11     2018    15         Esposo, Cónyuge
## 101                      11     2015    30         Esposo, Cónyuge
## 102                      11     2012    27         Esposo, Cónyuge
## 103                      11     2016    24         Esposo, Cónyuge
## 104                      12     2013     9         Esposa, Cónyuge
## 105                      12     2012     3         Esposa, Cónyuge
## 106                      12     2014    10         Esposa, Cónyuge
## 107                      12     2021    26         Esposa, Cónyuge
## 108                      12     2022    14         Esposa, Cónyuge
## 109                      12     2018     5         Esposa, Cónyuge
## 110                      12     2023     1         Esposa, Cónyuge
## 111                      12     2019    16         Esposa, Cónyuge
## 112                      12     2016     4         Esposa, Cónyuge
## 113                      12     2015     2         Esposa, Cónyuge
## 114                      12     2020     8         Esposa, Cónyuge
## 115                      12     2017     2         Esposa, Cónyuge
## 116                      13     2013     9                     Tío
## 117                      13     2023     1                     Tío
## 118                      13     2014     6                     Tío
## 119                      13     2012     7                     Tío
## 120                      13     2016    13                     Tío
## 121                      13     2015     8                     Tío
## 122                      13     2018     2                     Tío
## 123                      13     2017     6                     Tío
## 124                      13     2019     2                     Tío
## 125                      13     2022     2                     Tío
## 126                      14     2012     1                     Tía
## 127                      14     2018     1                     Tía
## 128                      15     2021     6                 Sobrino
## 129                      15     2014    10                 Sobrino
## 130                      15     2016     4                 Sobrino
## 131                      15     2019     5                 Sobrino
## 132                      15     2017     9                 Sobrino
## 133                      15     2013    14                 Sobrino
## 134                      15     2018     4                 Sobrino
## 135                      15     2023     6                 Sobrino
## 136                      15     2015     9                 Sobrino
## 137                      15     2022     6                 Sobrino
## 138                      15     2012    19                 Sobrino
## 139                      16     2016     1                 Sobrina
## 140                      16     2023     1                 Sobrina
## 141                      17     2013    15                   Primo
## 142                      17     2017    13                   Primo
## 143                      17     2023     2                   Primo
## 144                      17     2022     4                   Primo
## 145                      17     2019     3                   Primo
## 146                      17     2018    10                   Primo
## 147                      17     2020     4                   Primo
## 148                      17     2016     9                   Primo
## 149                      17     2014    10                   Primo
## 150                      17     2012    14                   Primo
## 151                      17     2015    11                   Primo
## 152                      17     2021     2                   Primo
## 153                      18     2016     1                   Prima
## 154                      21     2012     1                Bisnieto
## 155                      27     2017     2                  Suegro
## 156                      27     2018     3                  Suegro
## 157                      27     2012     2                  Suegro
## 158                      27     2013     1                  Suegro
## 159                      27     2015     2                  Suegro
## 160                      27     2016     1                  Suegro
## 161                      31     2023     1                   Yerno
## 162                      31     2018     3                   Yerno
## 163                      31     2016     3                   Yerno
## 164                      31     2021     1                   Yerno
## 165                      31     2012     4                   Yerno
## 166                      31     2013     5                   Yerno
## 167                      31     2014     1                   Yerno
## 168                      31     2015     4                   Yerno
## 169                      31     2017     4                   Yerno
## 170                      31     2022     1                   Yerno
## 171                      32     2018     1                   Nuera
## 172                      33     2015     9                  Cuñado
## 173                      33     2016     3                  Cuñado
## 174                      33     2018     7                  Cuñado
## 175                      33     2017     6                  Cuñado
## 176                      33     2013     8                  Cuñado
## 177                      33     2021     1                  Cuñado
## 178                      33     2019     1                  Cuñado
## 179                      33     2023     3                  Cuñado
## 180                      33     2012     9                  Cuñado
## 181                      33     2022     4                  Cuñado
## 182                      33     2014     9                  Cuñado
## 183                      34     2022     1                  Cuñada
## 184                      34     2012     1                  Cuñada
## 185                      35     2017     2                 Concuño
## 186                      35     2013     1                 Concuño
## 187                      35     2012     1                 Concuño
## 188                      35     2014     2                 Concuño
## 189                      37     2017     2               Padrastro
## 190                      37     2015     6               Padrastro
## 191                      37     2022     5               Padrastro
## 192                      37     2012     6               Padrastro
## 193                      37     2019     1               Padrastro
## 194                      37     2016     6               Padrastro
## 195                      37     2021     2               Padrastro
## 196                      37     2018     2               Padrastro
## 197                      37     2023     2               Padrastro
## 198                      37     2020     2               Padrastro
## 199                      37     2014     2               Padrastro
## 200                      37     2013     7               Padrastro
## 201                      38     2013     1               Madrastra
## 202                      39     2016     1                Hijastro
## 203                      39     2017     1                Hijastro
## 204                      39     2012     2                Hijastro
## 205                      39     2015     2                Hijastro
## 206                      39     2013     2                Hijastro
## 207                      39     2021     1                Hijastro
## 208                      39     2014     1                Hijastro
## 209                      41     2013     3             Hermanastro
## 210                      41     2012     1             Hermanastro
## 211                      41     2018     1             Hermanastro
## 212                      41     2020     1             Hermanastro
## 213                      41     2014     1             Hermanastro
## 214                      45     2020     7    Concubino, compañero
## 215                      45     2017    21    Concubino, compañero
## 216                      45     2019     5    Concubino, compañero
## 217                      45     2015    28    Concubino, compañero
## 218                      45     2013    27    Concubino, compañero
## 219                      45     2021     8    Concubino, compañero
## 220                      45     2014    26    Concubino, compañero
## 221                      45     2023    16    Concubino, compañero
## 222                      45     2016    25    Concubino, compañero
## 223                      45     2018    10    Concubino, compañero
## 224                      45     2012     9    Concubino, compañero
## 225                      45     2022    15    Concubino, compañero
## 226                      46     2015     5    Concubina, compañera
## 227                      46     2016     6    Concubina, compañera
## 228                      46     2012     4    Concubina, compañera
## 229                      46     2021     1    Concubina, compañera
## 230                      46     2014     7    Concubina, compañera
## 231                      46     2017     4    Concubina, compañera
## 232                      46     2013     4    Concubina, compañera
## 233                      46     2023     2    Concubina, compañera
## 234                      46     2022     1    Concubina, compañera
## 235                      47     2016     2 Amante, Amasio, Querido
## 236                      47     2019     1 Amante, Amasio, Querido
## 237                      47     2013     1 Amante, Amasio, Querido
## 238                      47     2015     1 Amante, Amasio, Querido
## 239                      47     2012     3 Amante, Amasio, Querido
## 240                      47     2017     1 Amante, Amasio, Querido
## 241                      48     2014     1 Amante, Amasia, Querida
## 242                      49     2022     1                   Novio
## 243                      49     2014     2                   Novio
## 244                      49     2015     2                   Novio
## 245                      49     2012     2                   Novio
## 246                      49     2019     1                   Novio
## 247                      49     2016     4                   Novio
## 248                      49     2023     2                   Novio
## 249                      49     2013     3                   Novio
## 250                      49     2017     1                   Novio
##  [ reached 'max' / getOption("max.print") -- omitted 109 rows ]
```

A plot of female homicide counts (making sure to exclude those that occurred outside Mexico):


```r
## make sure to only count deaths that occurred inside Mexico (codes 33 to 35 are USA, LATAM and Other)
df <- injury.intent %>%
  filter(sex == "Female" & 
           intent == "Homicide" & 
           !state_occur_death %in% 33:35) %>%
  group_by(year_reg, intent) %>%
  summarise(count = n())
```

```
## `summarise()` has grouped output by 'year_reg'. You can override using the
## `.groups` argument.
```

```r
ggplot(df, aes(year_reg, count)) +
  geom_line() +
  labs(title = "Female homicides in Mexico, by year of registration")
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png)


Homicides in the Mexico City metro area (ZM Valle de México), by the state where the murder was *registered*


```r
plotMetro <- function(metro.name) {
  require(stringr)
  ## data.frame metro.areas contains the 2010 CONAPO metro areas
  df <- merge(injury.intent, 
              metro.areas, 
              by.x = c('state_reg', 'mun_reg'), 
              by.y=c('state_code', 'mun_code'))
  ## Homicides in Mexico City, by state of registratio
  df2 <- df %>%
    filter(metro_area == metro.name & 
             intent == "Homicide") %>%
    group_by(state_reg, year_reg) %>%
    summarise(count = n())
  ## data.frame geo.codes contains the names of Mexican states (with mun_code 0) and municipios
  df2 <- merge(df2, subset(geo.codes, mun_code ==0), by.x = 'state_reg', by.y = 'state_code')
  ggplot(df2, aes(year_reg, count, group = state_reg, color = name)) +
    geom_line() +
    labs(title = str_c("Homicides in ", metro.name, ", by state of registration"))
  }
plotMetro("Valle de México")
```

```
## Loading required package: stringr
```

```
## `summarise()` has grouped output by 'state_reg'. You can override using the
## `.groups` argument.
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6-1.png)

The drop in homicides in the State of Mexico looks weird, let's plot by where the murder *occurred*


```r
plotMetro_occur <- function(metro.name) {
  require(stringr)
  ## data.frame metro.areas contains the 2010 CONAPO metro areas
  df <- merge(injury.intent, 
              metro.areas, 
              by.x = c('state_occur_death', 'mun_occur_death'), 
              by.y=c('state_code', 'mun_code'))
  ## Homicides in Mexico City, by state of registratio
  df2 <- df %>%
    filter(metro_area == metro.name & 
             intent == "Homicide") %>%
    group_by(state_occur_death, year_reg) %>%
    summarise(count = n())
  ## data.frame geo.codes contains the names of Mexican states (with mun_code 0) and municipios
  df2 <- merge(df2, subset(geo.codes, mun_code ==0), by.x = 'state_occur_death', by.y = 'state_code')
  ggplot(df2, aes(year_reg, count, group = state_occur_death, color = name)) +
    geom_line() +
    labs(title = str_c("Homicides in ", metro.name, ", by state of occurrence"))
  }
plotMetro_occur("Valle de México")
```

```
## `summarise()` has grouped output by 'state_occur_death'. You can override using
## the `.groups` argument.
```

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7-1.png)

So something changed in the way homicides were registered in the State of Mexico and you have to make sure to plot by where the homicide occurred.

## Warning

I encourage you to get acquainted with the database since it may contain some errors (introduced at the source) and some fields may be difficult to interpret because of the large number of missing values (see the aggressor relation example). The field _intent.imputed_ is the result of running a statistical model to impute the intent of deaths of unknown intent, and is mainly useful to the author of this package. Feel free to ignore the column.

Total Imputed Homicides in Mexico:


```r
## make sure to only count deaths that occurred inside Mexico (codes 33 to 35 are USA, LATAM and Other)
injury.intent %>%
  filter(intent.imputed == "Homicide" & !state_occur_death %in% 33:35) %>%
  group_by(year_reg) %>%
  summarise(count = n())
```

```
## # A tibble: 20 × 2
##    year_reg count
##       <int> <int>
##  1     2004 10445
##  2     2005 11046
##  3     2006 11490
##  4     2007 10362
##  5     2008 15315
##  6     2009 21138
##  7     2010 27638
##  8     2011 30146
##  9     2012 27922
## 10     2013 24819
## 11     2014 21748
## 12     2015 22305
## 13     2016 26274
## 14     2017 34254
## 15     2018 38923
## 16     2019 39068
## 17     2020 38621
## 18     2021 37573
## 19     2022 35308
## 20     2023 33319
```

## License

This package is free and open source software, licensed [MIT](http://en.wikipedia.org/wiki/MIT_License).
