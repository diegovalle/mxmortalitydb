Injury Intent Deaths 2004-2019 in Mexico
================
Diego Valle-Jones
February 28, 2019

  - [Injury Intent Deaths 2004-2019 in
    Mexico](#injury-intent-deaths-2004-2019-in-mexico)
      - [What does it do?](#what-does-it-do)
      - [Installation](#installation)
      - [Examples](#examples)
      - [Warning](#warning)
      - [License](#license)

# Injury Intent Deaths 2004-2019 in Mexico

[![Travis-CI Build
Status](https://travis-ci.org/diegovalle/mxmortalitydb.svg?branch=master)](https://travis-ci.org/diegovalle/mxmortalitydb)

|              |                                                 |
| ------------ | ----------------------------------------------- |
| **Author:**  | Diego Valle-Jones                               |
| **License:** | [MIT](http://en.wikipedia.org/wiki/MIT_License) |
| **Website:** | <https://github.com/diegovalle/mxmortalitydb>   |

## What does it do?

This is a data only package containing all injury intent deaths
(accidents, suicides, homicides, legal interventions, and deaths of
unspecified intent) registered by the SSA/INEGI from 2004 to 2019. The
data source for the database is the
[INEGI](http://www.inegi.org.mx/est/contenidos/proyectos/registros/vitales/mortalidad/default.aspx).
In addition the data was coded with the Injury Mortality Matrix provided
by the [CDC](http://www.cdc.gov/nchs/data/ice/icd10_transcode.pdf). The
code used to clean the database is available [as a separate
program](https://github.com/diegovalle/death.index)

## Installation

For the moment this package is only available from github. For the
development version:

``` r
if (!require(devtools)) {
    install.packages("devtools")
}
devtools::install_github('diegovalle/mxmortalitydb')
```

``` r
library(mxmortalitydb)
library(ggplot2)
suppressPackageStartupMessages(library(dplyr))
```

## Examples

Deaths by homicide in Mexico

``` r
injury.intent %>%
  filter(intent == "Homicide") %>%
  group_by(year_reg, intent) %>%
  summarise(count = n())
```

    ## `summarise()` regrouping output by 'year_reg' (override with `.groups` argument)

    ## # A tibble: 16 x 3
    ## # Groups:   year_reg [16]
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

All deaths of unknown intent in Sinaloa (state code 25) where the injury
mechanism was a firearm, by year of registration:

``` r
## The main data.frame in the package is called injury.intent
injury.intent %>%
  filter(is.na(intent)  & 
           mechanism == "Firearm" & 
           state_reg == 25 ) %>%
  group_by(year_reg, intent) %>%
  summarise(count = n())
```

    ## `summarise()` regrouping output by 'year_reg' (override with `.groups` argument)

    ## # A tibble: 13 x 3
    ## # Groups:   year_reg [13]
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

In addition to the injury.intent data.frame several other datasets are
available:

  - **aggressor.relation.code** (relationship between the aggressor and
    his victim, useful for merging aggressor\_relationship\_code,
    Spanish)
  - **geo.codes** (names of states and municipios, useful for merging
    state\_reg, state\_occur\_death and mun\_reg, mun\_occur\_death
    codes)
  - **icd.103** (list of 103 deceases by the WHO, Spanish)
  - **metro.areas** (2010 metro areas as defined by the CONAPO along
    with 2010 population counts)
  - **big.municipios** (since metro areas are not statistical in nature
    this is a list of all municipios which are bigger than the smallest
    metro area but are not part of one)
  - **mex.list.group** (groups of deceases, Spanish)
  - **mex.list** (list of deceases, Spanish)

Homicides merged with the aggressor.relation.code table:

``` r
df <- injury.intent %>%
  filter(intent == "Homicide") %>%
  group_by(year_reg, aggressor_relation_code) %>%
  summarise(count = n())
```

    ## `summarise()` regrouping output by 'year_reg' (override with `.groups` argument)

``` r
## A couple of other tables are included in the package to
## interpret some of the values in injury.intent
merge(df, aggressor.relation.code)
```

    ##     aggressor_relation_code year_reg count            relationship
    ## 1                         1     2012    25                   Padre
    ## 2                         1     2019     4                   Padre
    ## 3                         1     2017     7                   Padre
    ## 4                         1     2016    13                   Padre
    ## 5                         1     2015     7                   Padre
    ## 6                         1     2014   107                   Padre
    ## 7                         1     2018     6                   Padre
    ## 8                         1     2013    18                   Padre
    ## 9                         2     2016     9                   Madre
    ## 10                        2     2017     2                   Madre
    ## 11                        2     2019     6                   Madre
    ## 12                        2     2015    11                   Madre
    ## 13                        2     2018     8                   Madre
    ## 14                        2     2014    16                   Madre
    ## 15                        2     2012    64                   Madre
    ## 16                        2     2013    17                   Madre
    ## 17                        3     2017    13                 Hermano
    ## 18                        3     2015     9                 Hermano
    ## 19                        3     2018    14                 Hermano
    ## 20                        3     2014    13                 Hermano
    ## 21                        3     2013    16                 Hermano
    ## 22                        3     2016    11                 Hermano
    ## 23                        3     2019     5                 Hermano
    ## 24                        3     2012    14                 Hermano
    ## 25                        4     2015     2                 Hermana
    ## 26                        4     2019     4                 Hermana
    ## 27                        4     2018     4                 Hermana
    ## 28                        4     2014     9                 Hermana
    ## 29                        4     2012     7                 Hermana
    ## 30                        4     2013     6                 Hermana
    ## 31                        4     2017     5                 Hermana
    ## 32                        4     2016     4                 Hermana
    ## 33                        5     2019     7                    Hijo
    ## 34                        5     2012    10                    Hijo
    ## 35                        5     2013    14                    Hijo
    ## 36                        5     2018    11                    Hijo
    ## 37                        5     2017     9                    Hijo
    ## 38                        5     2016    13                    Hijo
    ## 39                        5     2014    20                    Hijo
    ## 40                        5     2015    10                    Hijo
    ## 41                        6     2012     1                    Hija
    ## 42                        6     2019     1                    Hija
    ## 43                        6     2016     3                    Hija
    ## 44                        6     2014     2                    Hija
    ## 45                        6     2013     2                    Hija
    ## 46                        6     2018     2                    Hija
    ## 47                        6     2015     1                    Hija
    ## 48                        7     2016     1                  Abuelo
    ## 49                        7     2014     2                  Abuelo
    ## 50                        7     2019     1                  Abuelo
    ## 51                        7     2013     4                  Abuelo
    ## 52                        7     2015     1                  Abuelo
    ## 53                        7     2012     5                  Abuelo
    ## 54                        8     2012     3                  Abuela
    ## 55                        8     2013     5                  Abuela
    ## 56                        8     2014     8                  Abuela
    ## 57                        8     2016     1                  Abuela
    ## 58                        9     2015     3                   Nieto
    ## 59                        9     2019     2                   Nieto
    ## 60                        9     2012     5                   Nieto
    ## 61                        9     2017     3                   Nieto
    ## 62                        9     2013    29                   Nieto
    ## 63                        9     2016     4                   Nieto
    ## 64                        9     2018     1                   Nieto
    ## 65                        9     2014    19                   Nieto
    ## 66                       10     2019     1                   Nieta
    ## 67                       10     2012     1                   Nieta
    ## 68                       10     2014     1                   Nieta
    ## 69                       10     2013     2                   Nieta
    ## 70                       11     2014    22         Esposo, Cónyuge
    ## 71                       11     2017     9         Esposo, Cónyuge
    ## 72                       11     2012    27         Esposo, Cónyuge
    ## 73                       11     2016    24         Esposo, Cónyuge
    ## 74                       11     2019     7         Esposo, Cónyuge
    ## 75                       11     2018    15         Esposo, Cónyuge
    ## 76                       11     2015    30         Esposo, Cónyuge
    ## 77                       11     2013    29         Esposo, Cónyuge
    ## 78                       12     2017     2         Esposa, Cónyuge
    ## 79                       12     2016     4         Esposa, Cónyuge
    ## 80                       12     2015     2         Esposa, Cónyuge
    ## 81                       12     2014    10         Esposa, Cónyuge
    ## 82                       12     2018     5         Esposa, Cónyuge
    ## 83                       12     2013     9         Esposa, Cónyuge
    ## 84                       12     2019    16         Esposa, Cónyuge
    ## 85                       12     2012     3         Esposa, Cónyuge
    ## 86                       13     2017     6                     Tío
    ## 87                       13     2018     2                     Tío
    ## 88                       13     2015     8                     Tío
    ## 89                       13     2014     6                     Tío
    ## 90                       13     2016    13                     Tío
    ## 91                       13     2012     7                     Tío
    ## 92                       13     2013     9                     Tío
    ## 93                       13     2019     2                     Tío
    ## 94                       14     2018     1                     Tía
    ## 95                       14     2012     1                     Tía
    ## 96                       15     2012    19                 Sobrino
    ## 97                       15     2013    14                 Sobrino
    ## 98                       15     2015     9                 Sobrino
    ## 99                       15     2017     9                 Sobrino
    ## 100                      15     2018     4                 Sobrino
    ## 101                      15     2016     4                 Sobrino
    ## 102                      15     2019     5                 Sobrino
    ## 103                      15     2014    10                 Sobrino
    ## 104                      16     2016     1                 Sobrina
    ## 105                      17     2017    13                   Primo
    ## 106                      17     2018    10                   Primo
    ## 107                      17     2014    10                   Primo
    ## 108                      17     2013    15                   Primo
    ## 109                      17     2012    14                   Primo
    ## 110                      17     2016     9                   Primo
    ## 111                      17     2015    11                   Primo
    ## 112                      17     2019     3                   Primo
    ## 113                      18     2016     1                   Prima
    ## 114                      21     2012     1                Bisnieto
    ## 115                      27     2018     3                  Suegro
    ## 116                      27     2012     2                  Suegro
    ## 117                      27     2017     2                  Suegro
    ## 118                      27     2016     1                  Suegro
    ## 119                      27     2015     2                  Suegro
    ## 120                      27     2013     1                  Suegro
    ## 121                      31     2015     4                   Yerno
    ## 122                      31     2012     4                   Yerno
    ## 123                      31     2018     3                   Yerno
    ## 124                      31     2013     5                   Yerno
    ## 125                      31     2016     3                   Yerno
    ## 126                      31     2017     4                   Yerno
    ## 127                      31     2014     1                   Yerno
    ## 128                      32     2018     1                   Nuera
    ## 129                      33     2015     9                  Cuñado
    ## 130                      33     2012     9                  Cuñado
    ## 131                      33     2017     6                  Cuñado
    ## 132                      33     2014     9                  Cuñado
    ## 133                      33     2019     1                  Cuñado
    ## 134                      33     2013     8                  Cuñado
    ## 135                      33     2018     7                  Cuñado
    ## 136                      33     2016     3                  Cuñado
    ## 137                      34     2012     1                  Cuñada
    ## 138                      35     2014     2                 Concuño
    ## 139                      35     2012     1                 Concuño
    ## 140                      35     2013     1                 Concuño
    ## 141                      35     2017     2                 Concuño
    ## 142                      37     2015     6               Padrastro
    ## 143                      37     2019     1               Padrastro
    ## 144                      37     2012     6               Padrastro
    ## 145                      37     2018     2               Padrastro
    ## 146                      37     2013     7               Padrastro
    ## 147                      37     2014     2               Padrastro
    ## 148                      37     2017     2               Padrastro
    ## 149                      37     2016     6               Padrastro
    ## 150                      38     2013     1               Madrastra
    ## 151                      39     2012     2                Hijastro
    ## 152                      39     2017     1                Hijastro
    ## 153                      39     2014     1                Hijastro
    ## 154                      39     2013     2                Hijastro
    ## 155                      39     2015     2                Hijastro
    ## 156                      39     2016     1                Hijastro
    ## 157                      41     2012     1             Hermanastro
    ## 158                      41     2014     1             Hermanastro
    ## 159                      41     2013     3             Hermanastro
    ## 160                      41     2018     1             Hermanastro
    ## 161                      45     2018    10    Concubino, compañero
    ## 162                      45     2014    26    Concubino, compañero
    ## 163                      45     2012     9    Concubino, compañero
    ## 164                      45     2017    21    Concubino, compañero
    ## 165                      45     2013    27    Concubino, compañero
    ## 166                      45     2015    28    Concubino, compañero
    ## 167                      45     2019     5    Concubino, compañero
    ## 168                      45     2016    25    Concubino, compañero
    ## 169                      46     2014     7    Concubina, compañera
    ## 170                      46     2017     4    Concubina, compañera
    ## 171                      46     2013     4    Concubina, compañera
    ## 172                      46     2016     6    Concubina, compañera
    ## 173                      46     2012     4    Concubina, compañera
    ## 174                      46     2015     5    Concubina, compañera
    ## 175                      47     2012     3 Amante, Amasio, Querido
    ## 176                      47     2013     1 Amante, Amasio, Querido
    ## 177                      47     2019     1 Amante, Amasio, Querido
    ## 178                      47     2016     2 Amante, Amasio, Querido
    ## 179                      47     2017     1 Amante, Amasio, Querido
    ## 180                      47     2015     1 Amante, Amasio, Querido
    ## 181                      48     2014     1 Amante, Amasia, Querida
    ## 182                      49     2012     2                   Novio
    ## 183                      49     2015     2                   Novio
    ## 184                      49     2016     4                   Novio
    ## 185                      49     2019     1                   Novio
    ## 186                      49     2014     2                   Novio
    ## 187                      49     2017     1                   Novio
    ## 188                      49     2013     3                   Novio
    ## 189                      50     2018     1                   Novia
    ## 190                      51     2018     6               Ex esposo
    ## 191                      51     2012     3               Ex esposo
    ## 192                      51     2014     5               Ex esposo
    ## 193                      51     2016     4               Ex esposo
    ## 194                      51     2017     3               Ex esposo
    ## 195                      51     2015     3               Ex esposo
    ## 196                      51     2013     2               Ex esposo
    ## 197                      52     2016     2               Ex esposa
    ## 198                      53     2015     1                 Padrino
    ## 199                      55     2014     1                 Ahijado
    ## 200                      57     2014     1                Compadre
    ## 201                      57     2019     1                Compadre
    ## 202                      57     2015     1                Compadre
    ## 203                      57     2012     1                Compadre
    ## 204                      61     2013     1    Trabajador doméstico
    ## 205                      66     2019     5                Conocido
    ## 206                      66     2018     7                Conocido
    ## 207                      66     2014     4                Conocido
    ## 208                      66     2013     6                Conocido
    ## 209                      66     2012     5                Conocido
    ## 210                      66     2015     6                Conocido
    ## 211                      66     2016    15                Conocido
    ## 212                      66     2017    11                Conocido
    ## 213                      67     2018     5                  Vecino
    ## 214                      67     2019     4                  Vecino
    ## 215                      67     2015     5                  Vecino
    ## 216                      67     2016     5                  Vecino
    ## 217                      67     2014     4                  Vecino
    ## 218                      67     2012     5                  Vecino
    ## 219                      67     2017     8                  Vecino
    ## 220                      67     2013     3                  Vecino
    ## 221                      68     2018     3                   Amigo
    ## 222                      68     2019     2                   Amigo
    ## 223                      68     2012     6                   Amigo
    ## 224                      68     2017     3                   Amigo
    ## 225                      68     2016     5                   Amigo
    ## 226                      68     2015     2                   Amigo
    ## 227                      68     2014     1                   Amigo
    ## 228                      68     2013     4                   Amigo
    ## 229                      69     2012     1                   Amiga
    ## 230                      69     2013     1                   Amiga
    ## 231                      70     2019     1           Otro familiar
    ## 232                      70     2012     3           Otro familiar
    ## 233                      70     2015     1           Otro familiar
    ## 234                      70     2018    10           Otro familiar
    ## 235                      70     2017     1           Otro familiar
    ## 236                      70     2016     3           Otro familiar
    ## 237                      70     2014     7           Otro familiar
    ## 238                      71     2012     1          Sin parentesco
    ## 239                      71     2019   115          Sin parentesco
    ## 240                      71     2013     5          Sin parentesco
    ## 241                      71     2015    12          Sin parentesco
    ## 242                      71     2014     7          Sin parentesco
    ## 243                      71     2017    22          Sin parentesco
    ## 244                      71     2018    14          Sin parentesco
    ## 245                      71     2016    19          Sin parentesco
    ## 246                      72     2014   324                 Ninguno
    ## 247                      72     2019     1                 Ninguno
    ## 248                      72     2018   111                 Ninguno
    ## 249                      72     2013   358                 Ninguno
    ## 250                      72     2012   438                 Ninguno
    ##  [ reached 'max' / getOption("max.print") -- omitted 17 rows ]

A plot of female homicide counts (making sure to exclude those that
occurred outside Mexico):

``` r
## make sure to only count deaths that occurred inside Mexico (codes 33 to 35 are USA, LATAM and Other)
df <- injury.intent %>%
  filter(sex == "Female" & 
           intent == "Homicide" & 
           !state_occur_death %in% 33:35) %>%
  group_by(year_reg, intent) %>%
  summarise(count = n())
```

    ## `summarise()` regrouping output by 'year_reg' (override with `.groups` argument)

``` r
ggplot(df, aes(year_reg, count)) +
  geom_line() +
  labs(title = "Female homicides in Mexico, by year of registration")
```

![](readme_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

Homicides in the Mexico City metro area (ZM Valle de México), by the
state where the murder was *registered*

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

    ## `summarise()` regrouping output by 'state_reg' (override with `.groups` argument)

![](readme_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

The drop in homicides in the State of Mexico looks weird, let’s plot by
where the murder *occurred*

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

    ## `summarise()` regrouping output by 'state_occur_death' (override with `.groups` argument)

![](readme_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

So something changed in the way homicides were registered in the State
of Mexico and you have to make sure to plot by where the homicide
occurred.

## Warning

I encourage you to get acquainted with the database since it may contain
some errors (introduced at the source) and some fields may be difficult
to interpret because of the large number of missing values (see the
aggressor relation example). The field *intent.imputed* is the result of
running a statistical model to impute the intent of deaths of unknown
intent, and is mainly useful to the author of this package. Feel free to
ignore the column.

Total Imputed Homicides in Mexico:

``` r
## make sure to only count deaths that occurred inside Mexico (codes 33 to 35 are USA, LATAM and Other)
injury.intent %>%
  filter(intent.imputed == "Homicide" & !state_occur_death %in% 33:35) %>%
  group_by(year_reg) %>%
  summarise(count = n())
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

    ## # A tibble: 16 x 2
    ##    year_reg count
    ##       <int> <int>
    ##  1     2004 10642
    ##  2     2005 11232
    ##  3     2006 11719
    ##  4     2007 10699
    ##  5     2008 15576
    ##  6     2009 21355
    ##  7     2010 27734
    ##  8     2011 30486
    ##  9     2012 28222
    ## 10     2013 25278
    ## 11     2014 22168
    ## 12     2015 22829
    ## 13     2016 26762
    ## 14     2017 34962
    ## 15     2018 39694
    ## 16     2019 39990

## License

This package is free and open source software, licensed
[MIT](http://en.wikipedia.org/wiki/MIT_License).
