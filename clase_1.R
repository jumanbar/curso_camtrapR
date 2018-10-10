# ---- CLASE 1 - CAMPTRAPR ----------------------------------------------------
# 
# Primera clase del curso - 2018-10-04
# 
# En esta clase se realiza una recorrida, empezando por la imortación de una 
# tabla de registros de cámara trampa, que servirá como ejemplo para mostrar 
# funciones básicas y avanzadas, así como de algunos análisis exploratorios de 
# los datos. Está enfocada en importar y analizar datos, dejando un poco de lado
# la programación en sí.
# 
# Se hace énfasis en las funciones y clases del llamado tidyverse (ver
# https://www.tidyverse.org/), ya que consideramos que es de interés de les
# estudiantes comenzar su aprendizaje incorporando estas nociones desde el
# principio, en lugar de "aprender el modo tradicional" primero.
# 
# Si el tilde no se ve bien acá, reabrir con encoding = UTF-8
# 
# Recomendaciones: configurar el tecldo de forma tal que los caracteres que se 
# escriben son los mismos que se pueden ver en las teclas... Muchas veces 
# tenemos teclados pensados para la configuración en inglés, pero los usamos en 
# español para poder escribir tildes y ñs, pero eso genera confusión a la hora 
# de escribir símbolos necesarios en programación, como [], {}, $, ~, etc...
# 
# Los comandos aquí escritos serán utilizados a lo largo de la clase. Los 
# comentarios, como este texto (marcados con un # a la izquierda), son para 
# futuras referencias, no para leer en clase.
# 
# Este archivo es un guión (script) de R. Normalmente se trabaja con estos 
# archivos, con el fin de poder volver a usar los comandos en el futuro.




# ---- Configuración de incio -------------------------------------------------
#
library(tidyverse)
# Cargo estos paquetes primero, porque son parte de mi caja de herramientas
# habitual. Si no funciona del todo, el mínimo de paquetes creo que es:
# 
# library(magrittr) # La pipa %>%
# library(tibble)   # Un formato de tabla más conveniente que data.frame
# library(dplyr)    # Funciones select, filter, arrange, group_by y más
# library(rlang)    # Un detallecito
# library(ggplot2)  # Gramática de gráficos

# El siguiente es el código generado automáticamente por la función `read_excel`
# al momento de importar la tabla que me interesa, utilizando los botones de
# RStudio:
library(readxl)
tr <-
  read_excel(
    "C:/Users/el usuario/Desktop/jmb/Julana/Curso camtrapR/data/tabla_registros.xlsx",
    col_types = c(
      "text",
      "text",
      "text",
      "date",
      "date",
      "date",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "text",
      "text",
      "text",
      "text",
      "text"
    )
  )
View(tr)
# Clases de las columnas:
sapply(tr, class)

# Alternativamente podemos usar `read.csv2`, ya que también tenemos esa tabla en
# formato CSV:
tr <-
  read.csv2(
    "~/../Desktop/jmb/Julana/Curso camtrapR/data/tabla_registros.csv",
    row.names = 1)
# Clases de las columnas:
sapply(tr, class)

# Es importante tener en cuenta que cuando importamos con esta función, no
# tenemos las opciones de editar las clases de las columnas, como con
# read_excel.

# Para ejecutar los comandos desde la ventana del guión (script), se puede usar
# la combinación Ctrl + Enter.

# View permite mirar de cerca los datos de una forma práctica. Probar con las
# funciones de filtro, ordenar, etc.

# Observaciones:

# - El comando empieza en la línea 2 y termina en la 6.

# - La tabla tiene columnas con distintos tipos de información, les llamamos
# clases. Lo ideal es acomodar las clases a los formatos apropiados en el
# momento de la importación, pero de todas maneras eso se puede hacer después.

# - Copiar y pegar el código generado es útil para no tener que repetir los
# pasos la próxima vez.

# - `library`: llama a un paquete y lo carga en nuestra sesión (ver ventana de
# los paquetes en RStudio)

# - La flecha `<-` es la asignación: es la forma de crear objetos (en este caso,
# una tabla lamada `tr`).

