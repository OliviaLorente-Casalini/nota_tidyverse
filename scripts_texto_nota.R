
library(palmerpenguins)
library(tidyverse)


# readr -------------------------------------------------------------------
# leer archivos
penguins_tb <- read_csv("penguins.csv")

# R base 
penguins_df <- read.csv("penguins.csv")


# tibble ------------------------------------------------------------------
# lo lee como un tibble
head(penguins_tb) 

# lo lee como un data frame
head(penguins_df)


# dplyr -------------------------------------------------------------------
# calcular la media de la longitud y profundidad
# del pico por isla, especie, sexo y año 
penguins_tb_mean <- penguins_tb |> 
  group_by(island, species, year) |> 
  summarise(bill_length_mm_mean = mean(bill_length_mm, na.rm = TRUE), 
            bill_depth_mm_mean = mean(bill_depth_mm, na.rm = TRUE),
            .groups = "drop")

# R base
penguins_df_mean <- aggregate(cbind(bill_length_mm, bill_depth_mm) ~ island + species + year,
                              data = penguins_tb,
                              FUN = function(x) mean(x, na.rm = TRUE))

colnames(penguins_df_mean)[4:5] <- c("bill_length_mm_mean", "bill_depth_mm_mean")


# tidyr -------------------------------------------------------------------
# organizar los datos en formato largo en base
# a la longitud y profundidad del pico
penguins_tb_mean_long <- penguins_tb_mean |> 
  pivot_longer(cols = c(bill_length_mm_mean, bill_depth_mm_mean),
               names_to = "bill_variable",
               values_to = "bill_value")

# R base
penguins_df_mean_long <- reshape(
  data = penguins_df_mean,
  varying = list(c("bill_length_mm_mean", "bill_depth_mm_mean")),
  v.names = "bill_value",
  times = c("bill_length_mm_mean", "bill_depth_mm_mean"),
  timevar = "bill_variable",
  direction = "long"
)

rownames(penguins_df_mean_long) <- NULL
penguins_df_mean_long$id <- NULL


# stringr -----------------------------------------------------------------
# extraer las dos primeras palabras de la variable 
# que hemos creado uniendo la longitud y profundidad del pico
penguins_tb_mean_long_str <- penguins_tb_mean_long |> 
  mutate(bill_str = word(bill_variable, start = 1L, end = 2L, sep = "_"))

# R base
penguins_df_mean_long$bill_str <- sapply(strsplit(penguins_df_mean_long$bill_variable, "_"),
                                         function(x) paste(x[1:2], collapse = "_"))

penguins_df_mean_long_str <- penguins_df_mean_long


# forcats -----------------------------------------------------------------
# reordenar los niveles del factor especies manualmente
penguins_tb_mean_long_str_for <- penguins_tb_mean_long_str |> 
  mutate(species = fct_relevel(species, c("Chinstrap", "Adelie", "Gentoo")))

# R base
penguins_df_mean_long_str$species <- factor(penguins_df_mean_long_str$species, 
                                            levels = c("Chinstrap", "Adelie", "Gentoo"))

penguins_df_mean_long_str_for <- penguins_df_mean_long_str


# ggplot2 -----------------------------------------------------------------
# generar una grafica mostrando la longitud y
# profundidad del pico de cada especie
ggplot(penguins_tb_mean_long_str_for, 
         aes(x = bill_str, y = bill_value, color = species)) +
  scale_color_manual(values = c("red", "green", "blue")) +
  geom_boxplot() +
  labs(x = "variable", y = "mm")

# R base
boxplot(bill_value ~ species * bill_str,
        data = penguins_df_mean_long_str_for,
        xlab = "species & variable", ylab = "mm",
        col = c("red", "green", "blue"))


# purrr -------------------------------------------------------------------
# generar una grafica para cada especie
plot_species_tidy <- function(species_name) {
  penguin_species_plot <- penguins_tb_mean_long_str_for |> 
    filter(species == species_name) |> 
    ggplot(aes(x = bill_str, y = bill_value)) +  
    geom_boxplot() +
    labs(x = "variable", y = "mm") +
    ggtitle(species_name)
  return(penguin_species_plot)
}

map(.x = levels(penguins_tb_mean_long_str_for$species),
    .f = plot_species_tidy)

# R base
plot_species_base <- function(species_name) {
  species_data <- subset(penguins_df_mean_long_str_for, species == species_name)
  penguin_species_plot <- boxplot(bill_value ~ bill_str, data = species_data,
          xlab = "variable", ylab = "mm",
          main = species_name)
  return(penguin_species_plot)
}

lapply(X = levels(penguins_df_mean_long_str_for$species),
       FUN = plot_species_base)

