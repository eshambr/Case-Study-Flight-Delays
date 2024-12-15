# Load necessary libraries for data manipulation, visualization, and modeling
library(reshape)      # For data reshaping
library(ggplot2)      # For creating visualizations
library(gains)        # For creating gains charts
library(caret)        # For modeling and evaluating performance

# Load the flight delays dataset into a data frame
delays.df <- read.csv("FlightDelays.csv")

# Create a barplot to visualize average flight delays by weekday
# Aggregate the delays by weekday and calculate the average delay
# "Flight.Status == 'delayed'" creates a logical TRUE/FALSE column for delays
average_delay <- aggregate(delays.df$Flight.Status == "delayed", 
                           by = list(delays.df$DAY_WEEK), 
                           mean, rm.na = TRUE)

# Plot the average delays for each weekday as a barplot
barplot(average_delay[,2], 
        xlab = "Day of Week", ylab = "Average Delay", 
        names.arg = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"))

# Create a heatmap to visualize delays by carrier, weekday, and origin
# Aggregate delays based on weekday, carrier, and origin airport
agg <- aggregate(delays.df$Flight.Status == "delayed", 
                 by = list(delays.df$DAY_WEEK, delays.df$CARRIER, delays.df$ORIGIN), 
                 FUN = mean, na.rm = TRUE)

# Rename columns for better readability
names(agg) <- c("DAY_WEEK", "CARRIER", "ORIGIN", "value")

# Create a heatmap to visualize the delays
ggplot(agg, aes(y = CARRIER, x = DAY_WEEK, fill = value)) +  # x: weekdays, y: carriers
  geom_tile() +  # Create the heatmap using tiles
  facet_grid(ORIGIN ~ ., scales = "free", space = "free") +  # Facet by origin airport
  scale_fill_gradient(low = "white", high = "Red") +  # Gradient color for delays
  labs(title = "Heatmap of Flight Delays by Carrier and Weekday", 
       x = "Day of Week", y = "Carrier")

# Data preprocessing for logistic regression modeling
# Convert DAY_WEEK into a factor with meaningful labels (Mon-Sun)
delays.df$DAY_WEEK <- factor(delays.df$DAY_WEEK, levels = c(1:7), 
                             labels = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"))

# Round departure times to the nearest hour and convert into factor
delays.df$CRS_DEP_TIME <- factor(round(delays.df$CRS_DEP_TIME / 100))

# Relevel categorical variables to set meaningful reference levels for modeling
delays.df$ORIGIN <- relevel(as.factor(delays.df$ORIGIN), ref = "IAD")  # Reference: IAD
delays.df$DEST <- relevel(as.factor(delays.df$DEST), ref = "LGA")      # Reference: LGA
delays.df$CARRIER <- relevel(as.factor(delays.df$CARRIER), ref = "US") # Reference: US
delays.df$DAY_WEEK <- relevel(as.factor(delays.df$DAY_WEEK), ref = "Wed") # Reference: Wed

# Create a binary target variable 'isDelay' (1 = delayed, 0 = on-time)
delays.df$isDelay <- 1 * (delays.df$Flight.Status == "delayed")

# Split the data into training and validation sets
# Select the columns to be used for modeling
selected.var <- c(10, 1, 8, 4, 2, 9, 14)  # Columns selected for training

# Create a 60% training and 40% validation split
train.index <- sample(c(1:dim(delays.df)[1]), dim(delays.df)[1]*0.6)

# Subset the data for training and validation sets
train.df <- delays.df[train.index, selected.var]  # Training data
valid.df <- delays.df[-train.index, selected.var]  # Validation data

# Train a logistic regression model
# Fit a logistic regression model using the training data
lm.fit <- glm(isDelay ~ ., data = train.df, family = "binomial")

# Display the summary of model coefficients and calculate odds ratios
data.frame(summary(lm.fit)$coefficients, odds = exp(coef(lm.fit)))

# Evaluate model performance using a gains chart
# Predict probabilities of delays for the validation dataset
pred <- predict(lm.fit, valid.df)

# Create a gains chart to evaluate model performance
gain <- gains(as.numeric(valid.df$isDelay), pred, groups = 100)

# Plot the cumulative gains curve
plot(c(0, gain$cume.pct.of.total * sum(valid.df$isDelay)) ~ c(0, gain$cume.obs), 
     xlab = "# cases", ylab = "Cumulative", main = "", type = "l")
lines(c(0, sum(valid.df$isDelay)) ~ c(0, dim(valid.df)[1]), lty = 2)  # Baseline line

# Generate confusion matrix and evaluate metrics
# Convert probabilities into class labels using a threshold of 0.5
pred.class <- ifelse(pred > 0.5, 1, 0)
pred.class <- factor(pred.class, levels = c(1,0), labels = c("delayed", "ontime"))

# Convert actual delay values into a factor
valid.class <- factor(valid.df$isDelay, levels = c(1,0), labels = c("delayed", "ontime"))

# Generate the confusion matrix to assess performance
confusionMatrix(pred.class, valid.class)


