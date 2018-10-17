
# PREPARAR LA SESIÒN DE TRABAJO --------------------------------

# - Definir el directorio de trabajo (wd)
 
# En RStudio podemos ir a
# session -> Set Working Directory -> Choose Directory
 
# En la consola veremos que se ejecuta un comando como este:
# setwd("C:/Users/gabol/Desktop/curso_camtrap/clase23/R")

# (¿Es exactamente igual?¿Qué diferencias ve y por qué creen que
# están?)

# Para comprobar que su wd está correctamente definido, recuerde
# que puede usar la función getwd:
getwd()

# - Instalar el paquete camtrapR, única vez.
# install.packages("camtrapR")

# Activarlo (cargarlo en la sesión de R):
library("camtrapR")


# 0. ORGANIZACION Y GESTION DE IMAGENES ------------------------

# Conviene respaldar las imagens porque el paquete las modifica
# Carpeta de analisis
carpeta_analisis <- getwd()

# Carpeta de salidas, algunas imagenes duplicadas van a dicho
# directorio carpeta arriba del wd
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

# Instalar ExifTool para leer metadatos de archivos ------------

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



#leo con exiftool los metadatos y verifico###################
#esta funcion puedo aplicar a carpeta de analisis
fixDateTimeOriginal(inDir     = carpeta_analisis,
                    recursive = TRUE)
##################################################
#1#RETOQUE DE IMAGENES############################
##################################################
#arreglo los desfasajes de tiempo que pueda haber#
#solo si es necesario#############################
##################################################
#en una tabla cargo nombre de estacion, camara, lo que el desfasaje
#y si se resta o suma el desfasaje en el tiempo
ajuste_t<-data.frame(estacion=c("edita","edita","henry"),camara=c("camara1","camara2","camara1"),desfasaje=c("0:0:0 0:0:0","0:0:0 0:0:0","0:0:0 0:0:0"),signo=c("+","+","+"))

#comando para arreglar desfasaje de fechas
#esta funcion puedo aplicar a carpeta de analisis
timeShiftImages (inDir= carpeta_analisis,
                 hasCameraFolders=TRUE,#si tengo igual estacion y diferente camaras
                 timeShiftTable=ajuste_t,#utilizo el dataframe antes creado, con desfasaje y signo por estacion y camara.
                 stationCol="estacion",#nombre columna de la estacion
                 cameraCol="camara",#nombre de columna camara
                 timeShiftColumn="desfasaje",#columna en dataframe de desfasaje
                 timeShiftSignColumn="signo",#columna en dataframe de tiempo
                 undo = FALSE#
)
##nos cambia los metadatos arreglando la fecha y la hora sin el desfasaje


##########################################
#renombrado de fotos segun info y hora####
#les pone fecha, hora y numero de disparo#
#tambien se puede exportar csv con eso####
##########################################
nombres<-imageRename(inDir=carpeta_analisis,#que estacion, directorio
            outDir=carpeta_salidas,#carpeta de salidas
            hasCameraFolders=TRUE,#subcarpetas por camaras
            keepCameraSubfolders=TRUE,#preservar los directorios de camaras.
            copyImages=TRUE,#si hace copia de archivos con nombre cambiado, o no
            writecsv = TRUE)#texto con los datos de la foto

##nos da como resultado un CSV con los datos de todas las imagenes,y
#si queremos renombra las imagenes con la fecha, hora, etc y las copia
#en un nuevo directorio de salida.

##################################################
#agregar un licencia o un tag, en nuestro caso CC#
##################################################
addCopyrightTag(inDir=carpeta_analisis, 
                copyrightTag="CC-BY-SA",#creative commons 
                askFirst = FALSE,#preguntar antes de modificar
                keepJPG_original = FALSE#se deja una copia de las fotos originales?
)

