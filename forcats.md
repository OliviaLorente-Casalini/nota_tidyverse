# [forcats](https://forcats.tidyverse.org/)

- [Modificar niveles de un factor con un orden
  específico](#modificar-niveles-de-un-factor-con-un-orden-específico)
  - [`fct_relevel()`](#fct_relevel)
- [Modificar el nombre de los niveles de un
  factor](#modificar-el-nombre-de-los-niveles-de-un-factor)
  - [`fct_recode()`](#fct_recode)
- [Eliminar niveles](#eliminar-niveles)
  - [`fct_drop()`](#fct_drop)
- [Añadir niveles](#añadir-niveles)
  - [`fct_expand()`](#fct_expand)

> El paquete forcats provee herramientas para trabajar con factores, la
> estructura de datos de R para datos categóricos.
>
> Un factor es una variable categórica con un número finito de valores o
> niveles. En R los factores se utilizan habitualmente para realizar
> clasificaciones de los datos, estableciendo su pertenencia a los
> grupos o categorías determinados por los niveles del factor.
>
> En este documento se incluye la siguiente información:
>
> 1)  Factores y sus niveles.
> 2)  Modificación del orden de los factores.
> 3)  Modificación de los niveles de los factores.

``` r
# install.packages("forcats")
library(forcats)

# o directamente
library(tidyverse)
#> -- Attaching core tidyverse packages ------------------------ tidyverse 2.0.0 --
#> v dplyr     1.1.4     v readr     2.1.5
#> v ggplot2   3.4.4     v stringr   1.5.1
#> v lubridate 1.9.3     v tibble    3.2.1
#> v purrr     1.0.2     v tidyr     1.3.0
#> -- Conflicts ------------------------------------------ tidyverse_conflicts() --
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
#> i Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

## Modificar niveles de un factor con un orden específico

En algunas ocasiones, puede ser interesante modificar los niveles de un
factor para una representación gráfica, ya que a lo mejor, el orden por
defecto que establece R no resulta tan intuitivo por la propia
naturaleza de los datos.

### `fct_relevel()`

``` r
# forcats
# se crea primero el dataset
data <- data.frame(
  name = c("north","south", "south-east", "north-west", "south-west", "north-east", "west", "east"),
  val = sample(seq(1, 10), 8))

# y después aplicando la función fct_relevel() 
data |> 
  mutate(name = fct_relevel(name, 
            "north", "north-east", "east", 
            "south-east", "south", "south-west", 
            "west", "north-west")) |> 
  ggplot(aes(x = name, y = val)) +
    geom_bar(stat = "identity") +
    xlab("")
```

![](forcats_files/figure-commonmark/fct_relevel()-1.png)

``` r


# R base
# se crea otro dataset 
df <- data.frame(region = factor(c("A", "B", "C", "D", "E")),
                 values = c(12, 18, 21, 14, 34))

# reordenar los niveles del factor por región
df$region <- factor(df$region, levels = c("C", "B", "A", "D", "E"))

# mostrar los niveles del factor por región
levels(df$region)
#> [1] "C" "B" "A" "D" "E"

# representación grÃ¡fica igual que en el ejemplo anterior, situando las barras en función de los niveles del factor region
barplot(df$values, names = df$region)
```

![](forcats_files/figure-commonmark/fct_relevel()-2.png)

## Modificar el nombre de los niveles de un factor

En otras ocasiones, puede resultar interesante cambiar el nombre de un
determinado nivel en un factor, para simplificarlo, armonizarlo para
unir a otro dataset, etc.

### `fct_recode()`

``` r
# se crea primero el factor
fruta <- factor(c("manzana", "pera", "plátano", "naranja"))
fruta
#> [1] manzana pera    plátano naranja
#> Levels: manzana naranja pera plátano

# forcats
fct_recode(fruta, M = "manzana", P = "pera", Pl = "plátano", N = "naranja") # lo ordena alfabéticamente
#> [1] M  P  Pl N 
#> Levels: M N P Pl

# R base
factor(fruta, labels = c("M", "P", "Pl", "N"))  # aquí no
#> [1] M  Pl N  P 
#> Levels: M P Pl N
```

## Eliminar niveles

### `fct_drop()`

``` r
# crear primero el factor
f <- factor(c("a", "b"), levels = c("a", "b", "c", "d"))
f
#> [1] a b
#> Levels: a b c d

# forcats
fct_drop(f, only = "c") 
#> [1] a b
#> Levels: a b d

# R base
droplevels(f, exclude = "c")
#> [1] a b
#> Levels: a b
```

## Añadir niveles

### `fct_expand()`

``` r
# crear el factor
g <- factor(c("a", "b"), levels = c("a", "b"))
g
#> [1] a b
#> Levels: a b

# forcats
fct_expand(g, "c", "d", "e", "f")
#> [1] a b
#> Levels: a b c d e f

# R base
factor(c("a", "b"), levels = c("a", "b", "c", "d", "e", "f"))
#> [1] a b
#> Levels: a b c d e f
```
