
# PREPARAR LA SESION DE TRABAJO --------------------------------

# - Definir el directorio de trabajo (wd)

# En RStudio podemos ir a
# session -> Set Working Directory -> Choose Directory

# En la consola veremos que se ejecuta un comando como este:
# setwd("C:/Users/gabol/Desktop/curso_camtrap/clase23/R")

# (¿Es exactamente igual?¿Que diferencias ve y por qué creen que
# están?)

# Para comprobar que su wd esta correctamente definido, recuerde
# que puede usar la funcion getwd:
getwd()

# - Instalar el paquete camtrapR, unica vez.
# install.packages("camtrapR")

# Activarlo (cargarlo en la sesion de R):
library("camtrapR")


# 0. ORGANIZACION Y GESTION DE IMAGENES ------------------------

# Conviene respaldar las imagens porque el paquete las modifica 
# Guardamos el camino a la carpeta de analisis, en este caso la
# wd:
carpeta_analisis <- getwd()

# Guardamos camino Carpeta de salidas, algunas imagenes
# duplicadas van a dicho directorio. El ".." indica que esta en
# una carpeta arriba del wd:
carpeta_salidas <- "../salidas"


# Crear la estacion en el directorio que especificamos para las
# imagenes crudas para el ejemplo ya estan las carpetas creadas
# con sus camaras dentro por lo que no es necesario correr la
# creacion de estaciones, que es simplemente creear la estructura
# de carpetas.

# Estacion edita, con dos camaras, camara1 y
# camara2:
# createStationFolders(carpeta_analisis,
#                      stations = c("edita","edita"),   #lugar
#                      cameras = c("camara1","camara2") #camara
# )

# Estacion henry, con 1 camara, camara1.
# createStationFolders(carpeta_analisis,
#                      stations = c("henry"), #lugar
#                      cameras = c("camara1") #camara
# )

# Colocamos las imagenes en las carpeta correspondientes, una
# copia ya clasificadas con tag (etiqueta) o con carpetas


# 0.a Instalar ExifTool para leer metadatos de arc --------

# Para esto hay que:

# 1. Descargar el archivo zip de esta página:
# https://sno.phy.queensu.ca/~phil/exiftool/

# 2. Extraer del zip el archivo .exe. en el directorio de
# trabajo que definimos antes.

# 3. Cambiar el nombre del archivo (en vez de
# "exiftool(-k).exe", debe llamarse "exiftool.exe").

# Una vez instalado, corremos el siguiente comando, que sirve
# para que todas las funciones del camtrapR encuentren al
# archivo exiftool.exe cada vez que lo necesiten usar:
exiftoolPath(exiftoolDir = getwd())

# ¿Por qué usamos getwd() aquí?¿Podría usarse otro valor para
# este argumento de la función exiftoolPath?

# 0.b Leo con exiftool los metadatos y verifico -----------
# Esta funcion puedo aplicar a carpeta de analisis
fixDateTimeOriginal(inDir     = carpeta_analisis,
                    recursive = TRUE)


# 1. RETOQUE DE IMAGENES -------------------------------------

# Arreglo los desfasajes de tiempo que pueda haber. Solo si es 
# necesario en una tabla cargo nombre de estacion, camara, 
# magnitud del desfasaje y si se resta o suma el desfasaje en el
# tiempo...


# 1.a Matriz de operaciones -------------------------------

# En este ejemplo, la cámara 1 de edita se quedó sin batería y
# se encontraron las fotos con la fecha inicial del 1/1/2012 (se
# colocó el 1/11/2016). Entonces hay una diferencia de + 4 años
# y 10 meses:

ajuste_t <-
  data.frame(
    estacion = c("edita", "edita", "henry"),
    camara = c("camara1", "camara2", "camara1"),
    desfasaje = c("4:10:0 0:0:0", "0:0:0 0:0:0", "0:0:0 0:0:0"),
    signo = c("+", "+", "+")
  )



# 1.b Arreglo de desfasaje temporal -----------------------

