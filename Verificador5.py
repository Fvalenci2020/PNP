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
import sqlalchemy
from sqlalchemy.types import Integer

pd.options.mode.chained_assignment = None
plt.close("all")

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

#DATOS DE ENTRADA
    #Definición de Versión
VersionDescripcion='2010V2'#DEFINIR DESCRIPCIÓN DE VERSIÓN

  #Agrega versión a base de datos
cursor.execute('''
               INSERT INTO versionefact(Descripcion)
               VALUES (?);
               ''', (VersionDescripcion))
conn.commit()

    #Agrega categoría Reconversión energética a tabla con tipos de despacho
#cursor.execute('''
 #              INSERT INTO tipodespacho
  #              VALUES (6,'Reconversión energética'); 
   #             ''')
#conn.commit()
        

    #IMPORTAR DATOS
path = 'Entrega_Revisión_EFacDx_2010.v02.xlsx' 
Datos = pd.read_excel(path,skiprows=6)
Datos= Datos.iloc[:, 1:11]
    
    #EXTRAR DE DB TABLAS QUE SE NECESITAN
#demanda = pd.read_sql_query('select * from Demanda where fecha',conn)
generadora= pd.read_sql_query('select * from generadora',conn)
distribuidora= pd.read_sql_query('select * from distribuidora',conn)
contrato= pd.read_sql_query('select * from codigocontrato',conn)
puntoretiro= pd.read_sql_query('select * from puntoretiro',conn)
#efact= pd.read_sql_query('select * from efactfiltrado',conn)
despacho= pd.read_sql_query('select * from tipodespacho',conn)
version= pd.read_sql_query('select * from versionefact',conn)

#Extrae versión de tabla version
IdVersion=version.IdVersion[version.Descripcion==VersionDescripcion].to_numpy()#INDICAR ID DE VERSION QUE SE VA A UTILIZAR
IdVersion=int(IdVersion)

#Agrego Id
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
Datos['flag generadora']=1
    #Reemplaza datos cuando la condición es False
Datos['flag generadora'].where(Datos.IdGeneradora.isna(), 0, inplace=True,)
    #Crea fila de flag para IdPuntoRetiro. Cuando IdPuntoRetiro es nan, flag=1
Datos['flag puntoretiro']=1
    #Reemplaza datos cuando la condición es False
Datos['flag puntoretiro'].where(Datos.IdPuntoRetiro.isna(), 0, inplace=True,)
    #Crea fila de flag para IdGeneradora. Cuando IdDistribuidora es nan, flag=1
Datos['flag codigocontrato']=1
    #Reemplaza datos cuando la condición es False
Datos['flag codigocontrato'].where(Datos.IdCodigoContrato.isna(), 0, inplace=True,)

#Agregar comentario de error cuando flag igual a 1
    #Crea columnas con observaciones, luego serán borradas
Datos['Observación1']=''
Datos['Observación2']=''
Datos['Observación3']=''
Datos['Observación4']=''

    #Agrega mensaje de error a observaciones creadas. Si flag es 1 agrega error.
Datos['Observación1'].where(Datos['flag distribuidora']==0, '-Error nombre de Distribuidora', inplace=True,)
Datos['Observación2'].where(Datos['flag generadora']==0, '-Error nombre de Generadora', inplace=True,)
Datos['Observación3'].where(Datos['flag puntoretiro']==0, '-Error nombre de Punto Retiro', inplace=True,)
Datos['Observación4'].where(Datos['flag codigocontrato']==0, '-Error nombre de Código Contrato', inplace=True,)

    #Suma strings con errores y los pega en columna Observación original
Datos['Observación']=Datos['Observación1']+Datos['Observación2']+Datos['Observación3']+Datos['Observación4']
    #Elimina columnas creadas
Datos.drop(['Observación1', 'Observación2','Observación3', 'Observación4'], axis=1, inplace=True)


