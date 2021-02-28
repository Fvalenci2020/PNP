"""
Created on Thu Jan 28 17:22:42 2021

@author: CNE
"""
#PROCEDIMIENTO DE GENERACION DE ERRORES DE EFACT INFORMADO
###########################################################################
#Para corrida local de los proc.

ConectorDB='Driver={SQL Server};''Server=DESKTOP-SSPJTJO\SQLEXPRESS;''Database=Modelo PNP;''Trusted_Connection=yes;'
IdVersion=22
path ='Entrega_Revisión_EFacDx_2012.v01.xlsx' 

"""
ConectorDB='Driver={SQL Server};Server=GTD-NOT019\SQLSERVER2012;Database=PNP_2;Trusted_Connection=yes;'
IdVersion=22
path = 'C:/fvalenci/CNE/PNP/PNP_2007_11-12_FPEC/Input/CEN/Entrega_Revisión_EFacDx_2012.v01.xlsx'
"""


def Validador(ConectorDB,path,IdVersion):
        
    import pandas as pd
    import numpy as np
    import pyodbc
    pd.options.mode.chained_assignment = None
        
    #Base de datos SQL    
    conn = pyodbc.connect(ConectorDB)
        
        
    #IMPORTAR DATOS ENTRADA
    Datos = pd.read_excel(path,skiprows=6)
    Datos= Datos.iloc[:, 1:11]
            
        
    #EXTRAR DE DB TABLAS QUE SE NECESITAN
    generadora= pd.read_sql_query('select * from generadora',conn)
    distribuidora= pd.read_sql_query('select * from distribuidora',conn)
    #contrato= pd.read_sql_query('select * from codigocontrato',conn)
    contrato= pd.read_sql_query('select t1.*,t2.VigenciaInicio,t2.VigenciaFin from codigocontrato t1 left join licitaciongx t2 on t1.IdLicitacion=t2.IdLicitacion and t1.IdGeneradora=t2.IdGeneradora and t1.TipoBloque=t2.TipoBloque and t1.Bloque=t2.Bloque',conn)
    puntoretiro= pd.read_sql_query('select * from puntoretiro',conn)
        
    #Agrego Ids  
       #Agrego Id Distribuidora
    Datos=pd.merge(Datos,distribuidora.iloc[:,[0,1]],left_on='Distribuidora',right_on='NombreDistribuidora',how = 'left').iloc[:,:-1]
        #Agrego Id Generadora
    Datos=pd.merge(Datos,generadora.iloc[:,[0,1]],left_on='Suministrador',right_on='NombreGeneradora',how = 'left').iloc[:,:-1]
        #Agrego Id Punto de Retiro
    Datos=pd.merge(Datos,puntoretiro.iloc[:,[0,1]],left_on='PuntoRetiro'  ,right_on='PuntoRetiro' ,how = 'left')
        #Agrego Id a contrato y su vigencia
    Datos=pd.merge(Datos,contrato.iloc[:,[0,1,-2,-1]],left_on='CodigoContrato',right_on='CodigoContrato',how = 'left')
    Datos['VigenciaFin']=pd.to_datetime(Datos['VigenciaFin'], format='%Y-%m-%d')
    Datos['VigenciaInicio']=pd.to_datetime(Datos['VigenciaInicio'], format='%Y-%m-%d')
        
       #Agregar columnas con flag
        #Cuando IdDistribuidora es nan, flag=1
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
        #Reemplaza datos cuando la condición es False
    Datos['flag codigocontrato Vigencia']=0
        #Reemplaza datos cuando la condición es False
    Datos['flag codigocontrato Vigencia'].mask((Datos.VigenciaInicio < Datos.Fecha) & (Datos.VigenciaFin>Datos.Fecha), 1, inplace=True,)#tiene error
    Datos['flag codigocontrato Vigencia'].mask((np.isnat(Datos.VigenciaInicio)) | (np.isnat(Datos.VigenciaFin)), 1, inplace=True,)#tiene error
    
        #Agregar comentario de error cuando flag igual a 1
     #Crea columnas con observaciones, luego serán borradas
    Datos['Observación1']=''
    Datos['Observación2']=''
    Datos['Observación3']=''
    Datos['Observación4']=''
    Datos['Observación5']=''
        
            #Agrega mensaje de error a observaciones creadas. Si flag es 1 agrega error.
    Datos['Observación1'].where(Datos['flag distribuidora']==0, '-Error nombre de Distribuidora', inplace=True,)
    Datos['Observación2'].where(Datos['flag generadora']==0, '-Error nombre de Generadora', inplace=True,)
    Datos['Observación3'].where(Datos['flag puntoretiro']==0, '-Error nombre de Punto Retiro', inplace=True,)
    Datos['Observación4'].where(Datos['flag codigocontrato']==0, '-Error nombre de Código Contrato', inplace=True,)
    Datos['Observación5'].mask(((Datos['flag codigocontrato Vigencia']==0) & (Datos['flag codigocontrato']==1)), '-Error Código Contrato Sin Vigencia', inplace=True,)
        
        #Suma strings con errores y los pega en columna Observación original
    Datos['Observación']=Datos['Observación1']+Datos['Observación2']+Datos['Observación3']+Datos['Observación4']+Datos['Observación5']
        #Elimina columnas creadas
    Datos.drop(['Observación1', 'Observación2','Observación3', 'Observación4', 'Observación5'], axis=1, inplace=True)
            
    #Crea Tabla Efact con errores en observación
        #Crea columna con la id de la versión
    Datos['IdDespacho']=np.nan
    Datos['IdVersion']=IdVersion 
    #UTILIZAR IDVERSION CREADO MÁS ARRIBA
    Efact=Datos[['IdData','IdVersion','Fecha','IdDistribuidora','IdGeneradora','IdCodigoContrato','IdPuntoRetiro','Distribuidora','Suministrador','CodigoContrato','PuntoRetiro','IdDespacho','Energía [kWh]','Potencia [kW]','Observación']]
    Efact_error=Efact[Efact['Observación']!='']
    NombreArchivo='Efact_error_'+str(IdVersion)+'.xlsx'
    Efact_error.to_excel(NombreArchivo, index=False,header=True,encoding='latin_1')
    conn.close()
    del conn
    return Efact_error,Efact    

