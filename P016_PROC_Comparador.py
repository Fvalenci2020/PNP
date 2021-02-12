# -*- coding: utf-8 -*-
"""
Created on Thu Feb 11 16:59:02 2021

@author: Asus
"""

"""
-LISTO-DEJAR AL INICIO % DE ERROR A CONSIDERAR COMO VARIABLE
-LISTO-AGREGAR UNIDADES A NOMBRES DE CAMPO DE SALIDA
-LISTO-MENSAJES DE OBSERVACIÓN QUE ESTÉN REFERENCIADOS AL % DE ERROR DE VARIABLE Y NO AL DEL REGISTRO
-LISTO-MENSAJES NO DEBEN CONTENER JUICIOS DE VALOR
-LISTO-QUE VALORES EN PORCENTAJE APAREZCAN COMO NÚMERO
-LISTO-ELIMINAR PABRA ERROR CUANDO SE COMPRARAN DATOS HISTÓRICOS
CORREGIR p015 PARA QUE VERIFIQUE VIGENCIA CONTRATO.
"""

def Comparador(ConectorDB,efact_corregido,efact_historico,proy):
    
    
    #Límites para generar alertas en datos a nivel de punto de retiro
    umbral_proy_PR=0.1 #Error tolerado en proyección de energía
    umbral_1m_E_PR=0.2 #Variación tolerada con respecto a la energía del mes anterior
    umbral_1m_P_PR=0.2 #Variación tolerada con respecto a la Potencia del mes anterior
    umbral_12m_E_PR=0.2 #Variación tolerada con respecto a la energía promedio de 12 meses
    umbral_12m_P_PR=0.2 #Variación tolerada con respecto a la Potencia promedio de 12 meses
    
    
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
    proy_suma_Holding.rename(columns={"Demanda": "Proyección Energía [MWh]"},inplace=True)
                                                                  
          #Agrega Proy a tabla efact_suma
    efact_suma_Holding=pd.merge(efact_suma_Holding,proy_suma_Holding,how = 'left')
         #Agrega error c/r a proyección
    efact_suma_Holding['Error relativo proyección ']=(efact_suma_Holding['Energia']-efact_suma_Holding['Proyección Energía [MWh]'])/efact_suma_Holding['Energia']
    
    
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
    
    
    proy_suma_Dx.rename(columns={"Demanda": "Proyección Energía [MWh]"},inplace=True)
    
          #Agrega Proy a tabla efact_suma
    efact_suma_Dx=pd.merge(efact_suma_Dx,proy_suma_Dx,how = 'left')
          #Agrega Error c/r a proyección
    efact_suma_Dx['Error relativo proyección ']=(efact_suma_Dx['Energia']-efact_suma_Dx['Proyección Energía [MWh]'])/efact_suma_Dx['Energia']
    
    
    #COMPARACIÓN DE ENERGÍA A NIVEL DE PUNTO DE RETIRO
    proy_suma_PR=proy[['IdPuntoRetiro','Demanda']]
    proy_suma_PR['Demanda']=proy_suma_PR.Demanda.astype(float)
       #Suma agrupada por Dx y fecha
    proy_suma_PR=proy_suma_PR.groupby(by=['IdPuntoRetiro']).sum()
       #Vuelve a dejar como indices la fecha y el Holding (Desaparecen con instrucción 'groupby')
    proy_suma_PR.reset_index(level=[0], inplace=True)
    proy_suma_PR.rename(columns={"Demanda": "Proyección Energía [MWh]"},inplace=True)
    
        #Agrega Proy a tabla efact_suma
    efact_suma_PR=pd.merge(efact_suma_PR,proy_suma_PR,how = 'left')
    
       #Agrega Error c/r a proyección
    efact_suma_PR['Error relativo proyección ']=(efact_suma_PR['Energia']-efact_suma_PR['Proyección Energía [MWh]'])/efact_suma_PR['Energia']
    
    
    #################################################################
    ######### COMPARACIÓN DATO REAL CON MES ANTERIOR ################
    #################################################################
    
    efact_1m=efact_historico[efact_historico['Fecha']==Fecha_mes_max]
    
    #NIVEL HOLDING
    efact_1m_Holding=efact_1m[['IdHolding','Energia','Potencia']]
        #Suma agrupada por holding y fecha
    efact_1m_Holding=efact_1m_Holding.groupby(by=['IdHolding']).sum()/1000
    efact_1m_Holding.reset_index(level=[0], inplace=True)
    efact_1m_Holding.rename(columns={"Energia": "Energía Mes anterior [MWh]"},inplace=True)
    efact_1m_Holding.rename(columns={"Potencia": "Potencia Mes anterior [MW]"},inplace=True)
    #Agrega mes anterior a tabla efact_suma
    efact_suma_Holding=pd.merge(efact_suma_Holding,efact_1m_Holding,how = 'left')
    
        #Agrega error c/r a mes anterior
    efact_suma_Holding['Variación relativa  Energía c/r mes anterior ']=abs((efact_suma_Holding['Energia']-efact_suma_Holding['Energía Mes anterior [MWh]'])/efact_suma_Holding['Energia'])
    efact_suma_Holding['Variación relativa Potencia c/r mes anterior ']=abs((efact_suma_Holding['Potencia']-efact_suma_Holding['Potencia Mes anterior [MW]'])/efact_suma_Holding['Potencia'])
    
    #NIVEL DISTRIBUIDORA
    efact_1m_Dx=efact_1m[['IdDistribuidora','Energia','Potencia']]
        #Suma agrupada por holding y fecha
    efact_1m_Dx=efact_1m_Dx.groupby(by=['IdDistribuidora']).sum()/1000
    efact_1m_Dx.reset_index(level=[0], inplace=True)
    efact_1m_Dx.rename(columns={"Energia": "Energía Mes anterior [MWh]"},inplace=True)
    efact_1m_Dx.rename(columns={"Potencia": "Potencia Mes anterior [MW]"},inplace=True)
    #Agrega mes anterior a tabla efact_suma
    efact_suma_Dx=pd.merge(efact_suma_Dx,efact_1m_Dx,how = 'left')
    
    
        #Agrega error c/r a mes anterior
    efact_suma_Dx['Variación relativa  Energía c/r mes anterior ']=(efact_suma_Dx['Energia']-efact_suma_Dx['Energía Mes anterior [MWh]'])/efact_suma_Dx['Energia']
    efact_suma_Dx['Variación relativa Potencia c/r mes anterior ']=(efact_suma_Dx['Potencia']-efact_suma_Dx['Potencia Mes anterior [MW]'])/efact_suma_Dx['Potencia']
    
    
    
    #NIVEL PUNTO RETIRO
    efact_1m_PR=efact_1m[['IdPuntoRetiro','Energia','Potencia']]
        #Suma agrupada por holding y fecha
    efact_1m_PR=efact_1m_PR.groupby(by=['IdPuntoRetiro']).sum()/1000
    efact_1m_PR.reset_index(level=[0], inplace=True)
    efact_1m_PR.rename(columns={"Energia": "Energía Mes anterior [MWh]"},inplace=True)
    efact_1m_PR.rename(columns={"Potencia": "Potencia Mes anterior [MW]"},inplace=True)
    #Agrega mes anterior a tabla efact_suma
    efact_suma_PR=pd.merge(efact_suma_PR,efact_1m_PR,how = 'left')
    
      #Agrega error c/r a mes anterior
    efact_suma_PR['Variación relativa  Energía c/r mes anterior ']=(efact_suma_PR['Energia']-efact_suma_PR['Energía Mes anterior [MWh]'])/efact_suma_PR['Energia']
    efact_suma_PR['Variación relativa Potencia c/r mes anterior ']=(efact_suma_PR['Potencia']-efact_suma_PR['Potencia Mes anterior [MW]'])/efact_suma_PR['Potencia']
    
    
    
    #NIVEL CONTRATO
    efact_1m_CC=efact_1m[['IdCodigoContrato','Energia','Potencia']]
        #Suma agrupada por holding y fecha
    efact_1m_CC=efact_1m_CC.groupby(by=['IdCodigoContrato']).sum()/1000
    efact_1m_CC.reset_index(level=[0], inplace=True)
    efact_1m_CC.rename(columns={"Energia": "Energía Mes anterior [MWh]"},inplace=True)
    efact_1m_CC.rename(columns={"Potencia": "Potencia Mes anterior [MW]"},inplace=True)
    #Agrega mes anterior a tabla efact_suma
    efact_suma_CC=pd.merge(efact_suma_CC,efact_1m_CC,how = 'left')
    
      #Agrega error c/r a mes anterior
    efact_suma_CC['Variación relativa  Energía c/r mes anterior ']=(efact_suma_CC['Energia']-efact_suma_CC['Energía Mes anterior [MWh]'])/efact_suma_CC['Energia']
    efact_suma_CC['Variación relativa Potencia c/r mes anterior ']=(efact_suma_CC['Potencia']-efact_suma_CC['Potencia Mes anterior [MW]'])/efact_suma_CC['Potencia']
    
    
    #################################################################
    ######## COMPARACIÓN DATO REAL CON VENTANA 12 MESES #############
    #################################################################
    
    #NIVEL HOLDING
        #Crea tabla con datos necesarios desde efact_historico para la comparación a nivel holding
    efact_12M_Holding=efact_historico[['IdHolding','Fecha','Energia','Potencia']]
        #Agrupa y suma datos por holding y fecha
    efact_12M_Holding=efact_12M_Holding.groupby(by=['IdHolding','Fecha']).sum().groupby(level=[0,1]).sum()/1000
        #Calcula promedio agrupando por fecha y cambia nombre a columna 
    efact_12M_promedio=efact_12M_Holding.groupby(by=['IdHolding']).mean().rename(columns={"Energia": "Energía Promedio 12 Meses [MWh]","Potencia": "Potencia Promedio 12 Meses [MW]"})
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
    efact_suma_Holding['Variación relativa  Energía c/r a promedio ']=(efact_suma_Holding['Energia']-efact_suma_Holding['Energía Promedio 12 Meses [MWh]'])/efact_suma_Holding['Energia']
    efact_suma_Holding['Variación relativa Potencia c/r a promedio ']=(efact_suma_Holding['Potencia']-efact_suma_Holding['Potencia Promedio 12 Meses [MW]'])/efact_suma_Holding['Potencia']
    
    
    #NIVEL DISTRIBUIDORA
        #Crea tabla con datos necesarios desde efact_historico para la comparación a nivel distribuidora
    efact_12M_Dx=efact_historico[['IdDistribuidora','Fecha','Energia','Potencia']]
        #Agrupa y suma datos por holding y fecha
    efact_12M_Dx=efact_12M_Dx.groupby(by=['IdDistribuidora','Fecha']).sum().groupby(level=[0,1]).sum()/1000
        #Calcula promedio agrupando por fecha y cambia nombre a columna 
    efact_12M_promedio=efact_12M_Dx.groupby(by=['IdDistribuidora']).mean().rename(columns={"Energia": "Energía Promedio 12 Meses [MWh]","Potencia": "Potencia Promedio 12 Meses [MW]"})
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
    efact_suma_Dx['Variación relativa  Energía c/r a promedio ']=(efact_suma_Dx['Energia']-efact_suma_Dx['Energía Promedio 12 Meses [MWh]'])/efact_suma_Dx['Energia']
    efact_suma_Dx['Variación relativa Potencia c/r a promedio ']=(efact_suma_Dx['Potencia']-efact_suma_Dx['Potencia Promedio 12 Meses [MW]'])/efact_suma_Dx['Potencia']
      
    
    #NIVEL PUNTO RETIRO
     #Crea tabla con datos necesarios desde efact_historico para la comparación a nivel distribuidora
    efact_12M_PR=efact_historico[['IdPuntoRetiro','Fecha','Energia','Potencia']]
        #Agrupa y suma datos por holding y fecha
    efact_12M_PR=efact_12M_PR.groupby(by=['IdPuntoRetiro','Fecha']).sum().groupby(level=[0,1]).sum()/1000
        #Calcula promedio agrupando por fecha y cambia nombre a columna 
    efact_12M_promedio=efact_12M_PR.groupby(by=['IdPuntoRetiro']).mean().rename(columns={"Energia": "Energía Promedio 12 Meses [MWh]","Potencia": "Potencia Promedio 12 Meses [MW]"})
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
    efact_suma_PR['Variación relativa  Energía c/r a promedio ']=(efact_suma_PR['Energia']-efact_suma_PR['Energía Promedio 12 Meses [MWh]'])/efact_suma_PR['Energia']
    efact_suma_PR['Variación relativa Potencia c/r a promedio ']=(efact_suma_PR['Potencia']-efact_suma_PR['Potencia Promedio 12 Meses [MW]'])/efact_suma_PR['Potencia']
    
    
    #NIVEL CONTRATO
     #Crea tabla con datos necesarios desde efact_historico para la comparación a nivel distribuidora
    efact_12M_CC=efact_historico[['IdCodigoContrato','Fecha','Energia','Potencia']]
        #Agrupa y suma datos por holding y fecha
    efact_12M_CC=efact_12M_CC.groupby(by=['IdCodigoContrato','Fecha']).sum().groupby(level=[0,1]).sum()/1000
        #Calcula promedio agrupando por fecha y cambia nombre a columna 
    efact_12M_promedio=efact_12M_CC.groupby(by=['IdCodigoContrato']).mean().rename(columns={"Energia": "Energía Promedio 12 Meses [MWh]","Potencia": "Potencia Promedio 12 Meses [MW]"})
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
    efact_suma_CC['Variación relativa  Energía c/r a promedio ']=(efact_suma_CC['Energia']-efact_suma_CC['Energía Promedio 12 Meses [MWh]'])/efact_suma_CC['Energia']
    efact_suma_CC['Variación relativa Potencia c/r a promedio ']=(efact_suma_CC['Potencia']-efact_suma_CC['Potencia Promedio 12 Meses [MW]'])/efact_suma_CC['Potencia']
    
    
    #################################################################
    ########### FLAG DE DATOS CON DUDA EN SU CALIDAD ################
    #################################################################
    
    #NIVEL PUNTO RETIRO
    
    #Agregar comentario cuando se cumple condición
        #Crea columnas con observaciones, luego serán borradas
    efact_suma_PR['Proy']=''
    efact_suma_PR['Energia_1m']=''
    efact_suma_PR['Energia_12m']=''
    efact_suma_PR['Potencia_1m']=''
    efact_suma_PR['Potencia_12m']=''
    
        #Agrega mensaje de error a observaciones creadas. Si se cumple condición agrega comentario
        #Proyección con porcentaje de error mayor a umbral porciento
    
        #Rellena columna de error de proyección cuando se cumple que error es mayor a umbral
    efact_suma_PR['Proy'].mask(abs(efact_suma_PR['Error relativo proyección '])>=umbral_proy_PR, '|Error relativo de Energía con respecto a proyección mayor a '+str(umbral_proy_PR)+'|' , inplace=True)
     #Caso Energía cero y proyección mayor a cero
    efact_suma_PR['Proy'].mask(np.isinf(efact_suma_PR['Error relativo proyección ']), '|Energía es 0 y proyección indica que es mayor a cero|', inplace=True)
    efact_suma_PR['Proy'].mask(efact_suma_PR['Proyección Energía [MWh]'].isna(), '|Proyección no existe para este punto|', inplace=True)
    
        #Rellena columna de variación de mes anterior cuando se cumple que error es mayor a umbral
    efact_suma_PR['Energia_1m'].mask(abs(efact_suma_PR['Variación relativa  Energía c/r mes anterior '])>=umbral_1m_E_PR, '|Variación relativa de energía con respecto a mes anterior mayor a '+str(umbral_1m_E_PR)+'|', inplace=True)
    efact_suma_PR['Energia_1m'].mask(efact_suma_PR['Energía Mes anterior [MWh]'].isna(), '|No hay datos de energía en mes anterior para este punto|', inplace=True)
    
                     
        #Se repite proceso anterior pero para columna de potencia
    efact_suma_PR['Potencia_1m'].mask(abs(efact_suma_PR['Variación relativa Potencia c/r mes anterior '])>=umbral_1m_P_PR, '|Variación relativa de potencia con respecto a mes anterior mayor a '+str(umbral_1m_P_PR)+'|', inplace=True)
    efact_suma_PR['Potencia_1m'].mask(efact_suma_PR['Potencia Mes anterior [MW]'].isna(), '|No hay datos de potencia en mes anterior para este punto|', inplace=True)
    
    
        #Rellena columna de variación de mes anterior cuando se cumple que error es mayor a umbral
    efact_suma_PR['Energia_12m'].mask(abs(efact_suma_PR['Variación relativa  Energía c/r a promedio '])>=umbral_12m_E_PR, '|Variación relativa de energía con respecto a 12 meses anteriores mayor a '+str(umbral_12m_E_PR)+'|', inplace=True)
        
         #Rellena columna de variación de mes anterior cuando se cumple que error es mayor a umbral
    efact_suma_PR['Potencia_12m'].mask(abs(efact_suma_PR['Variación relativa Potencia c/r a promedio '])>=umbral_12m_E_PR, '|Variación relativa de potencia con respecto a 12 meses anteriores mayor a '+str(umbral_12m_P_PR)+'|', inplace=True)
        
        #Suma strings con errores y los pega en columna Observación original
    efact_suma_PR['Observación']=efact_suma_PR['Proy']+efact_suma_PR['Energia_1m']+efact_suma_PR['Energia_12m']+efact_suma_PR['Potencia_1m']+efact_suma_PR['Potencia_12m']
    
        #Elimina columnas creadas
    efact_suma_PR.drop(['Proy', 'Energia_1m','Energia_12m', 'Potencia_1m','Potencia_12m'], axis=1, inplace=True)
    #Warning_PR=efact_suma_PR[efact_suma_PR['Observación']!='']
    
    #Agrego unidad a Energia y potencia
    efact_suma_Holding.rename(columns={"Energia": "Energía [MWh]","Potencia": "Potencia [MW]"},inplace=True)
    efact_suma_Dx.rename(columns={"Energia": "Energía [MWh]","Potencia": "Potencia [MW]"},inplace=True)
    efact_suma_PR.rename(columns={"Energia": "Energía [MWh]","Potencia": "Potencia [MW]"},inplace=True)
    efact_suma_CC.rename(columns={"Energia": "Energía [MWh]","Potencia": "Potencia [MW]"},inplace=True)
    
    
    
    NombreArchivo='Revisión_mes_'+str(Fecha_mes)+'.xlsx'
    
    with pd.ExcelWriter(NombreArchivo) as writer:  
        efact_suma_Holding.to_excel(writer, sheet_name='Holding')
        efact_suma_Dx.to_excel(writer, sheet_name='Distribuidora')
        efact_suma_PR.to_excel(writer, sheet_name='Punto Retiro')
        efact_suma_CC.to_excel(writer, sheet_name='Codigo Contrato')
    
    
    
    
