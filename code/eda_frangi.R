library(ggplot2)
library(purrr)
library(scales)
library(dplyr)

df <- read.csv('frangi_quantiles.csv')
df %>% 
  ggplot(aes(x = percentile, y = value, group = sub, color = sub)) +
  geom_line(alpha = 0.3) + 
  theme_bw() + 
  theme(legend.position = "none") +
  scale_x_continuous(breaks = seq(0,100, 10)) + 
  scale_y_continuous(minor_breaks = seq(0, 350, 10)) +
  ggtitle("Quantile distribution of frangi filters in CAVS data")

df %>% 
  split(df$sub) %>% 
  map(~ mutate(.x, value = scales::rescale_max(value))) %>% 
  bind_rows() %>% 
  ggplot(aes(x = percentile, y = value, group = sub, color = sub)) +
  geom_line(alpha = 0.1) + 
  theme_bw() + 
  theme(legend.position = "none") +
  scale_x_continuous(breaks = seq(0,100, 10)) + 
  scale_y_continuous(breaks = seq(0, 1, .1)) +
  ggtitle("Quantile distribution of frangi filters in CAVS data (rescaled)")
  
  
