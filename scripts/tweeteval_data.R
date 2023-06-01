library(stringi)
library(tidyverse)

get_data <- function(dataset) {
  map_labels = get_mapping_function(dataset)
  test = data.frame(
    type = 'test',
    text = get_text(dataset, "test"),
    label = get_labels(dataset, "test") |> map_labels()
  )
  train = data.frame(
    type='train',
    text = get_text(dataset, "train"),
    label = get_labels(dataset, "train") |> map_labels()

  )
  val = data.frame(
    type = 'val',
    text = get_text(dataset, "val"),
    label = get_labels(dataset, "val") |> map_labels()
  )
  rbind(train, test, val)
}

read_data <- function(dataset, filename) {
  dataset_url = paste0('https://raw.githubusercontent.com/cardiffnlp/tweeteval/main/datasets/', dataset)
  readLines(paste0(dataset_url, '/', filename, '.txt'))
}

get_mapping_function <- function(dataset) {
  mapping = read_data(dataset, 'mapping')
  labels = stri_split_fixed(mapping, '\t')
  mapping = data.frame(id = as.numeric(sapply(labels, `[[`, 1)),
                       label = as.character(sapply(labels, `[[`, 2)))
  function(ids) {
    indices = match(ids, mapping$id)
    mapping$label[indices]
  }
}

get_text <- function(dataset, split) {
  filename = paste0(split, '_text')
  as.character(read_data(dataset, filename))
}

get_labels <- function(dataset, split) {
  filename = paste0(split, '_labels')
  as.numeric(read_data(dataset, filename))
}

for (dataset in c('sentiment','emotion','hate','offensive')) {
  message(dataset)
  get_data(dataset) %>%
    as_tibble() %>%
    select(text, label) %>%
    write_csv(sprintf('data/%s_tweets.csv', dataset))
}