# Comando para arreglar desfasaje de fechas
# Esta funcion puedo aplicar a carpeta de analisis
timeShiftImages (
  inDir = carpeta_analisis,
  hasCameraFolders = TRUE,
  # Si tengo igual estacion y diferente camaras
  timeShiftTable = ajuste_t,
  # Utilizo el dataframe antes creado, con desfasaje y signo por
  # estacion y camara.
  stationCol = "estacion",
  # Nombre columna de la estacion
  cameraCol = "camara",
  # Nombre de columna camara
  timeShiftColumn = "desfasaje",
  # Columna en dataframe de desfasaje
  timeShiftSignColumn = "signo",
  # Columna en dataframe de tiempo
  undo = FALSE
)
# Esto cambia los metadatos arreglando la fecha y la hora sin el
# desfasaje


# 1.c Renombrado de fotos segun info y hora -------------------

# Poner fecha, hora y numero de disparo. Tambien se puede 
# exportar csv con info de cambios.
nombres <-
  imageRename(
    inDir = carpeta_analisis,
    # que estacion, directorio
    outDir = carpeta_salidas,
    # carpeta de salidas
    hasCameraFolders = TRUE,
    # subcarpetas por camaras
    keepCameraSubfolders = TRUE,
    # preservar los directorios de camaras.
    copyImages = TRUE,
    # si hace copia de archivos con nombre cambiado, o no
    writecsv = TRUE
    # texto con los datos de la foto
  ) 

# Nos da como resultado un CSV con los datos de todas las
# imagenes, y si queremos renombra las imagenes con la fecha,
# hora, etc y las copia en un nuevo directorio de salida.



# 1.d Etiquetas de licencia -------------------------------

# Agregar un licencia o un tag, en nuestro caso CC:
addCopyrightTag(
  inDir = carpeta_analisis,
  copyrightTag = "CC-BY-SA",
  # creative commons
  askFirst = FALSE,
  # preguntar antes de modificar
  keepJPG_original = FALSE
  # se deja una copia de las fotos originales?
)


# 2. TRABAJO CON ESPECIES ---------------------------------

# Agregar o sacar especies en el nombre de archivo tanto leidas
# desde carpetas como desde los metadatos las especies


# 2.a Usando carpetas -----------------------------------

# Lo dejamos comentado ya que nos enfocaremos en los métodos por
# etiquetas.

# appendSpeciesNames(
#   inDir = carpeta_analisis,
#   IDfrom = "directory",
#   # Leer las especies desde carpetas de especies
#   hasCameraFolders = TRUE,
#   # Camaras dentro de la estacion, false si hay carpetas
#   removeNames = FALSE,
#   # Borrar la especie del nombre de archivo? Ponemos TRUE si 
#   # queremos borrar nombres del nombre
#   writecsv = FALSE
#   # Tabla resumen
# )

###########utilizando TAG de metadatos##########


# 2.b Utilizando TAG de metadatos -------------------------

# (Tag = etiqueta)

appendSpeciesNames(
  inDir = carpeta_analisis,
  IDfrom = "metadata",
  # Leer las especies desde tags
  hasCameraFolders = TRUE,
  # Camaras dentro de la estacion
  metadataHierarchyDelimitor = "|",
  metadataSpeciesTag = "Especie",
  # Nombre del tag de metadatos con la especie
  removeNames = FALSE,
  # Borrar la especie del nombre de archivo? Ponemos TRUE si
  # queremos borrar nombres del nombre
  writecsv = TRUE#tabla resumen
)


# 2.c Revisando identificación de especies ----------------

# Dos usos en la funcion, dependiendo de la clasifiacion...

# Al usar tags nos permite comparar criterio de clasificacion
# segun observador, siempre y cuando tenga tag de especie por
# observador. Nos avisa cuando difieren y hay conflictos (en el
# csv conflicts)

