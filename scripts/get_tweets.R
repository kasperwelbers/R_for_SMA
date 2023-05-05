library(tidyverse)
library(academictwitteR)

query = 'rstats'

tweets = get_all_tweets(
  query = query,
  start_tweets = '2023-01-01T00:00:00Z',
  end_tweets = '2023-05-05T00:00:00Z',
  data_path= paste0('data/', query),
  lang='en',
  n=50000,
  is_retweet = FALSE,
)

library(tidyverse)
tweets %>%
  tibble() %>%
  mutate(retweets = public_metrics$retweet_count,
         replies = public_metrics$reply_count,
         likes = public_metrics$like_count,
         impressions = public_metrics$impression_count) %>%
  select(id, created_at, author_id, text, author_id, retweets, replies, likes, impressions, possibly_sensitive) %>%
  write_csv(file=paste0('data/tweets_', query, '.csv'))

#d = academictwitteR::bind_tweets('data/coronation')