#######################################################
#2#TRABAJO CON ESPECIES################################
#######################################################
#agregar o sacar especies en el nombre de archivo######
#tanto leidas desde carpetas como desde los metadatos##
#las especies##########################################
#######################################################
#####usando carpetas###################################
#appendSpeciesNames(inDir=carpeta_analisis, 
#                   IDfrom= "directory",##leer las especies desde carpetas de especies
#                   hasCameraFolders=TRUE,#camaras dentro de la estacion, false si hay carpetas
#                   removeNames = FALSE, #borral la especie del nombre de archivo?ponemos true si queremos borrar nombres del nombre
#                   writecsv = FALSE#tabla resumen
#)

###########utilizando TAG de metadatos##########

appendSpeciesNames(inDir=carpeta_analisis, 
                   IDfrom= "metadata",##leer las especies desde tags
                   hasCameraFolders=TRUE,#camaras dentro de la estacion
                   metadataHierarchyDelimitor = "|",
                   metadataSpeciesTag="Especie",#nombre del tag de metadatos con la especie
                   removeNames = FALSE, #borral la especie del nombre de archivo?ponemos true si queremos borrar nombres del nombre
                   writecsv = TRUE#tabla resumen
)

###checkSpeciesIdentification#############################################
##########################################################################
###dos usos en la funcion, dependiendo de la clasifiacion#################
###al usar tags nos permite comparar criterio de clasificacion############
###segun observador, siempre y cuando tenga tag de especie por observador#
###nos avisa cuando difieren y hay conflictos en el csv conflicts#########
#Por otro lado nos avisa en que registros para un misma estacion, en una##
#ventana de tiempo maxima no espero tener dos especies diferentes ########
#si en poco tiempo para un mismo sitio tengo dos especies diferentes######
#muy probable fue mal clasificada. hace un check.csv reportando los ######
#casos a donde tengo que revisar nuevamente###############################

#con carpetas
# chequeo<-checkSpeciesIdentification(inDir=carpeta_analisis,#directorio de la estacion
#                            IDfrom="directory",##si la identificacion de especie es con carpetas o tag "directory" o "metadata"
#                            hasCameraFolders=TRUE,
#                            maxDeltaTime=120,##120 segundo delta de tiempo para comparar y asumir especies diferentes
#                            excludeSpecies="",##especies a excluir del analisis
#                            writecsv = TRUE##devolver cvs con resultados
# 
# )


##uso TAG y miro si los observadores difieren o no, y lo del tiempo
#ej 120 segundos para que no haya cambio de especie
chequeo<-checkSpeciesIdentification(inDir = carpeta_analisis,
                             IDfrom = "metadata",
                             hasCameraFolders = TRUE,
                             metadataSpeciesTag = "Especie",
                             metadataSpeciesTagToCompare = "Especie_Juan",#valor a comparar contra el tag especie
                             metadataHierarchyDelimitor = "|",
                             maxDeltaTime = 120, # 120 segundo delta de tiempo para comparar y asumir especies diferentes
                             excludeSpecies = c("Desconocida", "Gente"), # Especies que no nos interesan
                             writecsv = TRUE
  )
#ej 86400(un dia), caso extremo para ver en un dia no cambiaria la especie, bastante poco probable
chequeo1<-checkSpeciesIdentification(inDir = carpeta_analisis,
                                    IDfrom = "metadata",
                                    hasCameraFolders = TRUE,
                                    metadataSpeciesTag = "Especie",
                                    metadataSpeciesTagToCompare = "Especie_Juan",#valor a comparar contra el tag especie
                                    metadataHierarchyDelimitor = "|",
                                    maxDeltaTime = 86400, # 120 segundo delta de tiempo para comparar y asumir especies diferentes
                                    excludeSpecies = c("Desconocida", "Gente"), # Especies que no nos interesan
                                    writecsv = TRUE
)
###################################################
###seleccion de fotos de una especie en particular#
##las copio en una carpeta de salida###############
###################################################

species_interes <- "Gente"    # seleccionamos todas las fotos de gente

