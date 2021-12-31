


function(input, output){
  
  output$histograma <- renderEcharts4r({
    
    df_bar <-
      datos |> 
      filter(fecha == input$fecha) |> 
      group_by(hora_cadena) |> 
      summarise(n = n()) |> 
      mutate(color = "gray") |> 
      mutate(hora_numero =
               substr(hora_cadena,1, if_else(nchar(hora_cadena)==4,1,2))) 
    
    
    df_bar$hora_numero <- as.numeric(df_bar$hora_numero)
    
    df_bar <- 
      df_bar |> 
      arrange(hora_numero)
    
    df_bar$color[df_bar$hora_cadena %in% input$hora ] <- "#8a3636"
    
    df_bar |> 
      e_charts(hora_cadena, dispose = FALSE) |> 
      e_bar(n, name = "Viajes totales:") |> 
      e_legend(FALSE) |> 
      e_theme("auritus") |> 
      e_y_axis(show = FALSE) |> 
      e_color(background = "#262524") |> 
      e_title("Histograma: Viajes totales por hora", paste0("Para la fecha ", input$fecha ),
              left = "center",
              textStyle = list(
                color = "gray")
              
              ) |> 
      e_tooltip(trigger = "axis") |> 
      e_add_nested("itemStyle", color)
    
      
    
    
  })
  
  output$mapa <- renderMapboxer({
    
    
    
    inicial <- 
      datos |> 
      filter(fecha == "6/1/2014") |> 
      rename(lng = Lon) |> 
      rename(lat = Lat)
    inicial <- 
      inicial |> 
      mutate(hora_s_seg = substr(
        Hora_dia,1,if_else(
          nchar(
            Hora_dia
          )==7,1,2
        )
      )) |> 
      mutate( color = 
                case_when(
                  hora_s_seg >= 3  ~ "#eae2b7",
                  hora_s_seg > 3 & hora_s_seg <= 6  ~ "#fcbf49",
                  hora_s_seg > 6 & hora_s_seg <= 12 ~ "#f77f00",
                  hora_s_seg > 12 & hora_s_seg <= 17 ~ "#d62828",
                  hora_s_seg > 17 & hora_s_seg <= 23  ~ "#003049",
                )
      )
    
    inicial$color[is.na(inicial$color)] <- "#eae2b7"
    
    
    map_rendered(TRUE)
    as_mapbox_source(inicial) |> 
      mapboxer(maxZoom = 14, minZoom = 8) |> 
      set_view_state(-73.9165, 40.7114, 11,pitch = 50) |> 
      add_circle_layer(
        circle_color = c("get", "color"),
        circle_radius = 2,
        popup = "<p>Hora: {{Hora_dia}}</p> "
      ) 
    
    
    
  })
  
  map_rendered <- reactiveVal(FALSE)
  
  filtro_zona <- reactive({
    zonas |> 
      filter(zona == input$zona)
  })
  
  
  
  
  observeEvent(input$zona,{
    
    
    
    req(map_rendered())
    
    mapboxer_proxy("mapa") |> 
      fit_bounds(
        bounds = c(
          filtro_zona()$lat,
          filtro_zona()$lng,
          filtro_zona()$lat,
          filtro_zona()$lng
        )
      ) |> 
      update_mapboxer()
    
  })
  
  
  toListen <- reactive({
    list(input$fecha,input$hora)
  })
  
  
  final <- reactive({
    
    
      datos |> 
      filter(fecha == input$fecha & hora_cadena %in% input$hora) |> 
      rename(lng = Lon) |> 
      rename(lat = Lat) |> 
      mutate(hora_s_seg = substr(
        Hora_dia,1,if_else(
          nchar(
            Hora_dia
          )==7,1,2
        )
      )) |> 
      mutate( color = 
                case_when(
                  hora_s_seg >= 3  ~ "#eae2b7",
                  hora_s_seg > 3 & hora_s_seg <= 6  ~ "#fcbf49",
                  hora_s_seg > 6 & hora_s_seg <= 12 ~ "#f77f00",
                  hora_s_seg > 12 & hora_s_seg <= 17 ~ "#d62828",
                  hora_s_seg > 17 & hora_s_seg <= 23  ~ "#003049",
                )
      )
    
  })
  
  densidad <- reactive({
    req(final() )
    
    final() |> 
      group_by(hora_cadena) |> 
      summarise(n = n())
  })
  
  
  observeEvent(toListen(),{
    
    
    
    req(map_rendered())
    req(final() )
    
    mapboxer_proxy("mapa") |> 
      set_data(final()) |> 
      update_mapboxer()
    
  })
  
  output$texto1 <- renderText({
    
    paste0(
      "Número de viajes totales: ", nrow(final())
    )
    
  })
  
  
  output$texto2 <- renderText({
    
    paste0(
      "Cantidad de horas seleccionadas: ", length(unique(final()$hora_cadena ))
    )
    
  })
  
  output$texto3 <- renderText({
    
    paste0(
      "Horario con mayor densidad de viajes: ", densidad()$hora_cadena[which.max(densidad()$n )]
    )
    
  })
  
  
  
  
  
  
  
  
  
  
  
}