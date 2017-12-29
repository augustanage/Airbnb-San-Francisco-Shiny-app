library(shinythemes)

shinyUI(
  navbarPage(title = "Airbnb in San Francisco", 
             #id ="nav",
             
             theme = shinytheme("cerulean"), #https://rstudio.github.io/shinythemes/
             
             ##### Map ########      
             tabPanel("Map",
                      div(class="outer",
                          tags$head(
                            includeCSS("styles.css")),
                          
                          leafletOutput(outputId = "map", width = "100%", height = "100%"),
                          
                          # Panel options: neighborhood, Room Type, Price, Rating, Reviews
                          absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE, 
                                        top = 70, left = "auto", right = 20, bottom = 200,
                                        width = 300, height = "auto",
                                        h2("Airbnb in San Francisco"),
                                        selectInput(inputId = "select_neighbourhood",
                                                    label = "neighbourhood:",
                                                    choices = neighbourhood_cleansed,
                                                    selected = neighbourhood_cleansed, 
                                                    multiple = TRUE)),
                          absolutePanel(id = "controls", class = "panel panel-default", fixed = FALSE, draggable = TRUE, 
                                        top = 20, left = 20, right = "auto" , bottom = 200,
                                        width = 250, height = "auto",
                                        checkboxGroupInput(inputId = "select_room", label = h4("Room Type"), 
                                                           choices = room_type, selected = room_type),
                                        sliderInput(inputId = "slider_price", label = h4("Price"), min = 0, max = 1000, step = 50,
                                                    pre = "$", sep = ",", value = c(100, 500)),
                                        sliderInput(inputId = "slider_rating", label = h4("Rating Score"), min = 20, max = 100, step = 10,
                                                    value = c(60, 100)),
                                        sliderInput(inputId = "slider_review", label = h4("Number of Reviews"), min = 0, max = 400, step = 50,
                                                    value = c(10, 350)),
                                        h6("The map dataset is generated on 02 October, 2017 from"),
                                        h6(a("http://insideairbnb.com", href = "http://insideairbnb.com/get-the-data.html", target="_blank"))
                          ),
                          
                          # Results: count_room, avgprice
                          absolutePanel(id = "controls", class = "panel panel-default", fixed = FALSE, draggable = TRUE, 
                                        top = 570, left = 150, right = "auto" , bottom = "auto",
                                        width = 280, height = "auto",
                                        plotlyOutput(outputId = "count_room", height = 120),
                                        plotlyOutput(outputId = "avgprice", height = 120))
                      )),
             
             ######## Listings ##########               
             tabPanel("Price and Review Ratings",    
                      fluidRow(
                        column(3,
                               h3("Prices and Review Ratings by Neighbourhood and Room Type"),
                               br(),
                               br(),
                               sliderInput(inputId = "tab2_price", h4("Price/Night"), min = 10, max = 1000, value = c(10, 1000)),
                               sliderInput(inputId = "tab2_rating", h4("Rating Score"), min = 90, max = 100, value = c(5,100))
                        ),
                        column(9,
                               h3(""),
                               plotlyOutput(outputId = "graph1", width=800, height =1000))
                      )
                  ),
             
             ###### Listings ##########
             tabPanel("Rating", 
                      fluidRow(
                        column(3,
                               plotlyOutput("review1", width = 700, height = 380))
                        ),
                      fluidRow(
                        column(9,
                                h3("Review Ratings by Neighborhoods"),
                                strong("It is clear that the overall review ratings are very high with no big difference among neighborhoods."),
                                br(),
                                br(),
                                p("After averaging the review ratings based on each neighborhood, each neighborhood reaches an average more than 90. To make the difference stands out, I use the average ratings score to minus 90 and draw the graph. To figure out which neighborhoods have relative higher rating scores, I rank the average ratings in order. ", style = "font-family: 'times'; font-si16pt"),
                                br(),
                                p("We could see that Diamond Heights, Presidio, Castro, Twin Peaks, Potrero Hill, Presidio Heights, West of Twin Peaks, Noe Valley and Treasure Island have an average rating up to 96. These are the best rating neighborhoods for customers to choose. "),
                                p("On the other hand, Golden Gate Park, Downtown, Bayview, Chinatown, and Croker Amazon receive lowest rating less than 93 which are the neighborhoods visitors should avoid booking in terms of finding a top rating place to stay. "))
                      )),
                      
             tabPanel("Relationship:Price and Rating", 
                      fluidRow(
                        column(3,
                               plotlyOutput("pr", width = 700, height = 400))
                      ),
                      fluidRow(
                        column(9,
                               h3("Relationship between Price and Review"),
                               strong("After grouping by the rating score to see the average price in each specific score, I find the prices are not linearly increasing with the growth of the review rating. The prices show a fluctuate change when the rating increases."),
                               br(),
                               br(),
                               p("In this case, the rooms earn up to 90 scores do not show a strong increase in their price. But overall, these are the rooms with an average up to $175 per night with a steady increase trend."),
                               p("For rooms received rating scores less than 90, the relationship between price and rating is likely to be random. And those rooms could have an average less than $150 per night. "),
                               p("It seems that rooms with a score at 74 reach the highest average price close to $300 per night which is a surprise due to the average price for 100 rating rooms is $260 per night."))
                      )),
                      
              tabPanel("Price Changes", 
                        fluidRow(
                         column(3,
                                plotlyOutput("tab_price", width = 700, height = 400))
                         ),
                       fluidRow(
                         column(9,
                                h3("Price changes over Month"),
                                strong("December has the lowest average price to $240/night among all months."),
                                br(),
                                br(),
                                p("By plotting a line graph in the price range from 2017 to 2018, we could see that from November to March, the average prices for each month are all below $250 night."),
                                p("Also, there is an increasing trend from January to June which the change for price is up to $15."),
                                p("Starting from June, a clear decrease trend shows up, except October which reach the highest average price to $264/night in a surprise."))
                       )),
           
           ##### Analytics ##########      
           navbarMenu("Analytics",
                      tabPanel("Motiviation",
                               h3("Motivation"),
                                  p("During the holiday seasons, I am always wondering to go somewhere else than the city I live in.", style = "font-family: 'times'; font-si16pt"),
                                  p("To consider a proper place to stay for a couple of days, Airbnb comes up to my mind.", style = "font-family: 'times'; font-si16pt"),
                                  p("I am planning to go San Francisco this Christmas. This triggers my interest to explore Airbnb’s listings in the city.", style = "font-family: 'times'; font-si16pt"),
                                  br(),
                                  strong(" I want to find answers to the following questions: "),
                                  br(),
                                  br(),
                                  div("What is the overall location distribution of Airbnb in San Francisco?", style = "color:blue"),
                                  p("-	Please take a look at the Interactive Map"),
                                  br(),
                                  div("Is there a neighborhood where provide budget friendly and highly rated rooms?", style = "color:blue"),
                                  p("-	The following tabs discussed the related topics: Price and Review Ratings, Review Ratings by Neighborhoods, Relationship between Price and Review"),
                                  p("-	Personal Suggestion in summary provides the answer to this question."),
                                  br(),
                                  div("Which month is the lowest cost season to go for a stay with Airbnb?", style = "color:blue"),
                                  p("-	Please look through the tab named Price Changes in Months")),
                      
                      tabPanel("SF Map",
                               h3("San Francisco Interactive Map"),
                               p("To have a quick glance at the overall location distribution, the 'CLUSTER' function in the right upper corner could be used to group up listings in certain neighborhood.", style = "font-family: 'times'; font-si16pt"),
                               p("To look for a colorful distribution for specific location, the “CIRCLE” function up to “CLUSTER” allows the users to zoom the map to look in detail to find the listing information for each room on its room type, price, rating score, and number of reviews.", style = "font-family: 'times'; font-si16pt"),
                               br(),
                               p("Users could use the left-hand side filter functions to find the proper range for room types, price range, rating score, and number of reviews."),
                               p("When the users change the range on their interests, the results for numbers of room types and average price would come up on the right lower corner."),
                               br(),
                               strong("We could see that Western Addition, Mission, South of Market, Noe Valley, Downtown, Castro, Bernal Heights have the large number of supply on rooms during the year."), 
                               strong("They are centralized and on the northeast side of the city.")),
                              
                      tabPanel("Understanding and Suggestion",
                               h3("Price and Review Ratings Analytics"),
                               p("To explore detailed information in each neighborhood and find the most budget friendly and highly rated rooms, I narrow the price range from 10 to 100 dollars/night and rating score range from 90 to 100 to check which neighborhood fits the expectation.", style = "font-family: 'times'; font-si16pt"),
                               br(),
                               strong("We could see that the private room type has the largest number of rooms, especially in Mission, Western Addition, Bernal Heights, and Outer sunset neighborhoods. "),
                               br(),
                               br(),
                               h3("Suggestion"),
                               strong("In terms of location, availability for rooms, types of rooms, review rating, price, I would recommend customers to choose private room or entire home/apt in Mission, Western Addition, and Bernal Heights neighborhoods which could have more than 1000 places for choosing with an average cost $178.63 for entire home/apt and $110.48 for private room. Since rating does not show a distinct, the rating influence has limited impact on selection.",style = "color:Orange")
                              ),
                      
                      tabPanel("Data in this project",
                               h3("data : Inside Airbnb", a("http://insideairbnb.com/get-the-data.html", href="http://insideairbnb.com/get-the-data.html")))
           ) 
  ))
