# -*- coding: utf-8 -*-
"""
Created on Tue Feb  9 11:17:08 2021

@author: Asus
"""
# -*- coding: utf-8 -*-
"""
Created on Thu Feb  4 15:39:56 2021

@author: Asus
"""
'''
*LISTO 1 COMPARACIÓN DE ENERGÍA A NIVEL DE HOLDING/MES, INDICANDO ERROR DE LA DDA ESTIMADA
*LISTO DX
*LISTO PTO RETIRO
Falta alarma de esto ^

ERROR: FUERA DE VECINDAD PROM+-2 DESVeST
WARNING: COMPARACIÓN CON VENTANA MÓVIL de 1 año (), MES ANTERIOR 
Promedio es del dato 12 meses hacia atrás
dda 0 que antes tenían energía o potencia

Idea: Agregar error a misma tabla efact_suma-LISTO
'''

import pandas as pd
import numpy as np
import pyodbc 
pd.options.mode.chained_assignment = None

conn = pyodbc.connect('Driver={SQL Server};'
                      'Server=DESKTOP-SSPJTJO\SQLEXPRESS;'
                      'Database=Modelo PNP;'
                      'Trusted_Connection=yes;')

cursor = conn.cursor()

#IMPORTAR TABLAS DESDE BASE DE DATOS
efact_corregido= pd.read_sql_query('''select * from efact where IdVersion=22 order by Fecha;''',conn)#Esto en realidad es efact_corregido
proy= pd.read_sql_query('''select * from demanda where Version='2007ProyV1' order by Mes;''',conn) 
puntoretiro= pd.read_sql_query('select * from puntoretiro',conn) #Estas no tengo que llamarlas
distribuidora= pd.read_sql_query('select * from distribuidora',conn) #Esta tampoco
    #Selecciona datos desde 2018-09-01 hasta 2020-12-01 y los ordena por fecha
efact_historico= pd.read_sql_query('''select * from efact where IdVersion=13 Union select * from efact where IdVersion=10
Union select * from efact where IdVersion=2 Union select * from efact where IdVersion=22
Union select * from efact where IdVersion=23 Union select * from efact where IdVersion=24 order by Fecha;
;''',conn)

#Esta parte del código prepara rango de fechas entre mes anterior y un año previo a este 
#Con esto se filtrará efact para sacar la ventana de 12 meses
separador='-'
Fecha_mes=efact_corregido.Fecha[1]
    #Prepara fechas para extraer rango desde Efact_historico
Fecha_mes_max=efact_corregido.Fecha[1].split('-')
if Fecha_mes_max[1]==1: #Si es enero
    Fecha_mes_max[1]==13 #Se reemplaza mes por 13 para que al restar 1 de 12 (dic)
Fecha_mes_max[1]='0'+str(int(Fecha_mes_max[1])-1)#Mes anterior
Fecha_mes_max=separador.join(Fecha_mes_max)#Junta string de nuevo

Fecha_mes_min=efact_corregido.Fecha[1].split('-')
Fecha_mes_min[0]=str(int(Fecha_mes_min[0])-1)#año anterior
if Fecha_mes_min[1]==1:
    Fecha_mes_min[1]==13
Fecha_mes_min[1]='0'+str(int(Fecha_mes_min[1])-1)#Mes anterior
Fecha_mes_min=separador.join(Fecha_mes_min)#Junta string de nuevo

#Se filtra efact con el rango de meses correspondiente
efact_historico=efact_historico[efact_historico['Fecha'].between(Fecha_mes_min, Fecha_mes_max)]


del separador
del Fecha_mes_min

#CREA DATO DE HOLDING AL QUE PERTENECE CADA DISTRIBUIDORA
    #Dataframe vacío con Id Dx, Holding y la descripción del holding
Holding=pd.DataFrame([], columns=['IdDistribuidora','IdHolding','Holding'])
    #Agrega Id distribuidora a columna desde tabla distribuidora
Holding.IdDistribuidora=distribuidora.IdDistribuidora



'''
CGE:            ENEL:             CHILQUINTA:         SAESA:  
EMELARI 1       ENEL 10           CHILQUINTA 6        FRONTEL 22
ELIQSA 2        COLINA 12         LITORAL 9           SAESA 23
ELECDA 3        LUZ ANDES 15      CASABLANCA 28       EDELAYSEN 24
EMELAT 4        *TIL TIL  13       LUZ LINARES 31      LUZ OSORNO 39
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
SASIPA 44
COOPRESOL 20

'''


    #Listas temporales de holding con Id de distribuidora
