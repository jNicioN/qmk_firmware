create procedure SOCLIRECPRO (
	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario 	char(6),
	@FechaSis 	smalldatetime,
	@SucOrigen 	char(3),
	@SucDestino char(3),
	@Modulo 	char(2))

as

/***************************************************************************
* DESCRIPCION: Proceso de obtencion de  clientes recompensas   			   *
****************************************************************************
** REFERENCIAS: 														   *
****************************************************************************
** Creo:		Julian Cano Carballo									****
** Fecha:		17/Junio/2022											****
** Help:		1637684													****
****************************************************************************
** Creo:		Fatima Sanchez Luis										****
** Fecha:		31/Mayo/2022											****
** Help:		1637684														****
****************************************************************************/
-- Declaración de constantes 
declare @Ent_Dos	int,	
		@Ent_Tres	int,	
		@Ent_Cuatro	int,	
		@Cla_ClaHey int, 	
		@Cli_TipPF	char(1),
		@Cli_ActEmp char(1),	
		@Cli_StaSi	char(1),	
		@Tip_PersPF	varchar(8),
		@Tip_PePFAE	varchar(8),
		@Ent_Cero	int,
		@Str_No		char(1),
		@Str_Si		char(1),
		@Str_Vacio	char(1)
		
-- Asignación de Constantes 
select	@Ent_Dos	= 2,		-- Tipo 2 clientes PF mas de un id 
		@Ent_Tres	= 3,		-- Tipo 3 clientes PFAE mas de un id 
		@Ent_Cuatro = 4,		-- Tipo 4 clientes Mas de una personalidad 
		@Cla_ClaHey	= 1,		-- Clasificacion clientes hey			
		@Cli_TipPF	= '2',		-- Tipo de persona Fisica		
		@Cli_ActEmp	= 'N',		-- Tipo de actividad empresarial		
		@Cli_StaSi	= 'S',		-- Estatus Activo si: S
		@Tip_PersPF = 'PF',		-- Tipo de persona PF
		@Tip_PePFAE	= 'PFAE',	-- Tipo de persona PFAE
		@Ent_Cero	= 0,		-- Entero cero
		@Str_No		= 'N',		-- String NO
		@Str_Si		= 'S',		-- String SI
		@Str_Vacio	= ''		-- String vacio
		
Create table #GrupPFAES(
Gpf_Grupo varchar(15),
Gpf_Conteo int
)

create nonclustered index GrupPFAESGru on #GrupPFAES (Gpf_Grupo)
with index_compression = none , index_hash_caching = default


Create table #SoloGrupPFS(
Gpf_Grupo varchar(15)
)

create nonclustered index SoloGrupPSGru on #SoloGrupPFS (Gpf_Grupo)
with index_compression = none , index_hash_caching = default


-----------------------------------------------------------------------------------------
-- Insercion de clientes PF mas de un id en tabla temporal para recompensas
-----------------------------------------------------------------------------------------
insert into  SOCLIREC
select	@Ent_Dos,		@Ent_Cero,		Clu_Grupo,	Cli_Numero,	ClClientID,
		@Tip_PersPF,	@Str_No,		@Str_No,	@Str_Vacio,	@Str_Vacio,		
		@Ent_Cero,		@Ent_Cero,		@Str_Si,	@Str_No,	@Str_No,		
		@Str_Vacio,		@Str_Vacio,		@Ent_Cero,	@Ent_Cero,	@Str_Vacio,			
		@Str_Vacio,		@Str_Vacio,		@Ent_Cero,	@Ent_Cero,	@Str_No,				
		@Str_Si,		@Ent_Cero,		@Ent_Cero,	@Ent_Cero,	@Ent_Cero,		
		@Ent_Cero,		@Ent_Cero,		@Str_No,	@Str_No,	@Str_Vacio,			
		@Ent_Cero,		@Ent_Cero,		@Ent_Cero,	@Ent_Cero,	@Ent_Cero,
		@Ent_Cero,		@Str_Vacio,		@Ent_Cero,	@Ent_Cero,	@NumTransac,
		@Transaccio,	@Usuario,		@FechaSis,	@SucOrigen,	@SucDestino    

	from (
			select Clu_Grupo Gpf_Grupo
				from CLCLIUNI noholdlock
				inner join CLCLIENT noholdlock on	Cli_Numero	= Clu_Client
												and Cli_Status	= @Cli_StaSi
												and Cli_Tipo	= @Cli_TipPF
												and Cli_ActEmp	= @Cli_ActEmp
				inner join CLCLACLI noholdlock	on Clc_Client	= ClClientID
												and Clc_Clasif	= @Cla_ClaHey
				group by Clu_Grupo
				having count(*) > 1
		) Cdf	-- Clientes Unicos con mas de un Cliente Detalle Persona Fisica
	inner join CLCLIUNI noholdlock on Clu_Grupo = Gpf_Grupo
	inner join CLCLIENT noholdlock on Cli_Numero = Clu_Client
						
									and Cli_Tipo = @Cli_TipPF
									and Cli_ActEmp = @Cli_ActEmp
	inner join CLCLACLI noholdlock on Clc_Client = ClClientID
									and Clc_Clasif = @Cla_ClaHey

 
-- ========================================================================================= --
--  								INSERT PFAE												 --
-- ========================================================================================= --