# - Los objetos creados aparecen en la ventana de arriba derecha: es el
# "ambiente" o "espacio de trabajo". También se puede usar el comando `ls()`.

# - A los efectos de este curso, el conjunto del ambiente + los paquetes que
# cargamos con `library` (o con `require`), conforman lo que llamaremos la
# **sesión de R**, la cual se puede guardar para volver a usar en el futuro.





# ---- Caminos ------------------------------------------------
# 
# Otra observación importante: el camino hacia el archivo R trabaja "en una
# carpeta":
getwd() # Será distinto en cada computadora

# En R llamamos directorio de trabajo (working directory o wd) a la carpeta "en
# la que estamos trabajando". Esto afecta la forma que interactuamos con los
# archivos del disco duro.

# Ver también que el camino se escribe entre comillas. Se trata de una "cadena
# de caracteres" y es importante distinguirla de otros tipos de información,
# como los números.

# Probemos armar un camino desde cero:
""
"C:/"
# Apretar tab... se puede escribir fácilmente el camino a cualquier parte del
# disco duro.

# Pique: "~/" = Mis Documentos (Home folder). Lástima que no sirve para los
# ejercicios que hacemos en la clase 2.
"~/"

# Cambiemos el directorio de trabajo al del curso:
setwd("C:/Users/el usuario/Desktop/jmb/Julana/Curso camtrapR/")

# Por cierto: esto es un "camino absoluto" (no importa desde qué parte del disco
# ejecutamos el comando, siempre encontramos esta carpeta).

# El siguiente, en cambio, es un camino relativo (sólo funciona desde la carpeta
# del curso):
"data/tabla_registros.xlsx"

# Ahora que cambiamos el directorio de trabajo, podríamos usar este último
# camino para el primer comando (read_excel), si así lo deseamos. Quedaría así:

tr <- read_excel(
  "data/tabla_registros.xlsx",
  col_types = c(
    "text",
    "text",
    "text",
    "date",
    "date",
    "date",
    "numeric",
    "numeric",
    "numeric",
    "numeric",
    "text",
    "text",
    "text",
    "text",
    "text"
  )
)
# ¿Qué pasa si volvemos a ejecutar este comando, dado que la tabla ya la
# habíamos cargado?

# Tener claro cuál es la carpeta en que estamos trabajando va a ser importante
# para trabajar con el paquete, ya que influye en la forma en que las funciones
# del paquete camtrapR interactua con los archivos de las fotos.

# Ahora podemos usar `dir` para vichar lo que hay en la carpeta:
dir()

# Pique: el punto . indica el la carpeta en la que estamos parades y el doble
# punto .. indica una carpeta más arriba.

dir(".")
dir("..")

#### 
#### ¿En qué situaciones será más útil un camino relativo que uno absoluto, y 
#### viceversa?
#### 





# ---- Mirar la tabla por arriba ----------------------------------------------
#
# Generalmente al importar una tabla, lo primero que hacemos es mirar los
# contenidos. Para eso hay varias herramientas rápidas y muy útiles a
# disposición. Aquí veremos unas cuantas funciones y trucos para ver y retocar
# la tabla que acabamos de importar...

head(tr) # La cabeza
tail(tr) # La cola

# Obs.: `head` y `tail` son **funciones** y, en este caso, tr actua como
# argumento. Más info usando:
?head

# Al ejecutar este comando, RStudio activa la pestaña de ayuda, mostrando la
# documentación de la función `head` (y `tail`). Qué pasa si ejecuto?
head(tr, 3)

#### 
#### ¿A qué argumento se corresponde el número 3 en este caso? ¿Qué diferencia 
#### tiene el resultado de esta sentencia con el de la anterior? ¿En qué se 
#### diferencia con esta sentencia?
#### 
head(n = 3, x = tr)

# La ayuda es un apoyo muy útil para trabajar en R. Es usada por personas de
# todo nivel de experiencia. La ayuda y la internet.