CGE=[1,2,3,4,7,18,25,45] #CGE
ENEL=[10,12,15,13] #ENEL (Verificar que tiltil sea de enel)
CHILQUINTA=[6,9,28,31,32] #CHILQUINTA
SAESA=[22,23,24,39] #SAESA
EEPA=[14] #EEPA
NA=[29,26,34,21,36,33,44,20,40,35,8] #NA


    #Agrega Id de Holding si se encuentra en listas definidas anteriormente
Holding['IdHolding']=np.nan 
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
          
       
#Agrega dato adicional a tabla de holding con Id de distribuidora de holdig
#Esto solo sirve para sumar al calcular energía a nivel Dx y después será borrado
Holding['IdDx']=np.nan
Holding['IdDx'].mask(Holding['IdHolding']==1, 18, inplace=True,)
Holding['IdDx'].mask(Holding['IdHolding']==2, 10, inplace=True,)
Holding['IdDx'].mask(Holding['IdHolding']==3, 6, inplace=True,)
Holding['IdDx'].mask(Holding['IdHolding']==4, 23, inplace=True,)
Holding['IdDx'].mask(Holding['IdHolding']==5, 14, inplace=True,)
Holding['IdDx'].mask(Holding['IdHolding']==6, 0, inplace=True,)


#Elimina listas temporales con holdings
del x    
del CGE
del ENEL
del CHILQUINTA
del SAESA
del EEPA
del NA


#Agrega Dato de Holding al final de tablas Proy y demanda
    #Efact
efact_corregido=pd.merge(efact_corregido,Holding,left_on='IdDistribuidora',right_on='IdDistribuidora',how = 'left').iloc[:,:-1]
    #Proyección
proy=pd.merge(proy,Holding,left_on='IdDistribuidora',right_on='IdDistribuidora',how = 'left').iloc[:,:-1]
proy=proy[proy.Mes==Fecha_mes]

#Agrega Dato de Holding al final de tabla efact historico
    #Efact
efact_historico=pd.merge(efact_historico,Holding,left_on='IdDistribuidora',right_on='IdDistribuidora',how = 'left').iloc[:,:-2]

#############################################################################################
#COMPARACIÓN DATO REAL CON PROYECCIÓN DE LA CNE

#COMPARACIÓN DE ENERGÍA A NIVEL DE HOLDING/MES
efact_suma_Holding=efact_corregido[['IdHolding','Energia']]
proy_suma_Holding=proy[['IdHolding','Demanda']]
proy_suma_Holding['Demanda']=proy_suma_Holding.Demanda.astype(float)

    #Suma agrupada por holding y fecha
efact_suma_Holding=efact_suma_Holding.groupby(by=['IdHolding']).sum()/1000
proy_suma_Holding=proy_suma_Holding.groupby(by=['IdHolding']).sum()
    #Vuelve a dejar como indice el Holding (Desaparece con instrucción 'groupby')
efact_suma_Holding.reset_index(level=[0], inplace=True)
proy_suma_Holding.reset_index(level=[0], inplace=True)
    #Cálculo de error
Error_Holding=pd.merge(efact_suma_Holding,proy_suma_Holding, left_on=['IdHolding'], right_on=['IdHolding'],how = 'left').iloc[:,:-1]
Error_Holding.Energia=100*(proy_suma_Holding.Demanda-efact_suma_Holding.Energia)/efact_suma_Holding.Energia
Error_Holding.rename(columns={"Energia": "Error Proy [%]"}, inplace=True)
#Agrega Error a tabla efact_suma
efact_suma_Holding=pd.merge(efact_suma_Holding,Error_Holding,how = 'left')


#COMPARACIÓN DE ENERGÍA A NIVEL DE DISTRIBUIDORA/MES
efact_suma_Dx=efact_corregido[['IdDistribuidora','Energia']]
proy_suma_Dx=proy[['IdDistribuidora','Demanda']]
proy_suma_Dx['Demanda']=proy_suma_Dx.Demanda.astype(float)

   #Suma agrupada por Dx y fecha
efact_suma_Dx=efact_suma_Dx.groupby(by=['IdDistribuidora']).sum()/1000
proy_suma_Dx=proy_suma_Dx.groupby(by=['IdDistribuidora']).sum()
   #Vuelve a dejar como indices la fecha y el Holding (Desaparecen con instrucción 'groupby')
efact_suma_Dx.reset_index(level=[0], inplace=True)
proy_suma_Dx.reset_index(level=[0], inplace=True)
   #Cálculo de error
#Distribuidoras que solo están en una tabla
diferencias_Dx= pd.concat([proy_suma_Dx, efact_suma_Dx], join='outer')
diferencias_Dx=diferencias_Dx.drop_duplicates(subset=['IdDistribuidora'],keep=False).reset_index()

