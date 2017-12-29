shinyServer(function(input, output, session) {
  
  ##### SF Interactive Map ############
  # reactivate map info
  mapdf <- reactive({
    SFmap %>%
      filter(neighbourhood_cleansed %in% input$select_neighbourhood & 
               room_type %in% input$select_room & 
               price >= input$slider_price[1] &
               price <= input$slider_price[2] &
               number_of_reviews >= input$slider_review[1] &
               number_of_reviews <= input$slider_review[2] &
               review_scores_rating >= input$slider_rating[1] &
               review_scores_rating <= input$slider_rating[2]) 
  })
  
  # create the map
  output$map <- renderLeaflet({
    leaflet() %>% 
      addProviderTiles("Esri.WorldStreetMap") %>%
      addLegend(position = "bottomleft", pal = groupColors, values = room_type, opacity = 1, title = "Room Type") %>% 
      setView(lng = -122.4299, lat = 37.7678, zoom = 13)
  })
  
  # observe an event
  observe({ #require a trigger to call the observe function
    proxy <- leafletProxy("map",data = mapdf()) %>%
      clearMarkerClusters() %>% 
      clearMarkers() %>%
      # circle
      addCircleMarkers(lng = ~longitude, lat = ~latitude, radius = 2, color = ~groupColors(room_type),
                       group = "CIRCLE",
                       popup = ~paste('<b><font color="Black">','Listing Information','</font></b><br/>',
                                      'Room Type:', room_type,'<br/>',
                                      'Price:', price,'<br/>',
                                      'Rating Score:', review_scores_rating, '<br/>',
                                      'Number of Reviews:', number_of_reviews,'<br/>')) %>% 
      # cluster
      addCircleMarkers(lng = ~longitude, lat = ~latitude, clusterOptions = markerClusterOptions(),
                       group = "CLUSTER",
                       popup = ~paste('<b><font color="Black">','Listing Information','</font></b><br/>',
                                      'Room Type: ', room_type, '<br/>',
                                      'Price:', price,'<br/>',
                                      'Rating Score:', review_scores_rating, '<br/>',
                                      'Number of Reviews:', number_of_reviews,'<br/>')) %>% 
      # circle/ cluster panel
      addLayersControl(
        baseGroups = c("CIRCLE","CLUSTER"),
        options = layersControlOptions(collapsed = FALSE)
      ) 
  })
  
  ## reactivate count dataframe for map graph1 
  countdf <- reactive({
    mapdf() %>%
      group_by(., room_type) %>%
      summarise(., count_type = n())
  })
  
  #map graph1 
  output$count_room <- renderPlotly({
    plot_ly(data = countdf(), x = ~room_type, y = ~count_type, type = "bar", color = ~room_type,
            colors = c("#e01149", "#f6ff00","#2c07b2"),
            hoverinfo = 'text',
            text = ~count_type) %>%
      layout(xaxis = list(title = "", showticklabels = FALSE),
             yaxis = list(title = "count"), showlegend = FALSE,
             annotations = list(x = ~room_type, y = ~count_type, text = ~paste(round(count_type/sum(count_type),2)*100,'%'),
                                xanchor = 'center', yanchor = 'bottom',
                                showarrow = FALSE)) %>% 
      config(displayModeBar = FALSE)
  })
  
  ## reactivate price dataframe for map graph2
  pricedf <- reactive({
    mapdf() %>% 
      group_by(., room_type) %>% 
      summarise(., avg_price = round(mean(price),2))
  })
  
  #map graph2 avgprice
  output$avgprice <- renderPlotly({
    plot_ly(data = pricedf(), x = ~room_type, y = ~avg_price, type = "bar", color = ~room_type,
            colors = c("#e01149", "#f6ff00","#2c07b2"),
            hoverinfo = 'text',
            text = ~avg_price) %>% 
      layout(xaxis = list(title = "", showticklabels = FALSE), 
             yaxis = list(title = "price"), showlegend = FALSE,
             annotations = list(x = ~room_type, y = ~avg_price, text = ~paste('$',avg_price),
                                xanchor = 'center', yanchor = 'bottom', 
                                showarrow = FALSE)) %>% 
      config(displayModeBar = FALSE)
  })

  
  
  
  
  ##### Neighbours and Price Changes #######################
  ## reactivate dataframe for listings grapgh
  graph1df <- reactive({
    SFmap %>%
      select(neighbourhood_cleansed,room_type,price,review_scores_rating) %>% 
      filter(price >= input$tab2_price[1] &
               price <= input$tab2_price[2] &
               review_scores_rating >= input$tab2_rating[1] &
               review_scores_rating <= input$tab2_rating[2]) %>% 
      group_by(neighbourhood_cleansed,room_type) %>% 
      summarise(n=n()) %>%
      arrange(desc(n))
  })
  
  
  # listings grapgh
  output$graph1 <- renderPlotly({
    t <- list(size = 9)
    plot_ly(data = graph1df(), x = ~n, y = ~room_type, type = "bar", color = ~neighbourhood_cleansed,
            colors = c("#E52B50", "#00C4B0", "#FFBF00", "#34B334", "#FF9899","#9966CC",
                       "#008000", "#FF9966", "#007FFF", "#F4C2C2", "#89CFF0", "#FFE135",
                       "#848482", "#F28E1C", "#8F5973", "#D1001C", "#0093AF", "#FADA5E",
                       "#059033", "#FF6600", "#00B9FB", "#8A2BE2", "#DA70D6", "#414A4C",
                       "#DDE26A", "#9BC4E2", "#DDADAF", "#DA8A67", "#DCD0FF", "#F984E5",
                       "#96DED1", "#78184A", "#009B7D", "#50C878", "#AEC6CF", "#FF6961",
                       "#D1E231"),
            orientation = 'h', showlegend = TRUE) %>%
      layout(xaxis = list(title = "count"),
             yaxis = list(title = ""), 
             barmode = 'group', font = t)
  })
  
  # price change graph (month)
  output$tab_price <- renderPlotly({
      plot_ly(data = month, x = ~month, y = ~avg_pricemo, type= 'scatter', mode = 'markers+lines', color = "Set9",
              text = ~paste('Price: $', avg_pricemo)) %>%
              layout(xaxis = list(title = "month", type = 'category'),
                     yaxis = list(title = "price"))
  })

 
  ##########overall rating scores by neighborhoods##########
  review$neighbourhood_cleansed <- factor(review$neighbourhood_cleansed, 
                                          levels = c("Diamond Heights", "Presidio", 
                                                     "Castro/Upper Market", "Twin Peaks", 
                                                     "Potrero Hill", "Presidio Heights", 
                                                     "West of Twin Peaks", "Noe Valley", 
                                                     "Treasure Island/YBI", "Outer Mission", 
                                                     "Seacliff", "Mission", "Bernal Heights",
                                                     "Western Addition", "Glen Park", 
                                                     "Pacific Heights", "Marina", 
                                                     "Inner Sunset", "Russian Hill", 
                                                     "South of Market", "Outer Richmond", 
                                                     "Haight Ashbury", "Visitacion Valley", 
                                                     "Inner Richmond", "Lakeshore", 
                                                     "Financial District", "North Beach", 
                                                     "Outer Sunset", "Parkside", "Nob Hill", 
                                                     "Ocean View", "Excelsior", "Golden Gate Park", 
                                                     "Downtown/Civic Center", "Bayview", 
                                                     "Chinatown", "Crocker Amazon"))
  output$review1 <- renderPlotly({
      plot_ly(data = review, x = ~ neighbourhood_cleansed, y = ~ avg_review-90, type= 'bar', color=I("pink")) %>%
        layout(xaxis = list(title = ""),
               yaxis = list(title = "average review rating"),
               paper_bgcolor = 'rgba(245, 246, 249, 1)',
               plot_bgcolor = 'rgba(245, 246, 249, 1)')
  })
  
  
  
  
  
  #########price and review##################
  p_r<-SFmap %>% select(review_scores_rating,price) %>%
    filter(review_scores_rating!="NA",price!="NA") %>%
    group_by(review_scores_rating) %>%
    summarise(avg_price=mean(price))
  
  output$pr <- renderPlotly({
    plot_ly(data = p_r, x = ~ review_scores_rating, y = ~ avg_price, type= 'scatter', mode = 'markers+lines', color=I("grey")) %>%
      layout(xaxis = list(title = "review rating"),
             yaxis = list(title = "average price"))
  })
})