# Otro detalle a considerar: cuando ejecutamos el comando aparece en la consola
# parte de la tabla. Eso es la salida de la función (las entradas son tr y 3).
# Todas las funciones tienen alguna salida (incluso si es NULL, que es como
# "nada"). Usando la asignación, `<-`, podemos "guarda" la salida de la función
# en un objeto, a fin de usarlo a futuro.
cabeza <- head(tr, 10)

# Si queremos ver qué es el objeto creado, alcanza con escribirlo en la consla y
# dar enter (o escribirlo en RStudio y dar enter).
cabeza

# Si decidimos que no nos interesa más ese objeto, se puede borrar con la
# función `rm`:
rm(cabeza)

# (Ver también:)
example(head)

names(tr) # Los nombres de las columnas; `colnames` tb sirve

dim(tr)           # Qué dimensiones tiene la tabla tr
str(tr)           # Un montón de información sobre tr
summary(tr)       # Resumen de todas las columnas
table(tr$Species) # Acá uso `$` para llamar a la variable
table(tr$Camera, tr$Species)






# ------- IMPORTANTE : LAS CLASES DE OBJETOS ----------------------------------

# En algunos de los comandos anterriores se entrevee que las columnas tienen
# distintas clases. Las clases son categorías en las que clasificamos los tipos
# de información. Algunos ejemplos son:

# - Numéricos

# - Texto ("character")

# - Factores (algo así como niveles o tratamientos en un experimento, por 
# ejemplo...)

# - Fecha y hora

# Las clases de los objetos en R son **muy importantes**, ya que determinan cómo
# van a comportarse en diferentes situaciones:
x <- 1
x + 1
x <- c(1, 3, 5)
x * 5
x <- c("coco", "mango", "papaya")
x * 5
x <- c(1, 3, "5") # ¿Y esto?

# Este último ejemplo es paradigmático, ya que nos muestra como R puede
# "mezclar" dos clases diferentes sin dar mensaje de error o avisar. Lo que
# muchas veces ocurre es que aparece un error mucho más adelante, cuando
# queremos usar un objeto creado de esta forma:
x * 5
# Error in x * 5 : non-numeric argument to binary operator

# Es parte de diseño de R y tal vez responda a alguna lógica en particular, pero
# lo cierto es que puede generar fuertes dolores de cabeza. De hecho, muchas
# veces cuando tenemos un error, es buena idea analizar cuáles son las clases de
# los objetos que estamos utilizando.

# Obs.: usamos la función `c`, que sirve para concatenar elementos y formar un
# vector. Los vectores son secuencias de elementos. Por ejemplo, cada columna de
# la tabla es en sí un vector.

# Repasamos las clases más importantes:

# - numeric, ingeter: números

# - character: texto

# - lógica: vectores cuyos valores son TRUE o FALSE

# - factor: secuencias de valores que expresan variables categóricas, muy al
# estilo tratamientos de un experimento controlado.

# - fecha/hora (Date, POSIXct o POSIXt)

# - data.frame: tablas de datos

# - matrix: matriz (a diferencia de tablas, todos sus elementos son de una misma
# clase).

# - tibble: una versión de las tablas que propone el paquete tibble (tidyverse).


#### 
#### Qué hace esta función? De qué clase es la salida de la misma?
is.numeric(x)
is.character(x)
#### 
#### 

#### 
#### Según el caso, x será clase "character" o clase "numeric". Haga pruebas
#### para ver, según los ejemplos de arriba, a cual corresponde cada caso.
class(x)
#### 
#### 

# Volvamos al ejemplo del "camino" de una carpeta o archivo. Recordarán que es
# un poco engorroso escribir un camino (especialmente si es un camino absoluto).
# Imaginen que lento que sería escribir el mismo camino una y otra vez. Esto lo 
# podemos evitar si guardamos el camino en un objeto. Por ejemplo:
camino <- "C:/Users/el usuario/Desktop/jmb/Julana/Curso camtrapR/"

# Ahora, alcanzará con llamarlo para usar este camino:
camino





# ---- Columnas de la tabla: clases -------------------------------------------
 
# Ya dijimos y miramos que las columnas de la tabla tr tienen distintas clases, 
# las cuales se corresponden con la información que contienen.
 
