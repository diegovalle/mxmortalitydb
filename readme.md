Injury Intent Deaths 2004-2015 in Mexico
================
Diego Valle-Jones
November 30, 2016

-   [Injury Intent Deaths 2004-2015 in Mexico](#injury-intent-deaths-2004-2015-in-mexico)
    -   [What does it do?](#what-does-it-do)
    -   [Installation](#installation)
    -   [Examples](#examples)
    -   [Warning](#warning)
    -   [License](#license)

Injury Intent Deaths 2004-2015 in Mexico
========================================

[![Travis-CI Build Status](https://travis-ci.org/diegovalle/mxmortalitydb.svg?branch=master)](https://travis-ci.org/diegovalle/mxmortalitydb)

<table style="width:43%;">
<colgroup>
<col width="20%" />
<col width="22%" />
</colgroup>
<tbody>
<tr class="odd">
<td align="left"><strong>Author:</strong></td>
<td align="left">Diego Valle-Jones</td>
</tr>
<tr class="even">
<td align="left"><strong>License:</strong></td>
<td align="left"><a href="http://en.wikipedia.org/wiki/MIT_License">MIT</a></td>
</tr>
<tr class="odd">
<td align="left"><strong>Website:</strong></td>
<td align="left"><a href="https://github.com/diegovalle/mxmortalitydb" class="uri">https://github.com/diegovalle/mxmortalitydb</a></td>
</tr>
</tbody>
</table>

What does it do?
----------------

This is a data only package containing all injury intent deaths (accidents, suicides, homicides, legal interventions, and deaths of unspecified intent) registered by the SSA/INEGI from 2004 to 2015. The data source for the database is the [INEGI](http://www.inegi.org.mx/est/contenidos/proyectos/registros/vitales/mortalidad/default.aspx). In addition the data was coded with the Injury Mortality Matrix provided by the [CDC](http://www.cdc.gov/nchs/data/ice/icd10_transcode.pdf). The code used to clean the database is available [as a separate program](https://github.com/diegovalle/death.index)

Installation
------------

For the moment this package is only available from github. For the development version:

``` r
if (!require(devtools)) {
    install.packages("devtools")
}
devtools::install_github('diegovalle/mxmortalitydb')
```

``` r
library(mxmortalitydb)
library(ggplot2)
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

Examples
--------

All deaths of unknown intent in Sinaloa (state code 25) where the injury mechanism was a firearm, by year of registration:

``` r
## The main data.frame in the package is called injury.intent
injury.intent %>%
  filter(is.na(intent)  & 
           mechanism == "Firearm" & 
           state_reg == 25 ) %>%
  group_by(year_reg, intent) %>%
  summarise(count = n())
```

    ## Source: local data frame [10 x 3]
    ## Groups: year_reg [?]
    ## 
    ##    year_reg intent count
    ##       <int> <fctr> <int>
    ## 1      2004     NA    11
    ## 2      2005     NA    11
    ## 3      2006     NA     2
    ## 4      2009     NA     8
    ## 5      2010     NA     7
    ## 6      2011     NA    25
    ## 7      2012     NA   197
    ## 8      2013     NA     8
    ## 9      2014     NA     1
    ## 10     2015     NA     1

In addition to the injury.intent data.frame several other datasets are available:

-   **aggressor.relation.code** (relationship between the aggressor and his victim, useful for merging aggressor\_relationship\_code, Spanish)
-   **geo.codes** (names of states and municipios, useful for merging state\_reg, state\_occur\_death and mun\_reg, mun\_occur\_death codes)
-   **icd.103** (list of 103 deceases by the WHO, Spanish)
-   **metro.areas** (2010 metro areas as defined by the CONAPO along with 2010 population counts)
-   **big.municipios** (since metro areas are not statistical in nature this is a list of all municipios which are bigger than the smallest metro area but are not part of one)
-   **mex.list.group** (groups of deceases, Spanish)
-   **mex.list** (list of deceases, Spanish)

Homicides merged with the aggressor.relation.code table:

``` r
df <- injury.intent %>%
  filter(intent == "Homicide") %>%
  group_by(year_reg, aggressor_relation_code) %>%
  summarise(count = n())
## A couple of other tables are included in the package to
## interpret some of the values in injury.intent
merge(df, aggressor.relation.code)
```

    ##     aggressor_relation_code year_reg count            relationship
    ## 1                         1     2012    25                   Padre
    ## 2                         1     2015     7                   Padre
    ## 3                         1     2014   107                   Padre
    ## 4                         1     2013    18                   Padre
    ## 5                         2     2015    11                   Madre
    ## 6                         2     2014    16                   Madre
    ## 7                         2     2013    17                   Madre
    ## 8                         2     2012    64                   Madre
    ## 9                         3     2015     9                 Hermano
    ## 10                        3     2014    13                 Hermano
    ## 11                        3     2013    16                 Hermano
    ## 12                        3     2012    14                 Hermano
    ## 13                        4     2015     2                 Hermana
    ## 14                        4     2014     9                 Hermana
    ## 15                        4     2013     6                 Hermana
    ## 16                        4     2012     7                 Hermana
    ## 17                        5     2012    10                    Hijo
    ## 18                        5     2013    14                    Hijo
    ## 19                        5     2015    10                    Hijo
    ## 20                        5     2014    20                    Hijo
    ## 21                        6     2012     1                    Hija
    ## 22                        6     2015     1                    Hija
    ## 23                        6     2014     2                    Hija
    ## 24                        6     2013     2                    Hija
    ## 25                        7     2015     1                  Abuelo
    ## 26                        7     2014     2                  Abuelo
    ## 27                        7     2013     4                  Abuelo
    ## 28                        7     2012     5                  Abuelo
    ## 29                        8     2014     8                  Abuela
    ## 30                        8     2013     5                  Abuela
    ## 31                        8     2012     3                  Abuela
    ## 32                        9     2015     3                   Nieto
    ## 33                        9     2013    29                   Nieto
    ## 34                        9     2012     5                   Nieto
    ## 35                        9     2014    19                   Nieto
    ## 36                       10     2012     1                   Nieta
    ## 37                       10     2013     2                   Nieta
    ## 38                       10     2014     1                   Nieta
    ## 39                       11     2014    22         Esposo, Cónyuge
    ## 40                       11     2012    27         Esposo, Cónyuge
    ## 41                       11     2015    30         Esposo, Cónyuge
    ## 42                       11     2013    29         Esposo, Cónyuge
    ## 43                       12     2014    10         Esposa, Cónyuge
    ## 44                       12     2015     2         Esposa, Cónyuge
    ## 45                       12     2013     9         Esposa, Cónyuge
    ## 46                       12     2012     3         Esposa, Cónyuge
    ## 47                       13     2015     8                     Tío
    ## 48                       13     2014     6                     Tío
    ## 49                       13     2013     9                     Tío
    ## 50                       13     2012     7                     Tío
    ## 51                       14     2012     1                     Tía
    ## 52                       15     2012    19                 Sobrino
    ## 53                       15     2013    14                 Sobrino
    ## 54                       15     2015     9                 Sobrino
    ## 55                       15     2014    10                 Sobrino
    ## 56                       17     2014    10                   Primo
    ## 57                       17     2013    15                   Primo
    ## 58                       17     2012    14                   Primo
    ## 59                       17     2015    11                   Primo
    ## 60                       21     2012     1                Bisnieto
    ## 61                       27     2012     2                  Suegro
    ## 62                       27     2015     2                  Suegro
    ## 63                       27     2013     1                  Suegro
    ## 64                       31     2015     4                   Yerno
    ## 65                       31     2014     1                   Yerno
    ## 66                       31     2012     4                   Yerno
    ## 67                       31     2013     5                   Yerno
    ## 68                       33     2015     9                  Cuñado
    ## 69                       33     2014     9                  Cuñado
    ## 70                       33     2013     8                  Cuñado
    ## 71                       33     2012     9                  Cuñado
    ## 72                       34     2012     1                  Cuñada
    ## 73                       35     2014     2                 Concuño
    ## 74                       35     2012     1                 Concuño
    ## 75                       35     2013     1                 Concuño
    ## 76                       37     2012     6               Padrastro
    ## 77                       37     2014     2               Padrastro
    ## 78                       37     2015     6               Padrastro
    ## 79                       37     2013     7               Padrastro
    ## 80                       38     2013     1               Madrastra
    ## 81                       39     2014     1                Hijastro
    ## 82                       39     2013     2                Hijastro
    ## 83                       39     2015     2                Hijastro
    ## 84                       39     2012     2                Hijastro
    ## 85                       41     2012     1             Hermanastro
    ## 86                       41     2014     1             Hermanastro
    ## 87                       41     2013     3             Hermanastro
    ## 88                       45     2012     9    Concubino, compañero
    ## 89                       45     2015    28    Concubino, compañero
    ## 90                       45     2013    27    Concubino, compañero
    ## 91                       45     2014    26    Concubino, compañero
    ## 92                       46     2015     5    Concubina, compañera
    ## 93                       46     2012     4    Concubina, compañera
    ## 94                       46     2014     7    Concubina, compañera
    ## 95                       46     2013     4    Concubina, compañera
    ## 96                       47     2012     3 Amante, Amasio, Querido
    ## 97                       47     2013     1 Amante, Amasio, Querido
    ## 98                       47     2015     1 Amante, Amasio, Querido
    ## 99                       48     2014     1 Amante, Amasia, Querida
    ## 100                      49     2014     2                   Novio
    ## 101                      49     2015     2                   Novio
    ## 102                      49     2013     3                   Novio
    ## 103                      49     2012     2                   Novio
    ## 104                      51     2015     3               Ex esposo
    ## 105                      51     2012     3               Ex esposo
    ## 106                      51     2014     5               Ex esposo
    ## 107                      51     2013     2               Ex esposo
    ## 108                      53     2015     1                 Padrino
    ## 109                      55     2014     1                 Ahijado
    ## 110                      57     2012     1                Compadre
    ## 111                      57     2014     1                Compadre
    ## 112                      57     2015     1                Compadre
    ## 113                      61     2013     1    Trabajador doméstico
    ## 114                      66     2012     5                Conocido
    ## 115                      66     2014     4                Conocido
    ## 116                      66     2015     6                Conocido
    ## 117                      66     2013     6                Conocido
    ## 118                      67     2012     5                  Vecino
    ## 119                      67     2014     4                  Vecino
    ## 120                      67     2015     5                  Vecino
    ## 121                      67     2013     3                  Vecino
    ## 122                      68     2014     1                   Amigo
    ## 123                      68     2013     4                   Amigo
    ## 124                      68     2012     6                   Amigo
    ## 125                      68     2015     2                   Amigo
    ## 126                      69     2012     1                   Amiga
    ## 127                      69     2013     1                   Amiga
    ## 128                      70     2014     7           Otro familiar
    ## 129                      70     2015     1           Otro familiar
    ## 130                      70     2012     3           Otro familiar
    ## 131                      71     2015    12          Sin parentesco
    ## 132                      71     2013     5          Sin parentesco
    ## 133                      71     2012     1          Sin parentesco
    ## 134                      71     2014     7          Sin parentesco
    ## 135                      72     2013   358                 Ninguno
    ## 136                      72     2015   339                 Ninguno
    ## 137                      72     2012   438                 Ninguno
    ## 138                      72     2014   324                 Ninguno
    ## 139                      88     2015    25               No aplica
    ## 140                      88     2014     3               No aplica
    ## 141                      99     2012 25253         No especificado
    ## 142                      99     2015 20205         No especificado
    ## 143                      99     2014 19349         No especificado
    ## 144                      99     2013 22431         No especificado

A plot of female homicide counts (making sure to exclude those that occurred outside Mexico):

``` r
## make sure to only count deaths that occurred inside Mexico (codes 33 to 35 are USA, LATAM and Other)
df <- injury.intent %>%
  filter(sex == "Female" & 
           intent == "Homicide" & 
           !state_occur_death %in% 33:35) %>%
  group_by(year_reg, intent) %>%
  summarise(count = n())
ggplot(df, aes(year_reg, count)) +
  geom_line() +
  labs(title = "Female homicides in Mexico, by year of registration")
```

![](readme_files/figure-markdown_github/unnamed-chunk-4-1.png)

Homicides in the Mexico City metro area (ZM Valle de México), by the state where the murder was *registered*

``` r
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

    ## Loading required package: stringr

![](readme_files/figure-markdown_github/unnamed-chunk-5-1.png)

The drop in homicides in the State of Mexico looks weird, let's plot by where the murder *occurred*

``` r
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

![](readme_files/figure-markdown_github/unnamed-chunk-6-1.png)

So something changed in the way homicides were registered in the State of Mexico and you have to make sure to plot by where the homicide occurred.

Warning
-------

I encourage you to get acquainted with the database since it may contain some errors (introduced at the source) and some fields may be difficult to interpret because of the large number of missing values (see the aggressor relation example). The field *intent.imputed* is the result of running a statistical model to impute the intent of deaths of unknown intent, and is mainly useful to the author of this package. Feel free to ignore the column.

Total Imputed Homicides in Mexico:

``` r
## make sure to only count deaths that occurred inside Mexico (codes 33 to 35 are USA, LATAM and Other)
injury.intent %>%
  filter(intent.imputed == "Homicide" & !state_occur_death %in% 33:35) %>%
  group_by(year_reg) %>%
  summarise(count = n())
```

    ## # A tibble: 12 × 2
    ##    year_reg count
    ##       <int> <int>
    ## 1      2004 10574
    ## 2      2005 11148
    ## 3      2006 11624
    ## 4      2007 10420
    ## 5      2008 15342
    ## 6      2009 21201
    ## 7      2010 27604
    ## 8      2011 30251
    ## 9      2012 28011
    ## 10     2013 25015
    ## 11     2014 21907
    ## 12     2015 22470

License
-------

This package is free and open source software, licensed [MIT](http://en.wikipedia.org/wiki/MIT_License).
