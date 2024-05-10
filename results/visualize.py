import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Read the CSV files
df1 = pd.read_csv('hummingbird.csv')
df2 = pd.read_csv('vapor.csv')

# Extracting data for plotting
hb_no_coldstart = df1[df1['coldStart'] == 0]['avgDuration']
hb_coldstart = df1[df1['coldStart'] == 1]['avgDuration']
vapor_no_coldstart = df2[df2['coldStart'] == 0]['avgDuration']
vapor_coldstart = df2[df2['coldStart'] == 1]['avgDuration']

# Plotting
plt.figure(figsize=(10, 6))

bar_width = 0.2
index = np.arange(len(hb_no_coldstart))

plt.bar(index, hb_no_coldstart, bar_width, label='Hummingbird, No Cold Start', color='skyblue', edgecolor='black', alpha=0.8)
plt.bar(index + bar_width, hb_coldstart, bar_width, label='Hummingbird, Cold Start', color='lightgreen', edgecolor='black', alpha=0.8)
plt.bar(index + 2*bar_width, vapor_no_coldstart, bar_width, label='Vapor, No Cold Start', color='salmon', edgecolor='black', alpha=0.8)
plt.bar(index + 3*bar_width, vapor_coldstart, bar_width, label='Vapor, Cold Start', color='orange', edgecolor='black', alpha=0.8)

plt.xlabel('Lambda')
plt.ylabel('avgDuration')
plt.title('Comparison of avgDuration with and without Cold Start')
plt.xticks(index + 1.5*bar_width, index)
plt.legend(loc='upper left')

# Add grid lines
plt.grid(axis='y', linestyle='--', alpha=0.7)

# Add value labels
for i in range(len(index)):
    plt.text(index[i] - 0.05, hb_no_coldstart.values[i] + 10, str(round(hb_no_coldstart.values[i], 2)), fontsize=8, color='black')
    plt.text(index[i] + bar_width - 0.05, hb_coldstart.values[i] + 10, str(round(hb_coldstart.values[i], 2)), fontsize=8, color='black')
    plt.text(index[i] + 2*bar_width - 0.05, vapor_no_coldstart.values[i] + 10, str(round(vapor_no_coldstart.values[i], 2)), fontsize=8, color='black')
    plt.text(index[i] + 3*bar_width - 0.05, vapor_coldstart.values[i] + 10, str(round(vapor_coldstart.values[i], 2)), fontsize=8, color='black')

plt.tight_layout()
plt.show()
