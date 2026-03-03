# Data Preparation
library(tidyverse)
library(haven)
data_star <- read_sav(
  "https://raw.githubusercontent.com/sammerk/did_data/master/STAR.sav"
)

#codebook::label_browser_static(data_star)

write_sav(
  data_star %>% 
  filter(!is.na(g4ptattn)) %>%
  group_by(g4tchid) %>%
  sample_n(1) %>%
  ungroup() %>%
    select(g4ptattn,
g4ptmtrl,
g4ptlate,
g4ptwork,
g4ptpers,
g4ptrepr,
g4ptanoy,
g4ptdisc,
g4ptextr,
g4ptdiss,
    ),
  "data_sem_workshop.sav"
)


## Variablen labels
codebook::label_browser_static(data_star)

## dummy CFA
data_star_selg4 <-
  data_star %>%
  filter(!is.na(g4ptattn)) %>%
  group_by(g4tchid) %>%
  sample_n(1) %>%
  ungroup() %>%
  mutate(
    g4ptmtrl_r = 6 - g4ptmtrl,
    g4ptlate_r = 6 - g4ptlate,
    g4ptknow_r = 6 - g4ptknow,
    g4ptintv_r = 6 - g4ptintv,
    g4pteasy_r = 6 - g4pteasy,
    g4ptdsrg_r = 6 - g4ptdsrg,
    g4ptwthd_r = 6 - g4ptwthd,
    g4ptcrit_r = 6 - g4ptcrit,
    g4ptcrts_r = 6 - g4ptcrts
  )

class_part_1f_mod <- 
"class_part =~ g4ptattn + g4ptmtrl_r + g4ptlate_r + g4ptwork + g4ptpers +
              g4ptrepr + g4ptanoy +
              g4ptdisc + g4ptextr + g4ptdiss"

class_part_4f_modcorr <- 
"effort =~ g4ptattn + g4ptmtrl_r + g4ptlate_r + g4ptwork + g4ptpers
 negative =~ g4ptrepr + g4ptanoy
 initiative =~ g4ptdisc + g4ptextr + g4ptdiss"

library(lavaan)
library(performance)
class_part_1f_fit <- cfa(class_part_1f_mod, data = data_star_selg4)
class_part_4fmodcorr_fit <- cfa(class_part_4f_modcorr, data = data_star_selg4)
modificationIndices(class_part_4fmodcorr_fit, sort. = T)

compare_performance(class_part_1f_fit, class_part_4fmodcorr_fit, metrics = c("RMSEA", "CFI", "SRMR"))

tau_gen <- "class_part =~ g4ptattn + g4ptmtrl_r + g4ptlate_r + g4ptwork + g4ptpers"
tau_par <- "class_part =~ t*g4ptattn + t*g4ptmtrl_r + t*g4ptlate_r + t*g4ptwork + t*g4ptpers"

compare_performance(cfa(tau_gen, data = data_star_selg4), 
                    cfa(tau_par, data = data_star_selg4), 
                    metrics = c("RMSEA", "CFI", "SRMR"))
