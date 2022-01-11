Injury Intent Deaths 2004-2019 in Mexico
================
Diego Valle-Jones
February 28, 2019

-   [Injury Intent Deaths 2004-2019 in
    Mexico](#injury-intent-deaths-2004-2019-in-mexico)
    -   [What does it do?](#what-does-it-do)
    -   [Installation](#installation)
    -   [Examples](#examples)
    -   [Warning](#warning)
    -   [License](#license)

# Injury Intent Deaths 2004-2019 in Mexico

[![Travis-CI Build
Status](https://travis-ci.org/diegovalle/mxmortalitydb.svg?branch=master)](https://travis-ci.org/diegovalle/mxmortalitydb)

|              |                                                 |
|--------------|-------------------------------------------------|
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

    ## `summarise()` has grouped output by 'year_reg'. You can override using the `.groups` argument.

    ## # A tibble: 17 × 3
    ## # Groups:   year_reg [17]
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

    ## `summarise()` has grouped output by 'year_reg'. You can override using the `.groups` argument.

    ## # A tibble: 14 × 3
    ## # Groups:   year_reg [14]
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

In addition to the injury.intent data.frame several other datasets are
available:

-   **aggressor.relation.code** (relationship between the aggressor and
    his victim, useful for merging aggressor_relationship_code, Spanish)
-   **geo.codes** (names of states and municipios, useful for merging
    state_reg, state_occur_death and mun_reg, mun_occur_death codes)
-   **icd.103** (list of 103 deceases by the WHO, Spanish)
-   **metro.areas** (2010 metro areas as defined by the CONAPO along
    with 2010 population counts)
-   **big.municipios** (since metro areas are not statistical in nature
    this is a list of all municipios which are bigger than the smallest
    metro area but are not part of one)
-   **mex.list.group** (groups of deceases, Spanish)
-   **mex.list** (list of deceases, Spanish)

Homicides merged with the aggressor.relation.code table:

``` r
df <- injury.intent %>%
  filter(intent == "Homicide") %>%
  group_by(year_reg, aggressor_relation_code) %>%
  summarise(count = n())
```

    ## `summarise()` has grouped output by 'year_reg'. You can override using the `.groups` argument.

``` r
## A couple of other tables are included in the package to
## interpret some of the values in injury.intent
merge(df, aggressor.relation.code)
```

    ##     aggressor_relation_code year_reg count            relationship
    ## 1                         1     2012    25                   Padre
    ## 2                         1     2020     6                   Padre
    ## 3                         1     2017     7                   Padre
    ## 4                         1     2016    13                   Padre
    ## 5                         1     2015     7                   Padre
    ## 6                         1     2019     4                   Padre
    ## 7                         1     2018     6                   Padre
    ## 8                         1     2014   107                   Padre
    ## 9                         1     2013    18                   Padre
    ## 10                        2     2016     9                   Madre
    ## 11                        2     2017     2                   Madre
    ## 12                        2     2013    17                   Madre
    ## 13                        2     2019     6                   Madre
    ## 14                        2     2020     1                   Madre
    ## 15                        2     2015    11                   Madre
    ## 16                        2     2018     8                   Madre
    ## 17                        2     2014    16                   Madre
    ## 18                        2     2012    64                   Madre
    ## 19                        3     2017    13                 Hermano
    ## 20                        3     2019     5                 Hermano
    ## 21                        3     2014    13                 Hermano
    ## 22                        3     2015     9                 Hermano
    ## 23                        3     2013    16                 Hermano
    ## 24                        3     2016    11                 Hermano
    ## 25                        3     2018    14                 Hermano
    ## 26                        3     2020     4                 Hermano
    ## 27                        3     2012    14                 Hermano
    ## 28                        4     2015     2                 Hermana
    ## 29                        4     2014     9                 Hermana
    ## 30                        4     2018     4                 Hermana
    ## 31                        4     2013     6                 Hermana
    ## 32                        4     2017     5                 Hermana
    ## 33                        4     2019     4                 Hermana
    ## 34                        4     2012     7                 Hermana
    ## 35                        4     2016     4                 Hermana
    ## 36                        5     2018    11                    Hijo
    ## 37                        5     2017     9                    Hijo
    ## 38                        5     2012    10                    Hijo
    ## 39                        5     2019     7                    Hijo
    ## 40                        5     2013    14                    Hijo
    ## 41                        5     2015    10                    Hijo
    ## 42                        5     2020     5                    Hijo
    ## 43                        5     2016    13                    Hijo
    ## 44                        5     2014    20                    Hijo
    ## 45                        6     2019     1                    Hija
    ## 46                        6     2013     2                    Hija
    ## 47                        6     2018     2                    Hija
    ## 48                        6     2015     1                    Hija
    ## 49                        6     2016     3                    Hija
    ## 50                        6     2012     1                    Hija
    ## 51                        6     2014     2                    Hija
    ## 52                        7     2019     1                  Abuelo
    ## 53                        7     2013     4                  Abuelo
    ## 54                        7     2012     5                  Abuelo
    ## 55                        7     2015     1                  Abuelo
    ## 56                        7     2016     1                  Abuelo
    ## 57                        7     2014     2                  Abuelo
    ## 58                        8     2012     3                  Abuela
    ## 59                        8     2014     8                  Abuela
    ## 60                        8     2013     5                  Abuela
    ## 61                        8     2016     1                  Abuela
    ## 62                        9     2015     3                   Nieto
    ## 63                        9     2019     2                   Nieto
    ## 64                        9     2012     5                   Nieto
    ## 65                        9     2017     3                   Nieto
    ## 66                        9     2013    29                   Nieto
    ## 67                        9     2016     4                   Nieto
    ## 68                        9     2018     1                   Nieto
    ## 69                        9     2014    19                   Nieto
    ## 70                       10     2019     1                   Nieta
    ## 71                       10     2012     1                   Nieta
    ## 72                       10     2014     1                   Nieta
    ## 73                       10     2013     2                   Nieta
    ## 74                       11     2014    22         Esposo, Cónyuge
    ## 75                       11     2012    27         Esposo, Cónyuge
    ## 76                       11     2017     9         Esposo, Cónyuge
    ## 77                       11     2015    30         Esposo, Cónyuge
    ## 78                       11     2019     7         Esposo, Cónyuge
    ## 79                       11     2016    24         Esposo, Cónyuge
    ## 80                       11     2020     9         Esposo, Cónyuge
    ## 81                       11     2018    15         Esposo, Cónyuge
    ## 82                       11     2013    29         Esposo, Cónyuge
    ## 83                       12     2014    10         Esposa, Cónyuge
    ## 84                       12     2017     2         Esposa, Cónyuge
    ## 85                       12     2015     2         Esposa, Cónyuge
    ## 86                       12     2012     3         Esposa, Cónyuge
    ## 87                       12     2016     4         Esposa, Cónyuge
    ## 88                       12     2020     8         Esposa, Cónyuge
    ## 89                       12     2018     5         Esposa, Cónyuge
    ## 90                       12     2019    16         Esposa, Cónyuge
    ## 91                       12     2013     9         Esposa, Cónyuge
    ## 92                       13     2014     6                     Tío
    ## 93                       13     2016    13                     Tío
    ## 94                       13     2015     8                     Tío
    ## 95                       13     2018     2                     Tío
    ## 96                       13     2019     2                     Tío
    ## 97                       13     2012     7                     Tío
    ## 98                       13     2013     9                     Tío
    ## 99                       13     2017     6                     Tío
    ## 100                      14     2012     1                     Tía
    ## 101                      14     2018     1                     Tía
    ## 102                      15     2012    19                 Sobrino
    ## 103                      15     2015     9                 Sobrino
    ## 104                      15     2013    14                 Sobrino
    ## 105                      15     2019     5                 Sobrino
    ## 106                      15     2014    10                 Sobrino
    ## 107                      15     2017     9                 Sobrino
    ## 108                      15     2018     4                 Sobrino
    ## 109                      15     2016     4                 Sobrino
    ## 110                      16     2016     1                 Sobrina
    ## 111                      17     2017    13                   Primo
    ## 112                      17     2013    15                   Primo
    ## 113                      17     2020     4                   Primo
    ## 114                      17     2016     9                   Primo
    ## 115                      17     2014    10                   Primo
    ## 116                      17     2019     3                   Primo
    ## 117                      17     2018    10                   Primo
    ## 118                      17     2012    14                   Primo
    ## 119                      17     2015    11                   Primo
    ## 120                      18     2016     1                   Prima
    ## 121                      21     2012     1                Bisnieto
    ## 122                      27     2017     2                  Suegro
    ## 123                      27     2012     2                  Suegro
    ## 124                      27     2016     1                  Suegro
    ## 125                      27     2018     3                  Suegro
    ## 126                      27     2015     2                  Suegro
    ## 127                      27     2013     1                  Suegro
    ## 128                      31     2015     4                   Yerno
    ## 129                      31     2018     3                   Yerno
    ## 130                      31     2013     5                   Yerno
    ## 131                      31     2012     4                   Yerno
    ## 132                      31     2016     3                   Yerno
    ## 133                      31     2017     4                   Yerno
    ## 134                      31     2014     1                   Yerno
    ## 135                      32     2018     1                   Nuera
    ## 136                      33     2014     9                  Cuñado
    ## 137                      33     2016     3                  Cuñado
    ## 138                      33     2015     9                  Cuñado
    ## 139                      33     2017     6                  Cuñado
    ## 140                      33     2018     7                  Cuñado
    ## 141                      33     2019     1                  Cuñado
    ## 142                      33     2012     9                  Cuñado
    ## 143                      33     2013     8                  Cuñado
    ## 144                      34     2012     1                  Cuñada
    ## 145                      35     2013     1                 Concuño
    ## 146                      35     2012     1                 Concuño
    ## 147                      35     2014     2                 Concuño
    ## 148                      35     2017     2                 Concuño
    ## 149                      37     2020     2               Padrastro
    ## 150                      37     2013     7               Padrastro
    ## 151                      37     2018     2               Padrastro
    ## 152                      37     2015     6               Padrastro
    ## 153                      37     2017     2               Padrastro
    ## 154                      37     2019     1               Padrastro
    ## 155                      37     2012     6               Padrastro
    ## 156                      37     2014     2               Padrastro
    ## 157                      37     2016     6               Padrastro
    ## 158                      38     2013     1               Madrastra
    ## 159                      39     2017     1                Hijastro
    ## 160                      39     2012     2                Hijastro
    ## 161                      39     2013     2                Hijastro
    ## 162                      39     2015     2                Hijastro
    ## 163                      39     2014     1                Hijastro
    ## 164                      39     2016     1                Hijastro
    ## 165                      41     2012     1             Hermanastro
    ## 166                      41     2020     1             Hermanastro
    ## 167                      41     2014     1             Hermanastro
    ## 168                      41     2013     3             Hermanastro
    ## 169                      41     2018     1             Hermanastro
    ## 170                      45     2017    21    Concubino, compañero
    ## 171                      45     2012     9    Concubino, compañero
    ## 172                      45     2019     5    Concubino, compañero
    ## 173                      45     2013    27    Concubino, compañero
    ## 174                      45     2020     7    Concubino, compañero
    ## 175                      45     2014    26    Concubino, compañero
    ## 176                      45     2016    25    Concubino, compañero
    ## 177                      45     2015    28    Concubino, compañero
    ## 178                      45     2018    10    Concubino, compañero
    ## 179                      46     2012     4    Concubina, compañera
    ## 180                      46     2017     4    Concubina, compañera
    ## 181                      46     2016     6    Concubina, compañera
    ## 182                      46     2013     4    Concubina, compañera
    ## 183                      46     2014     7    Concubina, compañera
    ## 184                      46     2015     5    Concubina, compañera
    ## 185                      47     2016     2 Amante, Amasio, Querido
    ## 186                      47     2019     1 Amante, Amasio, Querido
    ## 187                      47     2015     1 Amante, Amasio, Querido
    ## 188                      47     2017     1 Amante, Amasio, Querido
    ## 189                      47     2013     1 Amante, Amasio, Querido
    ## 190                      47     2012     3 Amante, Amasio, Querido
    ## 191                      48     2014     1 Amante, Amasia, Querida
    ## 192                      49     2014     2                   Novio
    ## 193                      49     2019     1                   Novio
    ## 194                      49     2017     1                   Novio
    ## 195                      49     2013     3                   Novio
    ## 196                      49     2016     4                   Novio
    ## 197                      49     2012     2                   Novio
    ## 198                      49     2015     2                   Novio
    ## 199                      50     2018     1                   Novia
    ## 200                      51     2018     6               Ex esposo
    ## 201                      51     2014     5               Ex esposo
    ## 202                      51     2017     3               Ex esposo
    ## 203                      51     2020     3               Ex esposo
    ## 204                      51     2016     4               Ex esposo
    ## 205                      51     2013     2               Ex esposo
    ## 206                      51     2012     3               Ex esposo
    ## 207                      51     2015     3               Ex esposo
    ## 208                      52     2016     2               Ex esposa
    ## 209                      53     2015     1                 Padrino
    ## 210                      55     2014     1                 Ahijado
    ## 211                      57     2019     1                Compadre
    ## 212                      57     2012     1                Compadre
    ## 213                      57     2015     1                Compadre
    ## 214                      57     2014     1                Compadre
    ## 215                      61     2013     1    Trabajador doméstico
    ## 216                      66     2012     5                Conocido
    ## 217                      66     2020     7                Conocido
    ## 218                      66     2019     5                Conocido
    ## 219                      66     2018     7                Conocido
    ## 220                      66     2013     6                Conocido
    ## 221                      66     2015     6                Conocido
    ## 222                      66     2014     4                Conocido
    ## 223                      66     2017    11                Conocido
    ## 224                      66     2016    15                Conocido
    ## 225                      67     2019     4                  Vecino
    ## 226                      67     2018     5                  Vecino
    ## 227                      67     2014     4                  Vecino
    ## 228                      67     2016     5                  Vecino
    ## 229                      67     2012     5                  Vecino
    ## 230                      67     2015     5                  Vecino
    ## 231                      67     2017     8                  Vecino
    ## 232                      67     2020     5                  Vecino
    ## 233                      67     2013     3                  Vecino
    ## 234                      68     2019     2                   Amigo
    ## 235                      68     2012     6                   Amigo
    ## 236                      68     2018     3                   Amigo
    ## 237                      68     2013     4                   Amigo
    ## 238                      68     2016     5                   Amigo
    ## 239                      68     2015     2                   Amigo
    ## 240                      68     2014     1                   Amigo
    ## 241                      68     2017     3                   Amigo
    ## 242                      68     2020     1                   Amigo
    ## 243                      69     2013     1                   Amiga
    ## 244                      69     2012     1                   Amiga
    ## 245                      70     2016     3           Otro familiar
    ## 246                      70     2017     1           Otro familiar
    ## 247                      70     2014     7           Otro familiar
    ## 248                      70     2018    10           Otro familiar
    ## 249                      70     2019     1           Otro familiar
    ## 250                      70     2012     3           Otro familiar
    ##  [ reached 'max' / getOption("max.print") -- omitted 35 rows ]

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

    ## `summarise()` has grouped output by 'year_reg'. You can override using the `.groups` argument.

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

    ## `summarise()` has grouped output by 'state_reg'. You can override using the `.groups` argument.

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

    ## `summarise()` has grouped output by 'state_occur_death'. You can override using the `.groups` argument.

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

    ## # A tibble: 17 × 2
    ##    year_reg count
    ##       <int> <int>
    ##  1     2004 10608
    ##  2     2005 11197
    ##  3     2006 11664
    ##  4     2007 10620
    ##  5     2008 15540
    ##  6     2009 21319
    ##  7     2010 27716
    ##  8     2011 30410
    ##  9     2012 28212
    ## 10     2013 25242
    ## 11     2014 22132
    ## 12     2015 22776
    ## 13     2016 26738
    ## 14     2017 34857
    ## 15     2018 39642
    ## 16     2019 39929
    ## 17     2020 39287

## License

This package is free and open source software, licensed
[MIT](http://en.wikipedia.org/wiki/MIT_License).