#PROCEDIMIENTO DE CORRECCIÓN DE DATOS PARA QUE PUEDA CARGARSE EN SQL.
###########################################################################
def CorrectorEfact(ConectorDB,IdVersion,Efact):
    
    import pandas as pd
    import numpy as np
    import pyodbc
    pd.options.mode.chained_assignment = None
        
    #Base de datos SQL    
    import pyodbc
    conn = pyodbc.connect(ConectorDB)

    #EXTRAR DE DB TABLAS QUE SE NECESITAN
    generadora= pd.read_sql_query('select * from generadora',conn)
    distribuidora= pd.read_sql_query('select * from distribuidora',conn)
    contrato= pd.read_sql_query('select * from codigocontrato',conn)
    puntoretiro= pd.read_sql_query('select * from puntoretiro',conn)
    tipodespacho= pd.read_sql_query('select * from tipodespacho',conn)
    
    Efact_corregido=Efact[['IdData','IdVersion','Fecha','Distribuidora','Suministrador','CodigoContrato','PuntoRetiro','IdDespacho','Energía [kWh]','Potencia [kW]','Observación']]
    
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
    Efact_corregido['IdCodigoContrato'].where(~(Efact_corregido.CodigoContrato=='RECONVERSIÓN ENERGÉTICA') , 0, inplace=True,)    
        #Caso punto retiro en blanco
    #Efact_corregido['IdPuntoRetiro'].where(~(Efact_corregido.PuntoRetiro=='(en blanco)') , 194, inplace=True,)   
    #Efact_corregido['PuntoRetiro'].where(~(Efact_corregido.PuntoRetiro=='(en blanco)') ,'Quirihue 023' , inplace=True,)    
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
    conn.close()
    del conn
    #Crea Tabla Efact sin errores en observación
    return Efact_corregido[['IdData','IdVersion','Fecha','IdDistribuidora','IdGeneradora','IdCodigoContrato','IdPuntoRetiro','Distribuidora','Suministrador','CodigoContrato','PuntoRetiro','IdTipoDespacho','Energía [kWh]','Potencia [kW]','Observación']]

#PROCEDIMIENTO DE CARGA DE EFACT A DB
###########################################################################
def CargaEfactDB(ConectorDB,Efact_corregido):
    
    import pandas as pd
    import numpy as np
    import pyodbc    
    pd.options.mode.chained_assignment = None
    import sqlalchemy
    from sqlalchemy.types import Integer
        
    #Base de datos SQL    
    import pyodbc
    #Se crea conexión con DB
    def creator():
        return pyodbc.connect(ConectorDB)
    eng = sqlalchemy.create_engine('mssql://', creator=creator)
        
    #Se cambian nombres de columnas para que calcen con la tabla destino en DB
    Efact_corregido=Efact_corregido.rename(columns={"IdData": "IdEfact", "Suministrador": "Generadora", "Energía [kWh]": "Energia", "Potencia [kW]": "Potencia","Observación": "Observacion"})
    
    #Agrega Efact corregido a la base de datos
    Efact_corregido.to_sql('Efact', eng, if_exists='append', index=False)                                                                    