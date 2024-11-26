# Example data for testing
set.seed(123)
students_data <- data.frame(
  ID = seq(1, 100),
  Age = rnorm(100, mean = 20, sd = 2),
  Score = rnorm(100, mean = 75, sd = 10),
  Subject = sample(c("Math", "English", "Science"), 100, replace = TRUE),
  Gender = sample(c("Male", "Female"), 100, replace = TRUE)
)

# Load the ggplot2 library
library(ggplot2)

# Example ggplot code
gg_point <- ggplot(students_data, aes(x = Age, y = Score, color = Subject, shape = Subject)) +
  geom_point(size = 3, alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE, linetype = "dashed") +
  labs(
    title = "Student Performance",
    x = "Age",
    y = "Score",
    color = "School \n subject",
    shape = "School \n subject" #if changing legend for colour, also need to change shape otherwise will get one legend for shape & 1 for colour
  ) +
  scale_x_continuous(breaks = 20, expand = expansion()) + #custom breaks, expand argument provides some padding around the data
  # coord_flip() + #to flip the axis
  theme_minimal()

# Display the plot
print(gg_point)

?legend_title()
# Requires categorical variables, however age and score are continuous from students_data
# Can visualise the counts of observations for a categorical variables e.g. Subject
gg_bar <- ggplot(students_data, aes(x = Subject, fill = Gender)) +
  geom_bar(color = "blue") + #Bars filled by gender, outlined in blue
  theme_minimal()

# facet_grid() divides plot into into a matrix of panels from two discrete variables
# facet_grid(A ~ B) >> facet by A (rows) and B (columns).
# facet_grid(A ~ .) >> facet by A for rows only.
# facet_grid(. ~ B) >> facet by B for columns only.
gg_point_facet <- ggplot(students_data, aes(x = Age, y = Score, color = Subject)) +
  geom_point() +
  facet_grid(Gender ~ Subject) +  # Row: Gender, Column: Subject
  theme(legend.background = element_rect(fill = "yellow")) +
  labs( x = "Age (years)", y = "Raw score")

# Need to summarise the data to display error bars
# Summarise subject and gender data
student_summary <- students_data %>%
  group_by(Subject, Gender) %>%
  summarise(
    count = n(),        # Count of observations
    se = sqrt(count)    # Example: Standard error for counts
  )

#plot with error bars
gg_bar_summary <- ggplot(student_summary, aes(x = Subject, y = count, fill = Gender)) +
  geom_bar(stat = "identity", # stat = "identity" to use pre-summarized data
           color = "blue",
           position = position_dodge(0.9),
           na.rm = TRUE,
           inherit.aes = FALSE, #will NOT inherited aesthetic mappings from aes
           aes(x = Subject, y = count, fill = Gender)) + #thus need to specify where to get x and y. This is actually the same as the current setting in aes however displayed for illustrated purposes
  geom_errorbar(
    aes(ymin = count - se, ymax = count + se),
    width = 0.2,
    position = position_dodge(0.9)  # Align error bars with bars
  ) +
  # scale_y_log10() + #transpose y to log
  scale_fill_manual(values = c("Male" = "yellow", "Female" = "purple")) +
  theme_void() + #removes background elements for a minimalist plot
  theme(axis.text = element_text(size = 15))

gg_bar_summary

#To combine two data frames, the aes() need to align with the columns in the respective data frames
df1 <- data.frame(time = c(1, 2, 3), value = c(10, 20, 30), group = "df1")
df2 <- data.frame(time = c(1, 2, 3), value = c(15, 25, 35), group = "df2")

ggplot() +
  geom_line(data = df1, aes(x = time, y = value, color = group, linetype = group)) +
  geom_line(data = df2, aes(x = time, y = value, color = group, linetype = group)) +
  labs(title = "Comparing Two Data Frames", x = "Time", y = "Value") +
  theme(legend.position = "bottom")

#step plot
ggplot() +
  geom_step(data = df1, aes(x = time, y = value, color = group, linetype = group), direction = "mid") + #alternate directions vh or hv
  geom_step(data = df2, aes(x = time, y = value, color = group, linetype = group), direction = "mid") +
  labs(title = "Comparing Two Data Frames with Step Plot", x = "Time", y = "Value") +
  theme(legend.position = "bottom")
