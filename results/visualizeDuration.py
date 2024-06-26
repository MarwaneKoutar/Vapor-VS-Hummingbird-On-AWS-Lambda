import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os

# Read the CSV files (change the file names if necessary)
# Hummingbird
hummingbird = "./results/1000req/simulated-performance-hummingbird.csv"
df1 = pd.read_csv(hummingbird) if os.path.exists(hummingbird) else pd.DataFrame()
# Vapor
vapor = "./results/1000req/simulated-performance-vapor.csv"
df2 = pd.read_csv(vapor) if os.path.exists(vapor) else pd.DataFrame()

# Extracting data for plotting
hb_no_coldstart = df1[df1['coldStart'] == 0]['avgDuration'] if not df1.empty else pd.Series()
hb_coldstart = df1[df1['coldStart'] == 1]['avgDuration'] if not df1.empty else pd.Series()
vapor_no_coldstart = df2[df2['coldStart'] == 0]['avgDuration'] if not df2.empty else pd.Series()
vapor_coldstart = df2[df2['coldStart'] == 1]['avgDuration'] if not df2.empty else pd.Series()

# Plotting
plt.figure(figsize=(10, 6))

if not hb_no_coldstart.empty:
    bar_width = 0.2
    index = np.arange(len(hb_no_coldstart))

    plt.bar(index, hb_no_coldstart, bar_width, label='Hummingbird, No Cold Start', color='skyblue', edgecolor='black', alpha=0.8)

if not hb_coldstart.empty:
    plt.bar(index + bar_width, hb_coldstart, bar_width, label='Hummingbird, Cold Start', color='lightgreen', edgecolor='black', alpha=0.8)

if not vapor_no_coldstart.empty:
    plt.bar(index + 2*bar_width, vapor_no_coldstart, bar_width, label='Vapor, No Cold Start', color='salmon', edgecolor='black', alpha=0.8)

if not vapor_coldstart.empty:
    plt.bar(index + 3*bar_width, vapor_coldstart, bar_width, label='Vapor, Cold Start', color='orange', edgecolor='black', alpha=0.8)

plt.xlabel('Lambda')
plt.ylabel('avgDuration')
plt.title('Comparison of avgDuration with and without Cold Start')

if not hb_no_coldstart.empty:
    plt.xticks(index + 1.5*bar_width, index)

plt.legend(loc='upper left')

# Add grid lines
plt.grid(axis='y', linestyle='--', alpha=0.7)

# Add value labels
if not hb_no_coldstart.empty:
    for i in range(len(index)):
        plt.text(index[i] - 0.05, hb_no_coldstart.values[i] + 10, str(round(hb_no_coldstart.values[i], 2)), fontsize=8, color='black')
        if not hb_coldstart.empty:
            plt.text(index[i] + bar_width - 0.05, hb_coldstart.values[i] + 10, str(round(hb_coldstart.values[i], 2)), fontsize=8, color='black')
        if not vapor_no_coldstart.empty:
            plt.text(index[i] + 2*bar_width - 0.05, vapor_no_coldstart.values[i] + 10, str(round(vapor_no_coldstart.values[i], 2)), fontsize=8, color='black')
        if not vapor_coldstart.empty:
            plt.text(index[i] + 3*bar_width - 0.05, vapor_coldstart.values[i] + 10, str(round(vapor_coldstart.values[i], 2)), fontsize=8, color='black')

# Set ylim to encompass a larger range
max_values = [val.max() for val in (hb_no_coldstart, hb_coldstart, vapor_no_coldstart, vapor_coldstart) if not val.empty]
if max_values:
    max_duration = max(max_values)
    plt.ylim(0, max_duration + 50)  # Adjust the value 50 as needed

plt.tight_layout()
plt.show()
