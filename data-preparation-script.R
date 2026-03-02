# Data Preparation
library(tidyverse)
library(haven)
data_star <- read_sav(
  "https://raw.githubusercontent.com/sammerk/did_data/master/STAR.sav"
)

#codebook::label_browser_static(data_star)

write_sav(
  data_star %>%
    select(
      g3tchid,
      g3tmathss,
      g3treadss,
      g3freelunch,
      g3classsize,
      g3classtype,
      g4ptimpt,
      g4ptcrit,
      g4ptcrts
    ) %>%
    mutate(
      classID = g3tchid
      ),
  "data_missing_workshop.sav"
)