# Si nos interesa cambiar alguna de estas clases, podemos intentar con funciones
# del tipo `as.<clase>`. Por ejemplo:
tr$delta.time.secs # Obs.: llamo a la columna con `$`
as.character(tr$delta.time.days) # Una prueba
tr$delta.time.secs <-
  as.character(tr$delta.time.days) # ¡Transformación!

class(tr$delta.time.secs)

# Los dos primeros son para ver el antes y después. El tercero cambia
# definitivamente la clase de la columna `delta.time.secs`. Podemos devolver esa
# columna a su clase original con `as.numeric`:
tr$delta.time.secs <- as.numeric(tr$delta.time.days)
class(tr$delta.time.secs)

# Hay que tener en cuenta que no siempre salen bien estas conversiones. Por
# ejemplo:
p <- c("papa", "zapallo", "cebolla")
as.numeric(p) # Cualquier verdura
as.character(as.numeric(p))

# Obs.: a qué clase pertenece la tabla tr?
class(tr)





# ---- Nombres de las columnas --------------------------------

# Estos son los nombres de las columnas. Se pueden ver o cambiar con la función
# `names`:

names(tr)
# Obs.: lo que me devuelve es un vector del tipo "character"

names(tr)[5] # Cuál es la columna 5?
names(tr)[5] <- "Fecha" # Decido cambiarle el nombre
names(tr)[6] <- "Hora"  # y acá también

names(tr) # Comprobamos que quedó bien

# Aquí un punto importante: con los corchetes [ ] puedo seleccionar un elemento
# de el **vector**, usando los nombres de las columnas. En este caso lo hice de
# a 1 elemento, pero puedo hacerlo de a varios:

names(tr)[5:6]
names(tr)[5:6] <- c("Fecha", "Hora") # 2 pasos en 1

#### 
#### Obs.: aquí usé la expresión `5:6`. ¿Qué significa? ¡Probar!
#### 

5:6
1:10
- 5:-20
- 5:20
# etc...

#### 
#### ¿Se entiende lo que está pasando?
####




# ==== Seleccionar elementos de la tabla ======================================

# Acá nos enfocaremos en las funciones básicas del paquete dplyr, parte del
# tidyverse.



# ---- La función select: elegir columnas / variables -------------------------

select(tr, Estacion, Camera, Species, Hora:delta.time.days)

select(tr, starts_with("delta"))

select(tr,-Directory,-FileName)

select(tr, 1, 4, 5:8)

select(tr,-5:-8)

i <- 5
select(tr,!!i) # Necesita paquete rlang

require(rlang) # Mirá si está cargado, y si no lo carga
select(tr,!!i)

# ¿Qué pasa si no pongo `!!`?

# Obs.: Así también puedo seleccionar columnas:
tr[, 5:8] # Columnas 5ta a 8va





# ---- La funcion filter: elegir filas / observaciones ------------------------

filter(tr, Estacion == "Edita")
# No devuelve nada

# Para ver qué valores posibles hay en la columna Estación:
distinct(tr, Estacion) # Hay un sólo valor posible
distinct(tr, Species)

# Supongamos que nos interesa ver las observaciones de Lagarto Overo:
filter(tr, Species == "Lagarto Overo")

# Pero también Zorro Perro:
filter(tr, Species == "Lagarto Overo" | Species == "Zorro Perro")

# Con lo que estamos jugando acá es con operadores lógicos, que sirven para
# armar un filtro de observaciones. Para el caso de variables numéricas hay que
# usar >, >=, etc:
filter(tr, delta.time.days < 3)

# Los mismos operadores se pueden usar con fechas, aunque ahí tenemos que
# conocer un poco más de las funciones que existen para trabajar con estas
# clases.
class(tr$Fecha)
summary(tr$Fecha)

# Obs.: UTC es la zona horaria o "time zone".

# Por suerte hay buenos paquetes, como lubridate o xts, que facilitan el trabajo
# con estas clases:
library(lubridate)
f1 <- ymd("2016-01-01")
f2 <- ymd("2017-07-01")
class(f1)

