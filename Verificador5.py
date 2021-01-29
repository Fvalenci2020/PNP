# -*- coding: utf-8 -*-
"""
Created on Thu Jan 28 17:22:42 2021

@author: Asus
"""
# -*- coding: utf-8 -*-
"""
Created on Fri Jan 22 10:36:22 2021
@author: Asus
"""

import pandas as pd
import numpy as np
import datetime
import matplotlib.pyplot as plt
import pyodbc
pd.options.mode.chained_assignment = None
plt.close("all")
import matplotlib.animation as animation


#IMPORTAR DATOS
path = 'Entrega_Revisión_EFacDx_2010.v01.xlsx' 
Datos = pd.read_excel(path,skiprows=6)
Datos= Datos.iloc[:, 1:11]

#Base de datos SQL
import pyodbc 

conn = pyodbc.connect('Driver={SQL Server};'
                      'Server=DESKTOP-SSPJTJO\SQLEXPRESS;'
                      'Database=Modelo PNP;'
                      'Trusted_Connection=yes;')

'''
conn = pyodbc.connect('Driver={SQL Server};'
                      'Server=GTD-NOT019\SQLSERVER2012;'
                      'Database=PNP_2;'
                      'Trusted_Connection=yes;')
'''

cursor = conn.cursor()


#demanda = pd.read_sql_query('select * from Demanda where fecha',conn)
generadora= pd.read_sql_query('select * from generadora',conn)
distribuidora= pd.read_sql_query('select * from distribuidora',conn)
contrato= pd.read_sql_query('select * from codigocontrato',conn)
puntoretiro= pd.read_sql_query('select * from puntoretiro',conn)
#efact= pd.read_sql_query('select * from efactfiltrado',conn)
despacho= pd.read_sql_query('select * from tipodespacho',conn)

conn.close()
del conn
del cursor

#AGREGO IDS
    #Renombrar columna tablas
#distribuidora=distribuidora.rename(columns={'NombreDistribuidora': 'Distribuidora'})
#generadora=generadora.rename(columns={'NombreGeneradora': 'Suministrador'})

    #Agrego Id Distribuidora
Datos=pd.merge(Datos,distribuidora.iloc[:,[0,1]],left_on='Distribuidora',right_on='NombreDistribuidora',how = 'left').iloc[:,:-1]
    #Agrego Id Generadora
Datos=pd.merge(Datos,generadora.iloc[:,[0,1]],left_on='Suministrador',right_on='NombreGeneradora',how = 'left').iloc[:,:-1]
    #Agrego Id Punto de Retiro
Datos=pd.merge(Datos,puntoretiro.iloc[:,[0,1]],left_on='PuntoRetiro'  ,right_on='PuntoRetiro' ,how = 'left')#.iloc[:,:-1]
    #Agrego Id a contrato
Datos=pd.merge(Datos,contrato.iloc[:,[0,1]],left_on='CodigoContrato',right_on='CodigoContrato',how = 'left')#.iloc[:,:-1]

#Agregar columnas con flag
    #Crea fila de flag para IdDistribuidora. Cuando IdDistribuidora es nan, flag=1
Datos['flag distribuidora']=1
    #Reemplaza datos cuando la condición es False
Datos['flag distribuidora'].where(Datos.IdDistribuidora.isna(), 0, inplace=True,)
    #Crea fila de flag para IdGeneradora. Cuando IdGeneradora es nan, flag=1
Datos['Flag generadora']=1
    #Reemplaza datos cuando la condición es False
Datos['Flag generadora'].where(Datos.IdGeneradora.isna(), 0, inplace=True,)
    #Crea fila de flag para IdPuntoRetiro. Cuando IdPuntoRetiro es nan, flag=1
Datos['Flag puntoretiro']=1
    #Reemplaza datos cuando la condición es False
Datos['Flag puntoretiro'].where(Datos.IdPuntoRetiro.isna(), 0, inplace=True,)
    #Crea fila de flag para IdGeneradora. Cuando IdDistribuidora es nan, flag=1
Datos['Flag codigocontrato']=1
    #Reemplaza datos cuando la condición es False
Datos['Flag codigocontrato'].where(Datos.IdCodigoContrato.isna(), 0, inplace=True,)


    #P2 tabla con errores de Efact.
        #crear flar de error si error alaguo de los 4 anteriores, then 1 else 0
        #agregar descripción error
        #agregar columna al final con mensaje de los errores que existen.
        #"Error nombre de Distribuidora"-"Error nombre de Generadora"

#P* corregir a la mala

#P0 agregar registro a VErsionEFact        
#P1    tabla EFACT 
        #agregar id despacho
        #agregar version

