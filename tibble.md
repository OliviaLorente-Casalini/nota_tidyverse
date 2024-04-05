# [tibble](https://tibble.tidyverse.org/)

- [tibble vs data frame](#tibble-vs-data-frame)
  - [Creación](#creación)
  - [Impresión](#impresión)
  - [Subconjuntos (subset)](#subconjuntos-subset)
  - [Reciclaje](#reciclaje)
  - [Operaciones aritméticas](#operaciones-aritméticas)
  - [Coerción](#coerción)

> Un tibble, o tbl_df, es una reestructuración moderna del data.frame,
> manteniendo lo que ha demostrado ser eficaz a lo largo del tiempo y
> desechando lo que no lo ha sido.

``` r
# install.packages("tibble")
library(tibble)

# o directamente
library(tidyverse)
#> -- Attaching core tidyverse packages ------------------------ tidyverse 2.0.0 --
#> v dplyr     1.1.4     v purrr     1.0.2
#> v forcats   1.0.0     v readr     2.1.5
#> v ggplot2   3.4.4     v stringr   1.5.1
#> v lubridate 1.9.3     v tidyr     1.3.0
#> -- Conflicts ------------------------------------------ tidyverse_conflicts() --
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
#> i Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

## tibble vs data frame

Este documento está basado en
<https://tibble.tidyverse.org/articles/tibble.html>

#### Creación

Nunca cambia el tipo de input.

``` r
# dataframe a veces cambia strings (cadenas de caracteres) a factores
str(data.frame(
  a = 1:length(letters), 
  b = letters
  # stringsAsFactors = FALSE
  ))
#> 'data.frame':    26 obs. of  2 variables:
#>  $ a: int  1 2 3 4 5 6 7 8 9 10 ...
#>  $ b: chr  "a" "b" "c" "d" ...

# tibble nunca
tibble(
  a = 1:length(letters), 
  b = letters
  )
#> # A tibble: 26 x 2
#>        a b    
#>    <int> <chr>
#>  1     1 a    
#>  2     2 b    
#>  3     3 c    
#>  4     4 d    
#>  5     5 e    
#>  6     6 f    
#>  7     7 g    
#>  8     8 h    
#>  9     9 i    
#> 10    10 j    
#> # i 16 more rows
```

Permite trabajar con listas-columna.

``` r
# data frame no permite
data.frame(x = 1:2, y = list(1:3, letters))
#> Error in (function (..., row.names = NULL, check.rows = FALSE, check.names = TRUE, : arguments imply differing number of rows: 3, 26

# tibble sí
tibble(x = 1:2, y = list(1:3, letters))
#> # A tibble: 2 x 2
#>       x y         
#>   <int> <list>    
#> 1     1 <int [3]> 
#> 2     2 <chr [26]>
```

No ajusta nombres de variables.

``` r
# data frame elimina los espacios
# y no admite caracteres especiales
names(data.frame(`pred^ocs uah` = 1))
#> [1] "pred.ocs.uah"

# tibble sí
names(tibble(`pred^ocs uah` = 1))
#> [1] "pred^ocs uah"
```

Evalúa los argumentos de forma lazy y secuencial.

``` r
# evaluacion lazy: solo se evalua cuando se requiere el argumento
mult <- function(x, y){
  x * 10
}
mult(5)
#> [1] 50

# evaluacion secuencial
# data frame no evalua de forma secuencial
data.frame(x = 1:5, y = x * 5)
#> Error in eval(expr, envir, enclos): objeto 'x' no encontrado

# tibble si
tibble(x = 1:5, y = x * 5)
#> # A tibble: 5 x 2
#>       x     y
#>   <int> <dbl>
#> 1     1     5
#> 2     2    10
#> 3     3    15
#> 4     4    20
#> 5     5    25
```

#### Impresión

La funcion `print()` muestra solamente las 10 primeras filas por defecto
y todas las columnas que caben en la pantalla. Indica el tipo de cada
columna y utiliza distintos estilos de fuente y colores para destacar
aspectos importantes que faciliten la interpretación del output.

``` r
# n. de filas (todas las columnas)
# n. de columnas (ampliar y disminuir el tamano de la consola)
# tipo de variable (todas las columnas)
# colorea valores positivos y negativos (col x)
# los miles estan subrayados (col y)
# se muestran los tres digitos mas importantes de cada numero (es decir los digitos que representan > 99.9% del valor del numero) y un punto final que indica la existencia de decimales (col z y h)

data.frame(
  x = -5:5,
  y = 1000:1010,
  z = pi * 300
  )
#>     x    y        z
#> 1  -5 1000 942.4778
#> 2  -4 1001 942.4778
#> 3  -3 1002 942.4778
#> 4  -2 1003 942.4778
#> 5  -1 1004 942.4778
#> 6   0 1005 942.4778
#> 7   1 1006 942.4778
#> 8   2 1007 942.4778
#> 9   3 1008 942.4778
#> 10  4 1009 942.4778
#> 11  5 1010 942.4778

tibble(
  x = -5:5,
  y = 1000:1010,
  z = pi * 300,
  h = pi * x ^ x,
  k = x
  )
#> # A tibble: 11 x 5
#>        x     y     z          h     k
#>    <int> <int> <dbl>      <dbl> <int>
#>  1    -5  1000  942.   -0.00101    -5
#>  2    -4  1001  942.    0.0123     -4
#>  3    -3  1002  942.   -0.116      -3
#>  4    -2  1003  942.    0.785      -2
#>  5    -1  1004  942.   -3.14       -1
#>  6     0  1005  942.    3.14        0
#>  7     1  1006  942.    3.14        1
#>  8     2  1007  942.   12.6         2
#>  9     3  1008  942.   84.8         3
#> 10     4  1009  942.  804.          4
#> 11     5  1010  942. 9817.          5
```

Se pueden modificar las opciones por defecto.

``` r
# p.ej. para mostrar siempre todas las filas
options(pillar.print_max = Inf)

# p.ej. para mostrar siempre todas las columnas
options(pillar.width = Inf)
```

#### Subconjuntos (subset)

Al realizar un subset a un tibble \[\] siempre devuelve otro tibble. Sin
embargo, en data frames a veces devuelve un data frame y otras, un
vector.

``` r
df <- data.frame(x = 1:5, y = 6:10)
# data frame
class(df[, 1:2])
#> [1] "data.frame"
# vector
class(df[, 1])
#> [1] "integer"

tbl <- tibble(x = 1:5, y = 6:10)
# tibble
class(tbl[, 1:2])
#> [1] "tbl_df"     "tbl"        "data.frame"
# tibble
class(tbl[, 1])
#> [1] "tbl_df"     "tbl"        "data.frame"

# se puede extraer una sola columna en un tibble mediante [[]] y $
class(tbl[[1]])
#> [1] "integer"
class(tbl$x)
#> [1] "integer"
```

Los tibbles son mas restrictivos con el operador \$. Nunca realizan
coincidencias parciales, y lanzan una advertencia y devuelven NULL si la
columna no existe.

``` r
df <- data.frame(hello = 1)
df$h
#> [1] 1
df$he
#> [1] 1
df$hel
#> [1] 1
df$hell
#> [1] 1
df$hello
#> [1] 1

tbl <- tibble(hello = 1)
tbl$h
#> Warning: Unknown or uninitialised column: `h`.
#> NULL
tbl$he
#> Warning: Unknown or uninitialised column: `he`.
#> NULL
tbl$hel
#> Warning: Unknown or uninitialised column: `hel`.
#> NULL
tbl$hell
#> Warning: Unknown or uninitialised column: `hell`.
#> NULL
tbl$hello
#> [1] 1
```

Los tibbles no admiten nombres de fila. Estos se eliminan al convertir
desde data frame a tibble o al realizar un subset.

``` r
df <- data.frame(x = 1:5, row.names = letters[1:5])
rownames(df)
#> [1] "a" "b" "c" "d" "e"

# se eliminan
rownames(as_tibble(df))
#> [1] "1" "2" "3" "4" "5"

tbl <- tibble(x = 1:5)
# advertencia
rownames(tbl) <- letters[1:5]
#> Warning: Setting row names on a tibble is deprecated.
# existen
rownames(tbl)
#> [1] "a" "b" "c" "d" "e"
# pero al realizar el subset se eliminan
rownames(tbl[5, ])
#> [1] "1"
```

#### Reciclaje

Al construir un tibble, sólo se reciclan los valores de longitud 1. La
primera columna con longitud diferente a uno determina el número de
filas del tibble.

``` r
# longitud de 1 -> se recicla
data.frame(x = 1, y = 1:6)
#>   x y
#> 1 1 1
#> 2 1 2
#> 3 1 3
#> 4 1 4
#> 5 1 5
#> 6 1 6
tibble(x = 1, y = 1:6)
#> # A tibble: 6 x 2
#>       x     y
#>   <dbl> <int>
#> 1     1     1
#> 2     1     2
#> 3     1     3
#> 4     1     4
#> 5     1     5
#> 6     1     6

# longitud de 2 -> se recicla
data.frame(x = 1:2, y = 1:6)
#>   x y
#> 1 1 1
#> 2 2 2
#> 3 1 3
#> 4 2 4
#> 5 1 5
#> 6 2 6
# longitud de 2 -> no se recicla
tibble(x = 1:2, y = 1:6)
#> Error in `tibble()`:
#> ! Tibble columns must have compatible sizes.
#> * Size 2: Existing data.
#> * Size 6: Column `y`.
#> i Only values of size one are recycled.
```

#### Operaciones aritméticas

Los tibbles no admiten operaciones aritméticas en las columnas y por
ello lo convierten silenciosamente a un data frame en el momento de
realizar las operaciones. Indican que esto se puede convertir en un
error en una próxima versión de tibble.

``` r
df <- data.frame(a = 1:5, b = 6:10)
class(df * 2)
#> [1] "data.frame"

tbl <- tibble(a = 1:5, b = 6:10)
class(tbl * 2)
#> [1] "data.frame"
```

#### Coerción

Tibble proporciona la función `as_tibble()` para coercionar objetos
hacia tibbles. Sus métodos son más sencillos y por tanto, más rápidos
que los de `as.data.frame()`.

``` r
x <- replicate(10, sample(100), simplify = FALSE)
names(x) <- letters[1:length(x)]

timing <- bench::mark(
  as_tibble(x),
  as.data.frame(x),
  check = FALSE,
  time_unit = "ns"
)

timing
#> # A tibble: 2 x 6
#>   expression           min  median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>         <dbl>   <dbl>     <dbl> <bch:byt>    <dbl>
#> 1 as_tibble(x)     132807. 144225.     5817.    12.9KB     28.0
#> 2 as.data.frame(x) 476544. 524920.     1551.        0B     29.3
```

Tidyverse está optimizado para usar tibbles!
