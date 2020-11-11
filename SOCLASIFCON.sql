create procedure SOCLASIFCON (
	@Cla_Numero int,
	@Cla_Descri varchar(50),
	@Cla_Compan char(2),
	@Cla_Status char(1),
	@Tip_Consul char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
	
as

/********************************************************************************/
/*	DESCRIPCION: ** Consulta de Clasificaciones **			*/
/********************************************************************************/
/**	REFERENCIAS:
********************************************************************************
** creó:		Juan José Sandoval Marín									****
** Fecha:		08/10/2020													****
** Help:		1431786														****
** Descripción:	Consulta de Clasificaciones de Compañias		 			****
********************************************************************************/

--declaracion de variables
declare	@Tip_ConTip char(1),
		@Tip_ConCon char(1)
		
-- Declaración de Constantes
declare	@Con_Consul	char(1),
		@Con_Lista	char(1),
		@Ent_Uno	smallint,
		@Ent_Dos	smallint,
		@Str_Uno	char(1),
		@Sta_Activa	char(1)
		
-- Asignación de constantes

select	@Con_Consul = 'C',				/* Tipo Consulta: Específica 		*/
		@Con_Lista	= 'L',				/* Tipo Consulta: Lista 			*/
		@Ent_Uno 	= 1,				/* Entero: Uno						*/
		@Ent_Dos 	= 2,				/* Entero: Dos						*/
		@Str_Uno 	= '1',				/* String: Dos						*/
		@Sta_Activa = 'A'				/* Status: Activa					*/


select	@Tip_ConTip	= substring(@Tip_Consul, @Ent_Uno, @Ent_Uno),
		@Tip_ConCon	= substring(@Tip_Consul, @Ent_Dos, @Ent_Uno)

if @Tip_ConTip = @Con_Consul begin
	
	if @Tip_ConCon = @Str_Uno begin
		
		select 	Cla_Numero, Cla_Descri, Cla_Compan, Cla_Status
		from 	SOCLASIF noholdlock
		where 	Cla_Numero = @Cla_Numero
		  
	end
	
end else if @Tip_ConTip = @Con_Lista begin
	
	if @Tip_ConCon = @Str_Uno begin
		
		select 	Cla_Numero, Cla_Descri, Cla_Compan, Cla_Status
		from 	SOCLASIF noholdlock
		where 	Cla_Status = @Sta_Activa
		
	end
	
end