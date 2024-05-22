import pandas as pd
import matplotlib.pyplot as plt
import os

# Read the CSV files (change the file names if necessary)
# Hummingbird
hummingbird = "./results/1000req/simulated-performance-hummingbird.csv"
df1 = pd.read_csv(hummingbird) if os.path.exists(hummingbird) else pd.DataFrame()
# Vapor
vapor = "./results/1000req/simulated-performance-vapor.csv"
df2 = pd.read_csv(vapor) if os.path.exists(vapor) else pd.DataFrame()

# Extracting data for plotting
def extract_percentile_data(df, cold_start):
    if df.empty:
        return pd.Series(), pd.Series(), pd.Series(), pd.Series(), pd.Series()
    subset = df[df['coldStart'] == cold_start]
    return (
        subset['avgDuration'],
        subset['p50Duration'],
        subset['p90Duration'],
        subset['p95Duration'],
        subset['p99Duration']
    )

hb_no_coldstart, hb_p50_no_cs, hb_p90_no_cs, hb_p95_no_cs, hb_p99_no_cs = extract_percentile_data(df1, 0)
hb_coldstart, hb_p50_cs, hb_p90_cs, hb_p95_cs, hb_p99_cs = extract_percentile_data(df1, 1)
vapor_no_coldstart, vapor_p50_no_cs, vapor_p90_no_cs, vapor_p95_no_cs, vapor_p99_no_cs = extract_percentile_data(df2, 0)
vapor_coldstart, vapor_p50_cs, vapor_p90_cs, vapor_p95_cs, vapor_p99_cs = extract_percentile_data(df2, 1)

# Plotting box plots
plt.figure(figsize=(12, 8))

data = [
    hb_no_coldstart, hb_p50_no_cs, hb_p90_no_cs, hb_p95_no_cs, hb_p99_no_cs,
    hb_coldstart, hb_p50_cs, hb_p90_cs, hb_p95_cs, hb_p99_cs,
    vapor_no_coldstart, vapor_p50_no_cs, vapor_p90_no_cs, vapor_p95_no_cs, vapor_p99_no_cs,
    vapor_coldstart, vapor_p50_cs, vapor_p90_cs, vapor_p95_cs, vapor_p99_cs
]

labels = [
    'HB No CS Avg', 'HB No CS 50th', 'HB No CS 90th', 'HB No CS 95th', 'HB No CS 99th',
    'HB CS Avg', 'HB CS 50th', 'HB CS 90th', 'HB CS 95th', 'HB CS 99th',
    'Vapor No CS Avg', 'Vapor No CS 50th', 'Vapor No CS 90th', 'Vapor No CS 95th', 'Vapor No CS 99th',
    'Vapor CS Avg', 'Vapor CS 50th', 'Vapor CS 90th', 'Vapor CS 95th', 'Vapor CS 99th'
]

# Filter out empty data
filtered_data = [d.dropna() for d in data if not d.empty]
filtered_labels = [labels[i] for i in range(len(data)) if not data[i].empty]

plt.boxplot(filtered_data, labels=filtered_labels, patch_artist=True, boxprops=dict(facecolor='skyblue', color='blue'),
            whiskerprops=dict(color='blue'), capprops=dict(color='blue'), flierprops=dict(color='blue', markeredgecolor='blue'))

plt.xlabel('Metrics')
plt.ylabel('Duration (ms)')
plt.title('Comparison of Avg Duration and Percentiles with and without Cold Start')

# Rotate x-axis labels for better readability
plt.xticks(rotation=45, ha='right')

# Add grid lines
plt.grid(axis='y', linestyle='--', alpha=0.7)

plt.tight_layout()
plt.show()
