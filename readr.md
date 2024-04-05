# [readr](https://readr.tidyverse.org/)

- [Guardar datos](#guardar-datos)
- [Importar archivos](#importar-archivos)
  - [Quitar o cambiar encabezado de las
    columnas](#quitar-o-cambiar-encabezado-de-las-columnas)
  - [Especificación de columnas](#especificación-de-columnas)
  - [Leer varios archivos en una misma
    tabla](#leer-varios-archivos-en-una-misma-tabla)

> readr proporciona una forma rápida y amigable de leer datos de
> archivos delimitados, como valores separados por comas (.csv) y
> valores separados por tabulaciones (.tsv).

``` r
# install.packages("readr")
library(readr)

# o directamente
library(tidyverse)
#> -- Attaching core tidyverse packages ------------------------ tidyverse 2.0.0 --
#> v dplyr     1.1.4     v purrr     1.0.2
#> v forcats   1.0.0     v stringr   1.5.1
#> v ggplot2   3.4.4     v tibble    3.2.1
#> v lubridate 1.9.3     v tidyr     1.3.0
#> -- Conflicts ------------------------------------------ tidyverse_conflicts() --
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
#> i Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

Antes de mostrar las principales funciones de `readr`, vamos a crear
unas bases de datos sencillas para poder trabajar con ellas.

``` r
peas_vector <- c("Green", "Smooth", "116", "9", 
                 "Green", "Wrinkled", "40", "3",  
                 "Yellow", "Smooth", "31", "3",  
                 "Yellow", "Wrinkled", "13", "1")

peas <- as_tibble(matrix(peas_vector, nrow = 4, ncol = 4, byrow = T))
   
colnames(peas) <- c("Color", "Textura", "Observacion", "Proporcion")
      
peas2_vector <- c("Green", "Smooth", "120", "9", 
                  "Green", "Wrinkled", "38", "3",  
                  "Yellow", "Smooth", "32", "3",  
                  "Yellow", "Wrinkled", "10", "1")
    
peas2 <- as_tibble(matrix(peas2_vector, nrow = 4, ncol = 4, byrow = T))
    
colnames(peas2) <-c("Color", "Textura", "Observacion", "Proporcion")
```

## Guardar datos

``` r
# establecer previamente el directorio de trabajo, donde se guardarán los archivos
# setwd("mi_directorio_de_trabajo")

# en readr
write_csv(peas, file = "peas.csv") # archivo separado por comas

write_delim(peas,
            file = "peas_tab.csv",
            delim = "|")           # opción de emplear cualquier delimitador

# otras funciones:
  # write_csv2() archivo separado por ;
  # write_tsv() archivo .txt 


# en R base la sintaxis es muy similar
write.csv(peas, file = "peas_rbase.csv") # archivo separado por comas

# write.csv2() # archivo separado por ;
```

## Importar archivos

Con cualquier delimitador

``` r
# con readr no es necesario especificar el delimitador
peas_readr <- read_delim("peas_tab.csv")
print(peas_readr)
#> # A tibble: 4 x 4
#>   Color  Textura  Observacion Proporcion
#>   <chr>  <chr>          <dbl>      <dbl>
#> 1 Green  Smooth           116          9
#> 2 Green  Wrinkled          40          3
#> 3 Yellow Smooth            31          3
#> 4 Yellow Wrinkled          13          1

# en R base sí
peas_rbase <- read.delim("peas_tab.csv", sep = "|")
print(peas_rbase)
#>    Color  Textura Observacion Proporcion
#> 1  Green   Smooth         116          9
#> 2  Green Wrinkled          40          3
#> 3 Yellow   Smooth          31          3
#> 4 Yellow Wrinkled          13          1
```

Separados por comas

``` r
# readr
peas_readr <- read_csv("peas.csv")
print(peas_readr)
#> # A tibble: 4 x 4
#>   Color  Textura  Observacion Proporcion
#>   <chr>  <chr>          <dbl>      <dbl>
#> 1 Green  Smooth           116          9
#> 2 Green  Wrinkled          40          3
#> 3 Yellow Smooth            31          3
#> 4 Yellow Wrinkled          13          1

# R base
peas_rbase <- read.csv("peas.csv")
print(peas_rbase)
#>    Color  Textura Observacion Proporcion
#> 1  Green   Smooth         116          9
#> 2  Green Wrinkled          40          3
#> 3 Yellow   Smooth          31          3
#> 4 Yellow Wrinkled          13          1
```

#### Quitar o cambiar encabezado de las columnas

A la hora de leer los archivos en R, se pueden establecer ciertos
parámetros en función de las necesidades. Por ejemplo, establecer que el
encabezado por defecto no lo detecte como tal y lo lea como una fila
más.

``` r
# readr
peas_readr <- read_delim("peas.csv", col_names = F)
print(peas_readr) 
#> # A tibble: 5 x 4
#>   X1     X2       X3          X4        
#>   <chr>  <chr>    <chr>       <chr>     
#> 1 Color  Textura  Observacion Proporcion
#> 2 Green  Smooth   116         9         
#> 3 Green  Wrinkled 40          3         
#> 4 Yellow Smooth   31          3         
#> 5 Yellow Wrinkled 13          1

# R base
peas_rbase <- read.csv("peas.csv", header  = F)
print(peas_rbase)
#>       V1       V2          V3         V4
#> 1  Color  Textura Observacion Proporcion
#> 2  Green   Smooth         116          9
#> 3  Green Wrinkled          40          3
#> 4 Yellow   Smooth          31          3
#> 5 Yellow Wrinkled          13          1
```

Al contrario, puede que las bases de datos no contengan encabezado y se
quiera añadir conforme se lee el archivo en R.

``` r
# readr
peas_readr <- read_delim("peas.csv", col_names = c("Colour", "Coat", "Obs", "Ratio"))
print(peas_readr)
#> # A tibble: 5 x 4
#>   Colour Coat     Obs         Ratio     
#>   <chr>  <chr>    <chr>       <chr>     
#> 1 Color  Textura  Observacion Proporcion
#> 2 Green  Smooth   116         9         
#> 3 Green  Wrinkled 40          3         
#> 4 Yellow Smooth   31          3         
#> 5 Yellow Wrinkled 13          1

# R base
colnames(peas_rbase) <- c("Colour", "Coat", "Obs", "Ratio")
print(peas_rbase)
#>   Colour     Coat         Obs      Ratio
#> 1  Color  Textura Observacion Proporcion
#> 2  Green   Smooth         116          9
#> 3  Green Wrinkled          40          3
#> 4 Yellow   Smooth          31          3
#> 5 Yellow Wrinkled          13          1
```

#### Especificación de columnas

Otro ejemplo, es que al importar los datos para comenzar el trabajo en
R, se quiera especificar directamente el formato en el que debe leer
cada variable.

``` r
# readr
# en readr, mediante el argumento col_types se pueden especificar las columnas directamente de forma independiente
peas_readr <- read_csv("peas.csv",
  col_types = cols(
    Color = col_factor(),
    Textura = col_factor(),
    Observacion = col_integer(),
    Proporcion = col_integer()
  )
)

str(peas_readr)
#> spc_tbl_ [4 x 4] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
#>  $ Color      : Factor w/ 2 levels "Green","Yellow": 1 1 2 2
#>  $ Textura    : Factor w/ 2 levels "Smooth","Wrinkled": 1 2 1 2
#>  $ Observacion: int [1:4] 116 40 31 13
#>  $ Proporcion : int [1:4] 9 3 3 1
#>  - attr(*, "spec")=
#>   .. cols(
#>   ..   Color = col_factor(levels = NULL, ordered = FALSE, include_na = FALSE),
#>   ..   Textura = col_factor(levels = NULL, ordered = FALSE, include_na = FALSE),
#>   ..   Observacion = col_integer(),
#>   ..   Proporcion = col_integer()
#>   .. )
#>  - attr(*, "problems")=<externalptr>

# adicionalmente se puede realizar con un vector: "ffii", donde se indica que las dos primeras columnas son factores y las dos siguientes son numÃ©ricas
peas_readr <- read_csv("peas.csv",
                       col_types = "ffii")
str(peas_readr)
#> spc_tbl_ [4 x 4] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
#>  $ Color      : Factor w/ 2 levels "Green","Yellow": 1 1 2 2
#>  $ Textura    : Factor w/ 2 levels "Smooth","Wrinkled": 1 2 1 2
#>  $ Observacion: int [1:4] 116 40 31 13
#>  $ Proporcion : int [1:4] 9 3 3 1
#>  - attr(*, "spec")=
#>   .. cols(
#>   ..   Color = col_factor(levels = NULL, ordered = FALSE, include_na = FALSE),
#>   ..   Textura = col_factor(levels = NULL, ordered = FALSE, include_na = FALSE),
#>   ..   Observacion = col_integer(),
#>   ..   Proporcion = col_integer()
#>   .. )
#>  - attr(*, "problems")=<externalptr>


# R base
peas_rbase <- read.csv("peas.csv")
str(peas_rbase)
#> 'data.frame':    4 obs. of  4 variables:
#>  $ Color      : chr  "Green" "Green" "Yellow" "Yellow"
#>  $ Textura    : chr  "Smooth" "Wrinkled" "Smooth" "Wrinkled"
#>  $ Observacion: int  116 40 31 13
#>  $ Proporcion : int  9 3 3 1

# mediante el argumento colClasses se puede especificar directamente
peas_rbase <- read.csv("peas.csv", 
                       colClasses = c("factor", "factor", "integer", "integer"))
```

En `readr` dentro de la función `read_csv()`, además se puede
especificar el argumento `guess_max`. En grandes bases de datos,
normalmente esta función de `readr` usa las 1000 primeras filas para
identificar/establecer el tipo de variable que es cada columna. Se puede
usar este argumento, para indicar el número de filas que tiene que usar
para determinar el tipo de columna.

#### Leer varios archivos en una misma tabla

Puede ser que tengamos varios archivos complementarios entre sí, pero
que contienen información diferente. En este caso, podría ser
interesante importarlos todos juntos para comenzar a trabajar con ellos
en R.

``` r
# en readr, se pueden cargar directamente concatenándolos
black_eyed_readr <- read_csv(c("peas.csv", "peas2.csv"))
print(black_eyed_readr)
#> # A tibble: 8 x 4
#>   Color  Textura  Observacion Proporcion
#>   <chr>  <chr>          <dbl>      <dbl>
#> 1 Green  Smooth           116          9
#> 2 Green  Wrinkled          40          3
#> 3 Yellow Smooth            31          3
#> 4 Yellow Wrinkled          13          1
#> 5 Green  Smooth           120          9
#> 6 Green  Wrinkled          38          3
#> 7 Yellow Smooth            32          3
#> 8 Yellow Wrinkled          10          1

# con R base se importan por separado y después se pueden unir
peas_rbase <- read.csv("peas.csv")
peas_rbase_2 <- read.csv("peas2.csv")
black_eyed_rbase <- rbind(peas_rbase, peas_rbase_2)
print(black_eyed_rbase)
#>    Color  Textura Observacion Proporcion
#> 1  Green   Smooth         116          9
#> 2  Green Wrinkled          40          3
#> 3 Yellow   Smooth          31          3
#> 4 Yellow Wrinkled          13          1
#> 5  Green   Smooth         120          9
#> 6  Green Wrinkled          38          3
#> 7 Yellow   Smooth          32          3
#> 8 Yellow Wrinkled          10          1
```

En general, la sintaxis entre ambos paquetes es muy similar, pero en
algunos casos `readr` reduce la cantidad de código necesario!
