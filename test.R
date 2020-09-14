library(igraph)
library(dplyr)
library(ggraph)
library(tidygraph)
library(NetOrigin)

# set seed using R version 4.0.2 (2020-06-22)
set.seed(321)

# helper function to exclude non-unique links, see below
sl <- function(a, b) {
  v <- c(a, b)
  s <- sort(v)
  paste(s, collapse = "")
}

# create an undirected graph with random edges and weights
nodes <- letters[1:6]
edges0 <- data.frame(from = sample(nodes, 30, TRUE), to = sample(nodes, 30, TRUE)) %>%
  rowwise() %>%
  mutate(link = sl(from, to)) %>% # exclude non-unique links using function 'sl' (see above)
  filter(to != from) %>% # exclude links to self
  mutate(weight = runif(n = 1))

edges1 <- edges0
edges1$dupllink <- duplicated(edges1$link)

edges <- filter(edges1, !dupllink) %>%
  select(from, to, weight) %>%
  arrange(from, to, weight)

# housekeeping
rm(edges0, edges1)

#############################

# gr is an undirected graph
gr <- igraph::graph_from_data_frame(edges, directed = FALSE, vertices = nodes)

# for plotting use tidygraph
gr.tidy <- tidygraph::as_tbl_graph(gr)

# create a ggraph object
p.gr <- ggraph(gr.tidy, layout = "graphopt") +
  # geom_edge_link(aes(width = weight), alpha = .2, lineend = "round") + 
  geom_edge_link(aes(width = weight, alpha = weight), lineend = "round", color = "red") + 
  scale_edge_width(range = c(0.1, 12)) +
  scale_edge_alpha(range = c(.05, .4)) +
  geom_node_point(size = 5) + 
  geom_node_text(aes(label = name), repel = T, size = 10, color = "darkgreen") +
  theme_graph()

# print on screen
print(p.gr)

##############################

# Prepare calculation of effective distance
amx <- igraph::as_adjacency_matrix(gr, attr = "weight", sparse = T) %>% as.matrix
# Calculate transition probability - this is where I am lost, because a direction is introduced:
p <- amx/rowSums(amx)
# Calculate effective distances
ed <- NetOrigin::eff_dist(p)