# Por otro lado nos avisa en que registros para un misma
# estacion, en una ventana de tiempo maxima. No espero tener dos
# especies diferentes, si en poco tiempo para un mismo sitio
# tengo dos especies diferentes muy probable fue mal
# clasificada. Hace un check.csv reportando los casos a donde
# tengo que revisar nuevamente.


# 2.d.1 con carpetas --------------------------------------

# chequeo <-
#   checkSpeciesIdentification(
#     inDir = carpeta_analisis,
#     #directorio de la estacion
#     IDfrom = "directory",
#     # Si la identificacion de especie es con carpetas o tag 
#     # "directory" o "metadata"
#     hasCameraFolders = TRUE,
#     maxDeltaTime = 120,
#     # 120 segundo delta de tiempo para comparar y asumir 
#     # especies diferentes
#     excludeSpecies = "",
#     # Especies a excluir del analisis
#     writecsv = TRUE
#     #devolver cvs con resultados
#   )



# 2.e Fotos con identificaciones conflictivas -------------

# Uso TAG y miro si los observadores difieren o no, y lo del
# tiempo (ej 120 segundos para que no haya cambio de especie)
chequeo <-
  checkSpeciesIdentification(
    inDir = carpeta_analisis,
    IDfrom = "metadata",
    hasCameraFolders = TRUE,
    metadataSpeciesTag = "Especie",
    metadataSpeciesTagToCompare = "Especie_Juan",
    # Valor a comparar contra el tag especie
    metadataHierarchyDelimitor = "|",
    maxDeltaTime = 120,
    # 120 segundo delta de tiempo para comparar y asumir
    # especies diferentes
    excludeSpecies = c("Desconocida", "Gente"),
    # Especies que no nos interesan
    writecsv = TRUE
  )

# Ej 86400 segundos (= un dia), caso extremo para ver en un dia
# no cambiaria la especie, bastante poco probable
chequeo1 <-
  checkSpeciesIdentification(
    inDir = carpeta_analisis,
    IDfrom = "metadata",
    hasCameraFolders = TRUE,
    metadataSpeciesTag = "Especie",
    metadataSpeciesTagToCompare = "Especie_Juan",
    # Valor a comparar contra el tag especie
    metadataHierarchyDelimitor = "|",
    maxDeltaTime = 86400,
    # 120 segundo delta de tiempo para comparar y asumir
    # especies diferentes
    excludeSpecies = c("Desconocida", "Gente"),
    # Especies que no nos interesan
    writecsv = TRUE
  )


# 2.f Fotos de una especie en partic ----------------------

# Las copio en una carpeta de salida

species_interes <- "Gente"
# Porque vamos a seleccionar todas las fotos de gente

# Utilizando info en carpetas
# specImagecopy <-
#   getSpeciesImages(
#     species = species_interes,
#     IDfrom = "directory",
#     inDir = carpeta_analisis,
#     outDir = carpeta_salidas,
#     createStationSubfolders = FALSE
#   )

# Con metadatos
tabla_gente <-
  getSpeciesImages(
    species = species_interes,
    IDfrom = "metadata",
    metadataSpeciesTag = "Especie",
    metadataHierarchyDelimitor = "|",
    inDir = carpeta_analisis,
    outDir = carpeta_salidas,
    createStationSubfolders = FALSE
  )


# 3. COMO CREAR TABLA DE REGISTROS ------------------------

# Esta tabla resume toda la informacion de los registros, y
# permite analizar usando independencias temporales.
# Eventualmente pued tener una tabla ya hecha en este formato,
# para seguir adelante, por ejemplo con informacion no de
# camaras.

# Los parámetros nuevos en esta función son

# - camerasIndependent: TRUE si se trata de cámaras que no están
# una al lado de la otra, en distinto trillo, etc. Decide el
# experto.

# - minDeltaTime: tiempo (minutos) m??nimo exigido entre 2
# registros independientes de misma especie y misma
# estación/cámara. Usan como ejemplo 60 minutos.

# - deltaTimeComparedTo, que puede ser:

#   + "lastRecord": el tiempo que pasó desde el último registro,
#   sin importar cuál ese registro.

