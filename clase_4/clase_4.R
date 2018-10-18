# ---- CLASE 4 - COMPARTIR DATOS ----
#
# Esta clase está enfocada a cómo compartir datos biológicos
#
# Pasos para compartir: 
# 1) Chequeo de nombres de especies
# 2) Estandarización de campos en la tabla 
# 3) Escribir metadatos descriptivos del conjunto de datos.
#
# Se utilizará como input la recortable que sale del camtrapR de las clases anteriores
# Se obtendrá como resultado una tabla de datos y sus metadatos asocaciados,
# aptos para liberar en respositorios de datos de biodiversidad.
#
# Exploraremos las funciones del camtrapR para resolución de especies y
# 2 paquetes para el chequeo y estandarización de la información: taxize y rgbif

# ---- Instalar paquetes y cargarlos ---- 

install.packages('taxize') # si tengo instalado el camtrapR ya tengo este paquete
library(taxize)

install.packages('rgbif')
library(rgbif)

# ---- Setear el working directory ---- 

setwd('C:/Users/Florencia/Documents/camtrapR/Clase4/')


######################################################################
# 1) Chequeo de nombres de especies
######################################################################

# ---- Chequeo de nombres (camptrapR) ----

lista_especies_a_chequear <- c('Tamandua tetradactila', 'Galictis cuya', 'Leopardus geofroy')
chequeo1 <- checkSpeciesNames(speciesNames=lista_especies_a_chequear,
                  searchtype="scientific",
                  accepted = FALSE, # devuleve nombres no aceptados también
                  ask = TRUE) # para decidir entre matches múltiples

# Qué resultado me devuelve? 
# Si las especies están erroneamente escritas la funcion no devuelve ningún resultado

lista_especies_a_chequear <- c('Cerdocyon thous', 'Galictis cuja')
chequeo2 <- checkSpeciesNames(speciesNames=lista_especies_a_chequear,
                              searchtype="scientific",
                              accepted = FALSE, # devuleve nombres no aceptados también
                              ask = TRUE) # para decidir entre matches múltiples
chequeo2
# En este caso los nombres científicos de las espcies están bien escritos y por eso tengo un resultado
# Por esto para chequear nombres vamos a usar otra función del paquete taxize.


# ---- Chequeo de nombres (taxize) ----

# Podemos usar este paquete para probar:
# 1) Si tenemos los nombres más actualizados
# 2) Si nuestros nombres están escritos correctamente
# 3) El nombre científico de un nombre común

# Para chequear nombres científicos voy a usar como base ITIS 
# (si no especifico la base me devuleve todas las opciones)
# Me guardo en la variable 'itis' el numero de ID todas las sources disponibles
sources <- gnr_datasources()
View(sources)
itis <- sources$id[sources$title == 'ITIS']

# Chequeo de nombre para una especie
sp_unkn_1 <- gnr_resolve('puma jagouaroundi') # todas las fuentes 
head(sp_unkn_1)

gnr_resolve('puma jagouaroundi', data_source_ids=itis) # solo resultados de la base ITIS

# Chequeo de nombre para una lista de especies
lista_especies_unkn <- gnr_resolve(c('Tamandua tetradactila', 
                                     'Galictis cuya', 
                                     'Leopardus geofroy'), 
                                   data_source_ids=itis,  # solo resultados de la base ITIS
                                   with_canonical_ranks = TRUE)

lista_especies_unkn

# Cómo puedo hacerlo para toda la recordTable ?

# Cargo la tabla de registros de prueba 'recordTable.csv'
recordTable <- read.csv("~/Uruguay2018/Curso camtrapR/Clase 4/recordTable.csv", row.names=1, stringsAsFactors=FALSE)
View(recordTable)

# Veo las especies
unique(recordTable$Species)

# Uso un loop para recorrer la tabla y resolver la especie para cada registro
for(sp in recordTable$Species) {
  sp_correcta <- gnr_resolve(sp, data_source_ids=itis, with_canonical_ranks = TRUE)
  if (dim(sp_correcta)!=0 && sp!=sp_correcta$matched_name2){
    cat(sp, sp_correcta$matched_name2, '\n') # este fragmento sirve para imprimir en pantalla aquellas especies que cambian
    recordTable$SpeciesCorrecta[recordTable$Species==sp] <- sp_correcta$matched_name2
  }
  else {
    recordTable$SpeciesCorrecta[recordTable$Species==sp] <- sp
    cat(sp, 'Especie correcta', '\n') # este fragmento sirve para imprimir en pantalla aquellas especies que se mantienen porque están correctos
  }
}

# Es importante detenerse a entender qué hace este fragmento de código


### Otras utilidades:

# Obtener IDs taxonómicas de las especies 
get_tsn('Cerdocyon thous', accepted = TRUE)

