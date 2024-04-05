# [stringr](https://stringr.tidyverse.org/)

- [Detectar coincidencias](#detectar-coincidencias)
  - [`str_detect()`](#str_detect)
  - [`str_locate()`](#str_locate)
  - [`str_count()`](#str_count)
- [Extracción de texto](#extracción-de-texto)
  - [`str_sub()`](#str_sub)
  - [`str_subset()`](#str_subset)
  - [`str_extract()`](#str_extract)
  - [`str_match()`](#str_match)
- [Gestión del tamaño de cadenas de
  texto](#gestión-del-tamaño-de-cadenas-de-texto)
  - [`str_lenght()`](#str_lenght)
  - [`str_pad()`y `str_trunc()`](#str_pady-str_trunc)
  - [`str_trim()`](#str_trim)
- [Editar cadenas de texto](#editar-cadenas-de-texto)
  - [`str_sub()`](#str_sub-1)
  - [`str_replace()` y
    `str_replace_all()`](#str_replace-y-str_replace_all)
  - [`str_to...()`](#str_to...)
- [Unir y separar cadenas de texto](#unir-y-separar-cadenas-de-texto)
  - [Unión: `str_c()` y `str_dup()`](#unión-str_c-y-str_dup)
  - [Separación: `str_split()` y
    `str_split_fixed()`](#separación-str_split-y-str_split_fixed)
- [Ordenar cadenas de texto](#ordenar-cadenas-de-texto)

> El paquete stringr proporciona una serie de funciones para trabajar
> con cadenas de texto en R. Una cadena de texto o de caracteres es una
> secuencia ordenada de letras, números u otros signos que se
> representan entre comillas y que se leen como texto. Este tipo de
> datos tienen mucha importancia en procesos de preparación y limpieza
> de datos.
>
> Las expresiones regulares, RegExp or [regular
> expresions](https://cran.r-project.org/web/packages/stringr/vignettes/regular-expressions.html)
> son una secuencia de caracteres que define un patrón de búsqueda. Su
> uso es muy común en la manipulación de textos o cadenas de caracteres.

``` r
# install.packages("stringr")
library(stringr)

# o directamente
library(tidyverse)
#> -- Attaching core tidyverse packages ------------------------ tidyverse 2.0.0 --
#> v dplyr     1.1.4     v purrr     1.0.2
#> v forcats   1.0.0     v readr     2.1.5
#> v ggplot2   3.4.4     v tibble    3.2.1
#> v lubridate 1.9.3     v tidyr     1.3.0
#> -- Conflicts ------------------------------------------ tidyverse_conflicts() --
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
#> i Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

Cadena de texto de ejemplo:

``` r

estrofa <- "Hay hombres que luchan un día. Y son buenos. Hay otros que luchan un año. Y son mejores. Hay quienes luchan muchos años.Y son muy buenos. Pero hay los que luchan toda la vida. Esos son los imprescindibles. Bertolt Brecht"

versos <- c("Hay hombres que luchan un día.", "Y son buenos.", "Hay otros que luchan un año.", "Y son mejores.", "Hay quienes luchan muchos años.", "Y son muy buenos.", "Pero hay los que luchan toda la vida.", "Esos son los imprescindibles.", "Bertolt Brecht.")
```

## Detectar coincidencias

Funciones que detectan una coincidencia entre una cadena de texto y un
patrón específico.

### `str_detect()`

La función `str_detect(texto, patrón)` devuelve una sentencia lógica
(verdadero = T, falso = F) por cada elemento que indica si se produce o
no coincidencia.

``` r
# stringr
str_detect(estrofa, "luchan")
#> [1] TRUE
str_detect(versos, "luchan")
#> [1]  TRUE FALSE  TRUE FALSE  TRUE FALSE  TRUE FALSE FALSE

# R base
grepl("luchan", estrofa)
#> [1] TRUE
grepl("luchan", versos)
#> [1]  TRUE FALSE  TRUE FALSE  TRUE FALSE  TRUE FALSE FALSE
```

También se pueden emplear funciones para detectar patrones en función
del inicio o final de una cadena de caracteres.

``` r
# stringr presenta las funciones str_starts() y str_ends()
str_starts(estrofa, "Hay hombres que luchan")
#> [1] TRUE
str_starts(estrofa, "Hay mujeres que luchan")
#> [1] FALSE
str_starts(versos, "Hay")
#> [1]  TRUE FALSE  TRUE FALSE  TRUE FALSE FALSE FALSE FALSE

str_ends(estrofa, "Bertolt Brecht")
#> [1] TRUE
str_ends(estrofa, "otra persona")
#> [1] FALSE


# R base emplea el símbolo ^ para indicar el inicio
grepl("^Hay hombres que luchan", estrofa)
#> [1] TRUE
grepl("^Hay mujeres que luchan", estrofa)
#> [1] FALSE
grepl("^Hay", versos)
#> [1]  TRUE FALSE  TRUE FALSE  TRUE FALSE FALSE FALSE FALSE

# y el símbolo $ para indicar el final
grepl("Bertolt Brecht$", estrofa)
#> [1] TRUE
grepl("otra persona$", estrofa)
#> [1] FALSE
```

### `str_locate()`

La función `str_locate(texto, patrón)` devuelve la posición, dentro de
cada elemento, de los caracteres donde se produce la primera
coincidecia.

``` r
# stringr
str_locate(versos, "luchan")
#>       start end
#>  [1,]    17  22
#>  [2,]    NA  NA
#>  [3,]    15  20
#>  [4,]    NA  NA
#>  [5,]    13  18
#>  [6,]    NA  NA
#>  [7,]    18  23
#>  [8,]    NA  NA
#>  [9,]    NA  NA
str_locate(estrofa, "luchan")
#>      start end
#> [1,]    17  22

# R base
as.numeric(regexpr("luchan", versos))
#> [1] 17 -1 15 -1 13 -1 18 -1 -1
locate_base <- matrix(c(regexpr("luchan", versos), 
                       (regexpr("luchan", versos) + attr(regexpr("luchan", versos), "match.length")-1)),
                        ncol = 2)
locate_base[locate_base < 0] <- NA
colnames(locate_base) <- c("start", "end")
print(locate_base)
#>       start end
#>  [1,]    17  22
#>  [2,]    NA  NA
#>  [3,]    15  20
#>  [4,]    NA  NA
#>  [5,]    13  18
#>  [6,]    NA  NA
#>  [7,]    18  23
#>  [8,]    NA  NA
#>  [9,]    NA  NA
```

La función `str_locate_all(texto, patrón)` busca todas las coincidencias
y devuelve una matriz con las posiciones.

``` r
# stringr
str_locate_all(estrofa, "luchan")
#> [[1]]
#>      start end
#> [1,]    17  22
#> [2,]    60  65
#> [3,]   102 107
#> [4,]   156 161

# R base
unlist(gregexpr("luchan", estrofa))
#> [1]  17  60 102 156
locate_base <- matrix(c(gregexpr("luchan", estrofa)[[1]], 
                       (gregexpr("luchan", estrofa)[[1]] + attr(gregexpr("luchan", estrofa)[[1]], "match.length")-1)),
                        ncol = 2)
locate_base[locate_base < 0] <- NA
colnames(locate_base)
#> NULL
print(locate_base)
#>      [,1] [,2]
#> [1,]   17   22
#> [2,]   60   65
#> [3,]  102  107
#> [4,]  156  161
```

### `str_count()`

La función `str_count(texto, patrón)` cuenta el número de coincidencias
que se producen por cada elemento de la cadena de texto.

``` r
# stringr
str_count(versos, "a")
#> [1] 3 0 3 0 3 0 5 0 0
str_count(estrofa, "a")
#> [1] 14

# R base
lengths(regmatches(estrofa, gregexpr("a", estrofa)))
#> [1] 14
lengths(regmatches(versos, gregexpr("a", versos)))
#> [1] 3 0 3 0 3 0 5 0 0
```

## Extracción de texto

### `str_sub()`

La función `str_sub(texto, inicio, final)` extrae la parte de la cadena
de texto que se encuentran entre los caracteres indicados (inicio y
final).

``` r
# stringr
str_sub(estrofa, 5L, 15L)
#> [1] "hombres que"
str_sub(versos, 1L, 5L)
#> [1] "Hay h" "Y son" "Hay o" "Y son" "Hay q" "Y son" "Pero " "Esos " "Berto"

# R base
substr(estrofa, 5L, 15L)
#> [1] "hombres que"
substr(versos, 1L, 5L)
#> [1] "Hay h" "Y son" "Hay o" "Y son" "Hay q" "Y son" "Pero " "Esos " "Berto"
```

### `str_subset()`

La función `str_subset(texto, patrón)` extrae los elementos (completos)
de la cadena que contengan el patrón indicado.

``` r
# stringr
str_subset(versos, "son")
#> [1] "Y son buenos."                 "Y son mejores."               
#> [3] "Y son muy buenos."             "Esos son los imprescindibles."

# R base
versos[grep("son", versos)]
#> [1] "Y son buenos."                 "Y son mejores."               
#> [3] "Y son muy buenos."             "Esos son los imprescindibles."
```

### `str_extract()`

La función `str_extract(texto, patrón)` extrae el patrón indicado (sólo
el patrón, no el elemento completo) en todos los elementos donde se
produce coincidencia. Extrae la primera coincidencia. Si no se produce
coincidencia devuelve NA.

``` r
# stringr
str_extract(versos, "son")
#> [1] NA    "son" NA    "son" NA    "son" NA    "son" NA
str_extract(estrofa, "son")
#> [1] "son"


# R base
v1 <- sub(".*\\b(son\\w*).*", "\\1", versos, perl = T)
v1[v1 != "son"] <- NA
print(v1)
#> [1] NA    "son" NA    "son" NA    "son" NA    "son" NA

e1 <- sub(".*\\b(son\\w*).*", "\\1", estrofa, perl = T)
e1[e1 != "son"] <- NA
print(e1)
#> [1] "son"
```

Con la función `str_extract_all()` se extraen todas las coincidencias en
formato lista.

``` r
# stringr
str_extract_all(estrofa, "son")
#> [[1]]
#> [1] "son" "son" "son" "son"

# R base
versos <- unlist(strsplit(estrofa, "\\."))
versos <- gsub("^\\s", "", versos)
v2 <- sub(".*\\b(son\\w*).*", "\\1", versos, perl = T)
v2[v2 != "son"] <- NA; as.vector(na.omit(v2))
#> [1] "son" "son" "son" "son"
print(v2)
#> [1] NA    "son" NA    "son" NA    "son" NA    "son" NA
```

### `str_match()`

La función `str_match(texto, patrón)` realiza lo mismo que la función
`str_extract()` pero devuelve el resultado en forma de matriz. Con ayuda
de lenguaje regular se pueden extraer grupos de palabras. En este caso,
en la primera columna aparece la frase completa extraida y en las
siguientes las palabras por separado. Con la función `str_match_all()`
se extraen todas las coincidencias y el output es una lista de matrices.

``` r
str_match(versos, "son")
#>       [,1] 
#>  [1,] NA   
#>  [2,] "son"
#>  [3,] NA   
#>  [4,] "son"
#>  [5,] NA   
#>  [6,] "son"
#>  [7,] NA   
#>  [8,] "son"
#>  [9,] NA

str_match(versos, "(son) (buenos|mejores)")
#>       [,1]          [,2]  [,3]     
#>  [1,] NA            NA    NA       
#>  [2,] "son buenos"  "son" "buenos" 
#>  [3,] NA            NA    NA       
#>  [4,] "son mejores" "son" "mejores"
#>  [5,] NA            NA    NA       
#>  [6,] NA            NA    NA       
#>  [7,] NA            NA    NA       
#>  [8,] NA            NA    NA       
#>  [9,] NA            NA    NA

str_match(versos, "(que|son) ([^ ]+)")
#>       [,1]          [,2]  [,3]     
#>  [1,] "que luchan"  "que" "luchan" 
#>  [2,] "son buenos"  "son" "buenos" 
#>  [3,] "que luchan"  "que" "luchan" 
#>  [4,] "son mejores" "son" "mejores"
#>  [5,] NA            NA    NA       
#>  [6,] "son muy"     "son" "muy"    
#>  [7,] "que luchan"  "que" "luchan" 
#>  [8,] "son los"     "son" "los"    
#>  [9,] NA            NA    NA

str_match(estrofa, "(que|son) ([^ ]+)")
#>      [,1]         [,2]  [,3]    
#> [1,] "que luchan" "que" "luchan"

str_match_all(estrofa, "(que|son) ([^ ]+)")
#> [[1]]
#>      [,1]           [,2]  [,3]      
#> [1,] "que luchan"   "que" "luchan"  
#> [2,] "son buenos."  "son" "buenos." 
#> [3,] "que luchan"   "que" "luchan"  
#> [4,] "son mejores." "son" "mejores."
#> [5,] "son muy"      "son" "muy"     
#> [6,] "que luchan"   "que" "luchan"  
#> [7,] "son los"      "son" "los"
```

## Gestión del tamaño de cadenas de texto

### `str_lenght()`

La función `str_length(texto)` devuelve el número de caracteres de cada
elemento de la cadena de texto.

``` r
# stringr
str_length(estrofa)
#> [1] 220
str_length(versos)
#> [1] 29 12 27 13 30 16 36 28 14

# R base
nchar(estrofa)
#> [1] 220
nchar(versos)
#> [1] 29 12 27 13 30 16 36 28 14
```

### `str_pad()`y `str_trunc()`

Las funciones `str_pad()` y `str_trunc()` permiten acortar o alargar los
elementos de la cadena de texto a una longitud constante. `str_pad()`
alarga la cadena y en el argumento “pad” se coloca el/los caracter/es
que se usa para rellenar. `str_trunc()` acorta la cadena de texto y
permite colocar en el argumento “ellipsis” el/los caracter/es que
queremos que aparezcan cuando se suprime una parte del texto.

``` r
# stringr
str_pad(versos, 30, side = "right", pad = "X")
#> [1] "Hay hombres que luchan un díaX"      
#> [2] "Y son buenosXXXXXXXXXXXXXXXXXX"      
#> [3] "Hay otros que luchan un añoXXX"      
#> [4] "Y son mejoresXXXXXXXXXXXXXXXXX"      
#> [5] "Hay quienes luchan muchos años"      
#> [6] "Y son muy buenosXXXXXXXXXXXXXX"      
#> [7] "Pero hay los que luchan toda la vida"
#> [8] "Esos son los imprescindiblesXX"      
#> [9] "Bertolt BrechtXXXXXXXXXXXXXXXX"

# R base
versos30 <- NULL

for(i in 1:length(versos)){
  if(nchar(versos[i]) < 30){
    add <- 30 - nchar(versos[i])
    versos30[i] <- paste0(versos[i], paste0(rep("X", add), collapse = ""))
  }else{
    versos30[i] <- versos[i]
  }
}


# stringr
str_trunc(versos, 10, ellipsis = "")
#> [1] "Hay hombre" "Y son buen" "Hay otros " "Y son mejo" "Hay quiene"
#> [6] "Y son muy " "Pero hay l" "Esos son l" "Bertolt Br"

# R base
elip <- ""
paste0(substr(versos, 1L, (10 - nchar(elip))), elip)
#> [1] "Hay hombre" "Y son buen" "Hay otros " "Y son mejo" "Hay quiene"
#> [6] "Y son muy " "Pero hay l" "Esos son l" "Bertolt Br"
```

### `str_trim()`

La función `str_trim()` elimina los espacios al inicio de la cadena de
texto en cada uno de los elementos que la componen.

``` r
# stringr
versos_espacios <- unlist(strsplit(estrofa, "\\."))
print(versos_espacios)
#> [1] "Hay hombres que luchan un día"        
#> [2] " Y son buenos"                        
#> [3] " Hay otros que luchan un año"         
#> [4] " Y son mejores"                       
#> [5] " Hay quienes luchan muchos años"      
#> [6] "Y son muy buenos"                     
#> [7] " Pero hay los que luchan toda la vida"
#> [8] " Esos son los imprescindibles"        
#> [9] " Bertolt Brecht"
str_trim(versos_espacios)
#> [1] "Hay hombres que luchan un día"       
#> [2] "Y son buenos"                        
#> [3] "Hay otros que luchan un año"         
#> [4] "Y son mejores"                       
#> [5] "Hay quienes luchan muchos años"      
#> [6] "Y son muy buenos"                    
#> [7] "Pero hay los que luchan toda la vida"
#> [8] "Esos son los imprescindibles"        
#> [9] "Bertolt Brecht"

# R base
trimws(versos_espacios)
#> [1] "Hay hombres que luchan un día"       
#> [2] "Y son buenos"                        
#> [3] "Hay otros que luchan un año"         
#> [4] "Y son mejores"                       
#> [5] "Hay quienes luchan muchos años"      
#> [6] "Y son muy buenos"                    
#> [7] "Pero hay los que luchan toda la vida"
#> [8] "Esos son los imprescindibles"        
#> [9] "Bertolt Brecht"
```

## Editar cadenas de texto

### `str_sub()`

La función `str_sub(texto, inicio, final)`, además de extraer un
fragmento del texto, también permite sustiuirlo, asignándole una nueva
cadena de texto.

``` r
# stringr
estrofa1 <- estrofa
str_sub(estrofa1, 1L, 11L) <- "También hay mujeres"

# R base
substr(estrofa1, 1L, 11L) <- "También hay mujeres"
```

### `str_replace()` y `str_replace_all()`

La función `str_replace(texto, patrón, reemplazo)` localiza un patrón en
la cadena de texto y lo sustituye por el remplazo indicado.
`str_replace()` solo reemplaza la primera coinicidencia y
`str_replace_all()` reempleaza todas las coincidencias.

``` r
# stringr
str_replace(versos, "son", "*")
#> [1] "Hay hombres que luchan un día"       
#> [2] "Y * buenos"                          
#> [3] "Hay otros que luchan un año"         
#> [4] "Y * mejores"                         
#> [5] "Hay quienes luchan muchos años"      
#> [6] "Y * muy buenos"                      
#> [7] "Pero hay los que luchan toda la vida"
#> [8] "Esos * los imprescindibles"          
#> [9] "Bertolt Brecht"
str_replace(estrofa, "son", "*")
#> [1] "Hay hombres que luchan un día. Y * buenos. Hay otros que luchan un año. Y son mejores. Hay quienes luchan muchos años.Y son muy buenos. Pero hay los que luchan toda la vida. Esos son los imprescindibles. Bertolt Brecht"
str_replace_all(estrofa, "son", "*")
#> [1] "Hay hombres que luchan un día. Y * buenos. Hay otros que luchan un año. Y * mejores. Hay quienes luchan muchos años.Y * muy buenos. Pero hay los que luchan toda la vida. Esos * los imprescindibles. Bertolt Brecht"

# R base
sub("son", "*", versos)
#> [1] "Hay hombres que luchan un día"       
#> [2] "Y * buenos"                          
#> [3] "Hay otros que luchan un año"         
#> [4] "Y * mejores"                         
#> [5] "Hay quienes luchan muchos años"      
#> [6] "Y * muy buenos"                      
#> [7] "Pero hay los que luchan toda la vida"
#> [8] "Esos * los imprescindibles"          
#> [9] "Bertolt Brecht"
sub("son", "*", estrofa)
#> [1] "Hay hombres que luchan un día. Y * buenos. Hay otros que luchan un año. Y son mejores. Hay quienes luchan muchos años.Y son muy buenos. Pero hay los que luchan toda la vida. Esos son los imprescindibles. Bertolt Brecht"
gsub("son", "*", estrofa)
#> [1] "Hay hombres que luchan un día. Y * buenos. Hay otros que luchan un año. Y * mejores. Hay quienes luchan muchos años.Y * muy buenos. Pero hay los que luchan toda la vida. Esos * los imprescindibles. Bertolt Brecht"
```

### `str_to...()`

Las funciones de la familia `str_to_...()` permiten cambiar mayúsculas
por minúsculas. En concreto: - `str_to_lower()` - `str_to_upper()` -
`str_to_sentence()` - `str_to_title()`.

``` r
# stringr
str_to_lower(versos)
#> [1] "hay hombres que luchan un día"       
#> [2] "y son buenos"                        
#> [3] "hay otros que luchan un año"         
#> [4] "y son mejores"                       
#> [5] "hay quienes luchan muchos años"      
#> [6] "y son muy buenos"                    
#> [7] "pero hay los que luchan toda la vida"
#> [8] "esos son los imprescindibles"        
#> [9] "bertolt brecht"
str_to_upper(versos)
#> [1] "HAY HOMBRES QUE LUCHAN UN DÍA"       
#> [2] "Y SON BUENOS"                        
#> [3] "HAY OTROS QUE LUCHAN UN AÑO"         
#> [4] "Y SON MEJORES"                       
#> [5] "HAY QUIENES LUCHAN MUCHOS AÑOS"      
#> [6] "Y SON MUY BUENOS"                    
#> [7] "PERO HAY LOS QUE LUCHAN TODA LA VIDA"
#> [8] "ESOS SON LOS IMPRESCINDIBLES"        
#> [9] "BERTOLT BRECHT"
str_to_sentence("me olvidé empezar la frase con mayúscula")
#> [1] "Me olvidé empezar la frase con mayúscula"
str_to_title(estrofa)
#> [1] "Hay Hombres Que Luchan Un Día. Y Son Buenos. Hay Otros Que Luchan Un Año. Y Son Mejores. Hay Quienes Luchan Muchos Años.y Son Muy Buenos. Pero Hay Los Que Luchan Toda La Vida. Esos Son Los Imprescindibles. Bertolt Brecht"

# R base
tolower(versos)
#> [1] "hay hombres que luchan un día"       
#> [2] "y son buenos"                        
#> [3] "hay otros que luchan un año"         
#> [4] "y son mejores"                       
#> [5] "hay quienes luchan muchos años"      
#> [6] "y son muy buenos"                    
#> [7] "pero hay los que luchan toda la vida"
#> [8] "esos son los imprescindibles"        
#> [9] "bertolt brecht"
toupper(versos)
#> [1] "HAY HOMBRES QUE LUCHAN UN DÍA"       
#> [2] "Y SON BUENOS"                        
#> [3] "HAY OTROS QUE LUCHAN UN AÑO"         
#> [4] "Y SON MEJORES"                       
#> [5] "HAY QUIENES LUCHAN MUCHOS AÑOS"      
#> [6] "Y SON MUY BUENOS"                    
#> [7] "PERO HAY LOS QUE LUCHAN TODA LA VIDA"
#> [8] "ESOS SON LOS IMPRESCINDIBLES"        
#> [9] "BERTOLT BRECHT"

s <-"me olvidé empezar la frase con mayúscula"
paste0(toupper(substr(s, 1, 1)),
       substr(s, 2, nchar(s)))
#> [1] "Me olvidé empezar la frase con mayúscula"

palabras <- unlist(strsplit(estrofa, "\\s"))
paste0(toupper(substr(palabras, 1, 1)),
       substr(palabras, 2, nchar(palabras)))
#>  [1] "Hay"              "Hombres"          "Que"              "Luchan"          
#>  [5] "Un"               "Día."             "Y"                "Son"             
#>  [9] "Buenos."          "Hay"              "Otros"            "Que"             
#> [13] "Luchan"           "Un"               "Año."             "Y"               
#> [17] "Son"              "Mejores."         "Hay"              "Quienes"         
#> [21] "Luchan"           "Muchos"           "Años.Y"           "Son"             
#> [25] "Muy"              "Buenos."          "Pero"             "Hay"             
#> [29] "Los"              "Que"              "Luchan"           "Toda"            
#> [33] "La"               "Vida."            "Esos"             "Son"             
#> [37] "Los"              "Imprescindibles." "Bertolt"          "Brecht"
```

## Unir y separar cadenas de texto

### Unión: `str_c()` y `str_dup()`

En el paquete `stringr` hay dos funciones que permiten concatenar o unir
cadenas de texto. `str_c(texto1, texto2...)` une los textos
especificados en el argumento y `str_dup(texto, n)` repite el texto
tantas veces como se especifique en el argumento “n”.

``` r
# stringr
str_c(letters, LETTERS)
#>  [1] "aA" "bB" "cC" "dD" "eE" "fF" "gG" "hH" "iI" "jJ" "kK" "lL" "mM" "nN" "oO"
#> [16] "pP" "qQ" "rR" "sS" "tT" "uU" "vV" "wW" "xX" "yY" "zZ"
str_dup("flor", 10)
#> [1] "florflorflorflorflorflorflorflorflorflor"

# R base
paste0(letters, LETTERS)
#>  [1] "aA" "bB" "cC" "dD" "eE" "fF" "gG" "hH" "iI" "jJ" "kK" "lL" "mM" "nN" "oO"
#> [16] "pP" "qQ" "rR" "sS" "tT" "uU" "vV" "wW" "xX" "yY" "zZ"
paste0(rep("flor", 10), collapse = "")
#> [1] "florflorflorflorflorflorflorflorflorflor"
```

### Separación: `str_split()` y `str_split_fixed()`

Las funciones `str_split(texto, patrón)` y
`str_split_fixed(texto, patrón, n)` permiten dividir cadenas de texto.
La primera función divide los elementos en grupos según el patrón. La
segunda función hace lo mismo pero solo en el número de grupos
especificados por el argumento n.

``` r
# stringr
str_split(estrofa, "\\.")
#> [[1]]
#> [1] "Hay hombres que luchan un día"        
#> [2] " Y son buenos"                        
#> [3] " Hay otros que luchan un año"         
#> [4] " Y son mejores"                       
#> [5] " Hay quienes luchan muchos años"      
#> [6] "Y son muy buenos"                     
#> [7] " Pero hay los que luchan toda la vida"
#> [8] " Esos son los imprescindibles"        
#> [9] " Bertolt Brecht"
str_split_fixed(versos, " ", n = 3)
#>       [,1]      [,2]      [,3]                         
#>  [1,] "Hay"     "hombres" "que luchan un día"          
#>  [2,] "Y"       "son"     "buenos"                     
#>  [3,] "Hay"     "otros"   "que luchan un año"          
#>  [4,] "Y"       "son"     "mejores"                    
#>  [5,] "Hay"     "quienes" "luchan muchos años"         
#>  [6,] "Y"       "son"     "muy buenos"                 
#>  [7,] "Pero"    "hay"     "los que luchan toda la vida"
#>  [8,] "Esos"    "son"     "los imprescindibles"        
#>  [9,] "Bertolt" "Brecht"  ""

# R base
strsplit(estrofa, "\\.")
#> [[1]]
#> [1] "Hay hombres que luchan un día"        
#> [2] " Y son buenos"                        
#> [3] " Hay otros que luchan un año"         
#> [4] " Y son mejores"                       
#> [5] " Hay quienes luchan muchos años"      
#> [6] "Y son muy buenos"                     
#> [7] " Pero hay los que luchan toda la vida"
#> [8] " Esos son los imprescindibles"        
#> [9] " Bertolt Brecht"

list <- strsplit(versos, "\\s")

for(i in 1:length(list)){
  if(length(list[[i]]) > 3)
    list[[i]][3] <- paste0(list[[i]][3:length(list[[i]])], collapse = " ")
}
t(sapply(list, "[", 1:3))
#>       [,1]      [,2]      [,3]                         
#>  [1,] "Hay"     "hombres" "que luchan un día"          
#>  [2,] "Y"       "son"     "buenos"                     
#>  [3,] "Hay"     "otros"   "que luchan un año"          
#>  [4,] "Y"       "son"     "mejores"                    
#>  [5,] "Hay"     "quienes" "luchan muchos años"         
#>  [6,] "Y"       "son"     "muy buenos"                 
#>  [7,] "Pero"    "hay"     "los que luchan toda la vida"
#>  [8,] "Esos"    "son"     "los imprescindibles"        
#>  [9,] "Bertolt" "Brecht"  NA
```

## Ordenar cadenas de texto

Las funciones `str_order(texto)` y `str_sort(texto)` ordenan
alfabéticamente los elementos de una cadena de texto. La primera
devuelve los índices de los elementos ordenados y la segunda devuelve
los propios elementos.

``` r
# stringr
str_order(versos)
#> [1] 9 8 1 3 5 7 2 4 6
str_sort(versos)
#> [1] "Bertolt Brecht"                      
#> [2] "Esos son los imprescindibles"        
#> [3] "Hay hombres que luchan un día"       
#> [4] "Hay otros que luchan un año"         
#> [5] "Hay quienes luchan muchos años"      
#> [6] "Pero hay los que luchan toda la vida"
#> [7] "Y son buenos"                        
#> [8] "Y son mejores"                       
#> [9] "Y son muy buenos"

# R base
order(versos)
#> [1] 9 8 1 3 5 7 2 4 6
sort(versos)
#> [1] "Bertolt Brecht"                      
#> [2] "Esos son los imprescindibles"        
#> [3] "Hay hombres que luchan un día"       
#> [4] "Hay otros que luchan un año"         
#> [5] "Hay quienes luchan muchos años"      
#> [6] "Pero hay los que luchan toda la vida"
#> [7] "Y son buenos"                        
#> [8] "Y son mejores"                       
#> [9] "Y son muy buenos"
```