#   + "lastIndependentRecord": el tiempo que pasó desde el
#   último registro que fue declarado independiente, sin
#   importar si hubieron otros registros más cercanos en el
#   tiempo.

# Sencilla con todo lo que tengo,usando directorios
tabla <-
  recordTable(inDir = carpeta_analisis,
              IDfrom = "directory",
              timeZone = "America/Montevideo")


# Sencilla con todo lo que tengo, usando directorios. Si no 
# especificamos minDeltaTime se asume cero, por lo que todas las
# fotos son consideradas registros independientes:
tabla <-
  recordTable(
    inDir = carpeta_analisis,
    IDfrom = "metadata",
    timeZone = "America/Montevideo",
    metadataSpeciesTag      = "Especie",
    metadataHierarchyDelimitor = "|"
  )


# 3.a Campos de la tabla de registros ---------------------

# Station: 	the station the image is from

# Species:	species name

# DateTimeOriginal:	Date and time of record in R-readable format

# Date:	record date

# Time:	record time of day

# delta.time.secs:	time difference between record and last
# (independent) record of same species at same station / camera*
# (in seconds)

# delta.time.mins:	time difference between record and last
# (independent) record of same species at same station / camera*
# (in minutes)

# delta.time.hours:	time difference between record and last
# (independent) record of same species at same station / camera*
# (in hours)

# delta.time.days:	time difference between record and last
# (independent) record of same species at same station / camera*
# (in days)

# Directory:	directory the image is in

# FileName:	image file name


# 3.b Tiempo mínimo entre registros -----------------------

# Ahora filtrando especies que se ponen delante de la cámara y
# se quedan bastante tiempo. Pongo ese tiempo en minutos con
# minDeltaTime:
tabla1 <-
  recordTable(
    inDir = carpeta_analisis,
    IDfrom = "metadata",
    cameraID = "directory",
    # Identificacion de las camaras
    metadataSpeciesTag      = "Especie",
    metadataHierarchyDelimitor = "|",
    minDeltaTime  = 60,
    # 60 minutos entre foto y foto para que se considere otro
    # registro, para una misma especie y estacion
    deltaTimeComparedTo = "lastRecord",
    # Que cuente el delta t desde la ultima foto procesada o del
    # ultimo registro independiente
    timeZone = "America/Montevideo",
    # Importante si la camara no guarda zona horaria, y el pais
    # tiene horario de verano
    camerasIndependent = T,
    # Si tengo mas de una camara por estacion, si asumo
    # independencia el delta t no las afecta, si es FALSE el
    # delta t es igual que para una misma camara
    exclude = ""
    # Por ejemplo quiero excluir las que no identifique
  )


# 3.c Más informacion en etiquetas ------------------------

# Hay otras informaciones de tag de interes en las imagenes,
# temperatura, fase lunar, etc. Luego podemos incluir estos tags
# de interes en la tabulacion con recordTable. Miramos los tag
# que tienen la foto, nos muestra de una foto, la ultima de la
# carpeta.

# Nombres de tags:
exifTagNames(
  inDir = carpeta_analisis, 
  returnMetadata = FALSE)

# Nombre y valores de tags:
tags <-
  exifTagNames(
    inDir = carpeta_analisis, 
    returnMetadata = TRUE)

# tags del valor de especie y su clasificacion. Ej valor del tag
# numero 69:
tags[69]

# Extraigo una tabla con las info adicionales de eso metadatos
# extra, en este caso modelo y descripcion:
tabla2 <-
  recordTable(
    inDir = carpeta_analisis,
    IDfrom = "metadata",
    metadataSpeciesTag      = "Especie",
    metadataHierarchyDelimitor = "|",
    timeZone = "America/Montevideo",
    additionalMetadataTags = c("EXIF:Model", "EXIF:ImageDescription"),
    writecsv = TRUE
  )

# Mirar un ranking de abundancia sencillo con la informacion de
# especie en la record table.
ranking <- sort(table(tabla2$Species), decreasing = TRUE)



