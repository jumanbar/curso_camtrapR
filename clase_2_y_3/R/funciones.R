camopPlot2 <- function(camMatOp, horiz = TRUE) {
  # camMatOp : matríz de operaciones de cámara.
  
  # Debe tener los siguientes nombres de columnas:
  #   Station, Camera, utm_y, utm_x, 
  #   Setup_date, Retrieval_date,
  #   Problem1_from, Problem1_to
  require(magrittr)
  require(ggplot2)
  require(lubridate)
  
  cn <- 
    c("Station", "Camara", "utm_y", "utm_x", "Setup_date",
      "Retrieval_date", "Problem1_from", "Problem1_to")
  
  if (any(colnames(camMatOp) != cn)) {
    stop(paste("Los nombres de las columnas de camMatOp",
               "no son los esperados. Se esperan los",
               "siguientes nombres:\n",
               paste(cn, collapse = ", ")))
  }
  
  cam <- camMatOp %>%
    select(-starts_with("utm")) %>%
    gather(key = "Hito_inicio", value = "Fecha_inicio",
           Setup_date, Problem1_from) %>%
    gather(key = "Hito_fin", value = "Fecha_fin",
           Retrieval_date, Problem1_to) %>%
    filter(!(
      grepl("^Problem", Hito_inicio) &
        grepl("^Retrieval", Hito_fin) |
        grepl("^Setup", Hito_inicio) &
        grepl("^Problem", Hito_fin)
    )) %>%
    mutate(
      Funciona = grepl("Setup|Retrieval", Hito_inicio) %>%
        ifelse("Sí", "No"),
      Fecha_inicio = dmy(Fecha_inicio),
      Fecha_fin    = dmy(Fecha_fin)
    )
  
  p <- ggplot(cam) +
    aes(x = Fecha_inicio, y = 1, col = Funciona) +
    xlab("Fecha") +
    ggtitle("Operación de las cámaras") +
    scale_y_continuous(name = NULL,
                       breaks = NULL,
                       labels = NULL) +
    scale_x_date(date_breaks = "1 month") +
    geom_segment(aes(
      x = Fecha_inicio,
      y = 1,
      xend = Fecha_fin,
      yend = 1
    ),
    size = 20)
  
  if (horiz) {
    p <- p + facet_grid(paste0(Station, "_", Camara) ~ .)
  } else {
    p <- p + 
      facet_grid(. ~ paste0(Station, "_", Camara)) +
      coord_flip()
  }
  print(p)
}