#Crea Tabla Efact con errores en observación
    #Crea columna con la id de la versión
Datos['IdDespacho']=np.nan
Datos['IdVersion']=IdVersion 
#UTILIZAR IDVERSION CREADO MÁS ARRIBA
Efact=Datos[['IdData','IdVersion','Fecha','IdDistribuidora','IdGeneradora','IdCodigoContrato','IdPuntoRetiro','Distribuidora','Suministrador','CodigoContrato','PuntoRetiro','IdDespacho','Energía [kWh]','Potencia [kW]','Observación']]
Efact_error=Efact[Efact['Observación']!='']


###########################################################################

Efact_corregido=Datos[['IdData','IdVersion','Fecha','Distribuidora','Suministrador','CodigoContrato','PuntoRetiro','IdDespacho','Energía [kWh]','Potencia [kW]','Observación']]

#Agrega Ids ignorando caracteres especiales y mayúsculas 
    #Crea columna temporal de NombreDistribuidora sin tilde y en minúscula en Efact_corregido y en tabla distribuidora
Efact_corregido['Distribuidora_temp']=Efact.Distribuidora.str.lower().str.normalize('NFKD').str.encode('ascii', errors='ignore').str.decode('utf-8')
distribuidora['Distribuidora_temp']=distribuidora.NombreDistribuidora.str.lower().str.normalize('NFKD').str.encode('ascii', errors='ignore').str.decode('utf-8')
    #Crea columna temporal de generadora sin tilde y en minúscula en Efact_corregido y en tabla generadora
Efact_corregido['Generadora_temp']=Efact.Suministrador.str.lower().str.normalize('NFKD').str.encode('ascii', errors='ignore').str.decode('utf-8')
generadora['Generadora_temp']=generadora.NombreGeneradora.str.lower().str.normalize('NFKD').str.encode('ascii', errors='ignore').str.decode('utf-8')
    #Crea columna temporal de Punto de Retiro sin tilde y en minúscula en Efact_corregido y en tabla puntoretiro
Efact_corregido['PuntoRetiro_temp']=Efact.PuntoRetiro.str.lower().str.normalize('NFKD').str.encode('ascii', errors='ignore').str.decode('utf-8')
puntoretiro['PuntoRetiro_temp']=puntoretiro.PuntoRetiro.str.lower().str.normalize('NFKD').str.encode('ascii', errors='ignore').str.decode('utf-8')
     #Crea columna temporal de Código de Contrato sin tilde y en minúscula en Efact_corregido y en tabla contrato
Efact_corregido['CodigoContrato_temp']=Efact.CodigoContrato.str.lower().str.normalize('NFKD').str.encode('ascii', errors='ignore').str.decode('utf-8')
contrato['CodigoContrato_temp']=contrato.CodigoContrato.str.lower().str.normalize('NFKD').str.encode('ascii', errors='ignore').str.decode('utf-8')

#Agrego Id
    #Agrego Id Distribuidora
Efact_corregido=pd.merge(Efact_corregido,distribuidora.iloc[:, lambda df: [0, 3]],left_on='Distribuidora_temp',right_on='Distribuidora_temp',how = 'left')
    #Agrego Id Generadora
Efact_corregido=pd.merge(Efact_corregido,generadora.iloc[:, lambda df: [0, 3]],left_on='Generadora_temp',right_on='Generadora_temp',how = 'left')
    #Agrego Id Punto de Retiro
Efact_corregido=pd.merge(Efact_corregido,puntoretiro.iloc[:, lambda df: [0, 3]],left_on='PuntoRetiro_temp'  ,right_on='PuntoRetiro_temp' ,how = 'left')
    #Agrego Id a contrato
Efact_corregido=pd.merge(Efact_corregido,contrato.iloc[:, lambda df: [0, 11]],left_on='CodigoContrato_temp',right_on='CodigoContrato_temp',how = 'left')
    #Elimina tablas temporales de Efact_corregido y las demás tablas
