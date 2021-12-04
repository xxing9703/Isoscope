# -*- coding: utf-8 -*-
"""
Created on Fri Sep 24 12:11:05 2021

@author: xxing
"""

# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import tkinter as tk
import os
from tkinter import filedialog
root = tk.Tk()
root.withdraw()
root.attributes("-topmost", True)
fn = filedialog.askopenfilename(filetypes=[("mis files", "*.mis")])
path,b = os.path.split(fn)
a,b = os.path.splitext(b)
fn1 = path+'/'+a+'.d/peaks.sqlite'
print(fn1)
#fn2=path+'/'+a+'.mat'  #save to original folder
fn2=a+'.mat'  #save to local folder

from xml.dom import minidom
mydoc=minidom.parse(fn)
items=mydoc.getElementsByTagName('Raster')
res=items[0].firstChild.nodeValue
import re
res=int(re.search(r'\d+', res).group())

import numpy as np
import pandas as pd
import sqlite3

import struct
# connect to database and read peaks into df
conn = sqlite3.connect(fn1)
c = conn.cursor()
print('Accessing database...')
df = pd.read_sql_query("SELECT XIndexPos,YIndexPos from Spectra", conn)
import matplotlib.pyplot as plt
plt.style.use('seaborn-whitegrid')
plt.plot(df.XIndexPos,df.YIndexPos,'.r')