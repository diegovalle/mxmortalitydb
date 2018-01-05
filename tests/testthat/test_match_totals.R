## compare with the numbers
## available at 
## http://www.inegi.org.mx/sistemas/olap/Proyectos/bd/continuas/mortalidad/MortalidadGeneral.asp?s=est&c=11144&proy=mortgral_mg


test_that("maximum age", {
  expect_that(max(injury.intent$age_years, na.rm = TRUE), equals(120))
})

test_that("number of registered homicides", {
  # 2014 - 2010
  homicides <- c(9330, 9926, 10454,
                 8868, 14007, 19804,
                 25757, 27213, 25967,  
                 23063, 20013, 20763, 24560)
  
  expect_that((injury.intent %>% 
                filter(intent =="Homicide") %>%
                group_by(year_reg) %>% 
                summarise(count = n()))$count,
              equals(
                homicides ))})


test_that("number of registered accidents", {
  # accidents 2014 - 35,372
  accidents <- c(34880, 35865, 36282,
                 39343, 38880, 39461,
                 38120, 36694, 37729, 
                 36295, 35817, 37190, 37429)
  expect_that((injury.intent %>% 
                 filter(intent =="Accident") %>%
                 group_by(year_reg) %>% 
                 summarise(count = n()))$count,
              equals(
                accidents ))})


test_that("number of registered suicides", {
  suicides <- c(4117, 4315, 4277, 4395, 
                4681, 5190, 5012, 5718, 
                5550, 5909, 6337, 6425, 6370)
  expect_that((injury.intent %>% 
                 filter(intent =="Suicide") %>%
                 group_by(year_reg) %>% 
                 summarise(count = n()))$count,
              equals(
                suicides ))})

test_that("number of registered deaths of unknown intent", {
  # 2014 - 4,335
  na <- c(2957, 2932, 2793, 2376, 
          2567, 2920, 3594, 5630, 
          4375, 4198, 4376, 4122, 4393)
  expect_that((injury.intent %>% 
                 filter(is.na(intent)) %>%
                 group_by(year_reg) %>% 
                 summarise(count = n()))$count,
              equals(
                na ))})


test_that("number of registered deaths by Legal Intervention", {
  # 2014 - 586
  mi <- c(39, 72, 48, 47, 39,
          34, 37, 65, 115, 120,
          97, 77, 69)
  expect_that((injury.intent %>% 
                 filter(intent == "Legal Intervention") %>%
                 group_by(year_reg) %>% 
                 summarise(count = n()))$count,
              equals(
                mi ))})
