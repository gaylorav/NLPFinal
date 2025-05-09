#installing + loading relevant packages
install.packages("tidyverse")
install.packages("ggtext")
install.packages("gt")
install.packages("wordcloud2")
install.packages("webshot")
webshot::install_phantomjs()
install.packages("showtext")

library(showtext)
library(tidyverse)
library(ggtext)
library(gt)
library(wordcloud2)
library(webshot)
library(htmlwidgets)

#may need to change the file path if you downloaded this code
file_path <- file.path("C:/Users/aidan/Documents/NaturalLanguageProcessing/NLPFinal")
setwd(file_path)

#reading in data
data <- read_csv("bg_descriptions.csv")

data |> head()

word_counts <- read_csv("bg_word_counts.csv")

word_counts |> head()

cloud <- wordcloud2(word_counts, size = 2,
           backgroundColor = "#faf0c8",
           color=rep_len( c("#db1548", "#071df4", "#f0cc00", "#f57135",  "#40d74f"), nrow(word_counts) ),
           minRotation = -pi/6, maxRotation = -pi/6, rotateRatio = 1,
           widgetsize = c(700, 1000))
cloud
saveWidget(cloud,"wordcloud.html",selfcontained = F)

pos_word_counts <- read_csv("bg_word_counts_pos.csv")
neg_word_counts <- read_csv("bg_word_counts_neg.csv")

pos_cloud <- wordcloud2(pos_word_counts, size = 2,
                        backgroundColor = "#faf0c8",
                        color=rep_len( c("#db1548", "#071df4", "#f0cc00", "#f57135",  "#40d74f"), nrow(word_counts) ),
                        minRotation = -pi/6, maxRotation = -pi/6, rotateRatio = 1,
                        widgetsize = c(700, 1000))

pos_cloud
saveWidget(pos_cloud,"pos_wordcloud.html",selfcontained = F)

neg_cloud <- wordcloud2(neg_word_counts, size = 2,
                        backgroundColor = "#faf0c8",
                        color=rep_len( c("#db1548", "#071df4", "#f0cc00", "#f57135",  "#40d74f"), nrow(word_counts) ),
                        minRotation = -pi/6, maxRotation = -pi/6, rotateRatio = 1,
                        widgetsize = c(700, 1000))

neg_cloud
saveWidget(neg_cloud,"neg_wordcloud.html",selfcontained = F)

smodel_metrics <- tibble(
  Model = c("LR", "NB", "RNN", "BERT"),
  precision = c(0.42, 0.44, 0.52, 0.56),
  recall = c(0.34, 0.41, 0.05, 0.54),
  accuracy = c(0.56, 0.55, 0.46, 0.62),
  `f1 score` = c(0.26, 0.40, 0.09, 0.62)
)

long_metrics <- model_metrics |>
  pivot_longer(cols = -Model, names_to = "metric", values_to = "value")

metric_ranges <- long_metrics |>
  group_by(metric) %>%
  summarise(ymin = min(value), ymax = max(value), .groups = "drop")

# Plot

font_add_google("Heebo", "Heebo")
showtext_auto()

ggplot() +
  # Line between min and max per metric
  geom_segment(data = metric_ranges,
               aes(x = metric, xend = metric, y = ymin, yend = ymax),
               color = "grey60", linewidth = 0.5) +
  # Points for each model
  geom_point(data = long_metrics,
             aes(x = metric, y = value, color = Model),
             size = 4) +
  scale_color_manual(values = c(
    "LR" = "#40d74f",
    "NB" = "#f57135",
    "RNN" = "#071df4",
    "BERT" = "#db1548"
  )) +
  coord_flip() +
  labs(x = NULL, y = NULL, title = "Model Performance by Metric") +
  theme(
    plot.background = element_rect(fill = "#ffffff"),
    plot.title = element_text(size = 18, family = "Heebo", color = "#292929"),
    axis.text.x = element_text(size = 14, vjust = -1, family = "Heebo", color = "#292929"),
    axis.text.y = element_text(size = 16, family = "Heebo", color = "#292929"),
    panel.background = element_blank(),  # Remove panel background
    panel.grid = element_blank(), 
    axis.line = element_line(color = "#292929"),  # Add axis lines (optional)
    legend.title = element_text(size = 18, family = "Heebo", color = "#292929"),
    legend.text = element_text(size = 14, family = "Heebo", color = "#292929"),
    legend.background = element_blank(),
    legend.position = c(1.2, .9),
    plot.margin = margin(t = 30, r = 120, b = 30, l = 30)
  )

metric_plot <- ggplot(long_metrics, aes(x = metric, y = value, fill = Model)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2)) +
  labs(title = "Model Comparison Across Metrics",
       y = "Score",
       x = "Metric") +
  scale_fill_manual(values = c(
    "LR" = "#40d74f",
    "NB" = "#f57135",
    "RNN" = "#071df4",
    "BERT" = "#db1548"
  )) +
  labs(x = NULL, y = "Score", title = "Model Comparison by Metric") +
  theme(
    plot.background = element_rect(fill = "#ffffff"),
    plot.title = element_text(size = 18, family = "Heebo", color = "#292929", hjust = 0.5),
    axis.title.y = element_text(size = 18, family = "Heebo", color = "#292929", vjust = 4),
    axis.text.x = element_text(size = 16, vjust = -1, family = "Heebo", color = "#292929"),
    axis.text.y = element_text(size = 16, family = "Heebo", color = "#292929"),
    panel.background = element_blank(),  # Remove panel background
    panel.grid = element_blank(), 
    axis.line = element_line(color = "#292929"),  # Add axis lines (optional)
    legend.title = element_text(size = 18, family = "Heebo", color = "#292929"),
    legend.text = element_text(size = 14, family = "Heebo", color = "#292929"),
    legend.background = element_blank(),
    legend.position = c(1.2, .9),
    plot.margin = margin(t = 30, r = 120, b = 30, l = 30)
  )

metric_plot

tb_model_metrics <- tibble(
  Model = c("Logistic Regression", "Naive Bayes", "Recurrent Neural Network", "BERT"),
  precision = c(0.42, 0.44, 0.52, 0.56),
  recall = c(0.34, 0.41, 0.05, 0.54),
  accuracy = c(0.56, 0.55, 0.46, 0.62),
  `f1 score` = c(0.26, 0.40, 0.09, 0.62)
) |> arrange(desc(accuracy))

tb_accur <- tibble(
  baseline = c("Stratified Baseline", "Majority Baseline", "BERT", "Logistic Regression", "Naive Bayes", "Recurrent Neural Network"),
  accuracy = c(0.09, 0.57, 0.62, 0.56, 0.55, 0.46),
)

accur_table <- tb_accur |> gt() |>
  tab_header(
    title = md("Accuracy by Model/Baseline"),
  ) |>
  cols_label(
    baseline = md("**Method**"),
    accuracy = md("**Accuracy**")
  )

accur_table

metric_table <- tb_model_metrics |> gt() |>
  tab_header(
    title = md("Classification Performance Metrics by Model"),
    subtitle = md("*Models ordered in descending accuracy*")
  ) |>
  cols_label(
    Model = md("**Model**"),
    precision = md("**Precision**"),
    recall = md("**Recall**"),
    `f1 score` = md("**F1-Score**"),
    accuracy = md("**Accuracy**")
  )

metric_table

ggsave("plot.png", plot = metric_plot, width = 8, height = 6)
gtsave(metric_table, "table1.png")
gtsave(accur_table, "table2.png")
