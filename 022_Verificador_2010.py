"""
Created on Mon Feb  8 22:21:09 2021
@author: fvalencia
"""
import pandas as pd
from P015_PROC_Verificador import *

#Definición variables

    #Datos Computador Fco
ConectorDB='Driver={SQL Server};Server=GTD-NOT019\SQLSERVER2012;Database=PNP_2;Trusted_Connection=yes;'
    #Datos Computador Carla
#ConectorDB='Driver={SQL Server};Server=Server=DESKTOP-SSPJTJO\SQLEXPRESS;Database=Modelo PNP;Trusted_Connection=yes;'

    #Definición de Versión
        #Agrega versión a base de datos
            #VersionDescripcion='2011V1'#DEFINIR DESCRIPCIÓN DE VERSIÓN
            #import pyodbc
            #conn = pyodbc.connect(ConectorDB)
            #cursor = conn.cursor()
            #cursor.execute('''INSERT INTO versionefact(Descripcion) VALUES (?);''', (VersionDescripcion))
            #conn.commit()
            #IdVersion=pd.read_sql_query("select idversion from versionefact  where Descripcion='"+VersionDescripcion+"'",conn)

#Para diciembre  2020
IdVersion=22

    #IMPORTAR DATOS
path = 'C:/fvalenci/CNE/PNP/PNP_2007_11-12_FPEC/Input/CEN/Entrega_Revisión_EFacDx_2012.v01.xlsx'

Efact_error,Efact=Validador(ConectorDB,path,IdVersion)#
Efact_corregido=CorrectorEfact(ConectorDB,IdVersion,Efact)#
CargaEfactDB(ConectorDB,Efact_corregido)#
"""
#Para noviembre  2020
IdVersion=20

    #IMPORTAR DATOS
path = 'C:/fvalenci/CNE/PNP/PNP_2007_11-12_FPEC/Input/CEN/Entrega_Revisión_EFacDx_2011.v01.xlsx'

Efact_error,Efact=Validador(ConectorDB,path,IdVersion)#
Efact_corregido=CorrectorEfact(ConectorDB,IdVersion,Efact)#
CargaEfactDB(ConectorDB,Efact_corregido)#
"""