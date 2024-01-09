Injury Intent Deaths 2004-2022 in Mexico
================
Diego Valle-Jones
December 30, 2023

- [Injury Intent Deaths 2004-2022 in
  Mexico](#injury-intent-deaths-2004-2022-in-mexico)
  - [What does it do?](#what-does-it-do)
  - [Installation](#installation)
  - [Examples](#examples)
  - [Warning](#warning)
  - [License](#license)

# Injury Intent Deaths 2004-2022 in Mexico

|              |                                                 |
|--------------|-------------------------------------------------|
| **Author:**  | Diego Valle-Jones                               |
| **License:** | [MIT](http://en.wikipedia.org/wiki/MIT_License) |
| **Website:** | <https://github.com/diegovalle/mxmortalitydb>   |

## What does it do?

This is a data only package containing all injury intent deaths
(accidents, suicides, homicides, legal interventions, and deaths of
unspecified intent) registered by the SSA/INEGI from 2004 to 2022. The
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

    ## `summarise()` has grouped output by 'year_reg'. You can override using the
    ## `.groups` argument.

    ## # A tibble: 19 × 3
    ## # Groups:   year_reg [19]
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

    ## `summarise()` has grouped output by 'year_reg'. You can override using the
    ## `.groups` argument.

    ## # A tibble: 16 × 3
    ## # Groups:   year_reg [16]
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

In addition to the injury.intent data.frame several other datasets are
available:

- **aggressor.relation.code** (relationship between the aggressor and
  his victim, useful for merging aggressor_relationship_code, Spanish)
- **geo.codes** (names of states and municipios, useful for merging
  state_reg, state_occur_death and mun_reg, mun_occur_death codes)
- **icd.103** (list of 103 deceases by the WHO, Spanish)
- **metro.areas** (2010 metro areas as defined by the CONAPO along with
  2010 population counts)
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

    ## `summarise()` has grouped output by 'year_reg'. You can override using the
    ## `.groups` argument.

``` r
## A couple of other tables are included in the package to
## interpret some of the values in injury.intent
merge(df, aggressor.relation.code)
```

    ##     aggressor_relation_code year_reg count            relationship
    ## 1                         1     2012    25                   Padre
    ## 2                         1     2020     6                   Padre
    ## 3                         1     2022     9                   Padre
    ## 4                         1     2016    13                   Padre
    ## 5                         1     2021     4                   Padre
    ## 6                         1     2017     7                   Padre
    ## 7                         1     2018     6                   Padre
    ## 8                         1     2019     4                   Padre
    ## 9                         1     2013    18                   Padre
    ## 10                        1     2015     7                   Padre
    ## 11                        1     2014   107                   Padre
    ## 12                        2     2016     9                   Madre
    ## 13                        2     2022     5                   Madre
    ## 14                        2     2019     6                   Madre
    ## 15                        2     2017     2                   Madre
    ## 16                        2     2015    11                   Madre
    ## 17                        2     2020     1                   Madre
    ## 18                        2     2013    17                   Madre
    ## 19                        2     2021     4                   Madre
    ## 20                        2     2018     8                   Madre
    ## 21                        2     2014    16                   Madre
    ## 22                        2     2012    64                   Madre
    ## 23                        3     2019     5                 Hermano
    ## 24                        3     2022    14                 Hermano
    ## 25                        3     2015     9                 Hermano
    ## 26                        3     2017    13                 Hermano
    ## 27                        3     2014    13                 Hermano
    ## 28                        3     2016    11                 Hermano
    ## 29                        3     2020     4                 Hermano
    ## 30                        3     2012    14                 Hermano
    ## 31                        3     2013    16                 Hermano
    ## 32                        3     2021     7                 Hermano
    ## 33                        3     2018    14                 Hermano
    ## 34                        4     2017     5                 Hermana
    ## 35                        4     2022     2                 Hermana
    ## 36                        4     2019     4                 Hermana
    ## 37                        4     2013     6                 Hermana
    ## 38                        4     2021     5                 Hermana
    ## 39                        4     2015     2                 Hermana
    ## 40                        4     2016     4                 Hermana
    ## 41                        4     2018     4                 Hermana
    ## 42                        4     2014     9                 Hermana
    ## 43                        4     2012     7                 Hermana
    ## 44                        5     2020     5                    Hijo
    ## 45                        5     2018    11                    Hijo
    ## 46                        5     2017     9                    Hijo
    ## 47                        5     2022    11                    Hijo
    ## 48                        5     2012    10                    Hijo
    ## 49                        5     2019     7                    Hijo
    ## 50                        5     2021    16                    Hijo
    ## 51                        5     2015    10                    Hijo
    ## 52                        5     2014    20                    Hijo
    ## 53                        5     2013    14                    Hijo
    ## 54                        5     2016    13                    Hijo
    ## 55                        6     2022     1                    Hija
    ## 56                        6     2019     1                    Hija
    ## 57                        6     2018     2                    Hija
    ## 58                        6     2015     1                    Hija
    ## 59                        6     2013     2                    Hija
    ## 60                        6     2012     1                    Hija
    ## 61                        6     2014     2                    Hija
    ## 62                        6     2016     3                    Hija
    ## 63                        7     2013     4                  Abuelo
    ## 64                        7     2019     1                  Abuelo
    ## 65                        7     2016     1                  Abuelo
    ## 66                        7     2015     1                  Abuelo
    ## 67                        7     2012     5                  Abuelo
    ## 68                        7     2014     2                  Abuelo
    ## 69                        8     2012     3                  Abuela
    ## 70                        8     2022     3                  Abuela
    ## 71                        8     2014     8                  Abuela
    ## 72                        8     2016     1                  Abuela
    ## 73                        8     2013     5                  Abuela
    ## 74                        9     2012     5                   Nieto
    ## 75                        9     2015     3                   Nieto
    ## 76                        9     2021     3                   Nieto
    ## 77                        9     2017     3                   Nieto
    ## 78                        9     2022     2                   Nieto
    ## 79                        9     2013    29                   Nieto
    ## 80                        9     2019     2                   Nieto
    ## 81                        9     2018     1                   Nieto
    ## 82                        9     2014    19                   Nieto
    ## 83                        9     2016     4                   Nieto
    ## 84                       10     2014     1                   Nieta
    ## 85                       10     2012     1                   Nieta
    ## 86                       10     2013     2                   Nieta
    ## 87                       10     2019     1                   Nieta
    ## 88                       11     2017     9         Esposo, Cónyuge
    ## 89                       11     2012    27         Esposo, Cónyuge
    ## 90                       11     2021     9         Esposo, Cónyuge
    ## 91                       11     2018    15         Esposo, Cónyuge
    ## 92                       11     2013    29         Esposo, Cónyuge
    ## 93                       11     2016    24         Esposo, Cónyuge
    ## 94                       11     2022    17         Esposo, Cónyuge
    ## 95                       11     2019     7         Esposo, Cónyuge
    ## 96                       11     2015    30         Esposo, Cónyuge
    ## 97                       11     2020     9         Esposo, Cónyuge
    ## 98                       11     2014    22         Esposo, Cónyuge
    ## 99                       12     2017     2         Esposa, Cónyuge
    ## 100                      12     2012     3         Esposa, Cónyuge
    ## 101                      12     2013     9         Esposa, Cónyuge
    ## 102                      12     2016     4         Esposa, Cónyuge
    ## 103                      12     2021    26         Esposa, Cónyuge
    ## 104                      12     2018     5         Esposa, Cónyuge
    ## 105                      12     2015     2         Esposa, Cónyuge
    ## 106                      12     2019    16         Esposa, Cónyuge
    ## 107                      12     2014    10         Esposa, Cónyuge
    ## 108                      12     2022    14         Esposa, Cónyuge
    ## 109                      12     2020     8         Esposa, Cónyuge
    ## 110                      13     2012     7                     Tío
    ## 111                      13     2019     2                     Tío
    ## 112                      13     2014     6                     Tío
    ## 113                      13     2013     9                     Tío
    ## 114                      13     2015     8                     Tío
    ## 115                      13     2022     2                     Tío
    ## 116                      13     2018     2                     Tío
    ## 117                      13     2017     6                     Tío
    ## 118                      13     2016    13                     Tío
    ## 119                      14     2018     1                     Tía
    ## 120                      14     2012     1                     Tía
    ## 121                      15     2013    14                 Sobrino
    ## 122                      15     2019     5                 Sobrino
    ## 123                      15     2021     6                 Sobrino
    ## 124                      15     2022     6                 Sobrino
    ## 125                      15     2012    19                 Sobrino
    ## 126                      15     2015     9                 Sobrino
    ## 127                      15     2016     4                 Sobrino
    ## 128                      15     2018     4                 Sobrino
    ## 129                      15     2017     9                 Sobrino
    ## 130                      15     2014    10                 Sobrino
    ## 131                      16     2016     1                 Sobrina
    ## 132                      17     2012    14                   Primo
    ## 133                      17     2015    11                   Primo
    ## 134                      17     2017    13                   Primo
    ## 135                      17     2014    10                   Primo
    ## 136                      17     2021     2                   Primo
    ## 137                      17     2020     4                   Primo
    ## 138                      17     2016     9                   Primo
    ## 139                      17     2022     4                   Primo
    ## 140                      17     2018    10                   Primo
    ## 141                      17     2013    15                   Primo
    ## 142                      17     2019     3                   Primo
    ## 143                      18     2016     1                   Prima
    ## 144                      21     2012     1                Bisnieto
    ## 145                      27     2018     3                  Suegro
    ## 146                      27     2016     1                  Suegro
    ## 147                      27     2017     2                  Suegro
    ## 148                      27     2013     1                  Suegro
    ## 149                      27     2015     2                  Suegro
    ## 150                      27     2012     2                  Suegro
    ## 151                      31     2016     3                   Yerno
    ## 152                      31     2018     3                   Yerno
    ## 153                      31     2015     4                   Yerno
    ## 154                      31     2014     1                   Yerno
    ## 155                      31     2012     4                   Yerno
    ## 156                      31     2021     1                   Yerno
    ## 157                      31     2022     1                   Yerno
    ## 158                      31     2017     4                   Yerno
    ## 159                      31     2013     5                   Yerno
    ## 160                      32     2018     1                   Nuera
    ## 161                      33     2012     9                  Cuñado
    ## 162                      33     2016     3                  Cuñado
    ## 163                      33     2022     4                  Cuñado
    ## 164                      33     2014     9                  Cuñado
    ## 165                      33     2015     9                  Cuñado
    ## 166                      33     2017     6                  Cuñado
    ## 167                      33     2021     1                  Cuñado
    ## 168                      33     2018     7                  Cuñado
    ## 169                      33     2013     8                  Cuñado
    ## 170                      33     2019     1                  Cuñado
    ## 171                      34     2022     1                  Cuñada
    ## 172                      34     2012     1                  Cuñada
    ## 173                      35     2012     1                 Concuño
    ## 174                      35     2013     1                 Concuño
    ## 175                      35     2014     2                 Concuño
    ## 176                      35     2017     2                 Concuño
    ## 177                      37     2015     6               Padrastro
    ## 178                      37     2016     6               Padrastro
    ## 179                      37     2020     2               Padrastro
    ## 180                      37     2013     7               Padrastro
    ## 181                      37     2021     2               Padrastro
    ## 182                      37     2022     5               Padrastro
    ## 183                      37     2012     6               Padrastro
    ## 184                      37     2017     2               Padrastro
    ## 185                      37     2018     2               Padrastro
    ## 186                      37     2014     2               Padrastro
    ## 187                      37     2019     1               Padrastro
    ## 188                      38     2013     1               Madrastra
    ## 189                      39     2015     2                Hijastro
    ## 190                      39     2021     1                Hijastro
    ## 191                      39     2012     2                Hijastro
    ## 192                      39     2017     1                Hijastro
    ## 193                      39     2014     1                Hijastro
    ## 194                      39     2016     1                Hijastro
    ## 195                      39     2013     2                Hijastro
    ## 196                      41     2020     1             Hermanastro
    ## 197                      41     2012     1             Hermanastro
    ## 198                      41     2013     3             Hermanastro
    ## 199                      41     2014     1             Hermanastro
    ## 200                      41     2018     1             Hermanastro
    ## 201                      45     2017    21    Concubino, compañero
    ## 202                      45     2012     9    Concubino, compañero
    ## 203                      45     2013    27    Concubino, compañero
    ## 204                      45     2019     5    Concubino, compañero
    ## 205                      45     2021     8    Concubino, compañero
    ## 206                      45     2020     7    Concubino, compañero
    ## 207                      45     2014    26    Concubino, compañero
    ## 208                      45     2018    10    Concubino, compañero
    ## 209                      45     2022    15    Concubino, compañero
    ## 210                      45     2016    25    Concubino, compañero
    ## 211                      45     2015    28    Concubino, compañero
    ## 212                      46     2017     4    Concubina, compañera
    ## 213                      46     2013     4    Concubina, compañera
    ## 214                      46     2022     1    Concubina, compañera
    ## 215                      46     2012     4    Concubina, compañera
    ## 216                      46     2014     7    Concubina, compañera
    ## 217                      46     2015     5    Concubina, compañera
    ## 218                      46     2016     6    Concubina, compañera
    ## 219                      46     2021     1    Concubina, compañera
    ## 220                      47     2016     2 Amante, Amasio, Querido
    ## 221                      47     2013     1 Amante, Amasio, Querido
    ## 222                      47     2015     1 Amante, Amasio, Querido
    ## 223                      47     2019     1 Amante, Amasio, Querido
    ## 224                      47     2017     1 Amante, Amasio, Querido
    ## 225                      47     2012     3 Amante, Amasio, Querido
    ## 226                      48     2014     1 Amante, Amasia, Querida
    ## 227                      49     2019     1                   Novio
    ## 228                      49     2014     2                   Novio
    ## 229                      49     2022     1                   Novio
    ## 230                      49     2016     4                   Novio
    ## 231                      49     2017     1                   Novio
    ## 232                      49     2015     2                   Novio
    ## 233                      49     2013     3                   Novio
    ## 234                      49     2012     2                   Novio
    ## 235                      50     2018     1                   Novia
    ## 236                      51     2013     2               Ex esposo
    ## 237                      51     2018     6               Ex esposo
    ## 238                      51     2017     3               Ex esposo
    ## 239                      51     2020     3               Ex esposo
    ## 240                      51     2014     5               Ex esposo
    ## 241                      51     2022     5               Ex esposo
    ## 242                      51     2016     4               Ex esposo
    ## 243                      51     2012     3               Ex esposo
    ## 244                      51     2015     3               Ex esposo
    ## 245                      52     2016     2               Ex esposa
    ## 246                      53     2015     1                 Padrino
    ## 247                      55     2014     1                 Ahijado
    ## 248                      57     2019     1                Compadre
    ## 249                      57     2014     1                Compadre
    ## 250                      57     2012     1                Compadre
    ##  [ reached 'max' / getOption("max.print") -- omitted 85 rows ]

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

    ## `summarise()` has grouped output by 'year_reg'. You can override using the
    ## `.groups` argument.

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

    ## `summarise()` has grouped output by 'state_reg'. You can override using the
    ## `.groups` argument.

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

    ## `summarise()` has grouped output by 'state_occur_death'. You can override using
    ## the `.groups` argument.

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

    ## # A tibble: 19 × 2
    ##    year_reg count
    ##       <int> <int>
    ##  1     2004 10721
    ##  2     2005 11266
    ##  3     2006 11635
    ##  4     2007 10317
    ##  5     2008 15292
    ##  6     2009 21178
    ##  7     2010 27542
    ##  8     2011 30307
    ##  9     2012 28121
    ## 10     2013 25008
    ## 11     2014 21812
    ## 12     2015 22303
    ## 13     2016 26210
    ## 14     2017 34164
    ## 15     2018 38648
    ## 16     2019 38891
    ## 17     2020 38727
    ## 18     2021 37756
    ## 19     2022 35265

## License

This package is free and open source software, licensed
[MIT](http://en.wikipedia.org/wiki/MIT_License).