-- Sacamos todos los PFAES 
insert into #GrupPFAES
select Clu_Grupo Gpf_Grupo, count(*) registros
	from CLCLIUNI noholdlock
				inner join CLCLIENT noholdlock on Cli_Numero = Clu_Client
												and Cli_Status = @Cli_StaSi
												and Cli_Tipo = @Cli_TipPF
												and Cli_ActEmp = @Cli_StaSi
				inner join CLCLACLI noholdlock on Clc_Client = ClClientID
												and Clc_Clasif = @Cla_ClaHey
				group by Clu_Grupo
				

-- Competamos la informacion que necesitamos para PFAES con mas de 1 id
select Clu_Grupo, Cli_Numero, ClClientID
into   #PFAE
	from  ( select Gpf_Grupo
				from #GrupPFAES
				where Gpf_Conteo>1 ) Cdf	-- Clientes Unicos con mas de un Cliente Detalle Persona Fisica con actividad empresarial
	inner join CLCLIUNI noholdlock on Clu_Grupo = Gpf_Grupo
	inner join CLCLIENT noholdlock on Cli_Numero = Clu_Client
						
									and Cli_Tipo = @Cli_TipPF
									and Cli_ActEmp = @Cli_StaSi
	inner join CLCLACLI noholdlock on Clc_Client = ClClientID
									and Clc_Clasif = @Cla_ClaHey

						
-- Eliminamos los que ya existan como PF
delete  
from SOCLIREC 
where Clr_Grupo in (
select Clu_Grupo
from #PFAE 
)

-- Guardamos la informacion
insert into  SOCLIREC
select	@Ent_Tres,		@Ent_Cero,		Clu_Grupo,	Cli_Numero,	ClClientID,
		@Tip_PePFAE	,	@Str_No,		@Str_No,	@Str_Vacio,	@Str_Vacio,		
		@Ent_Cero,		@Ent_Cero,		@Str_Si,	@Str_No,	@Str_No,		
		@Str_Vacio,		@Str_Vacio,		@Ent_Cero,	@Ent_Cero,	@Str_Vacio,			
		@Str_Vacio,		@Str_Vacio,		@Ent_Cero,	@Ent_Cero,	@Str_No,				
		@Str_Si,		@Ent_Cero,		@Ent_Cero,	@Ent_Cero,	@Ent_Cero,		
		@Ent_Cero,		@Ent_Cero,		@Str_No,	@Str_No,	@Str_Vacio,			
		@Ent_Cero,		@Ent_Cero,		@Ent_Cero,	@Ent_Cero,	@Ent_Cero,
		@Ent_Cero,		@Str_Vacio,		@Ent_Cero,	@Ent_Cero,	@NumTransac,
		@Transaccio,	@Usuario,		@FechaSis,	@SucOrigen,	@SucDestino    
   
from #PFAE								
									
										
-- ========================================================================================= --
--  								INSERT PF Y PFAE										 --
-- ========================================================================================= -- 

-- Sacamos solo PFS

insert into #SoloGrupPFS
select Clu_Grupo 
				from CLCLIUNI noholdlock
				inner join CLCLIENT noholdlock on Cli_Numero = Clu_Client
												and Cli_Status = @Cli_StaSi
												and Cli_Tipo = @Cli_TipPF
												and Cli_ActEmp = @Cli_ActEmp
				inner join CLCLACLI noholdlock on Clc_Client = ClClientID
												and Clc_Clasif = @Cla_ClaHey
				group by Clu_Grupo

				
				
select distinct fis.Gpf_Grupo 
into  #PFPFAES
from #SoloGrupPFS fis inner join #GrupPFAES act on fis.Gpf_Grupo=act.Gpf_Grupo
	
 -- se borra la informacion de los registros que ya estan solo como PF
delete 
from SOCLIREC 
where Clr_Grupo in (
select Gpf_Grupo
from #PFPFAES 
)
	
		
insert into  SOCLIREC
select	@Ent_Cuatro,	@Ent_Cero,		Clu_Grupo,	Cli_Numero,		ClClientID,
		case when Cli_ActEmp = @Cli_ActEmp then @Tip_PersPF
		      else @Tip_PePFAE
		     end,	@Str_No,	@Str_No,		@Str_Vacio,			@Str_Vacio,		
		@Ent_Cero,		@Ent_Cero,		@Str_Si,		@Str_No,	@Str_No,		
		@Str_Vacio,		@Str_Vacio,		@Ent_Cero,		@Ent_Cero,	@Str_Vacio,			
		@Str_Vacio,		@Str_Vacio,		@Ent_Cero,		@Ent_Cero,	@Str_No,				
		@Str_Si,		@Ent_Cero,		@Ent_Cero,		@Ent_Cero,	@Ent_Cero,		
		@Ent_Cero,		@Ent_Cero,		@Str_No,		@Str_No,	@Str_Vacio,			
		@Ent_Cero,		@Ent_Cero,		@Ent_Cero,		@Ent_Cero,	@Ent_Cero,
		@Ent_Cero,		@Str_Vacio,		@Ent_Cero,		@Ent_Cero,	@NumTransac,
		@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	@SucDestino    

from #PFPFAES inner join CLCLIUNI noholdlock on Clu_Grupo = Gpf_Grupo
			  inner join CLCLIENT noholdlock on Cli_Numero = Clu_Client
			  inner join CLCLACLI noholdlock on Clc_Client = ClClientID
									and Clc_Clasif = @Cla_ClaHey
where Cli_Tipo = @Cli_TipPF

 
drop table #GrupPFAES, #SoloGrupPFS