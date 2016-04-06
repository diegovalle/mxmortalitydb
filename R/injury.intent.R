#' Mexican Injury Intent Mortality Data
#'
#' This dataset contains all injury intent deaths (accidents, suicides, homicides, 
#' legal interventions, and deaths of unspecified intent) registered by the SSA/INEGI 
#' from 2004 to 2012 
#' \url{http://www.inegi.org.mx/est/contenidos/proyectos/registros/vitales/mortalidad/default.aspx}
#'
#' @section Variables:
#'
#' \itemize{
#' \item{\code{state_reg}}{: state where the death was registered}
#' \item{\code{mun_reg}}{: municipio where the death was registered}

#' \item{\code{state_res}}{: state where the deceased resided}
#' \item{\code{mun_res}}{: municipio where the deceased resided}
#' \item{\code{loc_res}}{: localidad where the deceased resided}
#' \item{\code{loc_res_size}}{:  size of the locality where the deceased resided, with levels \code{1-999}, \code{1000-1999}, \code{2000-2999}, \code{3000-4999}, \code{5000-9999}, \code{10000-14999}, \code{15000-19999}, \code{20000-29999}, \code{30000-39999}, \code{40000-49999}, \code{50000-74999}, \code{75000-99999}, \code{100000-249999}, \code{250000-499999}, \code{500000-999999}, \code{1000000-1499999}, \code{>1500000}}

#' \item{\code{state_occur_death}}{: state where the death occurred}
#' \item{\code{mun_occur_death}}{: municipio where the death occurred}
#' \item{\code{mun_occur_death2}}{: municipio where the death occurred with Tulum coded as if it were Solidaridad, Bacalar as Othon P. Blanco, and San Ignacio Cerro Gordo as Arandas}
#' \item{\code{loc_occur}}{: localidad where the death occurred}
#' \item{\code{loc_occur_death_size}}{:  size of the locality where the death occurred, with levels \code{1-999}, \code{1000-1999}, \code{2000-2999}, \code{3000-4999}, \code{5000-9999}, \code{10000-14999}, \code{15000-19999}, \code{20000-29999}, \code{30000-39999}, \code{40000-49999}, \code{50000-74999}, \code{75000-99999}, \code{100000-249999}, \code{250000-499999}, \code{500000-999999}, \code{1000000-1499999}, \code{>1500000}}

#' \item{\code{state_occur_lesion}}{: state where the lesion occurred}
#' \item{\code{mun_occur_lesion}}{: municipio where the lesion occurred}
#' \item{\code{loc_occur_lesion}}{: locality where the lesion occurred}
#' \item{\code{maternal_mortality_rate}}{: used for maternal mortality rate calculation}

#' \item{\code{oax_dist}}{: code for Oaxaca district}

#' \item{\code{icd4}}{: ICD-10 4 digit code}
#' \item{\code{icd_chapter}}{: ICD-10 chapter}
#' \item{\code{icd_group}}{: ICD-10 group}
#' \item{\code{icd_list_103}}{: List of 103 diseases}
#' \item{\code{mex_list}}{: code corresponding to the Mexican Disease List}
#' \item{\code{mex_list_group}}{: group corresponding to the Mexican Disease List}

#' \item{\code{sex}}{: sex of the deceased, with levels \code{Female}, \code{Male}}

#' \item{\code{age_coded}}{: coded age of the deceased, 1001 to 1023 means hours, 1097 minutes 
#' not specified, 1098 hours not specified, 2001 to 2029 means days, 2098 days not specified, 
#' 3001 to 3011 means months, 3098 months not specified, 4001 to 4120 means years, 
#' 4998 years not specified}
#' \item{\code{age_years}}{: age in years}
#' \item{\code{age_group}}{: five year age group, with levels \code{<1}, \code{1}, \code{2}, \code{3}, \code{4}, \code{5-9}, \code{10-14}, \code{15-19}, \code{20-24}, \code{25-29}, \code{30-34}, \code{35-39}, \code{40-44}, \code{45-49}, \code{50-54}, \code{55-59}, \code{60-64}, \code{65-69}, \code{70-74}, \code{75-79}, \code{80-84}, \code{85-89}, \code{90-94}, \code{95-99}, \code{100-104}, \code{105-109}, \code{110-114}, \code{115-119}, \code{120}}

