# [tidyr](https://tidyr.tidyverse.org/)

- [“Pivotar” datos](#pivotar-datos)
  - [`pivot_longer()`](#pivot_longer)
  - [`pivot_wider()`](#pivot_wider)
- [“Anidar” y “Desanidar” datos](#anidar-y-desanidar-datos)
  - [`nest()`](#nest)
  - [`unnest()`](#unnest)
- [Trabajar con NAs](#trabajar-con-nas)
  - [`drop_na()`](#drop_na)

> Los datos ordenados (en formato *tidy*) implican que:
>
> 1.  Cada columna es una variable.
>
> 2.  Cada fila es una observación.
>
> 3.  Cada celda o casilla tiene un único valor.
>
> `tidyr` ofrece múltiples aplicaciones con el objetivo de principal de
> crear datos ordenados, lo que facilita la conexión del flujo de
> trabajo entre paquetes dentro del entorno *tidyverse*.

``` r
# install.packages("tidyr")
library(tidyr)

# o directamente
library(tidyverse)
#> -- Attaching core tidyverse packages ------------------------ tidyverse 2.0.0 --
#> v dplyr     1.1.4     v purrr     1.0.2
#> v forcats   1.0.0     v readr     2.1.5
#> v ggplot2   3.4.4     v stringr   1.5.1
#> v lubridate 1.9.3     v tibble    3.2.1
#> -- Conflicts ------------------------------------------ tidyverse_conflicts() --
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
#> i Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

## “Pivotar” datos

“Pivotar” es reorganizar los datos colapsando o expandiendo las
columnas. Existen dos funciones principales para esto: `pivot_longer()`
y `pivot_wider()`.

### `pivot_longer()`

Colapsa muchas columnas en una sola ajustándose al formato *tidy*.

La siguiente base de datos no está en formato *tidy*, ya que el nivel de
ingresos es una única variable y por tanto, debería estar en una única
columna:

``` r
relig_income <- as_tibble(relig_income)
head(relig_income)
#> # A tibble: 6 x 11
#>   religion  `<$10k` `$10-20k` `$20-30k` `$30-40k` `$40-50k` `$50-75k` `$75-100k`
#>   <chr>       <dbl>     <dbl>     <dbl>     <dbl>     <dbl>     <dbl>      <dbl>
#> 1 Agnostic       27        34        60        81        76       137        122
#> 2 Atheist        12        27        37        52        35        70         73
#> 3 Buddhist       27        21        30        34        33        58         62
#> 4 Catholic      418       617       732       670       638      1116        949
#> 5 Don’t kn~      15        14        15        11        10        35         21
#> 6 Evangeli~     575       869      1064       982       881      1486        949
#> # i 3 more variables: `$100-150k` <dbl>, `>150k` <dbl>,
#> #   `Don't know/refused` <dbl>
```

Se agrupa toda la información usando tres variables: “religion”,
“income” and “frequency”:

``` r
# tidyr
relig_income |> 
  pivot_longer(-religion, names_to = "income", values_to = "frequency") |> 
  head(n = 12L)
#> # A tibble: 12 x 3
#>    religion income             frequency
#>    <chr>    <chr>                  <dbl>
#>  1 Agnostic <$10k                     27
#>  2 Agnostic $10-20k                   34
#>  3 Agnostic $20-30k                   60
#>  4 Agnostic $30-40k                   81
#>  5 Agnostic $40-50k                   76
#>  6 Agnostic $50-75k                  137
#>  7 Agnostic $75-100k                 122
#>  8 Agnostic $100-150k                109
#>  9 Agnostic >150k                     84
#> 10 Agnostic Don't know/refused        96
#> 11 Atheist  <$10k                     12
#> 12 Atheist  $10-20k                   27

# R base
stacked_relig_income <- data.frame(relig_income$religion, stack(relig_income, select = -religion))

colnames(stacked_relig_income) <- c("religion", "frequency", "income")

stacked_relig_income <- stacked_relig_income[ ,c(1,3,2)]                                 
head(stacked_relig_income, n = 20L)
#>                   religion  income frequency
#> 1                 Agnostic   <$10k        27
#> 2                  Atheist   <$10k        12
#> 3                 Buddhist   <$10k        27
#> 4                 Catholic   <$10k       418
#> 5       Don’t know/refused   <$10k        15
#> 6         Evangelical Prot   <$10k       575
#> 7                    Hindu   <$10k         1
#> 8  Historically Black Prot   <$10k       228
#> 9        Jehovah's Witness   <$10k        20
#> 10                  Jewish   <$10k        19
#> 11           Mainline Prot   <$10k       289
#> 12                  Mormon   <$10k        29
#> 13                  Muslim   <$10k         6
#> 14                Orthodox   <$10k        13
#> 15         Other Christian   <$10k         9
#> 16            Other Faiths   <$10k        20
#> 17   Other World Religions   <$10k         5
#> 18            Unaffiliated   <$10k       217
#> 19                Agnostic $10-20k        34
#> 20                 Atheist $10-20k        27
```

Para realizar la misma tarea en R base se puede usar la función
`stack()`.

### `pivot_wider()`

Funciona a la inversa de `pivot_longer()`, expande los datos (hace la
base de datos más ancha) dividiendo la información de una variable en
varias columnas diferentes. Partiendo de la base da datos generada
anteriormente con `nest()`, renombrándola como `relig_income_tidy`.

``` r
# tidyr
relig_income_tidy |> 
  pivot_wider(names_from = "income", values_from = "frequency") |> head() 
#> # A tibble: 6 x 11
#>   religion  `<$10k` `$10-20k` `$20-30k` `$30-40k` `$40-50k` `$50-75k` `$75-100k`
#>   <chr>       <dbl>     <dbl>     <dbl>     <dbl>     <dbl>     <dbl>      <dbl>
#> 1 Agnostic       27        34        60        81        76       137        122
#> 2 Atheist        12        27        37        52        35        70         73
#> 3 Buddhist       27        21        30        34        33        58         62
#> 4 Catholic      418       617       732       670       638      1116        949
#> 5 Don’t kn~      15        14        15        11        10        35         21
#> 6 Evangeli~     575       869      1064       982       881      1486        949
#> # i 3 more variables: `$100-150k` <dbl>, `>150k` <dbl>,
#> #   `Don't know/refused` <dbl>

# R base
unstacked_relig <- unstack(stacked_relig_income, frequency ~ income)

unstacked_relig_correct <- cbind(unique(stacked_relig_income$religion), unstacked_relig)

colnames(unstacked_relig_correct) <- colnames(relig_income)

head(unstacked_relig_correct)
#>             religion <$10k $10-20k $20-30k $30-40k $40-50k $50-75k $75-100k
#> 1           Agnostic    27      34      60      81      76     137      122
#> 2            Atheist    12      27      37      52      35      70       73
#> 3           Buddhist    27      21      30      34      33      58       62
#> 4           Catholic   418     617     732     670     638    1116      949
#> 5 Don’t know/refused    15      14      15      11      10      35       21
#> 6   Evangelical Prot   575     869    1064     982     881    1486      949
#>   $100-150k >150k Don't know/refused
#> 1       109    84                 96
#> 2        59    74                 76
#> 3        39    53                 54
#> 4       792   633               1489
#> 5        17    18                116
#> 6       723   414               1529
```

Con `R base` se podría usar la función `unstack()`.

## “Anidar” y “Desanidar” datos

“Anidar” (Nesting) es agrupar los datos en una lista anidada (una lista
con otro tipo de objetos dentro). “Desanidar” (Rectangling) es ordenar
los datos de una lista anidada a un formato *tidy*. Para ello, se usan
dos funciones principales: `nest()` & `unnest()`.

### `nest()`

Crea una lista anidada o un set de datos dentro de las celdas de una
base de datos mayor.

Desde `relig_income` se puede anidar “income” y “frequency” para cada
religión:

``` r
relig_income_tidy |> nest(data = c(income, frequency))
#> # A tibble: 18 x 2
#>    religion                data             
#>    <chr>                   <list>           
#>  1 Agnostic                <tibble [10 x 2]>
#>  2 Atheist                 <tibble [10 x 2]>
#>  3 Buddhist                <tibble [10 x 2]>
#>  4 Catholic                <tibble [10 x 2]>
#>  5 Don’t know/refused      <tibble [10 x 2]>
#>  6 Evangelical Prot        <tibble [10 x 2]>
#>  7 Hindu                   <tibble [10 x 2]>
#>  8 Historically Black Prot <tibble [10 x 2]>
#>  9 Jehovah's Witness       <tibble [10 x 2]>
#> 10 Jewish                  <tibble [10 x 2]>
#> 11 Mainline Prot           <tibble [10 x 2]>
#> 12 Mormon                  <tibble [10 x 2]>
#> 13 Muslim                  <tibble [10 x 2]>
#> 14 Orthodox                <tibble [10 x 2]>
#> 15 Other Christian         <tibble [10 x 2]>
#> 16 Other Faiths            <tibble [10 x 2]>
#> 17 Other World Religions   <tibble [10 x 2]>
#> 18 Unaffiliated            <tibble [10 x 2]>
```

Cada valor del objeto creado “data” es un tibble que recoge información
de la siguiente forma: (ejemplo - `relig_income_tidy[[2]][[1]]`):

| income             | frequency |
|:-------------------|----------:|
| \<\$10k            |        27 |
| \$10-20k           |        34 |
| \$20-30k           |        60 |
| \$30-40k           |        81 |
| \$40-50k           |        76 |
| \$50-75k           |       137 |
| \$75-100k          |       122 |
| \$100-150k         |       109 |
| \>150k             |        84 |
| Don’t know/refused |        96 |

Usando `R base` se podría usar `list()`, pero será necesario
`tibble::tibble()`, ya que el formato data frame no permite trabajar con
este tipo de datos.

Para este ejemplo, simplemente usaremos las primeras 4 filas de
`relig_income_tidy` :

``` r
Agnostic <- relig_income_tidy[relig_income_tidy$religion == "Agnostic", -1]
Atheist <- relig_income_tidy[relig_income_tidy$religion == "Atheist", -1]
Buddhist <- relig_income_tidy[relig_income_tidy$religion == "Buddhist", -1]
Catholic <- relig_income_tidy[relig_income_tidy$religion == "Catholic", -1]
Religion <- c("Agnostic", "Atheist", "Buddhist", "Catholic")

data <- list(Agnostic, Atheist, Buddhist, Catholic)

tibble(Religion, data)
#> # A tibble: 4 x 2
#>   Religion data             
#>   <chr>    <list>           
#> 1 Agnostic <tibble [10 x 2]>
#> 2 Atheist  <tibble [10 x 2]>
#> 3 Buddhist <tibble [10 x 2]>
#> 4 Catholic <tibble [10 x 2]>
```

### `unnest()`

La función inversa a `nest()`. A partir de una base de datos con datos
anidados, se puede generar una base de datos en formato *tidy*.

Partiendo de la base da datos anidada que hemos generado anteriormente
con `nest()`, renombrándola como `relig_income_nested`:

``` r
relig_income_nested |> unnest(cols = "data") |>  head(n = 20L)
#> # A tibble: 20 x 3
#>    religion income             frequency
#>    <chr>    <chr>                  <dbl>
#>  1 Agnostic <$10k                     27
#>  2 Agnostic $10-20k                   34
#>  3 Agnostic $20-30k                   60
#>  4 Agnostic $30-40k                   81
#>  5 Agnostic $40-50k                   76
#>  6 Agnostic $50-75k                  137
#>  7 Agnostic $75-100k                 122
#>  8 Agnostic $100-150k                109
#>  9 Agnostic >150k                     84
#> 10 Agnostic Don't know/refused        96
#> 11 Atheist  <$10k                     12
#> 12 Atheist  $10-20k                   27
#> 13 Atheist  $20-30k                   37
#> 14 Atheist  $30-40k                   52
#> 15 Atheist  $40-50k                   35
#> 16 Atheist  $50-75k                   70
#> 17 Atheist  $75-100k                  73
#> 18 Atheist  $100-150k                 59
#> 19 Atheist  >150k                     74
#> 20 Atheist  Don't know/refused        76
```

En `R base` necesitaremos acceder a los valores individuales de cada
tibble incluido en la variable “data”, de forma iterativa mediante un
bucle y el uso de dobles corchetes:

``` r
unnRbase <- data.frame() # generamos un dataframe vacio que iremos llenando

for(i in 1:nrow(relig_income_nested)) {
  unnRbase <- rbind(unnRbase, data.frame(relig_income_nested[[1]][[i]], relig_income_nested[[2]][[i]]))
}

colnames(unnRbase)[1] <- "religion"
head(unnRbase, n = 20L)    
#>    religion             income frequency
#> 1  Agnostic              <$10k        27
#> 2  Agnostic            $10-20k        34
#> 3  Agnostic            $20-30k        60
#> 4  Agnostic            $30-40k        81
#> 5  Agnostic            $40-50k        76
#> 6  Agnostic            $50-75k       137
#> 7  Agnostic           $75-100k       122
#> 8  Agnostic          $100-150k       109
#> 9  Agnostic              >150k        84
#> 10 Agnostic Don't know/refused        96
#> 11  Atheist              <$10k        12
#> 12  Atheist            $10-20k        27
#> 13  Atheist            $20-30k        37
#> 14  Atheist            $30-40k        52
#> 15  Atheist            $40-50k        35
#> 16  Atheist            $50-75k        70
#> 17  Atheist           $75-100k        73
#> 18  Atheist          $100-150k        59
#> 19  Atheist              >150k        74
#> 20  Atheist Don't know/refused        76
```

## Trabajar con NAs

Durante el procesado de datos es común encontrar valores NA (not
available) dentro de los objetos con los que se esté trabajando. Estos
valores a veces pueden resultar problemáticos para realizar determinadas
operaciones, por lo que existen funciones específicas para tratarlos.

Se trabajará con la base de datos `palmerpenguins`.

``` r
library(palmerpenguins)
```

Vamos a intentar calcular el valor medio de la variable `body mass`.

``` r
mean_bm <- mean(penguins$body_mass_g) # error NA

# si se indica el argumento na.rm (na remove), se puede realizar el cálculo
mean_bm <- mean(penguins$body_mass_g, na.rm = TRUE)
```

### `drop_na()`

En tidyverse, existe esta función para eliminar los valores NA. En el
siguiente ejemplo, se calcula el valor medio de `body mass` por cada
especie.

``` r
mean_bm_tidy <- penguins |> 
  tidyr::drop_na(body_mass_g) |>  
  group_by(species) |> 
  summarise(mean(body_mass_g)) |> 
  print()
#> # A tibble: 3 x 2
#>   species   `mean(body_mass_g)`
#>   <fct>                   <dbl>
#> 1 Adelie                  3701.
#> 2 Chinstrap               3733.
#> 3 Gentoo                  5076.
```

Hay que destacar que la función `drop_na()`, elimina los valores NA de
la variable que le indiquemos entre los paréntesis, como se ha realizado
en el ejemplo anterior. Pero si se aplica la misma función `drop_na()`,
sin indicar nada como argumento, por defecto eliminará todas las filas
donde se encuentre algún valor NA.

``` r
mean_bm_tidy_2 <- penguins |> 
  tidyr::drop_na() |>  
  group_by(species) |> 
  summarise(mean(body_mass_g)) |> 
  print()
#> # A tibble: 3 x 2
#>   species   `mean(body_mass_g)`
#>   <fct>                   <dbl>
#> 1 Adelie                  3706.
#> 2 Chinstrap               3733.
#> 3 Gentoo                  5092.
```

Los resultados son diferentes.

En otro caso, también podría resultar interesante cambiar los valores NA
por 0, en función de la naturaleza de los datos con los que se esté
trabajando.

``` r
# tidyr
penguins_mod_tidy <- penguins |>  
  mutate(body_mass_g = replace_na(body_mass_g, 0)) |> 
  print()
#> # A tibble: 344 x 8
#>    species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g
#>    <fct>   <fct>              <dbl>         <dbl>             <int>       <int>
#>  1 Adelie  Torgersen           39.1          18.7               181        3750
#>  2 Adelie  Torgersen           39.5          17.4               186        3800
#>  3 Adelie  Torgersen           40.3          18                 195        3250
#>  4 Adelie  Torgersen           NA            NA                  NA           0
#>  5 Adelie  Torgersen           36.7          19.3               193        3450
#>  6 Adelie  Torgersen           39.3          20.6               190        3650
#>  7 Adelie  Torgersen           38.9          17.8               181        3625
#>  8 Adelie  Torgersen           39.2          19.6               195        4675
#>  9 Adelie  Torgersen           34.1          18.1               193        3475
#> 10 Adelie  Torgersen           42            20.2               190        4250
#> # i 334 more rows
#> # i 2 more variables: sex <fct>, year <int>

# R base
penguins_mod <- penguins
penguins_mod[which(is.na(penguins_mod$body_mass_g) == TRUE), 6] <- 0
penguins_mod
#> # A tibble: 344 x 8
#>    species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g
#>    <fct>   <fct>              <dbl>         <dbl>             <int>       <int>
#>  1 Adelie  Torgersen           39.1          18.7               181        3750
#>  2 Adelie  Torgersen           39.5          17.4               186        3800
#>  3 Adelie  Torgersen           40.3          18                 195        3250
#>  4 Adelie  Torgersen           NA            NA                  NA           0
#>  5 Adelie  Torgersen           36.7          19.3               193        3450
#>  6 Adelie  Torgersen           39.3          20.6               190        3650
#>  7 Adelie  Torgersen           38.9          17.8               181        3625
#>  8 Adelie  Torgersen           39.2          19.6               195        4675
#>  9 Adelie  Torgersen           34.1          18.1               193        3475
#> 10 Adelie  Torgersen           42            20.2               190        4250
#> # i 334 more rows
#> # i 2 more variables: sex <fct>, year <int>
```