# Existen especies sinónimas ?
synonyms('Pseudalopex gymnocercus', db='itis')

# Common names from scientific names
sci2comm('Chrysocyon brachyurus', db = 'itis')

# Scientific names from common names
comm2sci('oso pardo', db = "itis")

#obtener la clasificacion
id_sp <- get_tsn('Leopardus pardalis')
classification(id_sp[1], db='itis')

tax_name(query = "Ozotoceros bezoarticus", get = "family", db = "ncbi")
tax_name(query = "Chironectes minimus", get = "order", db = "itis")

######################################################################
# 2) Estandarización de campos en la tabla 
######################################################################

# Puedo agregar tantos como quiera. 
# Ver: https://github.com/tdwg/dwc/blob/master/dist/simple_dwc_vertical.csv

names(recordTable)
# [1] "Station"          "Species"          "DateTimeOriginal" "Date"            
# [5] "Time"             "delta.time.secs"  "delta.time.mins"  "delta.time.hours"
# [9] "delta.time.days"  "Directory"        "FileName" 

# Creo un objeto nuevo que va a ser mi tabla a liberar
datos_abiertos <- recordTable[,c(2,4,11)]
datos_abiertos

# Para usar campos estándar tengo que renombrar algunos campos y crear otros nuevos
# Los campos a modificar a partir de otros ya existentes
# scientificName, eventDate, recordNumber

colnames(datos_abiertos) <- c('scientificName', 'eventDate', 'recordNumber')

# Los campos nuevos a crear:
# institutionCode, basisOfRecord, identifiedBy,
# countryCode, stateProvince, locality, decimalLatitude, decimalLongitude,
# licence

datos_abiertos$institutionCode <- 'JULANA'
datos_abiertos$decimalLatitude <- -32.144923 # cuidado con comas o puntos para los decimales!
datos_abiertos$decimalLongitude <- -53.787037
datos_abiertos$basisOfRecord <- 'MachineObservation' # PreservedSpecimen, FossilSpecimen, LivingSpecimen, HumanObservation
datos_abiertos$identifiedBy <- 'Florencia Grattarola'
datos_abiertos$countryCode <- 'UY'
datos_abiertos$stateProvince <- 'Cerro Largo'
datos_abiertos$locality <- 'Paso Centurión'
datos_abiertos$licence <- 'https://creativecommons.org/licenses/by/4.0/legalcode.es'

# Si quisiera editar ciertos registros en particular, voy a tener que hacerlo uno a uno
# Por ejmplo, lLas fotos de cierta especie fueron identificados por otra persona
datos_abiertos$identifiedBy[datos_abiertos$scientificName == "Lycalopex gymnocercus"] <- 'Juan Pérez'

View(datos_abiertos)

write.csv(datos_abiertos, file='datos_abiertos.csv')

######################################################################
# 3) Escribir metadatos descriptivos del conjunto de datos
######################################################################

# Archivo nuevo a crear con valores de metadatos. Ver https://github.com/gbif/ipt/wiki/GMPHowToGuide

# Campos a incorporar:
# Dataset (Resource): title, creator, contact, pubDate, language, 
# Project: title, personnel, funding, studyAreaDescription,
# People and Organisations: organizationName, electronicMailAddress, onlineUrl
# KeywordSet (General Keywords): keyword


######################################################################
# EXTRA #
######################################################################

# ---- Explorar datos de GBIF ----
# https://ropensci.org/tutorials/rgbif_tutorial/

# Número de observaciones en toda la base de datos
occ_count(basisOfRecord='OBSERVATION')

# Número de registros según el tipo
occ_count(type='basisOfRecord')

# Número de registros por especie ( ej.: taxonKey del Puma concolor es 2435099)
occ_count(taxonKey=2435099, georeferenced=TRUE)

# Número de registros por año
occ_count(year=2012)

# Registros en Uruguay
uy_code <- isocodes[grep("Uruguay", isocodes$name), "code"]
occ_count(country=uy_code)

# ---- Explorar datos con UICN ----
# http://apiv3.iucnredlist.org/api/v3/docs

# Para usar la API de UICN tenemos que crearnos una clave o token http://apiv3.iucnredlist.org/api/v3/token
# IUCN_REDLIST_KEY = 'token'
# Si no tenemos nos devuelve el siguiente error: 'Error: need an API key for Red List data'

# Una vez que UICN nos devuelve el 'token' tengo que crear una environmental variable
# ver https://www.java.com/en/download/help/path.xml

# Estatus de la especie
iucn_summary('Cerdocyon thous')

# Distribución de la especie
distribution_Cerdocyon <- iucn_summary('Cerdocyon thous', distr_detail = TRUE)
distribution_Cerdocyon[[1]]$distr




