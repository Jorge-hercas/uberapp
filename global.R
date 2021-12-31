
library(stringr)
library(shiny)
library(mapboxer)
library(echarts4r)
library(dplyr)
#library(dtplyr)
library(data.table)
library(shinyWidgets)
library(bslib)


datos <- fread("datos/uber-raw-data-jun14.txt")

datos <- 
  datos |> 
  mutate(fecha = str_split(datos$`Date/Time`, " ", simplify = TRUE)[,1]) |> 
  mutate(Hora_dia = str_split(datos$`Date/Time`, " ", simplify = TRUE)[,2])

zonas <- data.frame(
  zona = c("Madison Square Garden",
           "Yankee Stadium",
           "Empire State Building",
           "New York Stock Exchange",
           "John F. Kennedy International Airport",
           "Grand Central Terminal",
           "Times Square",
           "Columbia University",
           "United Nations Headquarters"
  ),
  lng = c(40.7505,40.8296,40.7484,40.7069,40.6413,40.7527,40.7580,40.8075,40.7489),
  lat = c(-73.9934,-73.9262,-73.9857,-74.0113,-73.7781,-73.9772,-73.9855, -73.9626,-73.9680)
)


datos <- 
datos |> 
  mutate(hora_cadena = paste0(
   substr(Hora_dia,1, if_else(nchar(Hora_dia)==7,1,2)), ":00"
  ))