#utilizando info en carpetas
# specImagecopy <- getSpeciesImages(species                 = species_interes,
#                                   IDfrom                  = "directory",
#                                   inDir                   = carpeta_analisis,
#                                   outDir                  = carpeta_salidas,
#                                   createStationSubfolders = FALSE
# )
###con metadatos
tabla_gente<-getSpeciesImages(species                 = species_interes,
                                  IDfrom                  = "metadata",
                                  metadataSpeciesTag      = "Especie",
                                  metadataHierarchyDelimitor = "|",
                                  inDir                   = carpeta_analisis,
                                  outDir                  = carpeta_salidas,
                                  createStationSubfolders = FALSE
)
##########################################################################
#3#COMO CREAR TABLA DE REGISTROS##########################################
##########################################################################
#esta tabla resume toda la informacion de los registros, y permite
#analizar usando independencias temporales
#eventualmente pued tener una tabla ya hecha en este formato, para
#seguir adelante, por ejemplo con informacion no de camaras
#
# Los parámetros nuevos en esta función son
# - camerasIndependent: TRUE si se trata de cámaras que no están una al lado
#   de la otra, en distinto trillo, etc. Decide el experto.
# - minDeltaTime: tiempo (minutos) m??nimo exigido entre 2 registros independientes 
#   de misma especie y misma estación/cámara. Usan como ejemplo 60 minutos.
# - deltaTimeComparedTo, que puede ser: 
#   + "lastRecord": el tiempo que pasó desde el último registro, sin importar cuál 
#     ese registro.
#   + "lastIndependentRecord": el tiempo que pasó desde el último registro que fue
#     declarado independiente, sin importar si hubieron otros registros más cercanos
#     en el tiempo.

#sencilla con todo lo que tengo,usando directorios
# tabla<-recordTable(inDir=carpeta_analisis,
#                 IDfrom="directory",
#                 timeZone="America/Montevideo"
#             )

#sencilla con todo lo que tengo,usando directorios
#sino especificamos minDeltaTime se asume cero, por lo que
#todas las fotos son consideradas registros independientes
tabla<-recordTable(inDir=carpeta_analisis,
                                    IDfrom="metadata",
                                    timeZone="America/Montevideo",
                                    metadataSpeciesTag      = "Especie",
                                    metadataHierarchyDelimitor = "|"
                    )
##campo de la tabla###
# Station: 	the station the image is from
# Species:	species name
# DateTimeOriginal:	Date and time of record in R-readable format
# Date:	record date
# Time:	record time of day
# delta.time.secs:	time difference between record and last (independent) record of same species at same station / camera* (in seconds)
# delta.time.mins:	time difference between record and last (independent) record of same species at same station / camera* (in minutes)
# delta.time.hours:	time difference between record and last (independent) record of same species at same station / camera* (in hours)
# delta.time.days:	time difference between record and last (independent) record of same species at same station / camera* (in days)
# Directory:	directory the image is in
# FileName:	image file name


##ahora filtrando especies que se ponen delante de la cámara y se quedan bastante tiempo
#pongo ese tiempoe en minutos en minDeltaTime
tabla1<-recordTable(inDir=carpeta_analisis,
                   IDfrom="metadata",
                   cameraID="directory",#identificacion de las camaras
                   metadataSpeciesTag      = "Especie",
                   metadataHierarchyDelimitor = "|",
                   minDeltaTime  = 60,#60 minutos entre foto y foto para que se considere otro registro, para una misma especie y estacion
                   deltaTimeComparedTo = "lastRecord",#que cuente el delta t desde la ultima foto procesada o del ultimo registro independiente
                   timeZone="America/Montevideo",##importante si la camara no guarda zona horaria, y el pais tiene horario de verano
                   camerasIndependent=T,# si tengo mas de una camara por estacion, si asumo independencia el delta t no las afecta, si es FALSE el delta t es igual que para una misma camara
                   exclude= "" #por ejemplo quiero excluir las que no identifique
                   )
                   


