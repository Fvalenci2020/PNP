# -*- coding: utf-8 -*-
"""
Created on Thu Feb  4 15:39:56 2021

@author: Asus
"""

#Falta cambiar mensajes de alerta y agregar flags cuando hay puntos con potencia y luego sin

def Comparador(ConectorDB,efact_corregido,efact_historico,proy):
    
    import pandas as pd
    import numpy as np
    import pyodbc 
    pd.options.mode.chained_assignment = None
    
    
    conn = pyodbc.connect(ConectorDB)
    
    cursor = conn.cursor()

    
    #IMPORTAR TABLAS DESDE BASE DE DATOS    
    puntoretiro= pd.read_sql_query('select * from puntoretiro',conn) #Estas no tengo que llamarlas
    distribuidora= pd.read_sql_query('select * from distribuidora',conn) #Esta tampoco
    contrato= pd.read_sql_query('select * from codigocontrato',conn) 
        #Selecciona datos desde 2018-09-01 hasta 2020-12-01 y los ordena por fecha

    
    
    #Esta parte del código prepara rango de fechas entre mes anterior y un año previo a este 
    #Con esto se filtrará efact para sacar la ventana de 12 meses
    separador='-'
    Fecha_mes=efact_corregido.Fecha[1]
        #Prepara fechas para extraer rango desde Efact_historico
    Fecha_mes_max=efact_corregido.Fecha[1].split('-')
    if Fecha_mes_max[1]==1: #Si es enero
        Fecha_mes_max[1]==13 #Se reemplaza mes por 13 para que al restar 1 de 12 (dic)
    
    Fecha_mes_max[1]=str(int(Fecha_mes_max[1])-1)#Mes anterior
    if int(Fecha_mes_max[1])<10:
        Fecha_mes_max[1]='0'+str(int(Fecha_mes_max[1])-1)#Mes anterior
    Fecha_mes_max=separador.join(Fecha_mes_max)#Junta string de nuevo
    
    Fecha_mes_min=efact_corregido.Fecha[1].split('-')
    Fecha_mes_min[0]=str(int(Fecha_mes_min[0])-1)#año anterior
    if Fecha_mes_min[1]==1:
        Fecha_mes_min[1]==13
        
    Fecha_mes_min[1]=str(int(Fecha_mes_min[1])-1)#Mes anterior
    if int(Fecha_mes_min[1])<10:
        Fecha_mes_min[1]='0'+str(int(Fecha_mes_min[1])-1)#Mes anterior
    Fecha_mes_min=separador.join(Fecha_mes_min)#Junta string de nuevo
    
    #Se filtra efact con el rango de meses correspondiente
    efact_historico=efact_historico[efact_historico['Fecha'].between(Fecha_mes_min, Fecha_mes_max)]
    
    
    del separador
    
    #CREA DATO DE HOLDING AL QUE PERTENECE CADA DISTRIBUIDORA
        #Dataframe vacío con Id Dx, Holding y la descripción del holding
    Holding=pd.DataFrame([], columns=['IdDistribuidora','IdHolding','Holding'])
        #Agrega Id distribuidora a columna desde tabla distribuidora
    Holding.IdDistribuidora=distribuidora.IdDistribuidora
    
    
        #Listas temporales de holding con Id de distribuidora
    CGE=[1,2,3,4,7,18,25,45] #CGE
    ENEL=[10,12,15,13] #ENEL (Verificar que tiltil sea de enel)
    CHILQUINTA=[6,9,28,31,32] #CHILQUINTA
    SAESA=[22,23,24,39] #SAESA
    EEPA=[14] #EEPA
    NA=[29,26,34,21,36,33,44,20,40,35,8] #NA
    
        #Agrega IdHolding
    Holding['IdHolding'].mask(Holding['IdDistribuidora'].isin(CGE), 1, inplace=True,)
    Holding['IdHolding'].mask(Holding['IdDistribuidora'].isin(ENEL), 2, inplace=True,)
    Holding['IdHolding'].mask(Holding['IdDistribuidora'].isin(CHILQUINTA), 3, inplace=True,)
    Holding['IdHolding'].mask(Holding['IdDistribuidora'].isin(SAESA), 4, inplace=True,)
    Holding['IdHolding'].mask(Holding['IdDistribuidora'].isin(EEPA), 5, inplace=True,)
    Holding['IdHolding'].mask(Holding['IdDistribuidora'].isin(NA), 6, inplace=True,)
    
        #Agrega el nombre del Holding
    Holding['Holding'].mask(Holding['IdDistribuidora'].isin(CGE), 'CGE', inplace=True,)
    Holding['Holding'].mask(Holding['IdDistribuidora'].isin(ENEL), 'ENEL', inplace=True,)
    Holding['Holding'].mask(Holding['IdDistribuidora'].isin(CHILQUINTA), 'CHILQUINTA', inplace=True,)
    Holding['Holding'].mask(Holding['IdDistribuidora'].isin(SAESA), 'SAESA', inplace=True,)
    Holding['Holding'].mask(Holding['IdDistribuidora'].isin(EEPA), 'EEPA', inplace=True,)
    Holding['Holding'].mask(Holding['IdDistribuidora'].isin(NA), 'No Asociada', inplace=True,)
           
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
    del CGE
    del ENEL
    del CHILQUINTA
    del SAESA
    del EEPA
    del NA
    
    #Agrega Dato de Holding al final de tablas Proy y demanda
        #Efact corregido
    efact_corregido=pd.merge(efact_corregido,Holding,left_on='IdDistribuidora',right_on='IdDistribuidora',how = 'left').iloc[:,:-1]
        #Proyección CEN
    proy=pd.merge(proy,Holding,left_on='IdDistribuidora',right_on='IdDistribuidora',how = 'left').iloc[:,:-1]
    proy=proy[proy.Mes==Fecha_mes]
    
    #Agrega Dato de Holding al final de tabla efact histórico
        #Efact historico
    efact_historico=pd.merge(efact_historico,Holding,left_on='IdDistribuidora',right_on='IdDistribuidora',how = 'left').iloc[:,:-2]
    
    
    
    #############################################################################################
    #CREACIÓN DE TABLAS EFACT_SUMA_dato
    
    #Nivel Holding
        #Crea tabla principal sobre la cual se pegarán resultados ''efact_suma''
    efact_suma_Holding=efact_corregido[['IdHolding','Energia','Potencia']]
        #Suma agrupada por holding para datos reales
    efact_suma_Holding=efact_suma_Holding.groupby(by=['IdHolding']).sum()/1000
        #Vuelve a dejar como indice el Holding (Desaparece con instrucción 'groupby')
    efact_suma_Holding.reset_index(level=[0], inplace=True)
    
    
      #Agrega nombre del Holding
    efact_suma_Holding['Holding']=np.nan
    efact_suma_Holding['Holding'].mask(efact_suma_Holding['IdHolding']==1, 'CGE', inplace=True,)
    efact_suma_Holding['Holding'].mask(efact_suma_Holding['IdHolding']==2, 'ENEL', inplace=True,)
    efact_suma_Holding['Holding'].mask(efact_suma_Holding['IdHolding']==3, 'CHILQUINTA', inplace=True,)
    efact_suma_Holding['Holding'].mask(efact_suma_Holding['IdHolding']==4, 'SAESA', inplace=True,)
    efact_suma_Holding['Holding'].mask(efact_suma_Holding['IdHolding']==5, 'EEPA', inplace=True,)
    efact_suma_Holding['Holding'].mask(efact_suma_Holding['IdHolding']==6, 'No Asociada', inplace=True,)
    
    
    
    #Nivel Distribuidora (Dx)
        #Crea tabla principal sobre la cual se pegarán resultados ''efact_suma''
    efact_suma_Dx=efact_corregido[['IdDistribuidora','Energia','Potencia']]
        #Suma agrupada por Dx para datos reales
    efact_suma_Dx=efact_suma_Dx.groupby(by=['IdDistribuidora']).sum()/1000
       #Vuelve a dejar como indices la fecha y el Holding (Desaparecen con instrucción 'groupby')
    efact_suma_Dx.reset_index(level=[0], inplace=True)
    
        #Agrega nombre Distribuidora
    efact_suma_Dx=pd.merge(efact_suma_Dx,distribuidora.iloc[:,[0,1]],left_on='IdDistribuidora',right_on='IdDistribuidora',how = 'left')
    
    
    
    
    #Nivel Punto Retiro (PR)
        #Crea tabla principal sobre la cual se pegarán resultados ''efact_suma''
    efact_suma_PR=efact_corregido[['IdPuntoRetiro','Energia','Potencia']]
        #Suma agrupada por Dx y fecha
    efact_suma_PR=efact_suma_PR.groupby(by=['IdPuntoRetiro']).sum()/1000
       #Vuelve a dejar como indices la fecha y el Holding (Desaparecen con instrucción 'groupby')
    efact_suma_PR.reset_index(level=[0], inplace=True)
    
        #Agrega nombre a PR
    efact_suma_PR=pd.merge(efact_suma_PR,puntoretiro.iloc[:,[0,1]],left_on='IdPuntoRetiro',right_on='IdPuntoRetiro',how = 'left')
    
    
    
    
    #Nivel Código contrato (CC)
    #Tabla con energia a nivel contrato mes actual (CodigoContrato = CC)
    efact_suma_CC=efact_corregido[['IdCodigoContrato','Energia','Potencia']]
        #Suma agrupada por holding y fecha
    efact_suma_CC=efact_suma_CC.groupby(by=['IdCodigoContrato']).sum()/1000
       #Vuelve a dejar como indices la fecha y el Holding (Desaparecen con instrucción 'groupby')
    efact_suma_CC.reset_index(level=[0], inplace=True)
    
     #Inserta nombre contrato 
    efact_suma_CC=pd.merge(efact_suma_CC,contrato.iloc[:,[0,1]],left_on='IdCodigoContrato',right_on='IdCodigoContrato',how = 'left')
    
    
    
    
    #################################################################
    ######### COMPARACIÓN DATO REAL CON PROYECCIÓN DE LA CNE ########
    #################################################################
    
    #COMPARACIÓN DE ENERGÍA A NIVEL DE HOLDING/MES
        #Crea tabla con proyección para comparar con tabla principal
    proy_suma_Holding=proy[['IdHolding','Demanda']]
        #Cambia formato de datos para evitar problemas con groupby
    proy_suma_Holding['Demanda']=proy_suma_Holding.Demanda.astype(float)
        #Suma agrupada por holding para proyección
    proy_suma_Holding=proy_suma_Holding.groupby(by=['IdHolding']).sum()
        #Vuelve a dejar como indice el Holding (Desaparece con instrucción 'groupby')
    proy_suma_Holding.reset_index(level=[0], inplace=True)
    proy_suma_Holding.rename(columns={"Demanda": "Proyección Energía"},inplace=True)
                                                                  
          #Agrega Proy a tabla efact_suma
    efact_suma_Holding=pd.merge(efact_suma_Holding,proy_suma_Holding,how = 'left')
         #Agrega error c/r a proyección
    efact_suma_Holding['Error Proyección [%]']=100*(efact_suma_Holding['Energia']-efact_suma_Holding['Proyección Energía'])/efact_suma_Holding['Energia']
    
    
    #COMPARACIÓN DE ENERGÍA A NIVEL DE DISTRIBUIDORA/MES
        #Crea tabla con proyección para comparar con tabla principal
    proy_suma_Dx=proy[['IdDistribuidora','Demanda']]
            #Cambia formato de datos para evitar problemas con groupby
    proy_suma_Dx['Demanda']=proy_suma_Dx.Demanda.astype(float)
    
       #Suma agrupada por Dx para proyección
    proy_suma_Dx=proy_suma_Dx.groupby(by=['IdDistribuidora']).sum()
       #Vuelve a dejar como indices la fecha y el Holding (Desaparecen con instrucción 'groupby')
    proy_suma_Dx.reset_index(level=[0], inplace=True)
       #Cálculo de error
    #Crea lista de Distribuidoras que solo están en una tabla
    diferencias_Dx= pd.concat([proy_suma_Dx, efact_suma_Dx], join='outer')
    diferencias_Dx=diferencias_Dx.drop_duplicates(subset=['IdDistribuidora'],keep=False).reset_index()
    
    #Sumar Dx que pertenecen a un holding que no están en la tabla de efact
    for i in range(len(diferencias_Dx)):
        #Recupera índice en tabla proyección
        Groupdx=Holding.IdDx[Holding.IdDistribuidora==diferencias_Dx.loc[i,'index']]
        j=efact_suma_Dx[efact_suma_Dx.IdDistribuidora==int(Groupdx)].index
        #Suma distribuidoras a su holding principal
        proy_suma_Dx.loc[j,'Demanda']=proy_suma_Dx.Demanda[j]+diferencias_Dx.Demanda[i]
        #Elimina Dx que solo están en tabla proyección
        proy_suma_Dx=proy_suma_Dx[~(proy_suma_Dx.IdDistribuidora==diferencias_Dx.loc[i,'IdDistribuidora'])]
        #Reinicia indice
        proy_suma_Dx.reset_index(inplace=True, drop=True)
    
    
    proy_suma_Dx.rename(columns={"Demanda": "Proyección Energía"},inplace=True)
    
          #Agrega Proy a tabla efact_suma
    efact_suma_Dx=pd.merge(efact_suma_Dx,proy_suma_Dx,how = 'left')
          #Agrega Error c/r a proyección
    efact_suma_Dx['Error Proyección [%]']=100*(efact_suma_Dx['Energia']-efact_suma_Dx['Proyección Energía'])/efact_suma_Dx['Energia']
    
    
    
    #COMPARACIÓN DE ENERGÍA A NIVEL DE PUNTO DE RETIRO
    proy_suma_PR=proy[['IdPuntoRetiro','Demanda']]
    proy_suma_PR['Demanda']=proy_suma_PR.Demanda.astype(float)
       #Suma agrupada por Dx y fecha
    proy_suma_PR=proy_suma_PR.groupby(by=['IdPuntoRetiro']).sum()
       #Vuelve a dejar como indices la fecha y el Holding (Desaparecen con instrucción 'groupby')
    proy_suma_PR.reset_index(level=[0], inplace=True)
    proy_suma_PR.rename(columns={"Demanda": "Proyección Energía"},inplace=True)
    
        #Agrega Proy a tabla efact_suma
    efact_suma_PR=pd.merge(efact_suma_PR,proy_suma_PR,how = 'left')
    
       #Agrega Error c/r a proyección
    efact_suma_PR['Error Proyección [%]']=100*(efact_suma_PR['Energia']-efact_suma_PR['Proyección Energía'])/efact_suma_PR['Energia']
    
    
    #################################################################
    ######### COMPARACIÓN DATO REAL CON MES ANTERIOR ################
    #################################################################
    
    efact_1m=efact_historico[efact_historico['Fecha']==Fecha_mes_max]
    
    #NIVEL HOLDING
    efact_1m_Holding=efact_1m[['IdHolding','Energia','Potencia']]
        #Suma agrupada por holding y fecha
    efact_1m_Holding=efact_1m_Holding.groupby(by=['IdHolding']).sum()/1000
    efact_1m_Holding.reset_index(level=[0], inplace=True)
    efact_1m_Holding.rename(columns={"Energia": "Energía Mes anterior"},inplace=True)
    efact_1m_Holding.rename(columns={"Potencia": "Potencia Mes anterior"},inplace=True)
    #Agrega mes anterior a tabla efact_suma
    efact_suma_Holding=pd.merge(efact_suma_Holding,efact_1m_Holding,how = 'left')
    
        #Agrega error c/r a mes anterior
    efact_suma_Holding['Error Energía c/r mes anterior [%]']=abs(100*(efact_suma_Holding['Energia']-efact_suma_Holding['Energía Mes anterior'])/efact_suma_Holding['Energia'])
    efact_suma_Holding['Error Potencia c/r mes anterior [%]']=abs(100*(efact_suma_Holding['Potencia']-efact_suma_Holding['Potencia Mes anterior'])/efact_suma_Holding['Potencia'])
    
    #NIVEL DISTRIBUIDORA
    efact_1m_Dx=efact_1m[['IdDistribuidora','Energia','Potencia']]
        #Suma agrupada por holding y fecha
    efact_1m_Dx=efact_1m_Dx.groupby(by=['IdDistribuidora']).sum()/1000
    efact_1m_Dx.reset_index(level=[0], inplace=True)
    efact_1m_Dx.rename(columns={"Energia": "Energía Mes anterior"},inplace=True)
    efact_1m_Dx.rename(columns={"Potencia": "Potencia Mes anterior"},inplace=True)
    #Agrega mes anterior a tabla efact_suma
    efact_suma_Dx=pd.merge(efact_suma_Dx,efact_1m_Dx,how = 'left')
    
    
        #Agrega error c/r a mes anterior
    efact_suma_Dx['Error Energía c/r mes anterior [%]']=100*(efact_suma_Dx['Energia']-efact_suma_Dx['Energía Mes anterior'])/efact_suma_Dx['Energia']
    efact_suma_Dx['Error Potencia c/r mes anterior [%]']=100*(efact_suma_Dx['Potencia']-efact_suma_Dx['Potencia Mes anterior'])/efact_suma_Dx['Potencia']
    
    
    
    #NIVEL PUNTO RETIRO
    efact_1m_PR=efact_1m[['IdPuntoRetiro','Energia','Potencia']]
        #Suma agrupada por holding y fecha
    efact_1m_PR=efact_1m_PR.groupby(by=['IdPuntoRetiro']).sum()/1000
    efact_1m_PR.reset_index(level=[0], inplace=True)
    efact_1m_PR.rename(columns={"Energia": "Energía Mes anterior"},inplace=True)
    efact_1m_PR.rename(columns={"Potencia": "Potencia Mes anterior"},inplace=True)
    #Agrega mes anterior a tabla efact_suma
    efact_suma_PR=pd.merge(efact_suma_PR,efact_1m_PR,how = 'left')
    
      #Agrega error c/r a mes anterior
    efact_suma_PR['Error Energía c/r mes anterior [%]']=100*(efact_suma_PR['Energia']-efact_suma_PR['Energía Mes anterior'])/efact_suma_PR['Energia']
    efact_suma_PR['Error Potencia c/r mes anterior [%]']=100*(efact_suma_PR['Potencia']-efact_suma_PR['Potencia Mes anterior'])/efact_suma_PR['Potencia']
    
    
    
    #NIVEL CONTRATO
    efact_1m_CC=efact_1m[['IdCodigoContrato','Energia','Potencia']]
        #Suma agrupada por holding y fecha
    efact_1m_CC=efact_1m_CC.groupby(by=['IdCodigoContrato']).sum()/1000
    efact_1m_CC.reset_index(level=[0], inplace=True)
    efact_1m_CC.rename(columns={"Energia": "Energía Mes anterior"},inplace=True)
    efact_1m_CC.rename(columns={"Potencia": "Potencia Mes anterior"},inplace=True)
    #Agrega mes anterior a tabla efact_suma
    efact_suma_CC=pd.merge(efact_suma_CC,efact_1m_CC,how = 'left')
    
      #Agrega error c/r a mes anterior
    efact_suma_CC['Error Energía c/r mes anterior [%]']=100*(efact_suma_CC['Energia']-efact_suma_CC['Energía Mes anterior'])/efact_suma_CC['Energia']
    efact_suma_CC['Error Potencia c/r mes anterior [%]']=100*(efact_suma_CC['Potencia']-efact_suma_CC['Potencia Mes anterior'])/efact_suma_CC['Potencia']
    
    
    
    #################################################################
    ######## COMPARACIÓN DATO REAL CON VENTANA 12 MESES #############
    #################################################################
    
    #NIVEL HOLDING
        #Crea tabla con datos necesarios desde efact_historico para la comparación a nivel holding
    efact_12M_Holding=efact_historico[['IdHolding','Fecha','Energia','Potencia']]
        #Agrupa y suma datos por holding y fecha
    efact_12M_Holding=efact_12M_Holding.groupby(by=['IdHolding','Fecha']).sum().groupby(level=[0,1]).sum()/1000
        #Calcula promedio agrupando por fecha y cambia nombre a columna 
    efact_12M_promedio=efact_12M_Holding.groupby(by=['IdHolding']).mean().rename(columns={"Energia": "Energía Promedio 12 Meses","Potencia": "Potencia Promedio 12 Meses"})
        #Calcula desviación estándar por fecha
    efact_12M_std=efact_12M_Holding.groupby(by=['IdHolding']).std()
        #Deja tabla efact_12M en el formato deseado para hacer cruce con efact_suma_holding (tabla del mes presente)
    efact_12M_Holding=efact_12M_promedio
        #Crea columna con desviación estándar
    efact_12M_Holding[['Desviacion Energía 12 Meses','Desviacion Potencia 12 Meses']]=efact_12M_std
        #Deja el IdHoling como columna (groupby lo deja como indice) para hacer cruce de datos
    efact_12M_Holding.reset_index(level=[0], inplace=True)
    
    #Tabla con promedio y desviación estándar (aun sin mensaje de error)
    efact_suma_Holding=pd.merge(efact_suma_Holding,efact_12M_Holding,how = 'left')
    
    del efact_12M_promedio
    del efact_12M_std
    
    #Agrega error c/r a promedio
    efact_suma_Holding['Error Energía c/r a promedio [%]']=100*(efact_suma_Holding['Energia']-efact_suma_Holding['Energía Promedio 12 Meses'])/efact_suma_Holding['Energia']
    efact_suma_Holding['Error Potencia c/r a promedio [%]']=100*(efact_suma_Holding['Potencia']-efact_suma_Holding['Potencia Promedio 12 Meses'])/efact_suma_Holding['Potencia']
    
    
    #NIVEL DISTRIBUIDORA
        #Crea tabla con datos necesarios desde efact_historico para la comparación a nivel distribuidora
    efact_12M_Dx=efact_historico[['IdDistribuidora','Fecha','Energia','Potencia']]
        #Agrupa y suma datos por holding y fecha
    efact_12M_Dx=efact_12M_Dx.groupby(by=['IdDistribuidora','Fecha']).sum().groupby(level=[0,1]).sum()/1000
        #Calcula promedio agrupando por fecha y cambia nombre a columna 
    efact_12M_promedio=efact_12M_Dx.groupby(by=['IdDistribuidora']).mean().rename(columns={"Energia": "Energía Promedio 12 Meses","Potencia": "Potencia Promedio 12 Meses"})
        #Calcula desviación estándar por fecha
    efact_12M_std=efact_12M_Dx.groupby(by=['IdDistribuidora']).std()
        #Deja tabla efact_12M en el formato deseado para hacer cruce con efact_suma_holding (tabla del mes presente)
    efact_12M_Dx=efact_12M_promedio
        #Crea columna con desviación estándar
    efact_12M_Dx[['Desviacion Energía 12 Meses','Desviacion Potencia 12 Meses']]=efact_12M_std
        #Deja el IdHoling como columna (groupby lo deja como indice) para hacer cruce de datos
    efact_12M_Dx.reset_index(level=[0], inplace=True)
    
    del efact_12M_promedio
    del efact_12M_std
    
        #Distribuidoras que solo están en una tabla (Se comenta porque no hay ninguna dx que esté en efact_historico)
    #diferencias_12Dx=pd.concat([efact_12M_Dx, efact_suma_Dx], join='outer')
    #diferencias_12Dx=diferencias_12Dx.drop_duplicates(subset=['IdDistribuidora'],keep=False).reset_index()
    
        #Tabla con promedio y desviación estándar (aun sin mensaje de error)
    efact_suma_Dx=pd.merge(efact_suma_Dx,efact_12M_Dx,how = 'left')
    
    #Agrega error c/r a promedio
    efact_suma_Dx['Error Energía c/r a promedio [%]']=100*(efact_suma_Dx['Energia']-efact_suma_Dx['Energía Promedio 12 Meses'])/efact_suma_Dx['Energia']
    efact_suma_Dx['Error Potencia c/r a promedio [%]']=100*(efact_suma_Dx['Potencia']-efact_suma_Dx['Potencia Promedio 12 Meses'])/efact_suma_Dx['Potencia']
    
    
    
    #NIVEL PUNTO RETIRO
     #Crea tabla con datos necesarios desde efact_historico para la comparación a nivel distribuidora
    efact_12M_PR=efact_historico[['IdPuntoRetiro','Fecha','Energia','Potencia']]
        #Agrupa y suma datos por holding y fecha
    efact_12M_PR=efact_12M_PR.groupby(by=['IdPuntoRetiro','Fecha']).sum().groupby(level=[0,1]).sum()/1000
        #Calcula promedio agrupando por fecha y cambia nombre a columna 
    efact_12M_promedio=efact_12M_PR.groupby(by=['IdPuntoRetiro']).mean().rename(columns={"Energia": "Energía Promedio 12 Meses","Potencia": "Potencia Promedio 12 Meses"})
        #Calcula desviación estándar por fecha
    efact_12M_std=efact_12M_PR.groupby(by=['IdPuntoRetiro']).std()
        #Deja tabla efact_12M en el formato deseado para hacer cruce con efact_suma_holding (tabla del mes presente)
    efact_12M_PR=efact_12M_promedio
        #Crea columna con desviación estándar
    efact_12M_PR[['Desviacion Energía 12 Meses','Desviacion Potencia 12 Meses']]=efact_12M_std
        #Deja el IdHoling como columna (groupby lo deja como indice) para hacer cruce de datos
    efact_12M_PR.reset_index(level=[0], inplace=True)
    
        #Tabla con promedio y desviación estándar (aun sin mensaje de error)
    efact_suma_PR=pd.merge(efact_suma_PR,efact_12M_PR,how = 'left')
    
    del efact_12M_promedio
    del efact_12M_std
    
    #Agrega error c/r a promedio
    efact_suma_PR['Error Energía c/r a promedio [%]']=100*(efact_suma_PR['Energia']-efact_suma_PR['Energía Promedio 12 Meses'])/efact_suma_PR['Energia']
    efact_suma_PR['Error Potencia c/r a promedio [%]']=100*(efact_suma_PR['Potencia']-efact_suma_PR['Potencia Promedio 12 Meses'])/efact_suma_PR['Potencia']
    
    
    
    
    
    #NIVEL CONTRATO
     #Crea tabla con datos necesarios desde efact_historico para la comparación a nivel distribuidora
    efact_12M_CC=efact_historico[['IdCodigoContrato','Fecha','Energia','Potencia']]
        #Agrupa y suma datos por holding y fecha
    efact_12M_CC=efact_12M_CC.groupby(by=['IdCodigoContrato','Fecha']).sum().groupby(level=[0,1]).sum()/1000
        #Calcula promedio agrupando por fecha y cambia nombre a columna 
    efact_12M_promedio=efact_12M_CC.groupby(by=['IdCodigoContrato']).mean().rename(columns={"Energia": "Energía Promedio 12 Meses","Potencia": "Potencia Promedio 12 Meses"})
        #Calcula desviación estándar por fecha
    efact_12M_std=efact_12M_CC.groupby(by=['IdCodigoContrato']).std()
        #Deja tabla efact_12M en el formato deseado para hacer cruce con efact_suma_holding (tabla del mes presente)
    efact_12M_CC=efact_12M_promedio
        #Crea columna con desviación estándar
    efact_12M_CC[['Desviacion Energía 12 Meses','Desviacion Potencia 12 Meses']]=efact_12M_std
        #Deja el IdHoling como columna (groupby lo deja como indice) para hacer cruce de datos
    efact_12M_CC.reset_index(level=[0], inplace=True)
    
    del efact_12M_promedio
    del efact_12M_std
    
    #Tabla con promedio y desviación estándar 
    efact_suma_CC=pd.merge(efact_suma_CC,efact_12M_CC,how = 'left')
    
    #Agrega error c/r a promedio
    efact_suma_CC['Error Energía c/r a promedio [%]']=100*(efact_suma_CC['Energia']-efact_suma_CC['Energía Promedio 12 Meses'])/efact_suma_CC['Energia']
    efact_suma_CC['Error Potencia c/r a promedio [%]']=100*(efact_suma_CC['Potencia']-efact_suma_CC['Potencia Promedio 12 Meses'])/efact_suma_CC['Potencia']
    
    
    
    ### Elimino tablas que ya no necesito (están en tablas efact_suma) ###
    del efact_1m
    del efact_1m_CC
    del efact_1m_Dx
    del efact_1m_Holding
    del efact_1m_PR
    del efact_12M_CC
    del efact_12M_Dx
    del efact_12M_Holding
    del efact_12M_PR
    del diferencias_Dx
    del proy_suma_Dx
    del proy_suma_Holding
    del proy_suma_PR
    del i
    del j
    del proy
    del Groupdx
    
    
    
    #################################################################
    ########### FLAG DE DATOS CON DUDA EN SU CALIDAD ################
    #################################################################
    
    #NIVEL HOLDING
    
    #Agregar comentario de error cuando se cumple condición
        #Crea columnas con observaciones, luego serán borradas
    efact_suma_Holding['Proy']=''
    efact_suma_Holding['Energia_1m']=''
    efact_suma_Holding['Energia_12m']=''
    efact_suma_Holding['Potencia_1m']=''
    efact_suma_Holding['Potencia_12m']=''
    
        #Agrega mensaje de error a observaciones creadas. Si se cumple condición agrega comentario
        #Proyección con porcentaje de error mayor a umbral porciento
    umbral_proy=10
    umbral_1m_E=10
    umbral_1m_P=10
    
        #Rellena columna de error de proyección cuando se cumple que error es mayor a umbral
    efact_suma_Holding['Proy'].mask(abs(efact_suma_Holding['Error Proyección [%]'])>=umbral_proy, '|Energía alejada de proyección en un ', inplace=True)
        #Crea columna temporal que recupera porcentaje en lugares donde se cumple la condición descrita anteriormente
        #Esto se hace porque con la función mask no se puede hacer directamente
    efact_suma_Holding['temp']=efact_suma_Holding[efact_suma_Holding['Proy']!='']['Error Proyección [%]'].to_frame().applymap(int).applymap(str)+'[%]|'
        #Se rellenan nan en lugares donde no se cumplía la condición, así la observación no es nan cuando se suman los strings 
    efact_suma_Holding['temp'].fillna(value='',inplace=True)
        #Se agrega porcentaje a la columna principal
    efact_suma_Holding['Proy']=efact_suma_Holding['Proy']+efact_suma_Holding['temp']
        #Se elimina columna temporal
    efact_suma_Holding.drop(['temp'],axis=1,inplace=True)
    
        #Rellena columna de error de mes anterior cuando se cumple que error es mayor a umbral
    efact_suma_Holding['Energia_1m'].mask(abs(efact_suma_Holding['Error Energía c/r mes anterior [%]'])>=umbral_1m_E, '|Energía alejada de mes anterior en un ', inplace=True)
        #Crea columna temporal que recupera porcentaje en lugares donde se cumple la condición descrita anteriormente
        #Esto se hace porque con la función mask no se puede hacer directamente
    efact_suma_Holding['temp']=efact_suma_Holding[efact_suma_Holding['Energia_1m']!='']['Error Energía c/r mes anterior [%]'].to_frame().applymap(int).applymap(str)+'[%]|'
        #Se rellenan nan en lugares donde no se cumplía la condición, así la observación no es nan cuando se suman los strings 
    efact_suma_Holding['temp'].fillna(value='',inplace=True)
        #Se agrega porcentaje a la columna principal
    efact_suma_Holding['Energia_1m']=efact_suma_Holding['Energia_1m']+efact_suma_Holding['temp']
        #Se elimina columna temporal
    efact_suma_Holding.drop(['temp'],axis=1,inplace=True)
                        
        #Se repite proceso anterior pero para columna de potencia
    efact_suma_Holding['Potencia_1m'].mask(abs(efact_suma_Holding['Error Potencia c/r mes anterior [%]'])>=umbral_1m_P, '|Potencia alejada de mes anterior en un ', inplace=True)
    efact_suma_Holding['temp']=efact_suma_Holding[efact_suma_Holding['Potencia_1m']!='']['Error Potencia c/r mes anterior [%]'].to_frame().applymap(int).applymap(str)+'[%]|'
    efact_suma_Holding['temp'].fillna(value='',inplace=True)
    efact_suma_Holding['Potencia_1m']=efact_suma_Holding['Potencia_1m']+efact_suma_Holding['temp']
    efact_suma_Holding.drop(['temp'],axis=1,inplace=True)
    
    
        #Se crea vector bool con condición en la que Energía es mayor a Promedio-2*DesvEst
    cond1=efact_suma_Holding['Energia']>=efact_suma_Holding['Energía Promedio 12 Meses']-2*efact_suma_Holding['Desviacion Energía 12 Meses']
        #Se crea vector bool con condición en la que Energía es menor a Promedio+2*DesvEst
    cond2=efact_suma_Holding['Energia']<=efact_suma_Holding['Energía Promedio 12 Meses']+2*efact_suma_Holding['Desviacion Energía 12 Meses']
        #Se rellenan filas donde se cumple cond1 y cond2, es decir donde Energía está dentro de intervalo 2*DesvEst
    efact_suma_Holding['Energia_12m'].where((cond1) & (cond2), '|Energía alejada de promedio de 12 meses anteriores en un ', inplace=True)
        #Se agrega error con respecto a promedio de 12 meses a Warning 
    efact_suma_Holding['temp']=efact_suma_Holding[efact_suma_Holding['Energia_12m']!='']['Error Energía c/r a promedio [%]'].to_frame().applymap(int).applymap(str)+'[%], lo cual está fuera de invervalo de 2 veces la desviación estándar|'
        #Se rellenan nan
    efact_suma_Holding['temp'].fillna(value='',inplace=True)
        #Se agrega mensaje a columna principal
    efact_suma_Holding['Energia_12m']=efact_suma_Holding['Energia_12m']+efact_suma_Holding['temp']
        #Se elimina columna temporal
    efact_suma_Holding.drop(['temp'],axis=1,inplace=True)
    
    #Se eliminan columnas bool de condición
    del cond1
    del cond2
    
        #Se repite proceso anterior pero para columna de potencia
    cond1=efact_suma_Holding['Potencia']>=efact_suma_Holding['Potencia Promedio 12 Meses']-2*efact_suma_Holding['Desviacion Potencia 12 Meses']
    cond2=efact_suma_Holding['Potencia']<=efact_suma_Holding['Potencia Promedio 12 Meses']+2*efact_suma_Holding['Desviacion Potencia 12 Meses']
    efact_suma_Holding['Potencia_12m'].where((cond1) & (cond2), '|Potencia alejada de promedio de 12 meses anteriores en un ', inplace=True)
    efact_suma_Holding['temp']=efact_suma_Holding[efact_suma_Holding['Potencia_12m']!='']['Error Potencia c/r a promedio [%]'].to_frame().applymap(int).applymap(str)+'[%], lo cual está fuera de invervalo de 2 veces la desviación estándar|'
    efact_suma_Holding['temp'].fillna(value='',inplace=True)
    efact_suma_Holding['Potencia_12m']=efact_suma_Holding['Potencia_12m']+efact_suma_Holding['temp']
    efact_suma_Holding.drop(['temp'],axis=1,inplace=True)
    
    
    #Se eliminan columnas bool de condición y umbrales para no tener tantas variables en el explorador
    del cond1
    del cond2
    del umbral_proy
    del umbral_1m_E
    del umbral_1m_P
    
        #Suma strings con errores y los pega en columna Observación original
    efact_suma_Holding['Observación']=efact_suma_Holding['Proy']+efact_suma_Holding['Energia_1m']+efact_suma_Holding['Energia_12m']+efact_suma_Holding['Potencia_1m']+efact_suma_Holding['Potencia_12m']
    
        #Elimina columnas creadas
    efact_suma_Holding.drop(['Proy', 'Energia_1m','Energia_12m', 'Potencia_1m','Potencia_12m'], axis=1, inplace=True)
    #Warning_Holding=efact_suma_Holding[efact_suma_Holding['Observación']!='']
    
    #NIVEL DISTRIBUIDORA
    #Agregar comentario de error cuando se cumple condición
        #Crea columnas con observaciones, luego serán borradas
    efact_suma_Dx['Proy']=''
    efact_suma_Dx['Energia_1m']=''
    efact_suma_Dx['Energia_12m']=''
    efact_suma_Dx['Potencia_1m']=''
    efact_suma_Dx['Potencia_12m']=''
    
        #Agrega mensaje de error a observaciones creadas. Si se cumple condición agrega comentario
        #Proyección con porcentaje de error mayor a umbral porciento
    umbral_proy=10
    umbral_1m_E=10
    umbral_1m_P=10
    
        #Rellena columna de error de proyección cuando se cumple que error es mayor a umbral
    efact_suma_Dx['Proy'].mask(abs(efact_suma_Dx['Error Proyección [%]'])>=umbral_proy, '|Energía alejada de proyección en un ', inplace=True)
        #Crea columna temporal que recupera porcentaje en lugares donde se cumple la condición descrita anteriormente
        #Esto se hace porque con la función mask no se puede hacer directamente
    efact_suma_Dx['temp']=efact_suma_Dx[efact_suma_Dx['Proy']!='']['Error Proyección [%]'].to_frame().applymap(int).applymap(str)+'[%]|'
        #Se rellenan nan en lugares donde no se cumplía la condición, así la observación no es nan cuando se suman los strings 
    efact_suma_Dx['temp'].fillna(value='',inplace=True)
        #Se agrega porcentaje a la columna principal
    efact_suma_Dx['Proy']=efact_suma_Dx['Proy']+efact_suma_Dx['temp']
        #Se elimina columna temporal
    efact_suma_Dx.drop(['temp'],axis=1,inplace=True)
    
        #Rellena columna de error de mes anterior cuando se cumple que error es mayor a umbral
    efact_suma_Dx['Energia_1m'].mask(abs(efact_suma_Dx['Error Energía c/r mes anterior [%]'])>=umbral_1m_E, '|Energía alejada de mes anterior en un ', inplace=True)
        #Crea columna temporal que recupera porcentaje en lugares donde se cumple la condición descrita anteriormente
        #Esto se hace porque con la función mask no se puede hacer directamente
    efact_suma_Dx['temp']=efact_suma_Dx[efact_suma_Dx['Energia_1m']!='']['Error Energía c/r mes anterior [%]'].to_frame().applymap(int).applymap(str)+'[%]|'
        #Se rellenan nan en lugares donde no se cumplía la condición, así la observación no es nan cuando se suman los strings 
    efact_suma_Dx['temp'].fillna(value='',inplace=True)
        #Se agrega porcentaje a la columna principal
    efact_suma_Dx['Energia_1m']=efact_suma_Dx['Energia_1m']+efact_suma_Dx['temp']
        #Se elimina columna temporal
    efact_suma_Dx.drop(['temp'],axis=1,inplace=True)
                        
        #Se repite proceso anterior pero para columna de potencia
    efact_suma_Dx['Potencia_1m'].mask(abs(efact_suma_Dx['Error Potencia c/r mes anterior [%]'])>=umbral_1m_P, '|Potencia alejada de mes anterior en un ', inplace=True)
    efact_suma_Dx['temp']=efact_suma_Dx[efact_suma_Dx['Potencia_1m']!='']['Error Potencia c/r mes anterior [%]'].to_frame().applymap(int).applymap(str)+'[%]|'
    efact_suma_Dx['temp'].fillna(value='',inplace=True)
    efact_suma_Dx['Potencia_1m']=efact_suma_Dx['Potencia_1m']+efact_suma_Dx['temp']
    efact_suma_Dx.drop(['temp'],axis=1,inplace=True)
    
    
        #Se crea vector bool con condición en la que Energía es mayor a Promedio-2*DesvEst
    cond1=efact_suma_Dx['Energia']>=efact_suma_Dx['Energía Promedio 12 Meses']-2*efact_suma_Dx['Desviacion Energía 12 Meses']
        #Se crea vector bool con condición en la que Energía es menor a Promedio+2*DesvEst
    cond2=efact_suma_Dx['Energia']<=efact_suma_Dx['Energía Promedio 12 Meses']+2*efact_suma_Dx['Desviacion Energía 12 Meses']
        #Se rellenan filas donde se cumple cond1 y cond2, es decir donde Energía está dentro de intervalo 2*DesvEst
    efact_suma_Dx['Energia_12m'].where((cond1) & (cond2), '|Energía alejada de promedio de 12 meses anteriores en un ', inplace=True)
        #Se agrega error con respecto a promedio de 12 meses a Warning 
    efact_suma_Dx['temp']=efact_suma_Dx[efact_suma_Dx['Energia_12m']!='']['Error Energía c/r a promedio [%]'].to_frame().applymap(int).applymap(str)+'[%], lo cual está fuera de invervalo de 2 veces la desviación estándar|'
        #Se rellenan nan
    efact_suma_Dx['temp'].fillna(value='',inplace=True)
        #Se agrega mensaje a columna principal
    efact_suma_Dx['Energia_12m']=efact_suma_Dx['Energia_12m']+efact_suma_Dx['temp']
        #Se elimina columna temporal
    efact_suma_Dx.drop(['temp'],axis=1,inplace=True)
    
    #Se eliminan columnas bool de condición
    del cond1
    del cond2
    
        #Se repite proceso anterior pero para columna de potencia
    cond1=efact_suma_Dx['Potencia']>=efact_suma_Dx['Potencia Promedio 12 Meses']-2*efact_suma_Dx['Desviacion Potencia 12 Meses']
    cond2=efact_suma_Dx['Potencia']<=efact_suma_Dx['Potencia Promedio 12 Meses']+2*efact_suma_Dx['Desviacion Potencia 12 Meses']
    efact_suma_Dx['Potencia_12m'].where((cond1) & (cond2), '|Potencia alejada de promedio de 12 meses anteriores en un ', inplace=True)
    efact_suma_Dx['temp']=efact_suma_Dx[efact_suma_Dx['Potencia_12m']!='']['Error Potencia c/r a promedio [%]'].to_frame().applymap(int).applymap(str)+'[%], lo cual está fuera de invervalo de 2 veces la desviación estándar|'
    efact_suma_Dx['temp'].fillna(value='',inplace=True)
    efact_suma_Dx['Potencia_12m']=efact_suma_Dx['Potencia_12m']+efact_suma_Dx['temp']
    efact_suma_Dx.drop(['temp'],axis=1,inplace=True)
    
    
    #Se eliminan columnas bool de condición y umbrales para no tener tantas variables en el explorador
    del cond1
    del cond2
    del umbral_proy
    del umbral_1m_E
    del umbral_1m_P
    
        #Suma strings con errores y los pega en columna Observación original
    efact_suma_Dx['Observación']=efact_suma_Dx['Proy']+efact_suma_Dx['Energia_1m']+efact_suma_Dx['Energia_12m']+efact_suma_Dx['Potencia_1m']+efact_suma_Dx['Potencia_12m']
    
        #Elimina columnas creadas
    efact_suma_Dx.drop(['Proy', 'Energia_1m','Energia_12m', 'Potencia_1m','Potencia_12m'], axis=1, inplace=True)
    #Warning_Dx=efact_suma_Dx[efact_suma_Dx['Observación']!='']
    
    
    #NIVEL PUNTO RETIRO
    #Agregar comentario de error cuando se cumple condición
        #Crea columnas con observaciones, luego serán borradas
    efact_suma_PR['Proy']=''
    efact_suma_PR['Energia_1m']=''
    efact_suma_PR['Energia_12m']=''
    efact_suma_PR['Potencia_1m']=''
    efact_suma_PR['Potencia_12m']=''
    
        #Agrega mensaje de error a observaciones creadas. Si se cumple condición agrega comentario
        #Proyección con porcentaje de error mayor a umbral porciento
    umbral_proy=20
    umbral_1m_E=20
    umbral_1m_P=20
    
        #Rellena columna de error de proyección cuando se cumple que error es mayor a umbral 
    efact_suma_PR['Proy'].mask(~np.isinf(efact_suma_PR['Error Proyección [%]']) & abs(efact_suma_PR['Error Proyección [%]'])>=umbral_proy, '|Energía alejada de proyección en un ', inplace=True)
        #Crea columna temporal que recupera porcentaje en lugares donde se cumple la condición descrita anteriormente
        #Esto se hace porque con la función mask no se puede hacer directamente
    efact_suma_PR['temp']=efact_suma_PR[efact_suma_PR['Proy']!='']['Error Proyección [%]'].to_frame().applymap(int).applymap(str)+'[%]|'
        #Se rellenan nan en lugares donde no se cumplía la condición, así la observación no es nan cuando se suman los strings 
    efact_suma_PR['temp'].fillna(value='',inplace=True)
        #Se agrega porcentaje a la columna principal
    efact_suma_PR['Proy']=efact_suma_PR['Proy']+efact_suma_PR['temp']
        #Se elimina columna temporal
    efact_suma_PR.drop(['temp'],axis=1,inplace=True)
        #Caso Energía cero y proyección mayor a cero
    efact_suma_PR['Proy'].mask(np.isinf(efact_suma_PR['Error Proyección [%]']), '|Energía es 0 y proyección indica que debería haber Energía en ese punto|', inplace=True)
    efact_suma_PR['Proy'].mask(efact_suma_PR['Proyección Energía'].isna(), '|Proyección no existe para este punto|', inplace=True)
    
    
        #Rellena columna de error de mes anterior cuando se cumple que error es mayor a umbral
    efact_suma_PR['Energia_1m'].mask(~np.isinf(efact_suma_PR['Error Energía c/r mes anterior [%]']) & abs(efact_suma_PR['Error Energía c/r mes anterior [%]'])>=umbral_1m_E, '|Energía alejada de mes anterior en un ', inplace=True)
        #Crea columna temporal que recupera porcentaje en lugares donde se cumple la condición descrita anteriormente
        #Esto se hace porque con la función mask no se puede hacer directamente
    efact_suma_PR['temp']=efact_suma_PR[efact_suma_PR['Energia_1m']!='']['Error Energía c/r mes anterior [%]'].to_frame().applymap(int).applymap(str)+'[%]|'
        #Se rellenan nan en lugares donde no se cumplía la condición, así la observación no es nan cuando se suman los strings 
    efact_suma_PR['temp'].fillna(value='',inplace=True)
        #Se agrega porcentaje a la columna principal
    efact_suma_PR['Energia_1m']=efact_suma_PR['Energia_1m']+efact_suma_PR['temp']
        #Se elimina columna temporal
    efact_suma_PR.drop(['temp'],axis=1,inplace=True)
        #Caso Energía cero y mes siguiente mayor a cero
    efact_suma_PR['Energia_1m'].mask(np.isinf(efact_suma_PR['Error Energía c/r mes anterior [%]']), '|Energía es cero y en mes anterior era mayor a cero|', inplace=True)
    
    
        #Se repite proceso anterior pero para columna de potencia
    efact_suma_PR['Potencia_1m'].mask(~np.isinf(efact_suma_PR['Error Potencia c/r mes anterior [%]']) & abs(efact_suma_PR['Error Potencia c/r mes anterior [%]'])>=umbral_1m_P, '|Potencia alejada de mes anterior en un ', inplace=True)
    efact_suma_PR['temp']=efact_suma_PR[efact_suma_PR['Potencia_1m']!='']['Error Potencia c/r mes anterior [%]'].to_frame().applymap(int).applymap(str)+'[%]|'
    efact_suma_PR['temp'].fillna(value='',inplace=True)
    efact_suma_PR['Potencia_1m']=efact_suma_PR['Potencia_1m']+efact_suma_PR['temp']
    efact_suma_PR.drop(['temp'],axis=1,inplace=True)
    efact_suma_PR['Potencia_1m'].mask(np.isinf(efact_suma_PR['Error Potencia c/r mes anterior [%]']), '|Potencia es cero y en mes anterior era mayor a cero|', inplace=True)
    
    
        #Se crea vector bool con condición en la que Energía es mayor a Promedio-2*DesvEst
    cond1=efact_suma_PR['Energia']>=efact_suma_PR['Energía Promedio 12 Meses']-2*efact_suma_PR['Desviacion Energía 12 Meses']
        #Se crea vector bool con condición en la que Energía es menor a Promedio+2*DesvEst
    cond2=efact_suma_PR['Energia']<=efact_suma_PR['Energía Promedio 12 Meses']+2*efact_suma_PR['Desviacion Energía 12 Meses']
        #Se rellenan filas donde se cumple cond1 y cond2, es decir donde Energía está dentro de intervalo 2*DesvEst
    efact_suma_PR['Energia_12m'].where((np.isinf(efact_suma_PR['Error Energía c/r a promedio [%]'])) | ((cond1) & (cond2)), '|Energía alejada de promedio de 12 meses anteriores en un ', inplace=True)
        #Se agrega error con respecto a promedio de 12 meses a Warning 
    efact_suma_PR['temp']=efact_suma_PR[efact_suma_PR['Energia_12m']!='']['Error Energía c/r a promedio [%]'].to_frame().applymap(int).applymap(str)+'[%], lo cual está fuera de invervalo de 2 veces la desviación estándar|'
        #Se rellenan nan
    efact_suma_PR['temp'].fillna(value='',inplace=True)
        #Se agrega mensaje a columna principal
    efact_suma_PR['Energia_12m']=efact_suma_PR['Energia_12m']+efact_suma_PR['temp']
        #Se elimina columna temporal
    efact_suma_PR.drop(['temp'],axis=1,inplace=True)
    
    
    
    #Se eliminan columnas bool de condición
    del cond1
    del cond2
    
        #Se repite proceso anterior pero para columna de potencia
    cond1=efact_suma_PR['Potencia']>=efact_suma_PR['Potencia Promedio 12 Meses']-2*efact_suma_PR['Desviacion Potencia 12 Meses']
    cond2=efact_suma_PR['Potencia']<=efact_suma_PR['Potencia Promedio 12 Meses']+2*efact_suma_PR['Desviacion Potencia 12 Meses']
    efact_suma_PR['Potencia_12m'].where(np.isinf(efact_suma_PR['Error Potencia c/r a promedio [%]']) | ((cond1) & (cond2)), '|Potencia alejada de promedio de 12 meses anteriores en un ', inplace=True)
    efact_suma_PR['temp']=efact_suma_PR[efact_suma_PR['Potencia_12m']!='']['Error Potencia c/r a promedio [%]'].to_frame().applymap(int).applymap(str)+'[%], lo cual está fuera de invervalo de 2 veces la desviación estándar|'
    efact_suma_PR['temp'].fillna(value='',inplace=True)
    efact_suma_PR['Potencia_12m']=efact_suma_PR['Potencia_12m']+efact_suma_PR['temp']
    efact_suma_PR.drop(['temp'],axis=1,inplace=True)
    
    
    #Se eliminan columnas bool de condición y umbrales para no tener tantas variables en el explorador
    del cond1
    del cond2
    del umbral_proy
    del umbral_1m_E
    del umbral_1m_P
    
        #Suma strings con errores y los pega en columna Observación original
    efact_suma_PR['Observación']=efact_suma_PR['Proy']+efact_suma_PR['Energia_1m']+efact_suma_PR['Energia_12m']+efact_suma_PR['Potencia_1m']+efact_suma_PR['Potencia_12m']
    
        #Elimina columnas creadas
    efact_suma_PR.drop(['Proy', 'Energia_1m','Energia_12m', 'Potencia_1m','Potencia_12m'], axis=1, inplace=True)
    #Warning_PR=efact_suma_PR[efact_suma_PR['Observación']!='']
    
    
    
    
    #NIVEL CONTRATO
    #Agregar comentario de error cuando se cumple condición
        #Crea columnas con observaciones, luego serán borradas
    efact_suma_CC['Energia_1m']=''
    efact_suma_CC['Energia_12m']=''
    efact_suma_CC['Potencia_1m']=''
    efact_suma_CC['Potencia_12m']=''
    
        #Agrega mensaje de error a observaciones creadas. Si se cumple condición agrega comentario
    umbral_1m_E=30
    umbral_1m_P=30
    
    
        #Rellena columna de error de mes anterior cuando se cumple que error es mayor a umbral
    efact_suma_CC['Energia_1m'].mask((~np.isinf(efact_suma_CC['Error Energía c/r mes anterior [%]'])) & (~(efact_suma_CC['Error Energía c/r mes anterior [%]']).isna()) & abs(efact_suma_CC['Error Energía c/r mes anterior [%]'])>=umbral_1m_E, '|Energía alejada de mes anterior en un ', inplace=True)
        #Crea columna temporal que recupera porcentaje en lugares donde se cumple la condición descrita anteriormente
        #Esto se hace porque con la función mask no se puede hacer directamente
    efact_suma_CC['temp']=efact_suma_CC[efact_suma_CC['Energia_1m']!='']['Error Energía c/r mes anterior [%]'].to_frame().applymap(int).applymap(str)+'[%]|'
        #Se rellenan nan en lugares donde no se cumplía la condición, así la observación no es nan cuando se suman los strings 
    efact_suma_CC['temp'].fillna(value='',inplace=True)
        #Se agrega porcentaje a la columna principal
    efact_suma_CC['Energia_1m']=efact_suma_CC['Energia_1m']+efact_suma_CC['temp']
        #Se elimina columna temporal
    efact_suma_CC.drop(['temp'],axis=1,inplace=True)
        #Caso Energía cero y mes siguiente mayor a cero
    efact_suma_CC['Energia_1m'].mask(np.isinf(efact_suma_CC['Error Energía c/r mes anterior [%]']), '|Energía es cero y en mes anterior era mayor a cero|', inplace=True)
    
    
        #Se repite proceso anterior pero para columna de potencia
    efact_suma_CC['Potencia_1m'].mask(~np.isinf(efact_suma_CC['Error Potencia c/r mes anterior [%]']) & (~(efact_suma_CC['Error Potencia c/r mes anterior [%]']).isna()) & abs(efact_suma_CC['Error Potencia c/r mes anterior [%]'])>=umbral_1m_P, '|Potencia alejada de mes anterior en un ', inplace=True)
    efact_suma_CC['temp']=efact_suma_CC[efact_suma_CC['Potencia_1m']!='']['Error Potencia c/r mes anterior [%]'].to_frame().applymap(int).applymap(str)+'[%]|'
    efact_suma_CC['temp'].fillna(value='',inplace=True)
    efact_suma_CC['Potencia_1m']=efact_suma_CC['Potencia_1m']+efact_suma_CC['temp']
    efact_suma_CC.drop(['temp'],axis=1,inplace=True)
    efact_suma_CC['Potencia_1m'].mask(np.isinf(efact_suma_CC['Error Potencia c/r mes anterior [%]']), '|Potencia es cero y en mes anterior era mayor a cero|', inplace=True)
    
    
        #Se crea vector bool con condición en la que Energía es mayor a Promedio-2*DesvEst
    cond1=efact_suma_CC['Energia']>=efact_suma_CC['Energía Promedio 12 Meses']-2*efact_suma_CC['Desviacion Energía 12 Meses']
        #Se crea vector bool con condición en la que Energía es menor a Promedio+2*DesvEst
    cond2=efact_suma_CC['Energia']<=efact_suma_CC['Energía Promedio 12 Meses']+2*efact_suma_CC['Desviacion Energía 12 Meses']
        #Se rellenan filas donde se cumple cond1 y cond2, es decir donde Energía está dentro de intervalo 2*DesvEst
    efact_suma_CC['Energia_12m'].where((efact_suma_CC['Error Energía c/r a promedio [%]']).isna() | (np.isinf(efact_suma_CC['Error Energía c/r a promedio [%]'])) | ((cond1) & (cond2)), '|Energía alejada de promedio de 12 meses anteriores en un ', inplace=True)
        #Se agrega error con respecto a promedio de 12 meses a Warning 
    efact_suma_CC['temp']=efact_suma_CC[efact_suma_CC['Energia_12m']!='']['Error Energía c/r a promedio [%]'].to_frame().applymap(int).applymap(str)+'[%], lo cual está fuera de invervalo de 2 veces la desviación estándar|'
        #Se rellenan nan
    efact_suma_CC['temp'].fillna(value='',inplace=True)
        #Se agrega mensaje a columna principal
    efact_suma_CC['Energia_12m']=efact_suma_CC['Energia_12m']+efact_suma_CC['temp']
        #Se elimina columna temporal
    efact_suma_CC.drop(['temp'],axis=1,inplace=True)
    
    
    
    #Se eliminan columnas bool de condición
    del cond1
    del cond2
    
        #Se repite proceso anterior pero para columna de potencia
    cond1=efact_suma_CC['Potencia']>=efact_suma_CC['Potencia Promedio 12 Meses']-2*efact_suma_CC['Desviacion Potencia 12 Meses']
    cond2=efact_suma_CC['Potencia']<=efact_suma_CC['Potencia Promedio 12 Meses']+2*efact_suma_CC['Desviacion Potencia 12 Meses']
    efact_suma_CC['Potencia_12m'].where((efact_suma_CC['Error Potencia c/r a promedio [%]']).isna() | np.isinf(efact_suma_CC['Error Potencia c/r a promedio [%]']) | ((cond1) & (cond2)), '|Potencia alejada de promedio de 12 meses anteriores en un ', inplace=True)
    efact_suma_CC['temp']=efact_suma_CC[efact_suma_CC['Potencia_12m']!='']['Error Potencia c/r a promedio [%]'].to_frame().applymap(int).applymap(str)+'[%], lo cual está fuera de invervalo de 2 veces la desviación estándar|'
    efact_suma_CC['temp'].fillna(value='',inplace=True)
    efact_suma_CC['Potencia_12m']=efact_suma_CC['Potencia_12m']+efact_suma_CC['temp']
    efact_suma_CC.drop(['temp'],axis=1,inplace=True)
    
    
    #Se eliminan columnas bool de condición y umbrales para no tener tantas variables en el explorador
    del cond1
    del cond2
    del umbral_1m_E
    del umbral_1m_P
    
        #Suma strings con errores y los pega en columna Observación original
    efact_suma_CC['Observación']=efact_suma_CC['Energia_1m']+efact_suma_CC['Energia_12m']+efact_suma_CC['Potencia_1m']+efact_suma_CC['Potencia_12m']
    
        #Elimina columnas creadas
    efact_suma_CC.drop(['Energia_1m','Energia_12m', 'Potencia_1m','Potencia_12m'], axis=1, inplace=True)
    #Warning_CC=efact_suma_CC[efact_suma_CC['Observación']!='']
    
    NombreArchivo='Revisión_mes_'+str(Fecha_mes)+'.xlsx'
    
    with pd.ExcelWriter(NombreArchivo) as writer:  
        efact_suma_Holding.to_excel(writer, sheet_name='Holding')
        efact_suma_Dx.to_excel(writer, sheet_name='Distribuidora')
        efact_suma_PR.to_excel(writer, sheet_name='Punto Retiro')
        efact_suma_CC.to_excel(writer, sheet_name='Codigo Contrato')