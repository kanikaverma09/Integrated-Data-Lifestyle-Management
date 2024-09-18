import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

def analyze_csv(csv_file_path):
    #df = pd.read_csv(csv_file_path,dtype=str,sep="|")
    #df1= pd.read_csv(csv_file_path,sep="|")
    df = pd.read_csv(csv_file_path,dtype=str)
    df1= pd.read_csv(csv_file_path)
    print(df.dtypes)
    print(df1.dtypes)
    df = df.astype(str)
    #print(df.iloc[:,-1]) 
    results = {}
    total_records = len(df)
    ######################################################
  
    
    ######################################################
    #print(df.loc[df['id'] == 8007])
    #print(df.loc[df['id'] == 8029, 'latitude'])
    #print(df.groupby(df.columns.tolist(),as_index=False).size())
    print(df.duplicated().sum())
    
    results['Total Records'] = total_records

    null_counts = df1.isnull().sum()
    results['Null Records'] = null_counts.to_dict()
 
    zero_counts = df1.isin([0]).sum()
    results['Zero Records'] = zero_counts.to_dict()
    
    unique_counts = df.nunique()
    results['Unique Records'] = unique_counts.to_dict()

    duplicate_records = total_records - unique_counts
    results['Duplicate Records'] = duplicate_records
    max_length = df.astype(str).applymap(len).max()
    min_length = df1.astype(str).applymap(len).min()
    results['Max Length'] = max_length.to_dict()
    results['Min Length'] = min_length.to_dict()
    return results

csv_file_path =  'itp_retail_transactions.csv'
analysis_results = analyze_csv(csv_file_path)
print(analysis_results)

df_results = pd.DataFrame(analysis_results)

output_file_path = 'analysis_results8.xlsx'
df_results.to_excel(output_file_path)