###explorar otras informaciones de tag de interes en las imagenes, temperatura, fase lunar, etc
#####luego podemos incluir estos tags de interes en la tabulacion con recordTable
###########
###miramos los tag que tienen la foto,nos muestra de una foto, la ultima
exifTagNames(inDir = carpeta_analisis, returnMetadata = FALSE)##nombres de tags
tags<-exifTagNames(inDir = carpeta_analisis, returnMetadata = TRUE)###nombre y valores de tags
#tags del valor de especie y su clasificacion
#ej valor del tag numero 69
tags[69]

###extraigo una tabla con las info adicionales de eso metadatos extra, en este caso modelo y descripcion
tabla2<- recordTable(inDir = carpeta_analisis,
                     IDfrom = "metadata",
                     metadataSpeciesTag      = "Especie",
                     metadataHierarchyDelimitor = "|",
                     timeZone = "America/Montevideo",
                     additionalMetadataTags = c("EXIF:Model", "EXIF:ImageDescription"),
                     writecsv = TRUE
                     )
#mirar un ranking de abundancia sencillo con la informacion
#de especie en la record table.
ranking <- sort(table(tabla2$Species), decreasing = TRUE)

#####################################################
#4#MATRIZ DE OPERACION DE CAMARAS####################
#####################################################

#creo un data frame con informacion de la camara 
#que estoy analizando, puede ser desde r, o leer 
#una planilla o un csv con la informacion necesaria

#leer un csv o excel con la informacion
#row.names=1 evita que se cree un valor m?s
camara<-read.csv("camaras.csv", row.names = 1)
#o crear el objeto directamente
#camara<-data.frame(Station = c("edita", "edita", "henry"), Camara = c("camara1", "camara2", "camara1"),  utm_y = c(604000, 604000,614000),utm_x = c(525000, 525000,526000),Setup_date = c("01/11/2016","01/11/2016","01/11/2016"),Retrieval_date = c("20/04/2017","20/04/2017","20/04/2017"),Problem1_from = c("","",""),Problem1_to = c("","",""))

##funcion para matriz de operacion de camaras, contruye una matriz diaria de disponibilidad de la camara
camop_problem <- cameraOperation(CTtable      = camara,#dataframe con datos de la camara
                                 cameraCol    = "Camara",
                                 byCamera     =TRUE, #mas de una camara
                                 stationCol   = "Station",#columna nombre estacion
                                 setupCol     = "Setup_date",#columna con fecha de instalacion
                                 retrievalCol = "Retrieval_date",#columna con fecha de visita
                                 writecsv     = FALSE,
                                 hasProblems  = FALSE,#si es true hay una columna con fecha del problema
                                 dateFormat   = "%d/%m/%Y"#formato de fecha para setup y visita
)

#para plotear momento de funcionamiento de la camara
#programamos una funcion

camopPlot <- function(camOp){
  
  which.tmp <- grep(as.Date(colnames(camOp)), pattern = "01$")
  label.tmp <- format(as.Date(colnames(camOp))[which.tmp], "%Y-%m")
  at.tmp <- which.tmp / ncol(camOp)
  
  image(t(as.matrix(camOp)), xaxt = "n", yaxt = "n", col = c("red", "grey70"))
  axis(1, at = at.tmp, labels = label.tmp)
  axis(2, at = seq(from = 0, to = 1, length.out = nrow(camOp)), labels = rownames(camOp), las = 1)
  abline(v = at.tmp, col = rgb(0,0,0, 0.2))
  box()
}

#ploteo
camopPlot(camop_problem)
################################################################################
###guardar martiz de operacion en csv de camaras para editar en futuras salidas#
##igual que la anterior pero con writecsv true para sacar y guardar el csv######
cameraOperation(CTtable      = camara,#dataframe con datos de la camara
                cameraCol    = "Camara",
                byCamera     =TRUE, #mas de una camara
                stationCol   = "Station",#columna nombre estacion
                setupCol     = "Setup_date",#columna con fecha de instalacion
                retrievalCol = "Retrieval_date",#columna con fecha de visita
                writecsv     = TRUE,
                outDir       = carpeta_salidas,
                hasProblems  = FALSE,#si es true hay una columna con fecha del problema
                dateFormat   = "%d/%m/%Y"#formato de fecha para setup y visita
)

