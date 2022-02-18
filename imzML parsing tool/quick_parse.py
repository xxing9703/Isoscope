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
df = pd.read_sql_query("SELECT XIndexPos,YIndexPos,PeakMzValues,PeakIntensityValues,NumPeaks from Spectra", conn)
#XX=np.array([],dtype=[('id','O'),('x', 'O'), ('y', 'O'),('peak_mz', 'O'), ('peak_sig', 'O')])
XX=np.empty(df.shape[0],dtype=[('id','O'),('x', 'O'), ('y', 'O'),('peak_mz', 'O'), ('peak_sig', 'O')])
for num in range(df.shape[0]):
    if np.floor(num/1000)==num/1000:
        print(num,',', end="\r", flush=True)
    list1=list(struct.unpack('d'*df['NumPeaks'][num],df['PeakMzValues'][num]))
    list2=list(struct.unpack('f'*df['NumPeaks'][num],df['PeakIntensityValues'][num]))
    XX[num]=np.array([(num+1,df['XIndexPos'][num],df['YIndexPos'][num],np.array(list1,dtype='d'),np.array(list2,dtype='f'))],dtype=[('id','O'),('x', 'O'), ('y', 'O'),('peak_mz', 'O'), ('peak_sig', 'O')])
XX1=np.array([(fn,XX,res)],dtype=[('fname', 'O'), ('data', 'O'),('res', 'O')])

print('\n writing to file......')
#import scipy.io as sio          #it has 2G limit
#sio.savemat(fn2, {'msi':XX1})  

import hdf5storage
hdf5storage.write({'msi':XX1}, '.', fn2, matlab_compatible=True)

print('Done')
import matplotlib.pyplot as plt
plt.style.use('seaborn-whitegrid')
plt.plot(df.XIndexPos,df.YIndexPos,'.r')