filter(tr, Fecha >= f1 & Fecha < f2)
# Hay 55 observaciones entre Enero y Junio de 2016

# Obs.: se puede especificar la hora incluso:
f1 <- ymd_hms("2016-01-01 06:30:00") # 6 de la mañana
f1
class(f1)

# Por último, se pueden seleccionar filas por número:
slice(tr, 100:120)

# Obs.: acá también se pueden usar los corchetes:
tr[100:120, ]
# Tiene que ir antes de la coma, para indicar filas.
tr[100:120, 5:8]
# Acá selecciono filas y columnas ¿Cuál es cual?




# ---- Combinando comandos ----------------------------------------------------
 
# Parte de la gracia de usar un lenguaje de programación es poder combinar
# varios comandos.
 
# La forma tradicional de R es así:
select(filter(tr, Species == "Vaca"), Camera:Hora)

# Sin embargo, recomiendo usar una altenrativa que propone el tidyverse: la pipa
# `%>%`. Por ejemplo, el comando anterior se puede escribir de esta manera:
tr %>%
  filter(Species == "Vaca") %>%
  select(Camera:Hora)

# Obs.: Ctrl + Shift + A para dejar el código bonito. Parece tonto, pero es muy
# importante para que se pueda leer más fácil.

#### 
#### ¿Qué demonios es `%>%`? En este momento de la clase, nos tomamos unos 
#### momentos para entender con claridad qué significa el código de arriba.
#### 


# ---- Explicación de la pipa: %>% --------------------------------------------

# En líneas generales:
# > `x %>% f` equivale a `f(x)`
# > `x %>% f(y)` equivale a `f(x, y)`
# `x %>% f %>% g %>% h` equivale a `h(g(f(x)))`
# > `x %>% f(y, z = .)` equivale a `f(y, z = x)`

# O sea que:
# y <- f(x)
# g(y)
#
# Es lo mismo que:
#
# g(f(x))
#
# Y con la pipa es: x %>% f %>% g
# 

# Recuerda bastante a la composición de funciones, en matemática:
browseURL("http://slideplayer.es/slide/5632319/2/images/5/Composici%C3%B3n+de+funciones.jpg")

# Personalmente, uso mucho la pipa porque me permite ir construyendo comandos de
# a un paso cada vez, de una forma tal que resulta natural.
tr %>% head

tr %>% summary

tr %>% head(3)

# Etc...





# ---- Paréntesis: el método clásico de seleccionar filas y columnas ----------

# Otro detalle: cuando un objeto tiene nombres, como la tabla tr, podemos
# usarlos para seleccionar elementos. Por ejemplo:
tr["Species"]
tr[c("Species", "Camera")]

# Pero esto también se puede hacer con números. Es más, también podemos
# seleccionar filas:
tr[2:3]
tr[, 2:3] # tr[filas, columnas]
# En caso de tablas, estos comandos resultan en lo mismo, no así con objetos del
# tipo `matrix` (más adelante).

tr[30:35, 2:3]
# Filas desde la 30 hasta la 35, de las columnas 2 y 3
# ----------------------------------------------------------- FIN del Paréntesis





# ---- arrange: ordenar por una o más columnas --------------------------------
#
# Similar al botón "ordenar" de excel.
#
# Cuales son los primeros bichos cuando empieza a clarear?
tr %>%
  filter(hour(DateTimeOriginal) >= 5 &
           hour(DateTimeOriginal)  < 8) %>%
  arrange(Species, Hora) %>%
  View

# Ahora igual, pero quiero ver cuáles son los últimos en aparecer antes de
# anochecer:
tr %>%
  filter(hour(DateTimeOriginal) >= 17 &
           hour(DateTimeOriginal)  < 20) %>%
  arrange(Species, desc(Hora)) %>%
  View




# ---- group_by + summarise: resúmenes por grupo ------------------------------

# Para agrupar valores según alguna categoría. Por ejemplo, si quiero saber cuál
# es la primer hora en que aparece cada especie (en la mañana, entre las 5 y 8
# am). Para eso agrupamos por especie (`group_by(Species)`) y usamos la
# conveniente función first para elegir el primer registro de cada una.
tr %>%
  filter(hour(DateTimeOriginal) >= 5 &
           hour(DateTimeOriginal)  < 8) %>%
  group_by(Species) %>%
  summarise(Primer = first(Hora))