#Sumar Dx que pertenecen a un holding que no están en la tabla de efact
for i in range(len(diferencias_Dx)):
    Groupdx=Holding.IdDx[Holding.IdDistribuidora==diferencias_Dx.loc[i,'index']]
    j=efact_suma_Dx[efact_suma_Dx.IdDistribuidora==int(Groupdx)].index
    proy_suma_Dx.loc[j,'Demanda']=proy_suma_Dx.Demanda[j]+diferencias_Dx.Demanda[i]
    proy_suma_Dx=proy_suma_Dx[~(proy_suma_Dx.IdDistribuidora==diferencias_Dx.loc[i,'IdDistribuidora'])]
    proy_suma_Dx.reset_index(inplace=True, drop=True)

  
    #Cálculo de error
Error_Dx=pd.DataFrame() 
Error_Dx['IdDistribuidora']=efact_suma_Dx['IdDistribuidora']
#Error_Dx=pd.merge(Error_Dx,distribuidora.iloc[:,[0,1]],left_on='IdDistribuidora',right_on='IdDistribuidora',how = 'left')
Error_Dx['Error Proy [%]']=100*(proy_suma_Dx.Demanda-efact_suma_Dx.Energia)/efact_suma_Dx.Energia
#Agrega Error a tabla efact_suma
efact_suma_Dx=pd.merge(efact_suma_Dx,Error_Dx,how = 'left')


#COMPARACIÓN DE ENERGÍA A NIVEL DE PUNTO DE RETIRO
efact_suma_PR=efact_corregido[['IdPuntoRetiro','Energia']]
proy_suma_PR=proy[['IdPuntoRetiro','Demanda']]
proy_suma_PR['Demanda']=proy_suma_PR.Demanda.astype(float)
   #Suma agrupada por Dx y fecha
efact_suma_PR=efact_suma_PR.groupby(by=['IdPuntoRetiro']).sum()/1000
proy_suma_PR=proy_suma_PR.groupby(by=['IdPuntoRetiro']).sum()
   #Vuelve a dejar como indices la fecha y el Holding (Desaparecen con instrucción 'groupby')
efact_suma_PR.reset_index(level=[0], inplace=True)
proy_suma_PR.reset_index(level=[0], inplace=True)
   #Detecta puntos que se encuentran en una tabla y no en la otra
diferencias_PR= pd.concat([proy_suma_PR, efact_suma_PR], join='outer')
diferencias_PR=diferencias_PR.drop_duplicates(subset=['IdPuntoRetiro'],keep=False)
    #Elimina puntos que no se encuentran en alguna de las tablas (diferencias)
    #Puntos que se encuentran en la primera y no en la segunda
proy_suma_PR= pd.concat([proy_suma_PR, diferencias_PR], join='outer').drop_duplicates(subset=['IdPuntoRetiro'],keep=False)
efact_suma_PR= pd.concat([efact_suma_PR, diferencias_PR], join='outer').drop_duplicates(subset=['IdPuntoRetiro'],keep=False)
    #Elimina puntos que están en la segunda y no en la primera
proy_suma_PR.drop(columns='Energia',inplace=True)
efact_suma_PR.drop(columns='Demanda',inplace=True)
    #Elimina nan
proy_suma_PR.dropna(inplace=True)
efact_suma_PR.dropna(inplace=True)
    #Recupera indices que se pierden al eliminar filas
proy_suma_PR.reset_index(drop=True,inplace=True)
efact_suma_PR.reset_index(drop=True,inplace=True)
    #Cálculo de error
Error_PR=pd.merge(efact_suma_PR,proy_suma_PR, left_on=['IdPuntoRetiro'], right_on=['IdPuntoRetiro'],how = 'left').iloc[:,:-1]
Error_PR.Energia=100*abs((proy_suma_PR.Demanda-efact_suma_PR.Energia)/efact_suma_PR.Energia)
Error_PR.rename(columns={"Energia": "Error Proy [%]"}, inplace=True)
#Agrega Error a tabla efact_suma
efact_suma_PR=pd.merge(efact_suma_PR,Error_PR,how = 'left')


#Desviación estándar
#Std_Holding=Error_Holding[['IdHolding','Energia']].groupby(by=['IdHolding']).std()
#Std_Holding.reset_index(level=[0], inplace=True)
#Std_Holding.rename(columns={"Energia": "std"}, inplace=True)
    #Compara error fuera de vecindad +-2DesvEstandar
#Error_Holding=pd.merge(Error_Holding,Std_Holding,left_on='IdHolding',right_on='IdHolding',how = 'left')

