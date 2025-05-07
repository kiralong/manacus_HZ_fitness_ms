#!/usr/bin/env python
# coding: utf-8

# # Extract Mark Recapture Matrix

# In[1]:


# Imports

import pandas as pd
import functools


# In[2]:


# Parameters
data_directory = "data/"
input_data_filename = "/Users/kiraroo/Google Drive/Bioinformatics/Chapter_3/MARK_recapture_analyses/Most_filtered_3yrs_3pops_rmsansan2/Capture_records_2017_2019_pops2_9_10_rmsansanlek2_DF_only.txt"
output_filename = "mark_recapture_2017_2020_DF_ONLY.inp"

# In[3]:


# Importing the data as a pandas dataframe

df = pd.read_csv(input_data_filename, sep='\t')
print(df)
print(df.keys())


# In[4]:


# Displaying relevant columns for our extraction of bird, species, and capture time for Mark Recapture data.
# Date is the date of capture
# Band # is the unique ID of the bird (via its band)
# Species is the species name, or Hybrid of the two.
# From these values we can process mark recapture data.

df[['Date', 'Band #', 'Species']]
print(df[['Date', 'Band #', 'Species']])


# In[5]:


# Debugging Species values for typos
unique_species_values = df['Species'].unique()
print(sorted(unique_species_values))

# Map Species to Species bit flag columns
# This is a mapping provided by Kira on how to convert Species into a bitwise flag.

species_mapping = {
    "Can": [1,0,0],
    "Hyb": [0,1,0],
    "Vit": [0,0,1]
}


# In words/pseudocode, the algorithm is:
#
# Phase 1: Do an initial scan of the dates to get the set of years and set up year columns in the result matrix.
# - Note that these year-wise columns are actually squished together into a single column.
#
# Phase 2: For each row in the input data, add the capture to the result matrix.

# In[6]:


# Gather Years for Columns

def convert_date_to_year(date):
    year = date.split("/")[-1]
    year = "20" + year # Date Representation isn't full year, add the 20 in 20XX
    return year

def reduce_to_years(years, date):
    year = convert_date_to_year(date)
    if (year not in years):
        years.append(year)
    return years

dates = df['Date'].tolist()
years = functools.reduce(reduce_to_years, dates, [])
years.sort()
print(years)


# In[7]:


# Prepare Result Data Structure (Not a matrix yet, will transform into a matrix/data frame later)
# Mark Recapture only needs the boolean value of whether a bird was captured that year.
# In the final result, will be represented by 1 = true and 0 = false.

# The overall object is a dictionary where the key is the band_number, and
# the corresponding value in the key-value pair are also dictionaries with Year: Boolean initialized to false
results = {}

# This is the template object to *copy* in as needed when creating new entries
templateMarkRecaptureDataByYear = {
    "species": None
}

for year in years:
    templateMarkRecaptureDataByYear[year] = False
print(templateMarkRecaptureDataByYear)


# In[8]:


# Process Input Data Row by Row

def process_data(current_row):
    band_number = current_row['Band #']
    date = current_row['Date']

    key = band_number
    if key not in results:
        results[key] = templateMarkRecaptureDataByYear.copy()

        # Species -> Bit flag mapping only needs to happen once per band_number.
        species = current_row['Species']
        results[key]['species'] = species_mapping[species]

    year = convert_date_to_year(date)
    results[key][year] = True

df.apply(process_data, axis=1)

print(results)


# In[9]:


# First, convert all Booleans to 1's and 0's

def convert_boolean_to_one_or_zero(bool_value):
    if bool_value:
        return 1
    return 0

def convert_data_by_year_to_ones_and_zeros(capture_data_dict):
    new_capture_data_dict = {}
    for (key, value) in capture_data_dict.items():
        if key in years:
            new_capture_data_dict[key] = convert_boolean_to_one_or_zero(value)
        else:
            new_capture_data_dict[key] = value
    return new_capture_data_dict

def convert_results_year_booleans_to_ones_and_zeros(results):
    new_results = {}
    for (band_number, data_dict) in results.items():
        new_results[band_number] = convert_data_by_year_to_ones_and_zeros(data_dict)
    return new_results

converted_results = convert_results_year_booleans_to_ones_and_zeros(results)
print(converted_results)


# In[10]:


# Flatten data for export

def flatten_and_format_row(band_number, capture_data_dict):
    band_number_comment = f"/* {band_number} */"

    combined_year_capture_column = ''
    for year in years:
        combined_year_capture_column += str(capture_data_dict[year])

    flattened_row_data = [band_number_comment, combined_year_capture_column] + capture_data_dict['species']

    # Program MARK uses 2 spaces as a column separator
    separator = ' ' * 2
    return separator.join([band_number_comment, combined_year_capture_column] + list(map(str, capture_data_dict['species']))) + ';'


def flatten_and_format_data(results):
    return [flatten_and_format_row(band_number, capture_data_dict) for (band_number, capture_data_dict) in results.items()]

flattened_and_formatted_data = flatten_and_format_data(converted_results)
print(flattened_and_formatted_data)


# In[11]:


# Output the results to a file

with open(output_filename, 'w') as output_file:
    output_file.write("/* manakins -- 4 sampling occassions -- 3 groups */\n")
    for formatted_row in flattened_and_formatted_data:
        output_file.write(formatted_row + '\n')