# Puedo agrupar por varios criterios, agregando columnas a group_by. En este 
# caso las columnas que me interesan son Camera y Species. Mi intención es sacar
# la cantidad de registros que hay en cada combinación de cámara + especie (y
# otros valores, como horas mínima, máxima y promedio):
horarios <- tr %>%
  group_by(Camera, Species) %>%
  summarise(
    N = n(),
    HoraMin = min(Hora),
    HoraPromedio = mean(Hora),
    HoraMax = max(Hora)
  ) %>%
  arrange(Camera, Species, HoraPromedio)




# ---- mutate: agregar columnas -----------------------------------------------

# Con la función mutate agregamos columnas, con la posibilidad de que las nuevas
# columnas sean hechas en base a las ya existentes. Por ejemplo, en la tabla
# horarios, creada recién, tengo la hora mínima y la hora máxima en que aparecen
# las especies, para cada cámara. El rango horario sería la cantidad de tiempo
# que pasa entre ambas. Para calcular esto puedo usar mutate:
horarios %>%
  mutate(RangoHoras = (HoraMax - HoraMin) / 3600) %>%
  arrange(RangoHoras %>% desc) %>%
  View

# Para aprender más de este tipo de funciones, recomiendo usar las cheatsheets
# (trencitos) que se pueden descargar de la página de RStudio (hay varios en
# español):
browseURL("https://www.rstudio.com/resources/cheatsheets/")





####### PAUSA PARA PREGUNTAS SOBRE LOS DATOS ##################################

####### Explorar preguntas cómo: ¿cuál es la especie que aparece en más
####### cámaras?¿cuál es más diurna?, etc.




# ---- Segunda parte: gráficos con ggplot2 ------------------------------------

# Empezaremos mirando un poco los datos de las fechas en que aparecen los
# registros. Pare esto es bastante práctico hacer un histograma de las fechas
# (histograma: barras que son tan altas como la cantidad de datos que hay para
# un valor x dado).

# Hagamos algún experimento con la columna DateTimeOriginal...
ggplot(tr) + geom_histogram(aes(x = DateTimeOriginal))

# Algunas explicaciones:

#  - `ggplot` es parte del paquete ggplot2, que a su vez es parte del paquete (o
#  conjunto de paquetes), tidyverse

#  - Las funciones de ggplot2 tienen una gramática particular (gg = *Grammar of
#  Graphics*).

#  - La receta básica es: `ggplot(data) + GEOM_FUNCTION(mapeo)`, en donde mapeo
#  es básicamente la función `aes`.

#  - x = DateTimeOriginal, ya que se trata de un histograma, los datos están en
#  el eje de las x (en las y están los conteos)

#  - ggplot2 usa el `+` para combinar funciones. No confundir con `%>%`.

# Obs.: mensaje sobre el `binwidth` ...
ggplot(tr) + geom_histogram(aes(x = DateTimeOriginal), bins = 60)

# ¿Qué diferencia observamos?

# Volviendo al hstograma, podemos ver que la mayoría de los
# registros están en enero. A qué se debe esto? será que hay más
# datos en una Estacion?

ggplot(tr) +
  geom_histogram(aes(x = DateTimeOriginal, fill = Estacion))
# Cierto que hay sólo una estación...

# Probemos con la cámara:
ggplot(tr) +
  geom_histogram(aes(x = DateTimeOriginal, fill = Camera))

# Aquí lo que hice es tomar mi comando original y agregar un componente al
# "mapeo". Es decir, le indiqué que haga un relleno diferente (fill) para cada
# Cámara (de la columna, Camera).

# Esto nos confirma que la separación en los datos se debe a la ubicación de las
# cámaras. Pero también sabemos que hay zorro escondido...

ggplot(tr) +
  geom_histogram(aes(x = DateTimeOriginal, fill = Species))