# 4. MATRIZ DE OPERACION DE CAMARAS -----------------------

# Creo un data frame con informacion de la camara que estoy
# analizando, puede ser desde r, o leer una planilla o un csv
# con la informacion necesaria

# Ej.: leer un csv o excel con la informacion:
camara <-
  read.csv2("camaras.csv",
           stringsAsFactors = FALSE
           # Para que no converta texto a factor
  )

# O crear el objeto directamente:

# camara <- 
#   data.frame(
#     Station = c("edita", "edita", "henry", "edita", "edita", "henry"),
#     Camera = c("camara1", "camara2", "camara1", "camara1", "camara2", "camara1"),
#     utm_y = c(604000, 604000, 614000, 604000, 604000, 614000),
#     utm_x = c(525000, 525000, 526000, 525000, 525000, 526000), 
#     Setup_date = c("1/11/2016", "1/11/2016", "3/1/2017", "25/4/2017", "25/4/2017", "25/4/2017"),
#     Retrieval_date = c("20/4/2017", "23/4/2017", "25/4/2017", "16/7/2017", "16/7/2017", "6/9/2017"),
#     Problem1_from = c("16/2/2017", NA, "3/3/2017", NA, "12/6/2017", "8/5/2017"), 
#     Problem1_to = c("20/4/2017", NA, "10/3/2017", NA, "6/7/2017", "1/6/2017"),
#     stringsAsFactors = FALSE
#     # Para que no converta texto a factor
# )


# 4.a Matriz diaria de disponibilidad ---------------------

# Funcion para matriz de operacion de camaras, contruye una
# matriz diaria de disponibilidad de la camara:
camop_problem <-
  cameraOperation(
    CTtable = camara,
    # dataframe con datos de la camara
    cameraCol = "Camera",
    byCamera = TRUE,
    # mas de una camara
    stationCol = "Station",
    # columna nombre estacion
    setupCol = "Setup_date",
    # columna con fecha de instalacion
    retrievalCol = "Retrieval_date",
    # columna con fecha de visita
    writecsv = FALSE,
    hasProblems = FALSE,
    # si es true hay una columna con fecha del problema
    dateFormat = "%d/%m/%Y"
    # formato de fecha para setup y visita
  )



# 4.b Graficar la operacion -------------------------------

# Para plotear momento de funcionamiento de la camara 
# programamos una funcion (de las vignettes de camtrapR):
camopPlot <- function(camOp) {
  which.tmp <- 
    grep(as.Date(colnames(camOp)), pattern = "01$")
  label.tmp <- 
    format(as.Date(colnames(camOp))[which.tmp], "%Y-%m")
  at.tmp <- which.tmp / ncol(camOp)
  
  image(t(as.matrix(camOp)), xaxt = "n", yaxt = "n",
    col = c("red", "grey70")
  )
  axis(1, at = at.tmp, labels = label.tmp)
  axis(2, at = seq(from = 0, to = 1, length.out = nrow(camOp)),
       labels = rownames(camOp), las = 1)
  abline(v = at.tmp, col = rgb(0, 0, 0, 0.2))
  box()
}

# Grafica:
camopPlot(camop_problem)

## Alternativa: camopPlot2 es una funcion hecha por nosotres...
## (requiere tener instalados los paquetes magrittr, ggplot2 y
## lubridate; todos tidyverse)
source("funciones.R")
camopPlot2(camara)
camopPlot2(camara, horiz = FALSE) # Para grafico vertical


# 4.c Guardar matriz disponibilidad -----------------------

# Guardar martiz de operacion en csv de camaras para editar en
# futuras salidas. Igual que la anterior pero con writecsv =
# TRUE para sacar y guardar el csv
cameraOperation(
  CTtable = camara,
  # dataframe con datos de la camara
  cameraCol = "Camara",
  byCamera = TRUE,
  # mas de una camara
  stationCol = "Station",
  # columna nombre estacion
  setupCol = "Setup_date",
  # columna con fecha de instalacion
  retrievalCol = "Retrieval_date",
  # columna con fecha de visita
  writecsv = TRUE,
  outDir = carpeta_salidas,
  hasProblems = FALSE,
  # si es true hay una columna con fecha del problema
  dateFormat = "%d/%m/%Y"
  # formato de fecha para setup y visita
)

