

fluidPage(
  title = "SHINY - UBER DATA APP",
  setBackgroundColor("#171717"),
  column(
    br(),br(),br(),
    div(style="display: inline-block;vertical-align:top; width: 130px;",
    img(src="logo_small_b.png", height = '108px', width = '100px')),
    div(style="display: inline-block;vertical-align:botton; width: 190px;
        color: white;",
        br(),
        h2("R-conomics"), align = "botton"),
    br(),br(),
    div(style="color: gray;",
    h3("SHINY - UBER DATA APP")),
    div(style="color: gray; width: 335px; align: left; margin-left: 50px;",
    p(align = "left
      ", "¿En qué momento incrementa la demanda de viajes en Uber para la ciudad de 'New York?' Mediante esta app podrás conocer este dato viendo el histograma con las frecuencias de los viajes y los puntos de mayor incidencia en el mapa.")),
    br(),br(),
    pickerInput("fecha",
                choices = unique(datos$fecha),
                selected = head(unique(datos$fecha),1)
                       
                       ),
    pickerInput(
      inputId = "zona",
      label = " ", 
      choices = zonas$zona,
      options = list(
        title = "Selecciona una zona")
    ),
    pickerInput(
      multiple = TRUE,
      inputId = "hora",
      label = " ", 
      choices = unique(datos$hora_cadena),
      selected = unique(datos$hora_cadena),
      options = list(
        `actions-box` = TRUE,
        title = "Selecciona una hora")
    ),
    br(),br(),
    div(style="color: gray; width: 335px; align: left; margin-left: 50px;",
    p(align ="left",textOutput("texto1"))),
    div(style="color: gray; width: 335px; align: left; margin-left: 50px;",
    p(align ="left",textOutput("texto2"))),
    div(style="color: gray; width: 335px; align: left; margin-left: 50px;",
    p(align ="left",textOutput("texto3"))),
    br(), br(), 
    
    div(style="color: gray; width: 335px; align: left; margin-left: -5px;",
        a(strong("Mira otras apps y tutoriales en R-conomics"), href = "https://r-conomics.netlify.app")
        ),
    
    align = "center",
    width = 4
  ),
  
  column(
    width = 8,
    mapboxerOutput("mapa", width = 950),
    echarts4rOutput("histograma", width = 950, height = 420)
    
    )
  
)