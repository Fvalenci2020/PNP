# -*- coding: utf-8 -*-
"""
Created on Thu Feb 11 14:15:27 2021

@author: Asus
"""
import pyodbc 
import pandas as pd
from P016_PROC_Comparador import *

#ConectorDB='Driver={SQL Server};''Server=DESKTOP-SSPJTJO\SQLEXPRESS;''Database=Modelo PNP;''Trusted_Connection=yes;'
ConectorDB='Driver={SQL Server};Server=GTD-NOT019\SQLSERVER2012;Database=PNP_2;Trusted_Connection=yes;'

conn = pyodbc.connect(ConectorDB)

cursor = conn.cursor()

efact_corregido= pd.read_sql_query('''select * from efact where IdVersion=22 order by Fecha;''',conn)#Esto en realidad es efact_corregido
efact_historico= pd.read_sql_query('''select * from efact where IdVersion=16 Union select * from efact where IdVersion=11
    Union select * from efact where IdVersion=2 Union select * from efact where IdVersion=18
    Union select * from efact where IdVersion=20 Union select * from efact where IdVersion=22 order by Fecha;''',conn)
proy= pd.read_sql_query('''select * from demanda where Version='2007ProyV1' order by Mes;''',conn) 

Comparador(ConectorDB,efact_corregido,efact_historico,proy)

#