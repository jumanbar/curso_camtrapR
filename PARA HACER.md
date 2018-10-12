Para hacer
==========

- Arreglar el .Rmd, usando encoding correcto y haciendo referencias correctas a los archivos (carpeta img_clase1, deprecar la generada automáticamente al hacer el html).

- Unificar ancho de líneas (hasta n caracteres, tal vez 60 o un número bajo, ya que en proyector hay menos espacio). Interrumpir las líneas largas para que entren; tanto para código como para comentarios).

- Posible cambio: pasar todas las clases a Rmarkdown. Ahí ya se puede prescindir de muchos comentarios y te olvidás de qué tan anchas son las líneas en el texto. La contra que le veo es que hay que generar todas las imágenes primero y luego agregarlas al documento manualmente con:

```
![Leyenda de la imagen](ruta/a/la/imagen.png)
```

- Unificar a tidyverse (y taller previo de tidyverse con Gabi y Flo?). Por lo pronto, JM va a ir agregando código estilo tidyverse para sustituir algunas partes de lo que está hecho con R clásico en las clases de Gabi y Flo. La idea un poco es que puedan comparar para ir aprendiendo.

- Lo anterior incluye hacer gráficos tipo ggplot... lo cual implica:
    + Hacer funciones propias para sustituir las que propone `camtrapR` relativas a gráficos.
    + Investigar nombres por defecto en las distintas tablas (para no tener que estar ajustando los parámetros correspondientes en las funciones del `camtrapR`).
    
- Matriz de operaciones:
  + Rinde?
  + Vertical?
  
- Caminos relativos a la carpeta raíz del repositorio.