'''
#AGREGA DATO DE HOLDING AL QUE PERTENECE
Holding=pd.DataFrame([], columns=['IdDistribuidora','IdHolding','Holding'])
Holding.IdDistribuidora=distribuidora.IdDistribuidora
'''
'''
CGE:            ENEL:             CHILQUINTA:         SAESA:  
EMELARI 1       ENEL 10           CHILQUINTA 6        FRONTEL 22
ELIQSA 2        COLINA 12         LITORAL 9           SAESA 23
ELECDA 3        LUZ ANDES 15      CASABLANCA 28       EDELAYSEN 24
EMELAT 4                          LUZ LINARES 31      LUZ OSORNO 39
CONAFE 7                          LUZ PARRAL 32
CGED 18
EDELMAG 25
MATAQUITO 45
    
NO ASOCIADA:    EEPA:
CEC 29          E.E PUENTE ALTO 14
CODINER 26
COELCHA 34
COOPELAN 21
COOPREL 36
COPELEC 33
CRELL 40
EMELCA 8
SOCOEPA 35
TIL-TIL 13
SASIPA 44
COOPRESOL 20
'''
'''
CGE=[1,2,3,4,7,18,25,45] #CGE
ENEL=[10,12,15] #ENEL
CHILQUINTA=[6,9,28,31,32] #CHILQUINTA
SAESA=[22,23,24,39] #SAESA
EEPA=[14] #EEPA
NA=[29,26,34,21,36,33,44,20,40,35,13,8] #NA

Datos['IdHolding']=np.nan
for x in range(len(Holding)):
    if Holding.loc[x,'IdDistribuidora'] in CGE :
        Holding.loc[x,'IdHolding']=1
        Holding.loc[x,'Holding']='CGE'
    elif Holding.loc[x,'IdDistribuidora'] in ENEL:
        Holding.loc[x,'IdHolding']=2
        Holding.loc[x,'Holding']='ENEL'
    elif Holding.loc[x,'IdDistribuidora'] in CHILQUINTA:
        Holding.loc[x,'IdHolding']=3  
        Holding.loc[x,'Holding']='CHILQUINTA'
    elif Holding.loc[x,'IdDistribuidora'] in SAESA:
       Holding.loc[x,'IdHolding']=4  
       Holding.loc[x,'Holding']='SAESA'
    elif Holding.loc[x,'IdDistribuidora'] in EEPA:
       Holding.loc[x,'IdHolding']=5 
       Holding.loc[x,'Holding']='EEPA'
    elif Holding.loc[x,'IdDistribuidora'] in NA:
       Holding.loc[x,'IdHolding']=6
       Holding.loc[x,'Holding']='NA'
          

del x    
del CGE
del ENEL
del CHILQUINTA
del SAESA
del EEPA
del NA

#DATOS DE POTENCIA Y ENERGÍA CERO
bool_energia=Datos['Energía [kWh]'] == 0
bool_potencia=Datos['Potencia [kW]'] == 0
Dato_cero= (bool_energia & bool_potencia)
corregir_E_P=Datos.IdData[Dato_cero]

#REVISAR DUPLICADOS
Duplicados_bool = Datos.duplicated(keep=False)
Duplicados_all= Datos[Duplicados_bool]
if len(Duplicados_all)!=0:
    print("\033[;36m"+'Corregir filas duplicadas:'+'\033[0;m')
    print('En índices '+ str(Duplicados_all.loc[:,'IdData'])+'\n')
del Duplicados_bool

#DUPLICADOS DE ENERGÍA Y POTENCIA
Datos_temp=Datos[~Dato_cero]
Duplicados_bool = Datos_temp.duplicated(subset=['Energía [kWh]','Potencia [kW]'],keep=False)
Duplicados_EP= Datos_temp[Duplicados_bool].sort_values(by=['Energía [kWh]'])
if len(Duplicados_EP)!=0:
    print("\033[;36m"+'Corregir filas duplicadas de energía y potencia:'+'\033[0;m')
    print('En ' + str(Duplicados_EP) +'\n')

del Duplicados_bool
del Datos_temp
del bool_energia
del bool_potencia
del Dato_cero

#REVISAR FECHA
Prueba_fechas=Datos.iloc[:, [3]].astype(str)
for x in range(len(Prueba_fechas)):
    try:
        date_obj =datetime.datetime.strptime(Prueba_fechas.Fecha[x], '%Y-%m-%d')
    except ValueError:
        print("Formato incorrecto de fecha en dato: "+str(Datos.loc[x,'IdData']))
        
del Prueba_fechas
del date_obj

#REVISAR NOMBRE DISTRIBUIDORA
'''