library(tidyverse)
library(chartmusicdata)
library(tsibble)

bands <- filter(songs2000, artist == "Drake") %>% 
  mutate(yearmonth = tsibble::yearmonth(year_month))

# song <- input$song
song <- filter(bands, song == "God's Plan")

ggplot(bands, aes(x = year_month, y = indicativerevenue)) +
  geom_point(size = 1.5, color = "darkgrey") +
  geom_point(data = song, size = 2.5, color = "darkblue") +
  labs(title = "Songs by Drake",
       subtitle = "Highlighted: God's Plan",
       x = "Month and Year",
       y = "Indicative Revenue in USD") +
  scale_x_discrete(labels = function(x) {
    x <- sort(unique(x))
    x[seq(2, length(x), 2)] <- ""
    x
  }) +
  scale_y_continuous(labels = scales::label_dollar(scale = 1000)) +
  theme_bw(base_size = 14) +
  theme(axis.text.x = element_text(angle = 90))
