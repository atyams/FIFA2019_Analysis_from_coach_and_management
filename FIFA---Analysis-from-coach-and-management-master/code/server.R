# Must be executed BEFORE rgl is loaded on headless devices.
options(rgl.useNULL=TRUE)

shinyServer(function(input,output){
  
  # Dashboard start
  output$countries <- renderValueBox({
    valueBox(length(unique(fifa$Nationality)),"Countries", icon = icon("globe"), color = "orange")
  })
  
  output$players <- renderValueBox({
    valueBox(length(unique(fifa$ID)),"Players", icon = icon("users"), color = "yellow")
  })
  
  # PLot to identify the performance and age.
  output$perf_plot <- renderPlot({
    g_age_overall <- ggplot(fifa, aes(Age, Overall, label = ifelse(Wage > 250000,Name,'')))
    g_age_overall + 
      geom_point(aes(color=wage_brackets)) + geom_smooth(color="darkblue") +  
      geom_text(aes(label=ifelse(Wage > 250000,as.character(Name),''), 
                    color=wage_brackets),
                    hjust=0,vjust=0, cex = 2)
  })
  
  # Dashboard end
  
  # Missing values start
  output$missvalbefore <- renderPlot({
    vis_miss(fifa_before, sort_miss = FALSE,
             show_perc = TRUE, warn_large_data = TRUE) + 
      labs(title = "Missing Values Before Cleaning.")
  })
  
  output$missvalafter <- renderPlot({
    vis_miss(fifa, sort_miss = FALSE,
             show_perc = TRUE, warn_large_data = TRUE) + 
      labs(title = "Missing Values Before Cleaning.")
  })
  
  # Missing values end
  
  # MDS start
  
  output$mds_column <- renderPlot({
    plot(cmd.var, pch = ".")
    text(cmd.var, labels = colnames(fifa_num_data[,1:13]), cex = 0.6)
  })
  
  output$graph_var <- renderPlot({
    g <- graph.full(nrow(dist.var))
    V(g)$label <- colnames(fifa_num_data[,1:13])
    layout <- layout.mds(g, dist = as.matrix(dist.var))
    plot(g, layout = layout, vertex.size = 3)
  })
  
  output$mds_obs <- renderPlot({
    plot(cmd)
    text(cmd, labels = rownames(fifa_num_data[,1:13]))
  })
  # MDS end
  
  # PCA start
  output$pca_summary <- renderPrint({
    summary(pc, loadings= T, cut = 0.2)
  })
  
  output$pca_2dplot <- renderPlot({
    pca2d(pc, group=gr, biplot=TRUE, legend="bottomleft", 
          show.labels = ifelse(row(fifa_num_data) %in% out_players, rownames(fifa_num_data),''), 
          axe.titles = c("Game Skills", "Popularity"))
  })
  
  # output$wdg_pca_3dplot <- renderRglwidget({
  #   pca3d <- pca3d(pc, group=gr, biplot=TRUE, show.shadows = FALSE, 
  #         show.labels = ifelse(row(fifa_num_data) %in% out_players, 
  #                              rownames(fifa_num_data),''), 
  #         axe.titles = c("Game Skills", "Popularity", "Experience"))
  #   rglwidget(pca3d)
  # })
  
  # scenegen <- reactive({
  #   # make a random scene
  #   input$regen
  #   pca3d <- pca3d(pc, group=gr, biplot=TRUE, show.shadows = FALSE,
  #                  show.labels = ifelse(row(fifa_num_data) %in% out_players,
  #                                       rownames(fifa_num_data),''),
  #                  axe.titles = c("Game Skills", "Popularity", "Experience"))
  #   scene1 <- scene3d()
  #   rgl.close() # make the app window go away
  #   return(scene1)
  # })
  
  # output$pca_3dplot <- renderPlot({ 
  #   pca3d(pc, group=gr, biplot=TRUE, show.shadows = FALSE,
  #                  show.labels = ifelse(row(fifa_num_data) %in% out_players,
  #                                       rownames(fifa_num_data),''),
  #                  axe.titles = c("Game Skills", "Popularity", "Experience"))
  # #rglwidget()
  # })
  
  # output$pca_3dplot <- renderRglwidget({
  #     pca3d <- pca3d(pc, group=gr, biplot=TRUE, show.shadows = FALSE,
  #           show.labels = ifelse(row(fifa_num_data) %in% out_players,
  #                                rownames(fifa_num_data),''),
  #           axe.titles = c("Game Skills", "Popularity", "Experience"))
  #     rglwidget(elementId = "plot3drgl")
  # })
  
  output$pca_3dboxplot <- renderRglwidget({
    plot3d(scores[,1:3], col=c(1:14), pch = 18, cex = 2, xlab = "Game Skills", 
           ylab = "Popularity", zlab = "Experience",
           xlim = c(-10,30), ylim=c(-10,30), zlim=c(-10,30), 
           show.labels = ifelse(row(fifa_num_data) %in% out_players, rownames(fifa_num_data),''),
           axe.titles = c("Game Skills", "Popularity", "Experience"))
    text3d(scores[,1], scores[,2], scores[,3],
           texts=ifelse(fifa_num_data$Overall > 89,rownames(scores),''), cex= 0.7, pos=3)
    
    # f <-  function(time) {
    #   for (i in 1:360) {
    #     view3d(userMatrix=rotationMatrix(time * i/360, 0, 1, 0))
    #   }
    # }
    # play3d(f, duration = 0.5)
    rglwidget()
    # for (i in 1:360) {
    #   view3d(userMatrix=rotationMatrix(pi * i/360, 0, 1, 0))
    # }
  })
  
  # output$pca_viewcube <- renderCubeView({
  #   open3d()
  #   plot3d(scores[,1:3], col=c(1:14), pch = 18, cex = 2, xlab = "Game Skills", 
  #          ylab = "Popularity", zlab = "Experience",
  #          xlim = c(-10,30), ylim=c(-10,30), zlim=c(-10,30), 
  #          show.labels = ifelse(row(fifa_num_data) %in% out_players, rownames(fifa_num_data),''),
  #          axe.titles = c("Game Skills", "Popularity", "Experience"))
  #   text3d(scores[,1], scores[,2], scores[,3],
  #          texts=ifelse(fifa_num_data$Overall > 89,rownames(scores),''), cex= 0.7, pos=3)
  #   for (i in 1:360) {
  #     view3d(userMatrix=rotationMatrix(1*pi * i/360, 0, 1, 0))
  #   }
  #   rglwidget()
  # })
  # PCA end
  
  # CCA start
  output$X_plot <- renderPlot({
    ggpairs(X)
  })
  
  output$Y_plot <- renderPlot({
    ggpairs(Y)
  })
  
  output$mat_corr_summary <- renderPrint({
    print(mat_corr)
    # print('Management Perspective: ')
    # print(cca_fifa$xcoef)
    # print('Coach Perspective: ')
    # print(cca_fifa$ycoef)
    # print('Cannonical correlation between the two: ')
    # print(corr)
  })
  
  output$cca_corr_summary <- renderPrint({
    print(cca_cor)
  })
  # CCA end
  
  # Cluster Analysis Start
  output$ebtest_plot <- renderPlot({
    plot.wgss(fifa_num_data, 20)
  })
  
  output$true_plot <- renderPlot({
    plot(fifa_num_data_scaled, col = fifa_num_data$overall_break, main = "True Clustering based on Overall")
    text(fifa_num_data_scaled, labels = ifelse(row(fifa_num_data_scaled) %in% out_players, 
                                               rownames(fifa_num_data_scaled),''), cex = 0.6)
  })
  
  output$hc_plot <- renderPlot({
    plot(fifa_num_data_scaled, col = ct_fifa, main = "HC Complete")
    text(fifa_num_data_scaled, 
         labels = ifelse(row(fifa_num_data_scaled) %in% out_players, 
                                               rownames(fifa_num_data_scaled),''), cex = 0.6)
  })
  
  output$km_plot <- renderPlot({
    plot(fifa_num_data_scaled, col = km_clust, main = "KMeans")
    text(fifa_num_data_scaled, 
         labels = ifelse(row(fifa_num_data_scaled) %in% out_players, 
                         rownames(fifa_num_data_scaled),''), cex = 0.6)
  })
  
  output$mbc_plot <- renderPlot({
    plot(fifa_num_data_scaled, col = mc_clust, main = "MBClust 3 Clusters")
    text(fifa_num_data_scaled, 
         labels = ifelse(row(fifa_num_data_scaled) %in% out_players, 
                                               rownames(fifa_num_data_scaled),''), cex = 0.6)
  })
  
  # Cluster Analysis end
  
  # Factor Analysis Start
  output$efa_text <- renderPrint({
    print(fa_fifa$loadings, cut = 0.50)
  })
  
  output$cfa_text <- renderPrint({
    summary(fifa_sem, fit.measures = TRUE)
  })
  
  output$cfa_plot <- renderPlot({
    semPaths(fifa_sem, rotation = 2, 'std', 'est')
  })
  # Factor Analysis end
  
})
