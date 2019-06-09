

#Used shinyUI dashboard to create rich interactive dashboard component.
shinyUI(dashboardPage(
  title = "Welcome to FIFA",
  skin = "blue",
  dashboardHeader(title = "FIFA-2019"
  ),
  
  # dashboardSidebar start
  dashboardSidebar(
    sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuSubItem("Missing Values", tabName = "missing_values", icon = icon("minus")), 
    menuSubItem("Multidimensional Scaling", tabName = "mds", icon = icon("laptop-code")),
    menuSubItem("Principal Component Analysis", tabName = "pca", icon = icon("product-hunt")),
    menuSubItem("Canonical Correlation Analysis", tabName = "cca", icon = icon("closed-captioning")),
    menuSubItem("Cluster Analysis", tabName = "ca", icon = icon("atom")),
    menuSubItem("Factor Analysis", tabName = "fa", icon = icon("foursquare"))
  )
  # dashboardSidebar end  
  ),
  
  # dashboardBody start
  dashboardBody(
    headerPanel("",
                tags$head(
                  # tags$link(rel="stylesheet", type="text/css",
                  #           href="app.css")
                 # tags$img(src="Rawlsheader.jpg", align = "right")
                )
    ),
  
   # tabItems start
    tabItems(
    # start dashboard tab item  
     tabItem(tabName = "dashboard",
        fluidRow(
          column(width = 10,
                valueBoxOutput("countries"),
                valueBoxOutput("players")
          )
        ),
        fluidRow(
          box(title = "Distribution between Age and Overall of players based  on Wage bracket", 
              solidHeader = T,
              background = "aqua",
              status = "primary", plotOutput("perf_plot"))
        )
      ),
     # end dashboardtabitem
     
     # start missing_values
     tabItem(tabName = "missing_values",
        fluidRow(
          column(12,
            tabBox(width = 12,
              tabPanel(title = "Missing Values Before Cleaning", solidHeader = T,
                            background = "aqua",
                            status = "warning",
                            plotOutput("missvalbefore")
                ),
                tabPanel(title = "Missing Values After Cleaning", status = "success", solidHeader = T,
                         background = "teal",
                         plotOutput("missvalafter")
                )
              )
            #end tabbox
            )
          # end fluidrow
          )
      # end missing_values tab item
      ),
     
     # start dist_mtrx tab item
     tabItem(tabName = "mds",
             # start fluidRow
             fluidRow(
               column(12,
                  # start tabBox    
                  tabBox(width = 12,
                    tabPanel(title = "Multidimensional Scaling For Variables", solidHeader = T,
                             background = "aqua",
                             status = "primary",
                             plotOutput("mds_column")
                      ),
                      tabPanel(title = "Distance Matrix Variable Graph", solidHeader = T,
                               background = "aqua",
                               status = "primary",
                               plotOutput("graph_var")
                      )
                    # end tabBox
                    )
                )
              # end fluidRow 
              )
      # end dist_mtrx tab item       
      ),
     
     # start pca tab item
     tabItem(tabName = "pca",
             # start fluidRow
             fluidRow(
               column(12,
                      # start tabBox    
                      tabBox(width = 12,
                             tabPanel(title = "Summary", solidHeader = T,
                                      background = "aqua",
                                      status = "primary",
                                      verbatimTextOutput("pca_summary")
                             ),
                             tabPanel(title = "PCA 2D Plot", solidHeader = T,
                                      background = "blue",
                                     # status = "primary",
                                      plotOutput("pca_2dplot")
                             ),
                             # tabPanel(title = "PCA 3D Plot", solidHeader = T,
                             #          background = "light-blue",
                             #         # status = "primary",
                             #          #playwidgetOutput("control"),
                             #          #rglwidgetOutput("wdg_pca_3dplot"),
                             #          plotOutput("pca_3dplot", width = 800, height = 600)
                             # ),
                             tabPanel(title = "PCA 3D Box Plot", solidHeader = T,
                                      background = "aqua",
                                      status = "primary",
                                      rglwidgetOutput("pca_3dboxplot", width = 800, height = 600)
                             )
                             # end tabBox
                      )
               )
               # end fluidRow 
             )
             # end pca tab item       
     ),
     # end tabItem
     
     # start cca tab item
     tabItem(tabName = "cca",
             # start fluidRow
             fluidRow(
               column(12,
                      # start tabBox    
                      tabBox(width = 12,
                             tabPanel(title = "Plot Correlation Management Perspective", solidHeader = T,
                                      background = "aqua",
                                      status = "primary",
                                      plotOutput("X_plot")
                             ),
                             tabPanel(title = "Plot Correlation Coach Perspective", solidHeader = T,
                                      background = "aqua",
                                      status = "primary",
                                      plotOutput("_plot")
                             ),
                             tabPanel(title = "Matrix Correlation", solidHeader = T,
                                      background = "aqua",
                                      status = "primary",
                                      verbatimTextOutput("mat_corr_summary")
                             ),
                             tabPanel(title = "Cannonical Correlation", solidHeader = T,
                                      background = "aqua",
                                      status = "primary",
                                      verbatimTextOutput("cca_corr_summary")
                             )
                      # end tabBox
                      )
               )
               # end fluidRow 
             )
             # end cca tab item       
     ),
     # end tabItem
     
     # start ca tab item
     tabItem(tabName = "ca",
             # start fluidRow
             fluidRow(
               column(12,
                      # start tabBox    
                      tabBox(width = 12,
                             tabPanel(title = "Elbow Test Plot", solidHeader = T,
                                      background = "aqua",
                                      status = "primary",
                                      plotOutput("ebtest_plot")
                              ),
                             tabPanel(title = "True Clustering based on Overall", solidHeader = T,
                                      background = "aqua",
                                      status = "primary",
                                      plotOutput("true_plot")
                             ),
                             tabPanel(title = "Hierarchical Complete Cluster", solidHeader = T,
                                      background = "aqua",
                                      status = "primary",
                                      plotOutput("hc_plot")
                             ),
                             tabPanel(title = "KMeans Cluster", solidHeader = T,
                                      background = "aqua",
                                      status = "primary",
                                      plotOutput("km_plot")
                             ),
                             tabPanel(title = "Model Based Cluster", solidHeader = T,
                                      background = "aqua",
                                      status = "primary",
                                      plotOutput("mbc_plot")
                             )
                      )
               )
               # end fluidRow 
             )
             # end ca tab item       
     ),
     # end tabItem
     
     # start fa tab item
     tabItem(tabName = "fa",
             # start fluidRow
             fluidRow(
               column(12,
                      # start tabBox    
                      tabBox(width = 12,
                             tabPanel(title = "Exploratory Factor Analysis", solidHeader = T,
                                      background = "aqua",
                                      status = "primary",
                                      verbatimTextOutput("efa_text")
                             ),
                             tabPanel(title = "Confirmatory Factor Analysis-Summary", solidHeader = T,
                                      background = "aqua",
                                      status = "primary",
                                      verbatimTextOutput("cfa_text")
                             ),
                             tabPanel(title = "Confirmatory Factor Analysis-Plot", solidHeader = T,
                                      background = "aqua",
                                      status = "primary",
                                      plotOutput("cfa_plot")
                             )
                      )
               )
               # end fluidRow 
              )
       # end fa tab item       
      )
     # end tabItem
     
    )
    # tabItems end
  )
  # dashboardBody end
))