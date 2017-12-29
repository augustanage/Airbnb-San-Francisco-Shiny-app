#SFmap <- read_csv("~/Documents/*5500 Data Visualization/Assignment4/shiny SF airbnb/SFmap.csv")
summary(SFmap)

#SFmap %>% select(neighbourhood_cleansed,review_scores_rating) %>%
#  filter(review_scores_rating!="NA") %>%
#  group_by(neighbourhood_cleansed) %>%
#  summarise(min_review=min(review_scores_rating), avg_review=mean(review_scores_rating), 
#            median_review=median(review_scores_rating),max_review=max(review_scores_rating))
a<-SFmap %>% select(neighbourhood_cleansed, review_scores_rating) %>%
  filter(review_scores_rating!="NA") %>%
  group_by(neighbourhood_cleansed) %>%
  summarise(avg_review=mean(review_scores_rating)) %>%
  arrange(desc(avg_review))

write_csv(a,"review.csv")