################################################################################
###caragamos la matriz de operacion de cámaras guradad como csv#################
#indicamos la primera fila para que deje las fechas.##############################
##camop <- read.csv(file = "CameraOperationMatrix_by_station_2018-04-27.csv", row.names = 1, check.names = FALSE)


###############################
#5#ANALISIS Y VISUALIZACION####
###############################
###############################
##############################
# Actividad de una especie #
############################

#3 graficos que nos muestras la misma informacion
#en funcion de las horas del dia, como se dan las 
#ocurrencia de los animales, y por lo tanto en que
#horarios es mas comun que esten activos

#me elijo una especia a mirar su comportamiento
laEspecie <- "Zorro Gris"
#ploteos
activityDensity(recordTable = tabla,
                species     = laEspecie)

activityHistogram(recordTable = tabla,
                  species     = laEspecie)

activityRadial(recordTable = tabla,
               species     = laEspecie, lwd = 5)



##== Todas las especies! ==##
#me hace los graficos para cada una de las especies
#me los coloca en la carpeta de salida
activityDensity(recordTable = tabla,
                allSpecies = TRUE,
                # Los siguientes argumentos son para guardar los gráficos en archivos:
                writePNG = TRUE, 
                createDir = TRUE,
                plotDirectory = carpeta_salidas) 

###########################
# Actividad de 2 especies #
###########################

#especies que me interesan
sppA <- "Zorro Gris"
sppB <- "Lagarto Overo"

#ploteos
activityOverlap(recordTable = tabla,
                speciesA = sppA,
                speciesB = sppB,
                writePNG = FALSE,
                plotR = TRUE,
                linecol = c("red", "blue"),
                linewidth = c(3, 3),
                add.rug = TRUE)


###################################################
####Analisis de ocurrencia, abundancia y riqueza###
###################################################
##para lo analisis de ocupacion, si tenemos mas de#
##una camara deberiamos editar el nombre de las ###
#estaciones en la matriz de operacion, o en la#####
#recordtable para que coincidan, sino no funciona##
#Para el ejemplo hicimos un caso de dos estaciones#
#edita y henry , cada uno con una camara dentro####
###################################################

#cargo tabla y matriz de camara para el analisis
tabla_una_cam<-read.csv("tabla_una_cam.csv", row.names = 1)
camara_una_estacion<-read.csv("camara_una_estacion.csv", row.names = 1)

