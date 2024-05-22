import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os

# Read the CSV files (change the file names if necessary)
# Hummingbird
hummingbird = "./results/csv/advanced-calc-hum.csv"
df1 = pd.read_csv(hummingbird) if os.path.exists(hummingbird) else pd.DataFrame()
# Vapor
vapor = "./results/csv/advanced-calc-vap.csv"
df2 = pd.read_csv(vapor) if os.path.exists(vapor) else pd.DataFrame()

# Extracting data for plotting
hb_no_coldstart_ram = df1[df1['coldStart'] == 0]['avgRam'] if not df1.empty else pd.Series()
hb_coldstart_ram = df1[df1['coldStart'] == 1]['avgRam'] if not df1.empty else pd.Series()
vapor_no_coldstart_ram = df2[df2['coldStart'] == 0]['avgRam'] if not df2.empty else pd.Series()
vapor_coldstart_ram = df2[df2['coldStart'] == 1]['avgRam'] if not df2.empty else pd.Series()

# Plotting
plt.figure(figsize=(10, 6))

if not hb_no_coldstart_ram.empty:
    bar_width = 0.2
    index = np.arange(len(hb_no_coldstart_ram))

    plt.bar(index, hb_no_coldstart_ram, bar_width, label='Hummingbird, No Cold Start', color='skyblue', edgecolor='black', alpha=0.8)

if not hb_coldstart_ram.empty:
    plt.bar(index + bar_width, hb_coldstart_ram, bar_width, label='Hummingbird, Cold Start', color='lightgreen', edgecolor='black', alpha=0.8)

if not vapor_no_coldstart_ram.empty:
    plt.bar(index + 2*bar_width, vapor_no_coldstart_ram, bar_width, label='Vapor, No Cold Start', color='salmon', edgecolor='black', alpha=0.8)

if not vapor_coldstart_ram.empty:
    plt.bar(index + 3*bar_width, vapor_coldstart_ram, bar_width, label='Vapor, Cold Start', color='orange', edgecolor='black', alpha=0.8)

plt.xlabel('Lambda')
plt.ylabel('avgRam')
plt.title('Comparison of avgRam with and without Cold Start')

if not hb_no_coldstart_ram.empty:
    plt.xticks(index + 1.5*bar_width, index)

plt.legend(loc='upper left')

# Add grid lines
plt.grid(axis='y', linestyle='--', alpha=0.7)

# Add value labels
if not hb_no_coldstart_ram.empty:
    for i in range(len(index)):
        plt.text(index[i] - 0.05, hb_no_coldstart_ram.values[i] + 10, str(round(hb_no_coldstart_ram.values[i], 2)), fontsize=8, color='black')
        if not hb_coldstart_ram.empty:
            plt.text(index[i] + bar_width - 0.05, hb_coldstart_ram.values[i] + 10, str(round(hb_coldstart_ram.values[i], 2)), fontsize=8, color='black')
        if not vapor_no_coldstart_ram.empty:
            plt.text(index[i] + 2*bar_width - 0.05, vapor_no_coldstart_ram.values[i] + 10, str(round(vapor_no_coldstart_ram.values[i], 2)), fontsize=8, color='black')
        if not vapor_coldstart_ram.empty:
            plt.text(index[i] + 3*bar_width - 0.05, vapor_coldstart_ram.values[i] + 10, str(round(vapor_coldstart_ram.values[i], 2)), fontsize=8, color='black')

# Set ylim to encompass a larger range
max_values_ram = [val.max() for val in (hb_no_coldstart_ram, hb_coldstart_ram, vapor_no_coldstart_ram, vapor_coldstart_ram) if not val.empty]
if max_values_ram:
    max_ram = max(max_values_ram)
    plt.ylim(0, max_ram + 50)  # Adjust the value 50 as needed

plt.tight_layout()
plt.show()
