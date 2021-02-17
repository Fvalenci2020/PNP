"""
Created on Mon Feb  8 22:21:09 2021
@author: fvalencia
"""
import pandas as pd
import pyodbc
from P015_PROC_Verificador import *
from P016_PROC_Comparador import *

#Definición variables

    #Datos Computador Fco
ConectorDB='Driver={SQL Server};Server=GTD-NOT019\SQLSERVER2012;Database=PNP_2;Trusted_Connection=yes;'
    #Datos Computador Carla
#ConectorDB='Driver={SQL Server};Server=Server=DESKTOP-SSPJTJO\SQLEXPRESS;Database=Modelo PNP;Trusted_Connection=yes;'

    #Definición de Versión
        #Agrega versión a base de datos
#VersionDescripcion='2010V3'#DEFINIR DESCRIPCIÓN DE VERSIÓN
#conn = pyodbc.connect(ConectorDB)
#cursor = conn.cursor()
#cursor.execute('''INSERT INTO versionefact(Descripcion) VALUES (?);''', (VersionDescripcion))
#conn.commit()
#IdVersion=pd.read_sql_query("select idversion from versionefact  where Descripcion='"+VersionDescripcion+"'",conn)

#Para octubre  2020
IdVersion=25
conn = pyodbc.connect(ConectorDB)
cursor = conn.cursor()
efact_historico= pd.read_sql_query('''select * from efact where IdVersion=16 Union select * from efact where IdVersion=11
    Union select * from efact where IdVersion=2 Union select * from efact where IdVersion=25
    Union select * from efact where IdVersion=20 Union select * from efact where IdVersion=22 order by Fecha;''',conn)
proy= pd.read_sql_query('''select * from demanda where Version='2007ProyV1' order by Mes;''',conn) 
    #IMPORTAR DATOS
path = 'C:/fvalenci/CNE/PNP/PNP_2007_10_FPEC/Input/CEN/Entrega_Revisión_EFacDx_2010.v03.xlsx'

Efact_error,Efact=Validador(ConectorDB,path,IdVersion)#
Efact_corregido=CorrectorEfact(ConectorDB,IdVersion,Efact)#
#CargaEfactDB(ConectorDB,Efact_corregido)

Efact_corregido= pd.read_sql_query('''select * from efact where IdVersion='''+str(IdVersion)+''' order by Fecha;''',conn)#Esto en realidad es efact_corregido
Comparador(ConectorDB,Efact_corregido,efact_historico,proy)