Efact_corregido.drop(['Distribuidora_temp', 'Generadora_temp','PuntoRetiro_temp', 'CodigoContrato_temp'], axis=1, inplace=True)
distribuidora.drop('Distribuidora_temp', axis=1, inplace=True)
generadora.drop('Generadora_temp', axis=1, inplace=True)
puntoretiro.drop('PuntoRetiro_temp', axis=1, inplace=True)
contrato.drop('CodigoContrato_temp', axis=1, inplace=True)
    
#Id Casos especiales
    #Distribuidora
Efact_corregido['IdDistribuidora'].where(~((Efact_corregido.Distribuidora=='CGE Distribución') | (Efact_corregido.Distribuidora=='CGED') | (Efact_corregido.Distribuidora=='CGE DISTRIBUCION')) ,18 , inplace=True,)    
Efact_corregido['IdDistribuidora'].where(~((Efact_corregido.Distribuidora=='Enel Distribución') | (Efact_corregido.Distribuidora=='CHILECTRA') | (Efact_corregido.Distribuidora=='ENEL DISTRIBUCIÓN')) ,10 , inplace=True,)    
Efact_corregido['IdDistribuidora'].where(~(Efact_corregido.Distribuidora=='TIL-TIL') ,13 , inplace=True,)    
Efact_corregido['IdDistribuidora'].where(~(Efact_corregido.Distribuidora=='LUZANDES') ,15 , inplace=True,)    
Efact_corregido['IdDistribuidora'].where(~(Efact_corregido.Distribuidora=='MATAQUITO') ,45 , inplace=True,)    
    #Código Contrato
Efact_corregido['IdCodigoContrato'].where(~((Efact_corregido.CodigoContrato=='Contrato Corto Plazo_Coelcha_ENDESA') | (Efact_corregido.CodigoContrato=='Contrato Corto Plazo_Frontel_ENDESA') | (Efact_corregido.CodigoContrato=='Contrato Corto Plazo_COOPERSOL_E-CL')) , 0, inplace=True,)    
Efact_corregido['IdCodigoContrato'].where(~(Datos.CodigoContrato=='RECONVERSIÓN ENERGÉTICA') , 0, inplace=True,)    
    #Caso punto retiro en blanco
Efact_corregido['IdPuntoRetiro'].where(~(Datos.PuntoRetiro=='(en blanco)') , 194, inplace=True,)   
Efact_corregido['PuntoRetiro'].where(~(Datos.PuntoRetiro=='(en blanco)') ,'Quirihue 023' , inplace=True,)    
    #Busca punto faltante en efact mes 07. El punto faltante es	Quirihue 023
#mask= ((efact.Fecha=='2020-08-01')&(efact.IdDistribuidora==33) & (efact.IdGeneradora==21) & (efact.IdCodigoContrato==624))
#mask2= ((Efact_corregido.IdDistribuidora==33) & (Efact_corregido.IdGeneradora==21) & (Efact_corregido.IdCodigoContrato==624))
#Puntofaltante=efact[mask]
#Puntofaltante2=Efact_corregido[mask2] 



#Agrega columna con tipo de despacho
    #Crea columna con datos del despacho
Efact_corregido['IdTipoDespacho']=np.nan
    #Agrega categoría reconversión energética a tabla despacho
    #Caso 1	Licitacion
Efact_corregido.IdTipoDespacho=1
    #Caso 2	Corto Plazo
Efact_corregido['IdTipoDespacho'].where(~((Efact_corregido.CodigoContrato=='Contrato Corto Plazo_Coelcha_ENDESA') | (Efact_corregido.CodigoContrato=='Contrato Corto Plazo_Frontel_ENDESA') | (Efact_corregido.CodigoContrato=='Contrato Corto Plazo_COOPERSOL_E-CL')) , 2, inplace=True,)    
    #Caso 3	Déficit