#' \item{\code{hour_occur}}{: hour the death occurred}
#' \item{\code{min_occur}}{: minute the death occurred}
#' \item{\code{day_occur}}{: day when the death occurred}
#' \item{\code{month_occur}}{: month when the death occurred}
#' \item{\code{year_occur}}{: year when the death occurred}

#' \item{\code{day_reg}}{: day when the death was registered}
#' \item{\code{month_reg}}{: month when the death was registered}
#' \item{\code{year_reg}}{: year when the death was registered}

#' \item{\code{day_cert}}{: day the death was certified}
#' \item{\code{month_cert}}{: month the death was certified}
#' \item{\code{year_cert}}{: year the death was certified}

#' \item{\code{day_birth}}{: day of birth of the deceased}
#' \item{\code{month_birth}}{: month of birth of the deceased}
#' \item{\code{year_birth}}{: year of birth of the deceased}

#' \item{\code{job}}{: job of the deceased, with levels \code{Administrators (inferior)}, \code{Administrators (intermediate)}, \code{Agropecuary}, \code{Armed Forces, Protection and Private Security}, \code{Arts and Sports}, \code{Directors}, \code{Domestic Services}, \code{Education}, \code{Inactive}, \code{Industrial Activities (Foremen)}, \code{Industrial Production (Helpers)}, \code{Industrial Production (Machine Operators)}, \code{Industrial Production (Workers)}, \code{Insufficiently Specified}, \code{Not App. (< 12 years old)}, \code{Personal Services}, \code{Professional}, \code{Sales} ,\code{Street Salesman}, \code{Technician} ,\code{Transportation}}

#' \item{\code{education}}{: education level of the deceased before 2012, with levels \code{3 to 5 years}, \code{Less than 3 years}, \code{No Schooling}, \code{Not Applicable (< 6 yrs old)}, \code{Preparatoria}, \code{Primaria Completed}, \code{Profesional}, \code{Secundaria}}
#' \item{\code{education_2012}}{: education level of the deceased (coding changed in 2012), with levels \code{Graduate Degree}, \code{No Schooling}, \code{Not Applicable (< 3 yrs old)}, \code{Preparatoria Complete}, \code{Preparatoria Incomplete}, \code{Preschool}, \code{Primaria Completed}, \code{Primaria Incomplete}, \code{Profesional}, \code{Secundaria Complete}, \code{Secundaria Incomplete}}

#' \item{\code{marital_status}}{: marital status of the deceased before 2012, with levels \code{Divorced}, \code{Living Together}, \code{Married}, \code{Not App. (< 12 yrs old)}, \code{Single}, \code{Widow}}
#' \item{\code{marital_status_2012}}{: marital status of the deceased (coding changed in 2012), with levels \code{Divorced}, \code{Living Together}, \code{Married}, \code{Not App. (< 12 yrs old)}, \code{Separated}, \code{Single}, \code{Widow}}

#' \item{\code{insurance}}{: medical institution with which the deceased was affiliated before 2012, with levels \code{IMSS}, \code{ISSSTE}, \code{None}, \code{Other}, \code{PEMEX}, \code{SEDENA}, \code{Seguro Popular}, \code{SEMAR}}
#' \item{\code{insurance_2012}}{: medical institution with which the deceased was affiliated (coding changed in 2012), with levels \code{IMSS}, \code{IMSS oportunidades}, \code{ISSSTE}, \code{None}, \code{Other}, \code{PEMEX}, \code{SEDENA}, \code{Seguro Popular}, \code{SEMAR}}


#' \item{\code{during_job}}{: did the death occur while the deceased was performing a job related activity, with levels \code{No} \code{Yes}}
#' \item{\code{place_occur}}{: place where the accident or violent act took place, with levels \code{Commercial Area}, \code{Farm} \code{Home}, \code{Industrial Area}, \code{Other}, \code{Public Street}, \code{Residential Institution}, \code{School or Office}, \code{Sporting Area}}
#' \item{\code{site_occur}}{: site where the vital statistic was recorded: with levels \code{Home}, \code{IMSS}, \code{IMSS Oportunidades}, \code{ISSSTE}, \code{Other}, \code{PEMEX}, \code{Private Hospital}, \code{Public Street}, \code{Secretaria de Salud} \code{SEDENA}, \code{SEMAR}}

