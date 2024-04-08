
library(palmerpenguins)
library(tidyverse)

## readr ----
# leer archivos con readr
read_delim("penguins.csv")
read_csv("penguins.csv") 
str(penguins) # lo lee automáticamente como un tibble
# R base 
read.csv("penguins.csv")
str(penguins) # lo lee como data frame


## tibble ----
# tibble permite almacenar columnas de tipo lista
tibble(x = 1:2, y = list(1:3, letters)) 
# data frame no permite almacenar columnas de tipo lista
data.frame(x = 1:2, y = list(1:3, letters))
# el output de esto es un tibble con listas-columna
penguins |> 
  group_by(species) |> 
  nest()


## stringr ----
penguins <- penguins |> 
# str_sub() # extrae una parte de una cadena de texto
mutate(species_code = str_sub(species, start = 1L, end = 3L))
# R base
penguins$species_code <- substr(penguins$species, 1L, 3L)


## dplyr ----
penguins_bmass <- penguins |>   
  group_by(island, species, sex) |>     # operar por niveles (calcular la masa corporal promedio en cada una de las islas)  
  summarise(body_mass_g = mean(body_mass_g, na.rm = TRUE)) 
# R base
aggregate(body_mass_g ~ island + species + sex, data = penguins, FUN = mean, na.rm = TRUE) # calcular la masa corporal promedio en cada isla y especie


## tidyr ----
# con el output del ejemplo anterior en dplyr, se reorganizan los datos formando una columna para cada especie donde indica el sexo de cada individuo
penguins_bmass_wide <- penguins_bmass |> pivot_wider(names_from = species, values_from = sex)
# R base
reshape(penguins_bmass, idvar = "species", timevar = "sex", direction = "wide")


## forcats ----
# reordenar las especies según el tamaño medio de la longitud de la aleta (en orden creciente)
penguins$sex2 <- fct_recode(penguins$sex, f = "female", m = "male")
# R base
penguins$sex2 <- factor(penguins$sex, labels = c("f", "m"), levels = c("female", "male"))


## ggplot ----
plot_species <- function(species_name) {
  penguins |> 
    na.omit() |> 
    filter(species == species_name) |> 
    ggplot(aes(x = flipper_length_mm, y = body_mass_g)) +  
    geom_point() +      
    geom_smooth(method = "lm", col = "black") +
    ggtitle(species_name)
}
# R base
plot_species <- function(species_name) {
  filtered_data <- na.omit(penguins)
  filtered_data <- subset(filtered_data, species == species_name)
  plot(
    body_mass_g ~ flipper_length_mm,
    data = filtered_data,
    main = species_name,
    xlab = "Flipper Length (mm)",
    ylab = "Body Mass (g)"
  )
  lm_model <- lm(body_mass_g ~ flipper_length_mm, data = filtered_data)
  abline(lm_model, col = "black")
}

## purrr ----
map(.x = levels(penguins$species), .f = plot_species)
# R base
lapply(X = levels(penguins$species), FUN = plot_species)
