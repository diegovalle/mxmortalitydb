Injury Intent Deaths 2004-2021 in Mexico
================
Diego Valle-Jones
February 28, 2019

- <a href="#injury-intent-deaths-2004-2021-in-mexico"
  id="toc-injury-intent-deaths-2004-2021-in-mexico">Injury Intent Deaths
  2004-2021 in Mexico</a>
  - <a href="#what-does-it-do" id="toc-what-does-it-do">What does it do?</a>
  - <a href="#installation" id="toc-installation">Installation</a>
  - <a href="#examples" id="toc-examples">Examples</a>
  - <a href="#warning" id="toc-warning">Warning</a>
  - <a href="#license" id="toc-license">License</a>

# Injury Intent Deaths 2004-2021 in Mexico

|              |                                                 |
|--------------|-------------------------------------------------|
| **Author:**  | Diego Valle-Jones                               |
| **License:** | [MIT](http://en.wikipedia.org/wiki/MIT_License) |
| **Website:** | <https://github.com/diegovalle/mxmortalitydb>   |

## What does it do?

This is a data only package containing all injury intent deaths
(accidents, suicides, homicides, legal interventions, and deaths of
unspecified intent) registered by the SSA/INEGI from 2004 to 2021. The
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

    ## # A tibble: 18 × 3
    ## # Groups:   year_reg [18]
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

    ## # A tibble: 15 × 3
    ## # Groups:   year_reg [15]
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
    ## 3                         1     2017     7                   Padre
    ## 4                         1     2016    13                   Padre
    ## 5                         1     2021     4                   Padre
    ## 6                         1     2019     4                   Padre
    ## 7                         1     2018     6                   Padre
    ## 8                         1     2015     7                   Padre
    ## 9                         1     2013    18                   Padre
    ## 10                        1     2014   107                   Padre
    ## 11                        2     2016     9                   Madre
    ## 12                        2     2017     2                   Madre
    ## 13                        2     2015    11                   Madre
    ## 14                        2     2019     6                   Madre
    ## 15                        2     2013    17                   Madre
    ## 16                        2     2021     4                   Madre
    ## 17                        2     2020     1                   Madre
    ## 18                        2     2014    16                   Madre
    ## 19                        2     2018     8                   Madre
    ## 20                        2     2012    64                   Madre
    ## 21                        3     2017    13                 Hermano
    ## 22                        3     2015     9                 Hermano
    ## 23                        3     2019     5                 Hermano
    ## 24                        3     2014    13                 Hermano
    ## 25                        3     2021     7                 Hermano
    ## 26                        3     2013    16                 Hermano
    ## 27                        3     2016    11                 Hermano
    ## 28                        3     2020     4                 Hermano
    ## 29                        3     2018    14                 Hermano
    ## 30                        3     2012    14                 Hermano
    ## 31                        4     2021     5                 Hermana
    ## 32                        4     2015     2                 Hermana
    ## 33                        4     2017     5                 Hermana
    ## 34                        4     2018     4                 Hermana
    ## 35                        4     2014     9                 Hermana
    ## 36                        4     2019     4                 Hermana
    ## 37                        4     2012     7                 Hermana
    ## 38                        4     2013     6                 Hermana
    ## 39                        4     2016     4                 Hermana
    ## 40                        5     2019     7                    Hijo
    ## 41                        5     2018    11                    Hijo
    ## 42                        5     2017     9                    Hijo
    ## 43                        5     2012    10                    Hijo
    ## 44                        5     2013    14                    Hijo
    ## 45                        5     2021    16                    Hijo
    ## 46                        5     2020     5                    Hijo
    ## 47                        5     2016    13                    Hijo
    ## 48                        5     2015    10                    Hijo
    ## 49                        5     2014    20                    Hijo
    ## 50                        6     2013     2                    Hija
    ## 51                        6     2016     3                    Hija
    ## 52                        6     2012     1                    Hija
    ## 53                        6     2014     2                    Hija
    ## 54                        6     2018     2                    Hija
    ## 55                        6     2015     1                    Hija
    ## 56                        6     2019     1                    Hija
    ## 57                        7     2019     1                  Abuelo
    ## 58                        7     2016     1                  Abuelo
    ## 59                        7     2015     1                  Abuelo
    ## 60                        7     2014     2                  Abuelo
    ## 61                        7     2012     5                  Abuelo
    ## 62                        7     2013     4                  Abuelo
    ## 63                        8     2012     3                  Abuela
    ## 64                        8     2013     5                  Abuela
    ## 65                        8     2014     8                  Abuela
    ## 66                        8     2016     1                  Abuela
    ## 67                        9     2012     5                   Nieto
    ## 68                        9     2015     3                   Nieto
    ## 69                        9     2017     3                   Nieto
    ## 70                        9     2013    29                   Nieto
    ## 71                        9     2019     2                   Nieto
    ## 72                        9     2021     3                   Nieto
    ## 73                        9     2016     4                   Nieto
    ## 74                        9     2018     1                   Nieto
    ## 75                        9     2014    19                   Nieto
    ## 76                       10     2014     1                   Nieta
    ## 77                       10     2013     2                   Nieta
    ## 78                       10     2012     1                   Nieta
    ## 79                       10     2019     1                   Nieta
    ## 80                       11     2016    24         Esposo, Cónyuge
    ## 81                       11     2017     9         Esposo, Cónyuge
    ## 82                       11     2012    27         Esposo, Cónyuge
    ## 83                       11     2014    22         Esposo, Cónyuge
    ## 84                       11     2021     9         Esposo, Cónyuge
    ## 85                       11     2015    30         Esposo, Cónyuge
    ## 86                       11     2013    29         Esposo, Cónyuge
    ## 87                       11     2018    15         Esposo, Cónyuge
    ## 88                       11     2020     9         Esposo, Cónyuge
    ## 89                       11     2019     7         Esposo, Cónyuge
    ## 90                       12     2012     3         Esposa, Cónyuge
    ## 91                       12     2017     2         Esposa, Cónyuge
    ## 92                       12     2015     2         Esposa, Cónyuge
    ## 93                       12     2016     4         Esposa, Cónyuge
    ## 94                       12     2014    10         Esposa, Cónyuge
    ## 95                       12     2021    26         Esposa, Cónyuge
    ## 96                       12     2020     8         Esposa, Cónyuge
    ## 97                       12     2013     9         Esposa, Cónyuge
    ## 98                       12     2019    16         Esposa, Cónyuge
    ## 99                       12     2018     5         Esposa, Cónyuge
    ## 100                      13     2012     7                     Tío
    ## 101                      13     2013     9                     Tío
    ## 102                      13     2019     2                     Tío
    ## 103                      13     2016    13                     Tío
    ## 104                      13     2018     2                     Tío
    ## 105                      13     2015     8                     Tío
    ## 106                      13     2017     6                     Tío
    ## 107                      13     2014     6                     Tío
    ## 108                      14     2012     1                     Tía
    ## 109                      14     2018     1                     Tía
    ## 110                      15     2012    19                 Sobrino
    ## 111                      15     2017     9                 Sobrino
    ## 112                      15     2015     9                 Sobrino
    ## 113                      15     2021     6                 Sobrino
    ## 114                      15     2018     4                 Sobrino
    ## 115                      15     2014    10                 Sobrino
    ## 116                      15     2016     4                 Sobrino
    ## 117                      15     2013    14                 Sobrino
    ## 118                      15     2019     5                 Sobrino
    ## 119                      16     2016     1                 Sobrina
    ## 120                      17     2020     4                   Primo
    ## 121                      17     2017    13                   Primo
    ## 122                      17     2013    15                   Primo
    ## 123                      17     2018    10                   Primo
    ## 124                      17     2016     9                   Primo
    ## 125                      17     2012    14                   Primo
    ## 126                      17     2021     2                   Primo
    ## 127                      17     2019     3                   Primo
    ## 128                      17     2015    11                   Primo
    ## 129                      17     2014    10                   Primo
    ## 130                      18     2016     1                   Prima
    ## 131                      21     2012     1                Bisnieto
    ## 132                      27     2017     2                  Suegro
    ## 133                      27     2018     3                  Suegro
    ## 134                      27     2012     2                  Suegro
    ## 135                      27     2016     1                  Suegro
    ## 136                      27     2015     2                  Suegro
    ## 137                      27     2013     1                  Suegro
    ## 138                      31     2012     4                   Yerno
    ## 139                      31     2018     3                   Yerno
    ## 140                      31     2014     1                   Yerno
    ## 141                      31     2017     4                   Yerno
    ## 142                      31     2015     4                   Yerno
    ## 143                      31     2016     3                   Yerno
    ## 144                      31     2013     5                   Yerno
    ## 145                      31     2021     1                   Yerno
    ## 146                      32     2018     1                   Nuera
    ## 147                      33     2016     3                  Cuñado
    ## 148                      33     2015     9                  Cuñado
    ## 149                      33     2017     6                  Cuñado
    ## 150                      33     2019     1                  Cuñado
    ## 151                      33     2021     1                  Cuñado
    ## 152                      33     2012     9                  Cuñado
    ## 153                      33     2014     9                  Cuñado
    ## 154                      33     2018     7                  Cuñado
    ## 155                      33     2013     8                  Cuñado
    ## 156                      34     2012     1                  Cuñada
    ## 157                      35     2013     1                 Concuño
    ## 158                      35     2012     1                 Concuño
    ## 159                      35     2017     2                 Concuño
    ## 160                      35     2014     2                 Concuño
    ## 161                      37     2015     6               Padrastro
    ## 162                      37     2013     7               Padrastro
    ## 163                      37     2012     6               Padrastro
    ## 164                      37     2021     2               Padrastro
    ## 165                      37     2018     2               Padrastro
    ## 166                      37     2020     2               Padrastro
    ## 167                      37     2017     2               Padrastro
    ## 168                      37     2014     2               Padrastro
    ## 169                      37     2016     6               Padrastro
    ## 170                      37     2019     1               Padrastro
    ## 171                      38     2013     1               Madrastra
    ## 172                      39     2012     2                Hijastro
    ## 173                      39     2017     1                Hijastro
    ## 174                      39     2016     1                Hijastro
    ## 175                      39     2015     2                Hijastro
    ## 176                      39     2014     1                Hijastro
    ## 177                      39     2021     1                Hijastro
    ## 178                      39     2013     2                Hijastro
    ## 179                      41     2020     1             Hermanastro
    ## 180                      41     2018     1             Hermanastro
    ## 181                      41     2013     3             Hermanastro
    ## 182                      41     2012     1             Hermanastro
    ## 183                      41     2014     1             Hermanastro
    ## 184                      45     2017    21    Concubino, compañero
    ## 185                      45     2020     7    Concubino, compañero
    ## 186                      45     2013    27    Concubino, compañero
    ## 187                      45     2021     8    Concubino, compañero
    ## 188                      45     2012     9    Concubino, compañero
    ## 189                      45     2014    26    Concubino, compañero
    ## 190                      45     2019     5    Concubino, compañero
    ## 191                      45     2015    28    Concubino, compañero
    ## 192                      45     2016    25    Concubino, compañero
    ## 193                      45     2018    10    Concubino, compañero
    ## 194                      46     2017     4    Concubina, compañera
    ## 195                      46     2013     4    Concubina, compañera
    ## 196                      46     2014     7    Concubina, compañera
    ## 197                      46     2012     4    Concubina, compañera
    ## 198                      46     2016     6    Concubina, compañera
    ## 199                      46     2015     5    Concubina, compañera
    ## 200                      46     2021     1    Concubina, compañera
    ## 201                      47     2013     1 Amante, Amasio, Querido
    ## 202                      47     2015     1 Amante, Amasio, Querido
    ## 203                      47     2016     2 Amante, Amasio, Querido
    ## 204                      47     2017     1 Amante, Amasio, Querido
    ## 205                      47     2019     1 Amante, Amasio, Querido
    ## 206                      47     2012     3 Amante, Amasio, Querido
    ## 207                      48     2014     1 Amante, Amasia, Querida
    ## 208                      49     2014     2                   Novio
    ## 209                      49     2019     1                   Novio
    ## 210                      49     2016     4                   Novio
    ## 211                      49     2012     2                   Novio
    ## 212                      49     2015     2                   Novio
    ## 213                      49     2013     3                   Novio
    ## 214                      49     2017     1                   Novio
    ## 215                      50     2018     1                   Novia
    ## 216                      51     2020     3               Ex esposo
    ## 217                      51     2018     6               Ex esposo
    ## 218                      51     2014     5               Ex esposo
    ## 219                      51     2016     4               Ex esposo
    ## 220                      51     2013     2               Ex esposo
    ## 221                      51     2012     3               Ex esposo
    ## 222                      51     2017     3               Ex esposo
    ## 223                      51     2015     3               Ex esposo
    ## 224                      52     2016     2               Ex esposa
    ## 225                      53     2015     1                 Padrino
    ## 226                      55     2014     1                 Ahijado
    ## 227                      57     2014     1                Compadre
    ## 228                      57     2019     1                Compadre
    ## 229                      57     2015     1                Compadre
    ## 230                      57     2012     1                Compadre
    ## 231                      61     2013     1    Trabajador doméstico
    ## 232                      66     2014     4                Conocido
    ## 233                      66     2013     6                Conocido
    ## 234                      66     2015     6                Conocido
    ## 235                      66     2019     5                Conocido
    ## 236                      66     2018     7                Conocido
    ## 237                      66     2016    15                Conocido
    ## 238                      66     2021     3                Conocido
    ## 239                      66     2012     5                Conocido
    ## 240                      66     2017    11                Conocido
    ## 241                      66     2020     7                Conocido
    ## 242                      67     2014     4                  Vecino
    ## 243                      67     2012     5                  Vecino
    ## 244                      67     2015     5                  Vecino
    ## 245                      67     2019     4                  Vecino
    ## 246                      67     2021     2                  Vecino
    ## 247                      67     2018     5                  Vecino
    ## 248                      67     2013     3                  Vecino
    ## 249                      67     2017     8                  Vecino
    ## 250                      67     2020     5                  Vecino
    ##  [ reached 'max' / getOption("max.print") -- omitted 57 rows ]

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

    ## # A tibble: 18 × 2
    ##    year_reg count
    ##       <int> <int>
    ##  1     2004 10651
    ##  2     2005 11213
    ##  3     2006 11676
    ##  4     2007 10009
    ##  5     2008 15191
    ##  6     2009 21246
    ##  7     2010 27710
    ##  8     2011 30352
    ##  9     2012 28163
    ## 10     2013 25159
    ## 11     2014 22070
    ## 12     2015 22661
    ## 13     2016 26596
    ## 14     2017 34701
    ## 15     2018 39475
    ## 16     2019 39720
    ## 17     2020 39252
    ## 18     2021 38233

## License

This package is free and open source software, licensed
[MIT](http://en.wikipedia.org/wiki/MIT_License).