#####################################################################################
#COMPARACIÓN CON MES ANTERIOR
efact_1m=efact_historico[efact_historico['Fecha']==Fecha_mes_max]

#NIVEL HOLDING
efact_1m_Holding=efact_1m[['IdHolding','Energia']]
    #Suma agrupada por holding y fecha
efact_1m_Holding=efact_1m_Holding.groupby(by=['IdHolding']).sum()/1000
efact_1m_Holding.reset_index(level=[0], inplace=True)
efact_1m_Holding.rename(columns={"Energia": "Mes anterior"},inplace=True)
#Agrega mes anterior a tabla efact_suma
efact_suma_Holding=pd.merge(efact_suma_Holding,efact_1m_Holding,how = 'left')


#NIVEL DISTRIBUIDORA
efact_1m_Dx=efact_1m[['IdDistribuidora','Energia']]
    #Suma agrupada por holding y fecha
efact_1m_Dx=efact_1m_Dx.groupby(by=['IdDistribuidora']).sum()/1000
efact_1m_Dx.reset_index(level=[0], inplace=True)
efact_1m_Dx.rename(columns={"Energia": "Mes anterior"},inplace=True)
#Agrega mes anterior a tabla efact_suma
efact_suma_Dx=pd.merge(efact_suma_Dx,efact_1m_Dx,how = 'left')


#NIVEL PUNTO RETIRO
efact_1m_PR=efact_1m[['IdPuntoRetiro','Energia']]
    #Suma agrupada por holding y fecha
efact_1m_PR=efact_1m_PR.groupby(by=['IdPuntoRetiro']).sum()/1000
efact_1m_PR.reset_index(level=[0], inplace=True)
efact_1m_PR.rename(columns={"Energia": "Mes anterior"},inplace=True)
#Agrega mes anterior a tabla efact_suma
efact_suma_PR=pd.merge(efact_suma_PR,efact_1m_PR,how = 'left')



#####################################################################################
#COMPARACIÓN CON VENTANA MOVIL DE 1 AÑO

#NIVEL HOLDING
    #Crea tabla con datos necesarios desde efact_historico para la comparación a nivel holding
efact_12M_Holding=efact_historico[['IdHolding','Fecha','Energia']]
    #Agrupa y suma datos por holding y fecha
efact_12M_Holding=efact_12M_Holding.groupby(by=['IdHolding','Fecha']).sum().groupby(level=[0,1]).sum()/1000
    #Calcula promedio agrupando por fecha y cambia nombre a columna 
efact_12M_promedio=efact_12M_Holding.groupby(by=['IdHolding']).mean().rename(columns={"Energia": "Promedio 12 Meses"})
    #Calcula desviación estándar por fecha
efact_12M_std=efact_12M_Holding.groupby(by=['IdHolding']).std()
    #Deja tabla efact_12M en el formato deseado para hacer cruce con efact_suma_holding (tabla del mes presente)
efact_12M_Holding=efact_12M_promedio
    #Crea columna con desviación estándar
efact_12M_Holding['Desviacion']=efact_12M_std
    #Deja el IdHoling como columna (groupby lo deja como indice) para hacer cruce de datos
efact_12M_Holding.reset_index(level=[0], inplace=True)

#Tabla con promedio y desviación estándar (aun sin mensaje de error)
efact_suma_Holding=pd.merge(efact_suma_Holding,efact_12M_Holding,how = 'left')

del efact_12M_promedio
del efact_12M_std


#NIVEL DISTRIBUIDORA
    #Crea tabla con datos necesarios desde efact_historico para la comparación a nivel distribuidora
efact_12M_Dx=efact_historico[['IdDistribuidora','Fecha','Energia']]
    #Agrupa y suma datos por holding y fecha
efact_12M_Dx=efact_12M_Dx.groupby(by=['IdDistribuidora','Fecha']).sum().groupby(level=[0,1]).sum()/1000
    #Calcula promedio agrupando por fecha y cambia nombre a columna 
efact_12M_promedio=efact_12M_Dx.groupby(by=['IdDistribuidora']).mean().rename(columns={"Energia": "Promedio 12 Meses"})
    #Calcula desviación estándar por fecha
efact_12M_std=efact_12M_Dx.groupby(by=['IdDistribuidora']).std()
    #Deja tabla efact_12M en el formato deseado para hacer cruce con efact_suma_holding (tabla del mes presente)
efact_12M_Dx=efact_12M_promedio
    #Crea columna con desviación estándar
efact_12M_Dx['Desviacion']=efact_12M_std
    #Deja el IdHoling como columna (groupby lo deja como indice) para hacer cruce de datos
