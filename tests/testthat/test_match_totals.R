## compare with the numbers
## available at 
## http://www.inegi.org.mx/est/contenidos/espanol/proyectos/continuas/vitales/bd/mortalidad/MortalidadGeneral.asp?s=est&c=11144


test_that("maximum age", {
  expect_that(max(injury.intent$age_years, na.rm = TRUE), equals(120))
})

test_that("number of registered homicides", {
  homicides <- c(9330, 9926, 10454,
                 8868, 14007, 19804,
                 25757, 27213, 25967,  23063, 20013)
  
  expect_that(ddply(subset(injury.intent, intent =="Homicide"),
                    .(year_reg), nrow)$V1,
              equals(
                homicides ))})


test_that("number of registered accidents", {
  accidents <- c(34880, 35865, 36282,
                 39343, 38880, 39461,
                 38120, 36694, 37729,36295, 35782)
  expect_that(ddply(subset(injury.intent, intent =="Accident"),
                    .(year_reg), nrow)$V1,
              equals(
                accidents ))})


test_that("number of registered suicides", {
  suicides <- c(4117, 4315, 4277, 4395, 
                4681, 5190, 5012, 5718, 5550, 5909, 6337)
  expect_that(ddply(subset(injury.intent, intent =="Suicide"),
                    .(year_reg), nrow)$V1,
              equals(
                suicides ))})

test_that("number of registered deaths of unknown intent", {
  
  na <- c(2957, 2932, 2793, 2376, 
          2567, 2920, 3594, 5630, 4375,4198, 4375)
  expect_that(ddply(subset(injury.intent, is.na(intent)),
                    .(year_reg), nrow)$V1,
              equals(
                na ))})
