## compare with the numbers
## available at 
## http://www.inegi.org.mx/sistemas/olap/Proyectos/bd/continuas/mortalidad/MortalidadGeneral.asp?s=est&c=11144&proy=mortgral_mg


test_that("maximum age", {
  expect_equal(max(injury.intent$age_years, na.rm = TRUE), 120)
})

test_that("number of registered homicides", {
  # 2014 - 2010
  homicides <- c(9330, 9926, 10454,
                 8868, 14007, 19804,
                 25757, 27213, 25967,  
                 23063, 20013, 20763, 24560, 32082, 36687,36662,
                 36773)
  
  expect_equal((injury.intent %>% 
                  filter(intent =="Homicide") %>%
                  group_by(year_reg) %>% 
                  summarise(count = n()))$count,
               homicides )})


test_that("number of registered accidents", {
  # accidents 2014 - 35,372
  accidents <- c(34880, 35865, 36282,
                 39343, 38880, 39461,
                 38120, 36694, 37729, 
                 36295, 35817, 37190, 37429, 36220, 34591, 33525,
                 32364)
  expect_equal((injury.intent %>% 
                  filter(intent =="Accident") %>%
                  group_by(year_reg) %>% 
                  summarise(count = n()))$count,
               accidents )})


test_that("number of registered suicides", {
  suicides <- c(4117, 4315, 4277, 4395, 
                4681, 5190, 5012, 5718, 
                5550, 5909, 6337, 6425, 6370, 6559, 6808, 7225,
                7896)
  expect_equal((injury.intent %>% 
                  filter(intent =="Suicide") %>%
                  group_by(year_reg) %>% 
                  summarise(count = n()))$count,
               suicides )})

test_that("number of registered deaths of unknown intent", {
  # 2014 - 4,335
  na <- c(2957, 2932, 2793, 2376, 
          2567, 2920, 3594, 5630, 
          4375, 4198, 4376, 4122, 4393, 5427, 5567, 6399,
          5580)
  expect_equal((injury.intent %>% 
                  filter(is.na(intent)) %>%
                  group_by(year_reg) %>% 
                  summarise(count = n()))$count,
               na )})


test_that("number of registered deaths by Legal Intervention", {
  # 2014 - 586
  mi <- c(39, 72, 48, 47, 39,
          34, 37, 65, 115, 120,
          97, 77, 69,
          112, 96, 71, 47)
  expect_equal((injury.intent %>% 
                  filter(intent == "Legal Intervention") %>%
                  group_by(year_reg) %>% 
                  summarise(count = n()))$count,
               mi )})
