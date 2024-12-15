## **Flight Delay Prediction Using Logistic Regression**

![image](https://github.com/user-attachments/assets/156974b8-f9ff-4acc-9f2d-4f634da83d28)


### **Project Overview**
This project involves building a logistic regression model to predict flight delays based on a given dataset. The dataset contains flight information such as origin, destination, carrier, departure time, and day of the week. The objective is to evaluate the model's ability to classify flights as **"delayed"** or **"ontime"**.

The performance metrics and confusion matrix reveal key insights about the model's strengths and weaknesses, especially in handling **imbalanced datasets**.

---

### **Dataset**
- **Source**: `FlightDelays.csv`
- **Target Variable**: `Flight.Status`  
   - *delayed* → Positive Class  
   - *ontime* → Negative Class
- **Features**:  
   - `DAY_WEEK` (Day of the week)  
   - `CRS_DEP_TIME` (Scheduled departure time)  
   - `ORIGIN` (Origin airport)  
   - `DEST` (Destination airport)  
   - `CARRIER` (Airline carrier)

---

### **Steps and Methodology**
1. **Data Exploration and Visualization**  
   - Barplot of average delays by weekday.  
   - Heatmap of delays by carrier, weekday, and origin airport.  

2. **Data Preprocessing**  
   - Factorization of categorical variables (`DAY_WEEK`, `ORIGIN`, `DEST`, `CARRIER`).  
   - Conversion of `CRS_DEP_TIME` to a rounded factor.  
   - Creation of a binary target variable (`isDelay` → 1 for "delayed," 0 for "ontime").  

3. **Data Splitting**  
   - 60% of the data was used for **training**, and 40% was used for **validation**.

4. **Logistic Regression Model**  
   - Model built using `glm()` with the **binomial family**.  
   - Coefficients and **odds ratios** were examined for interpretation.

5. **Model Evaluation**  
   - **Confusion Matrix** and related metrics were used to assess performance.  
   - A **Gains Chart** was plotted to evaluate the model’s ability to identify delays.

---

### **Results**

#### **Confusion Matrix**
|                   | **Actual: delayed** | **Actual: ontime** |
|-------------------|--------------------|-------------------|
| **Predicted: delayed** | 11                 | 0                 |
| **Predicted: ontime**  | 161                | 709               |

#### **Key Metrics**
- **Accuracy**: 81.73%  
   - 95% CI: (79.01%, 84.22%)  
   - Accuracy is only marginally better than **No Information Rate (NIR)** of 80.48%.  
- **Kappa**: 0.0991 → Indicates poor agreement beyond chance.  

#### **Sensitivity and Specificity**
- **Sensitivity (Recall)** for "delayed": 6.40% → Poor at identifying delayed flights.  
- **Specificity**: 100% → Perfect at predicting "ontime" flights.

#### **Precision**
- **Positive Predictive Value (Precision)**: 100% → All predicted "delayed" cases were correct, but very few were predicted.  
- **Negative Predictive Value**: 81.5% → Among all "ontime" predictions, 81.5% were correct.

#### **Balanced Accuracy**
- Balanced Accuracy: **53.20%** → Reflects the model's struggle with class imbalance.

---

### **Insights**
1. The model achieves **high specificity** (100%) but fails to detect the minority class "delayed" (Sensitivity = 6.40%).  
2. The **imbalanced dataset** causes the model to favor the majority class ("ontime").  
3. **Balanced Accuracy** of ~53% indicates poor overall performance.  
4. The model’s accuracy is not statistically significant compared to the baseline (NIR).

---

### **Recommendations**
To improve the model’s performance:  
- **Resampling Techniques**:  
   - Oversample the minority class (delayed) or undersample the majority class.  
- **Alternative Models**:  
   - Use decision trees, random forests, or ensemble methods that handle imbalanced data better.  
- **Feature Engineering**:  
   - Create additional features such as weather, seasonality, or flight duration.

---

### **Files in Repository**
1. `FlightDelays.csv` → Dataset used for training and testing.  
2. `Case Study Flight Delays.R` → Complete R script for data preprocessing, visualization, modeling, and evaluation.  
3. `README.md` → Project documentation (this file).

---

### **How to Run**
1. Clone the repository to your local system:
   ```bash
   git clone https://github.com/yourusername/FlightDelayPrediction.git
   ```
2. Open `Case Study Flight Delays.R` in RStudio or any R IDE.  
3. Install required libraries using the following commands:
   ```r
   install.packages(c("reshape", "ggplot2", "gains", "caret"))
   ```
4. Run the script step by step to reproduce the analysis.

---

### **Conclusion**
The logistic regression model provides insights into flight delays but struggles with the imbalanced dataset. Future enhancements using resampling or alternative algorithms are recommended to improve its ability to predict "delayed" flights.