efact_12M_Dx.reset_index(level=[0], inplace=True)

del efact_12M_promedio
del efact_12M_std

    #Distribuidoras que solo están en una tabla (Se comenta porque no hay ninguna dx que esté en efact_historico)
#diferencias_12Dx=pd.concat([efact_12M_Dx, efact_suma_Dx], join='outer')
#diferencias_12Dx=diferencias_12Dx.drop_duplicates(subset=['IdDistribuidora'],keep=False).reset_index()

    #Tabla con promedio y desviación estándar (aun sin mensaje de error)
efact_suma_Dx=pd.merge(efact_suma_Dx,efact_12M_Dx,how = 'left')

#NIVEL PUNTO RETIRO
 #Crea tabla con datos necesarios desde efact_historico para la comparación a nivel distribuidora
efact_12M_PR=efact_historico[['IdPuntoRetiro','Fecha','Energia']]
    #Agrupa y suma datos por holding y fecha
efact_12M_PR=efact_12M_PR.groupby(by=['IdPuntoRetiro','Fecha']).sum().groupby(level=[0,1]).sum()/1000
    #Calcula promedio agrupando por fecha y cambia nombre a columna 
efact_12M_promedio=efact_12M_PR.groupby(by=['IdPuntoRetiro']).mean().rename(columns={"Energia": "Promedio 12 Meses"})
    #Calcula desviación estándar por fecha
efact_12M_std=efact_12M_PR.groupby(by=['IdPuntoRetiro']).std()
    #Deja tabla efact_12M en el formato deseado para hacer cruce con efact_suma_holding (tabla del mes presente)
efact_12M_PR=efact_12M_promedio
    #Crea columna con desviación estándar
efact_12M_PR['Desviacion']=efact_12M_std
    #Deja el IdHoling como columna (groupby lo deja como indice) para hacer cruce de datos
efact_12M_PR.reset_index(level=[0], inplace=True)

    #Tabla con promedio y desviación estándar (aun sin mensaje de error)
efact_suma_PR=pd.merge(efact_suma_PR,efact_12M_PR,how = 'left')

del efact_12M_promedio
del efact_12M_std

#NIVEL CONTRATO
#Tabla con energia a nivel contrato mes actual (CodigoContrato = CC)
efact_suma_CC=efact_corregido[['IdCodigoContrato','Energia']]
    #Suma agrupada por holding y fecha
efact_suma_CC=efact_suma_CC.groupby(by=['IdCodigoContrato']).sum()/1000
efact_suma_CC.reset_index(level=[0], inplace=True)

 #Crea tabla con datos necesarios desde efact_historico para la comparación a nivel distribuidora
efact_12M_CC=efact_historico[['IdCodigoContrato','Fecha','Energia']]
    #Agrupa y suma datos por holding y fecha
efact_12M_CC=efact_12M_CC.groupby(by=['IdCodigoContrato','Fecha']).sum().groupby(level=[0,1]).sum()/1000
    #Calcula promedio agrupando por fecha y cambia nombre a columna 
efact_12M_promedio=efact_12M_CC.groupby(by=['IdCodigoContrato']).mean().rename(columns={"Energia": "Promedio 12 Meses"})
    #Calcula desviación estándar por fecha
efact_12M_std=efact_12M_CC.groupby(by=['IdCodigoContrato']).std()
    #Deja tabla efact_12M en el formato deseado para hacer cruce con efact_suma_holding (tabla del mes presente)
efact_12M_CC=efact_12M_promedio
    #Crea columna con desviación estándar
efact_12M_CC['Desviacion']=efact_12M_std
    #Deja el IdHoling como columna (groupby lo deja como indice) para hacer cruce de datos
efact_12M_CC.reset_index(level=[0], inplace=True)

del efact_12M_promedio
del efact_12M_std

#NIVEL CONTRATO MES ANTERIOR
efact_1m_CC=efact_1m[['IdCodigoContrato','Energia']]
    #Suma agrupada por holding y fecha
efact_1m_CC=efact_1m_CC.groupby(by=['IdCodigoContrato']).sum()/1000
efact_1m_CC.reset_index(level=[0], inplace=True)
efact_1m_CC.rename(columns={"Energia": "Mes anterior"},inplace=True)
#Agrega mes anterior a tabla efact_suma
efact_suma_CC=pd.merge(efact_suma_CC,efact_1m_CC,how = 'left')

#Tabla con promedio y desviación estándar (aun sin mensaje de error)
efact_suma_CC=pd.merge(efact_suma_CC,efact_12M_CC,how = 'left')