# Caragamos la matriz de operacion de camaras guradad como csv.
# Indicamos la primera fila para que deje las fechas:
# camop <-
#   read.csv(file = "CameraOperationMatrix_by_station_2018-04-27.csv",
#            row.names = 1,
#            check.names = FALSE)



# 5. ANALISIS Y VISUALIZACION -----------------------------


# 5.a Actividad de una especie ----------------------------

# 3 graficos que nos muestras la misma informacion en funcion de
# las horas del dia, como se dan las ocurrencia de los animales,
# y por lo tanto en que horarios es mas comun que esten activos

# Elijo una especie a mirar su comportamiento
laEspecie <- "Zorro Gris"

# Graficos:
activityDensity(recordTable = tabla,
                species     = laEspecie)

activityHistogram(recordTable = tabla,
                  species     = laEspecie)

activityRadial(recordTable = tabla,
               species     = laEspecie, lwd = 5)



# 5.b Actividad de todas las especies ---------------------

# Me hace los graficos para cada una de las especies. Los coloca
# en la carpeta de salida:
activityDensity(
  recordTable = tabla,
  allSpecies = TRUE,
  # Los siguientes argumentos son para guardar los gráficos en archivos:
  writePNG = TRUE,
  createDir = TRUE,
  plotDirectory = carpeta_salidas
) 

# 5.c Actividad de 2 las especies -------------------------

# Especies que me interesan
sppA <- "Zorro Gris"
sppB <- "Lagarto Overo"

# Ploteos
activityOverlap(recordTable = tabla,
                speciesA = sppA,
                speciesB = sppB,
                writePNG = FALSE,
                plotR = TRUE,
                linecol = c("red", "blue"),
                linewidth = c(3, 3),
                add.rug = TRUE)




# 5.d Analisis de ocurrencia, abundancia y riqueza --------

# Para lo analisis de ocupacion, si tenemos mas de una camara
# deberiamos editar el nombre de las estaciones en la matriz de
# operacion, o en la recordtable para que coincidan, sino no
# funciona. Para el ejemplo hicimos un caso de dos estaciones,
# edita y henry, cada una con una camara dentro.

#cargo tabla y matriz de camara para el analisis
tabla_una_cam <- 
  read.csv("tabla_una_cam.csv", stringsAsFactors = FALSE)
camara_una_estacion <- 
  read.csv2("camara_una_estacion.csv", stringsAsFactors = FALSE)

# Funcion para matriz de operacion de camaras, contruye una
# matriz diaria de disponibilidad de la camara. En este caso
# para el nuevo monitoreo con dos camaras: estacion edita -
# camara1 y estacion henry - camara1:
camop_una_estacion <-
  cameraOperation(
    CTtable = camara_una_estacion,
    # dataframe con datos de la camara
    stationCol = "Station",
    # columna nombre estacion
    setupCol = "Setup_date",
    # columna con fecha de instalacion
    retrievalCol = "Retrieval_date",
    # columna con fecha de visita
    writecsv = FALSE,
    hasProblems = FALSE,
    # si es true hay una columna con fecha del problema
    dateFormat = "%d/%m/%Y"
    #formato de fecha para setup y visita
  )