Efact_corregido['IdTipoDespacho'].where(~(Efact_corregido.CodigoContrato=='DÉFICIT_Coopelan') , 3, inplace=True,)    
    #Caso 4	Traspaso Excedentes
Efact_corregido['IdTipoDespacho'].where(~(Efact_corregido.IdDistribuidora==45) , 4, inplace=True,)    
    #Caso 5	Dx con contratos Holding
Efact_corregido['IdTipoDespacho'].where(~((Efact_corregido.IdDistribuidora==12) | (Efact_corregido.IdDistribuidora==13) | (Efact_corregido.IdDistribuidora==15)) , 5, inplace=True,)
    #Caso 6 Reconversión energética
Efact_corregido['IdTipoDespacho'].where(~(Efact_corregido.CodigoContrato=='RECONVERSIÓN ENERGÉTICA') , 6, inplace=True,)    


#Crea columna con la id de la versión
Efact_corregido['IdVersion']=IdVersion #Este podría ser cualquier número, por convención 15 es V1 y 16 V2

#Quita errores de observación
Efact_corregido['Observación']=np.nan

#Crea Tabla Efact sin errores en observación
Efact_corregido=Efact_corregido[['IdData','IdVersion','Fecha','IdDistribuidora','IdGeneradora','IdCodigoContrato','IdPuntoRetiro','Distribuidora','Suministrador','CodigoContrato','PuntoRetiro','IdTipoDespacho','Energía [kWh]','Potencia [kW]','Observación']]


#P2 tabla con errores de Efact.
#LISTO#crear flar de error si error alaguo de los 4 anteriores, then 1 else 0
#LISTO#agregar descripción error
#LISTO#agregar columna al final con mensaje de los errores que existen.
#LISTO#"Error nombre de Distribuidora"-"Error nombre de Generadora"

#P* corregir a la mala
#LISTO#P0 agregar registro a VErsionEFact        
#LISTO#P1    tabla EFACT 
        #agregar id despacho
        #agregar version

#Se crea conexión con DB
def creator():
    return pyodbc.connect(r'Driver={SQL Server};Server=DESKTOP-SSPJTJO\SQLEXPRESS;Database=Modelo PNP;Trusted_Connection=yes;')

eng = sqlalchemy.create_engine('mssql://', creator=creator)


#Se cambian nombres de columnas para que calcen con la tabla destino en DB
Efact_corregido=Efact_corregido.rename(columns={"IdData": "IdEfact", "Suministrador": "Generadora", "Energía [kWh]": "Energia", "Potencia [kW]": "Potencia","Observación": "Observacion"})

#Agrega Efact corregido a la base de datos
Efact_corregido.to_sql('Efact', eng, if_exists='append', index=False)                                                                
conn.close()
del conn
del cursor


'''
#AGREGA DATO DE HOLDING AL QUE PERTENECE
Holding=pd.DataFrame([], columns=['IdDistribuidora','IdHolding','Holding'])
Holding.IdDistribuidora=distribuidora.IdDistribuidora

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
bool_energia=Efact_corregido['Energía [kWh]'] == 0
bool_potencia=Efact_corregido['Potencia [kW]'] == 0
Dato_cero= (bool_energia & bool_potencia)
cero_EP=Efact_corregido[Dato_cero]

#REVISAR DUPLICADOS
Duplicados_bool = Efact_corregido.duplicated(keep=False)
Duplicados_all= Efact_corregido[Duplicados_bool]
del Duplicados_bool

#DUPLICADOS DE ENERGÍA Y POTENCIA
Datos_temp=Efact_corregido[~Dato_cero]
Duplicados_bool = Datos_temp.duplicated(subset=['Energía [kWh]','Potencia [kW]'],keep=False)
Duplicados_EP= Datos_temp[Duplicados_bool].sort_values(by=['Energía [kWh]'])

del Duplicados_bool
del Datos_temp
del bool_energia
del bool_potencia
del Dato_cero

'''