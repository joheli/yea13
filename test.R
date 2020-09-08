library(igraph)
library(dplyr)

set.seed(123)

# helper function to exclude non-unique links
sl <- function(a, b) {
  v <- c(a, b)
  s <- sort(v)
  paste(s, collapse = "")
}

nodes <- letters[1:10]
edges0 <- data.frame(from = sample(nodes, 30, TRUE), to = sample(nodes, 30, TRUE)) %>%
  rowwise() %>%
  mutate(link = sl(from, to)) %>% # exclude non-unique links
  filter(to != from) %>% # exclude links to self
  mutate(weight = runif(1))

edges1 <- edges0
edges1$dupllink <- duplicated(edges1$link)

edges <- filter(edges1, !dupllink) %>%
  select(from, to, weight)

rm(edges0, edges1)

gr <- graph_from_data_frame(edges, directed = FALSE, vertices = nodes)

plot(gr)