# Para el analisis debemos contar con la matriz de operacion de
# la camara (camop_una_estacion) y una tabla de regristros
# (tabla_una_cam):
DetHist1 <-
  detectionHistory(
    recordTable = tabla_una_cam,
    ##tabla de registros
    camOp = camop_una_estacion,
    #matriz de operacion
    stationCol = "Station",
    #columna de la tabla
    speciesCol = "Species",
    #columna de la tabla
    recordDateTimeCol = "DateTimeOriginal",
    #columna de la tabla
    species = "Guazubira",
    #especie de interes a analizas
    minActiveDaysPerOccasion = 1,
    #valor minimo de dias para computar el cluster, sobre todo
    #al final que puede no ser exactamente 7 en este caso
    occasionLength = 7,
    #largo de cluster de dias para analizar ocurrencia
    day1 = "station",
    #cuado empieza el analisis
    includeEffort = FALSE,
    #incluir esfuerzo de muestreo, si pongo true reporta la
    #cantidad de dias
    timeZone = "America/Montevideo",
    writecsv = TRUE,
    outDir = carpeta_salidas
  )

# El mismo caso pero reportando la matriz de esfuerzo de
# muestreo eventualmente la ocurrencia se puede rescalar por el
# esfuerzo de muestreo realizado (que son la cantidad de dias
# que esta encendida la camara):
DetHist2 <-
  detectionHistory(
    recordTable = tabla_una_cam,
    ##tabla de registros
    camOp = camop_una_estacion,
    #matriz de operacion
    stationCol = "Station",
    #columna de la tabla
    speciesCol = "Species",
    #columna de la tabla
    recordDateTimeCol = "DateTimeOriginal",
    #columna de la tabla
    species = "Guazubira",
    #que buscamos de especie
    minActiveDaysPerOccasion = 1,
    occasionLength = 7,
    #largo de dias
    day1 = "station",
    #cuado empieza el analisis
    includeEffort = TRUE,
    #incluir esfuerzo de muestreo, si pongo true reporta la cantidad de dias
    scaleEffort = FALSE,
    #rescalar valor, en caso de tener esfuerzos de muestros diferentes.
    timeZone = "America/Montevideo",
    writecsv = TRUE,
    outDir = carpeta_salidas
  )

# Tanto las matrices de esfuerzo como de ocupacion puede ser
# guardadas y cargadas luego


# 5.e Mapas de riqueza ------------------------------------

Mapstest1 <-
  detectionMaps(
    CTtable = camara_una_estacion,
    #datos de camaras, coordenadas, etc
    recordTable = tabla_una_cam,
    #recordtable de registros
    Xcol = "utm_x",
    Ycol = "utm_y",
    stationCol = "Station",
    speciesCol = "Species",
    printLabels = TRUE,
    richnessPlot = TRUE,
    # Riqueza de spp por cámara
    speciesPlots = FALSE,
    addLegend = TRUE
  )



# 5.e.1 Mapa de abundancia para una especie ---------------

# Especie de interes
laEspecie<-"Tatu"

# Mapa
Mapstest2 <-
  detectionMaps(
    CTtable = camara_una_estacion,
    recordTable =
      tabla_una_cam[tabla_una_cam$Species == laEspecie, ],
    # aca solo nos quedamos con los registros de recordtable de
    # la especie de interes
    Xcol = "utm_x",
    Ycol = "utm_y",
    stationCol = "Station",
    speciesCol = "Species",
    speciesToShow = laEspecie,
    printLabels = TRUE,
    richnessPlot = FALSE,
    # para hacer abundancia FALSE
    speciesPlots = TRUE,
    addLegend = TRUE
  )

# 6. Notas para DIGIKAM -----------------------------------

# 1. Ir a digikam, importar las fotos (duplica los archivos) y
# editar la metadata. Recordar que hay una jerarqu??a:
# Espece/Mano Pelada, etc. Esto es importante para que las
# funciones del paquete anden bien...

# Cosas a recordar de digiKam:

# - Debe estar configurado para que escriba en los metadatos de
# los archivos, y no en archivos auxiliares (xmp)

# - No estamos trabajando sobre los mismos archivos, si no con
# una copia en "Mis Imágenes" (pol??tica de no modificar
# archivos de digiKam)

# - Luego de poner etiquetas, hay que expl??citamente indicarle
# a digiKam que guarde la información en los archivos (Album >
# Escribir metadatos...)
