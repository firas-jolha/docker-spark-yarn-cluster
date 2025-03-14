#!/usr/bin/python

""" 
obtained from https://github.com/asmith26/python-mapreduce-examples
INPUT: Output from mapper.py
        Format of each line is: location\tcost

OUTPUT: E.g.
            50  12268.16
"""


import fileinput

transactions_count = 0
sales_total = 0

for line in fileinput.input():

    data = line.strip().split("\t")    

    if len(data) != 2:
        # Something has gone wrong. Skip this line.
        continue

    current_key, current_value = data

    transactions_count += 1
    sales_total += float(current_value)

print(transactions_count, "\t", sales_total)