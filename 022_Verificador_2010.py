"""
Created on Mon Feb  8 22:21:09 2021
@author: fvalencia
"""
import pandas as pd
from P015_PROC_Verificador import *
from P016_PROC_Comparador import *

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
CargaEfactDB(ConectorDB,Efact_corregido)
"""
#Para noviembre  2020
IdVersion=20

    #IMPORTAR DATOS
path = 'C:/fvalenci/CNE/PNP/PNP_2007_11-12_FPEC/Input/CEN/Entrega_Revisión_EFacDx_2011.v01.xlsx'

Efact_error,Efact=Validador(ConectorDB,path,IdVersion)#
Efact_corregido=CorrectorEfact(ConectorDB,IdVersion,Efact)#
CargaEfactDB(ConectorDB,Efact_corregido)#
"""

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
"""
DEJAR AL INICIO % DE ERROR A CONSIDERAR COMO VARIABLE
AGREGAR UNIDADES A NOMBRES DE CAMPO DE SALIDA
MENSAJES DE OBSERVACIÓN QUE ESTÉN REFERENCIADOS AL % DE ERROR DE VARIABLE Y NO AL DEL REGISTRO
MENSAJES NO DEBEN CONTENER JUICIOS DE VALOR
QUE VALORES EN PORCENTAJE APAREZCAN COMO NÚMERO
ELIMINAR PABRA ERROR CUANDO SE COMPRARAN DATOS HISTÓRICOS
CORREGIR p015 PARA QUE VERIFIQUE VIGENCIA CONTRATO.
"""