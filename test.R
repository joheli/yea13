library(igraph)
library(dplyr)
library(ggraph)

set.seed(321)

# helper function to exclude non-unique links
sl <- function(a, b) {
  v <- c(a, b)
  s <- sort(v)
  paste(s, collapse = "")
}

nodes <- letters[1:6]
edges0 <- data.frame(from = sample(nodes, 30, TRUE), to = sample(nodes, 30, TRUE)) %>%
  rowwise() %>%
  mutate(link = sl(from, to)) %>% # exclude non-unique links
  filter(to != from) %>% # exclude links to self
  mutate(weight = runif(n = 1, min = 0, max = 10000))

edges1 <- edges0
edges1$dupllink <- duplicated(edges1$link)

edges <- filter(edges1, !dupllink) %>%
  select(from, to, weight) %>%
  arrange(from, to, weight)

rm(edges0, edges1)

gr <- graph_from_data_frame(edges, directed = FALSE, vertices = nodes)

gr.tidy <- tidygraph::as_tbl_graph(gr)

p.gr <- ggraph(gr.tidy, layout = "graphopt") +
  geom_edge_link(aes(width = weight), alpha = .3) + 
  scale_edge_alpha(range = c(0.1,1)) +
  geom_node_point(size = 5) + 
  geom_node_text(aes(label = name), repel = T, size = 10) +
  theme_graph()

print(p.gr)