#' \item{\code{autopsy}}{: was an autopsy performed? With levels \code{No}, \code{Yes}}
#' \item{\code{med_help}}{: did the deceased receive medical help before death occurred? \code{No}, \code{Yes}}
#' \item{\code{certifier}}{: who certified the death, with levels \code{Attending Physician}, \code{Civil Authority}, \code{Forensic Doctor}, \code{Other}, \code{Other Doctor}, \code{SSA Personnel}}
#' \item{\code{nationality}}{: nationality of the deceased, with levels \code{Foreigner}, \code{Mexican}}

#' \item{\code{pregnancy_complication}}{: did the cause of death complicate the pregnancy, birth or puerperium \code{No} \code{Not App.}}
#' \item{\code{pregnancy_condition}}{: pregnancy condition, with levels \code{43 days to 11 months after giving birth} \code{Birth} \code{No pregnancy for 11 months}, \code{Not Applicable}, \code{Pregnancy}, \code{Pregnancy more than a year before death}, \code{Puerperium}}
#' \item{\code{pregnancy_related}}{: was the death related to pregnancy, birth or puerperium, with levels \code{No} \code{Not App.}}
#' \item{\code{maternal_code}}{: maternal code of death \code{}}

#' \item{\code{domestic_violence}}{: was domestic violence a factor in the death, with levels \code{No}, \code{Not Homicide}, \code{Yes}}
#' \item{\code{urban_rural}}{: urban or rural, with levels \code{Rural} \code{Urban}}
#' \item{\code{indigenous_language}}{: did the deceased speak an indigenous language? \code{0}}
#' \item{\code{employed}}{: was the deceased economically active? \code{0}}
#' \item{\code{aggressor_relation_code}}{: relationship between the victim and his aggressor (coded)}
#' \item{\code{weight}}{: weight of the deceased}

#' \item{\code{intent}}{: injury intent of the death, with levels \code{Accident}, \code{Homicide}, \code{Legal Intervention}, \code{Suicide}}
#' \item{\code{mechanism}}{: External Cause of Injury Mortality Matrix for ICD-10, with levels \code{Adverse effects}, \code{All Transport}, \code{Cut/pierce}, \code{Drowning}, \code{Fall}, \code{Firearm}, \code{Fire/hot object or substance}, \code{Machinery}, \code{Natural/environmental}, \code{Other specified, classifiable}, \code{Other specified, nec}, \code{Overexertion}, \code{Poisoning}, \code{Struck by or against}, \code{Suffocation}, \url{http://www.cdc.gov/nchs/data/ice/icd10_transcode.pdf}}
#' \item{\code{mechanism_detail}}{: External Cause of Injury Mortality Matrix for ICD-10, with levels \code{Adverse effects - Drugs}, \code{Adverse effects - Medical care}, \code{Cut/pierce}, \code{Drowning}, \code{Fall}, \code{Firearm}, \code{Fire/flame}, \code{Hot object/substance}, \code{Machinery}, \code{Motor Vehicle Traffic}, \code{Natural/environmental}, \code{Other land transport}, \code{Other specified, classifiable}, \code{Other specified, nec}, \code{Other Transport}, \code{Overexertion}, \code{Pedal cyclist, other}, \code{Pedestrian, other}, \code{Poisoning}, \code{Struck by or against}, \code{Suffocation}, \url{http://www.cdc.gov/nchs/data/ice/icd10_transcode.pdf}}
#' \item{\code{motor_vehicle_traffic}}{: External Cause of Injury Mortality Matrix for ICD-10, Motor Vehicle Traffic, with levels \code{MVT - Motorcyclist}, \code{MVT - Occupant}, \code{MVT - Other}, \code{MVT - Pedal cyclist}, \code{MVT - Pedestrian}, \url{http://www.cdc.gov/nchs/data/ice/icd10_transcode.pdf}}
#' \item{\code{intent.imputed}}{: result of a statistical model to classify deaths of unknown intent and recode legal interventions as homicides, with levels \code{Accident}, \code{Homicide}, \code{Suicide}}
#' }
#' @docType data
#' @name injury.intent
#' @usage injury.intent
#' @format A data frame with 562,475 rows and 66 columns.
#' @examples
#' head(injury.intent)
NULL