##funcion para matriz de operacion de camaras, contruye una matriz diaria de disponibilidad de la camara
#en este caso para el nuevo monitoreo con dos camaras, estacion edita
#camara1 y estacion henry camara1
camop_una_estacion <- cameraOperation(CTtable      = camara_una_estacion,#dataframe con datos de la camara
                                 stationCol   = "Station",#columna nombre estacion
                                 setupCol     = "Setup_date",#columna con fecha de instalacion
                                 retrievalCol = "Retrieval_date",#columna con fecha de visita
                                 writecsv     = FALSE,
                                 hasProblems  = FALSE,#si es true hay una columna con fecha del problema
                                 dateFormat   = "%d/%m/%Y"#formato de fecha para setup y visita
)
##para el analisis debemos contar con la matriz 
#de operacion de la camara (camop_una_estacion) y una tabla de regristros (tabla_una_cam)
DetHist1 <- detectionHistory(recordTable         = tabla_una_cam,##tabla de registros
                             camOp                = camop_una_estacion,#matriz de operacion
                             stationCol           = "Station",#columna de la tabla
                             speciesCol           = "Species",#columna de la tabla
                             recordDateTimeCol    = "DateTimeOriginal",#columna de la tabla
                             species              = "Guazubira",#especie de interes a analizas
                             minActiveDaysPerOccasion = 1,#valor minimo de dias para computar el cluster, sobre todo al final que puede no ser exactamente 7 en este caso
                             occasionLength       = 7,#largo de cluster de dias para analizar ocurrencia
                             day1                 = "station",#cuado empieza el analisis
                             includeEffort        = FALSE,#incluir esfuerzo de muestreo, si pongo true reporta la cantidad de dias
                             timeZone = "America/Montevideo", 
                             writecsv = TRUE,
                             outDir = carpeta_salidas
                              
)
#El mismo caso pero reportando la matriz de esfuerzo de muestreo
#eventualmente la ocurrencia se puede rescalar por el esfuerzo de muestreo
#realizado (que son la cantidad de dias que esta encendida la camara)
DetHist2 <- detectionHistory(recordTable         = tabla_una_cam,##tabla de registros
                             camOp                = camop_una_estacion,#matriz de operacion
                             stationCol           = "Station",#columna de la tabla
                             speciesCol           = "Species",#columna de la tabla
                             recordDateTimeCol    = "DateTimeOriginal",#columna de la tabla
                             species              = "Guazubira",#que buscamos de especie
                             minActiveDaysPerOccasion = 1,
                             occasionLength       = 7,#largo de dias
                             day1                 = "station",#cuado empieza el analisis
                             includeEffort        = TRUE,#incluir esfuerzo de muestreo, si pongo true reporta la cantidad de dias
                             scaleEffort = FALSE,#rescalar valor, en caso de tener esfuerzos de muestros diferentes.
                             timeZone = "America/Montevideo", 
                             writecsv = TRUE,
                             outDir = carpeta_salidas
)

##tanto las matrices de esfuerzo como de ocupacion puede ser guardadas y cargadas luego
############################################################################################
############################################################################################
# Mapas de riqueza #########################################################################
############################################################################################
Mapstest1 <- detectionMaps(CTtable      = camara_una_estacion,#datos de camaras, coordenadas, etc
                           recordTable  = tabla_una_cam,#recordtable de registros
                           Xcol         = "utm_x",
                           Ycol         = "utm_y",
                           stationCol   = "Station",
                           speciesCol   = "Species",
                           printLabels  = TRUE,
                           richnessPlot = TRUE, # Riqueza de spp por cámara
                           speciesPlots = FALSE,
                           addLegend    = TRUE)

############################################################
#Mapa de abundancia para una especie########################
############################################################
#especia de interes
laEspecie<-"Tatu"
#mapa
Mapstest2 <- detectionMaps(CTtable      = camara_una_estacion,
                           recordTable  = tabla_una_cam[tabla_una_cam$Species==laEspecie,],#aca solo nos quedamos con los registros de recordtable de la especie de interes
                           Xcol         = "utm_x",
                           Ycol         = "utm_y",
                           stationCol   = "Station",
                           speciesCol   = "Species",
                           speciesToShow = laEspecie,
                           printLabels  = TRUE,
                           richnessPlot = FALSE,    # para hacer abundancia FALSE
                           speciesPlots = TRUE,
                           addLegend    = TRUE)



####################################################
###############DIGIKAM##############################
####################################################
####################################################
## 1. Ir a digikam, importar las fotos (duplica los archivos) y editar la 
## metadata. Recordar que hay una jerarqu??a: Espece/Mano Pelada, etc. Esto
## es importante para que las funciones del paquete anden bien...

## Cosas a recordar de digiKam:
## - Debe estar configurado para que escriba en los metadatos de los archivos, y no
##   en archivos auxiliares (xmp)
## - No estamos trabajando sobre los mismos archivos, si no con una copia en
##   "Mis Imágenes" (pol??tica de no modificar archivos de digiKam)
## - Luego de poner etiquetas, hay que expl??citamente indicarle a digiKam que
##   guarde la información en los archivos (Album > Escribir metadatos...)