# Y tengo otro truco bajo la manga... hagamos 2 gráficos, separándolos por
# cámara:
ggplot(tr) +
  geom_histogram(aes(x = DateTimeOriginal, fill = Species)) +
  facet_grid(Camera ~ .)

# Estamos cada vez más cerca de entender la historia. Tenemos al menos 3
# elementos que nos pueden ayudar a explicar el patrón:

# - La presencia del zorro gris

# - La fecha (enero = verano, "los bichos salen más")

# - La ubicación de las cámaras Claramente no son excluyentes. Veamos primero a
# ver qué tanto cambia si sacamos al zorro gris de la ecuación:
tr %>%
  filter(Species != "Zorro Gris") %>%
  ggplot() +
  geom_histogram(aes(x = DateTimeOriginal, fill = Species)) +
  facet_grid(Camera ~ .)

# Podemos ver que aún sin ZG, hay una gran diferencia en las cantidades de
# registros.

# Sobre qué cambió en el código: en vez de tr sólo, encontramos todo este
# comando:
filter(tr, Species != "Zorro Gris")
# Estamos usando la función `filter`, del paquete dplyr (tidyverse). Aquí lo que
# estoy diciendo es: filtrame la tabla tr, dejando solamente aquellos registros
# en los que la especie NO ES el zorro gris (el operador `!=` significa
# "distinto de").

# No se ustedes, pero creo que ya prácticamente contamos la historia: sea por
# lugar, fecha, o ambos, las cámaras tomaron cantidades muy diferentes de
# registros. A esto se suma el ruido que puso la gran cantidad de registros de
# ZG ocurridos únicamente en la cámara 2. Conociendo el comportamiento de los 
# animales, es posible que se trate de muchos registros de unos pocos
# individuos.

# Confesión: La verdadera historia es que: 1. Hay menos datos de cámara1, en
# buena parte porque no tuvimos tiempo para agregar todos los registros que
# había (ie: procesar las fotos, lo cual se hace manualmente). 2. Lo mismo puede
# decirse para la cámara 2 desde febrero a junio. 3. Si miramos las fotos,
# veremos que hay una familia de zorros grises con varios cachorros que pasan
# una y otra vez frente a la cámara, durante el mes de enero.




# ---- Histograma de horas ----------------------------------------------------

# Nunca revisamos muy en detalle la columna Hora:
summary(tr$Hora)

# Confirmado que son todas del mismo día, puedo usar esta columna para hacer el
# histograma:
tr %>%
  filter(Camera == "Camara2") %>%
  ggplot() +
  geom_histogram(aes(x = Hora, fill = Species))

# Hagamos una superposición entre 2 especies:
tr %>%
  filter(Camera == "Camara2" &
           Species %in% c("Zorro Gris", "Lagarto Overo")) %>%
  ggplot() +
  geom_density(aes(x = Hora, col = Species, fill = Species),
               alpha = I(.1)) +
  geom_rug(aes(x = Hora, col = Species),
           sides = "b") +
  scale_x_datetime(limits = ymd_hms(c(
    "1899-12-31 00:00:00", "1900-01-01 00:00:00"
  )))
# scale_x_datetime sirve para marcar el rango de horas que queremos para el
# gráfico.



####### PAUSA PARA HACER GRÁFICOS A PEDIDO ####################



# ---- Sobre la interfaz de R y RStudio ---------------------------------------

# Navegar por los comandos: flechas arriba y abajo en la consola
 
# La historia de comandos también está en la ventana de arriba a la derecha... 
# La historia se puede salvar con el botón de guardar allí presente. Hay otros 
# botones, qué hacen?
 
# En la pestaña de Ambiente, el botón de guardar sirve para salvar la sesión 
# completa. Lo mismo que el siguiente comando:
save.image("sesion1.RData") # .RData es la extensión estándar
save(tr, file = "tabla_registros.RData") # Guarda la tabla

# En la ventana de Gráficos, se puede navegar por las gráficas previas, borrar
# las que no gustan, etc...
 
# También encontramos pestañas de paquetes, ayuda y archivos. En archivos
# podemos navegar por directorios y además.


