Gestión y análisis de registros de fauna con cámaras trampa utilizando software R (camtrapR)
============================================================================================

Clase 1
-------

Proponemos el siguiente orden para esta clase:

### 1. R, una recorrida:

Archivos:
  - [clase_1_consejos.Rmd](clase_1_consejos.Rmd)

Este documento muestra las características principales de R, incluyendo las preguntas ¿qué es? ¿para qué sirve? ¿por qué R?. También da consejos para tener un buen vínculo con R, incluyendo formas de conseguir ayuda y enfrentarse a errores.

### 2. Guión introductorio con caso de estudio:

Archivos necesarios:
  - [clase_1.R](clase_1.R), el cual precisa de:
  - [../data/tabla_registros.csv](../data/tabla_registros.csv) y/o
  - [../data/tabla_registros.xlsx](../data/tabla_registros.xlsx)

El guión o script de R (camtrapR_clase_1.R) es un archivo de texto plano que se puede abrir con [RStudio](https://www.rstudio.com/) (para lo cual está pensado) o cualquier editor de texto plano (ej.: notepad). La idea es ir leyendo las instrucciones allí indicadas (en comentarios, textos precedidos por el `#`) e ir probando los comandos expuestos (usando, en RStudio, el atajo `Ctrl + Enter`). También se invita y recomienda probar con variantes de dichos comandos e investigar qué cambia en los resultados (incuyendo errores).

### Lista completa de archivos y carpetas:

- [clase_1.R](camtrapR_clase_1.R)
- [clase_1_consejos.Rmd](clase_1_consejos.Rmd): archivo "R markdown", usado para crear documento html (vía [knitr](https://yihui.name/knitr/)).
- data
  + [tabla_registros.csv](../data/tabla_registros.csv): tabla usada en el guión camtrapR_clase_1.R. Formato CSV (comma separated values; texto plano).
  + [tabla_registros.xlsx](../data/tabla_registros.xlsx): tabla usada en el guión camtrapR_clase_1.R. Format Xlsx (Excel).
- img_clase1: imágenes auxiliares para el el Rmd
