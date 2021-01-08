create procedure SOHISUSUCON (
	@Hiu_FolUsu		int,				
	@Hiu_Estatus	char(1),			
	@Hiu_FecEst		smalldatetime,		
	@Hiu_Usuari		char(6),				
	@Hiu_Sucurs		char(3),				
	@Hiu_Canal 		int,				
	@Hiu_DesEst 	char(180),			
	@Hiu_FecIni		smalldatetime,
	@Hiu_FecFin		smalldatetime,
	@Tip_Consul		char(2),
	
	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario 	char(6), 
	@FechaSis 	smalldatetime,
	@SucOrigen 	char(3),
	@SucDestino char(3), 
	@Modulo 	char(2))

as

/**
****************************************************************************
** DESCRIPCION: ** Consulta de historico de usuarios					****
****************************************************************************
**	REFERENCIAS:														****
****************************************************************************
** Creo:		Carlos Copto											****
** Fecha:		26/11/2020   											****
** Help Desk:	1376175										 			****
****************************************************************************
**/

/* Declaracion de Variables */
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1),
		@Une_Estatu char(1)

/* Declaracion de Constantes */
declare	@Str_Vacio	char(1),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Sta_Activo	char(1),
		@Str_C		char(1),
		@Str_L	    char(1),
		@Str_Uno	char(1),
		@Str_Dos	char(1)

/* Asignacion de Constantes */
select	@Str_Vacio	= '',			-- String Vacio
		@Ent_Cero	= 0,			-- Entero : 0
		@Ent_Uno	= 1,			-- Entero : 1
		@Sta_Activo	= 'A',			-- Status: Activo
		@Str_C		= 'C',			-- Letra C
		@Str_L		= 'L',			-- Letra L
		@Str_Uno	= '1',			-- String 1
		@Str_Dos	= '2'			-- String 2
		
select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = @Str_C begin
	if @Tip_ConCon	= @Str_Uno begin
		/* consulta por folio de compra venta por rango de fecha*/
		select 	Hiu_FolUsu, Hiu_Estatus, Hiu_FecEst, Hiu_Usuari, Hiu_Sucurs, 
				Hiu_Canal,  Hiu_DesEst
			from SOHISUSU noholdlock
			where Hiu_FolUsu = @Hiu_FolUsu
			and Hiu_FecEst > @Hiu_FecIni
			and Hiu_FecEst < @Hiu_FecFin
			order by Hiu_FecEst
	end
end	else if @Tip_ConTip	= @Str_L begin	
	
	/* conuslta todo por rango de fecha */
	if @Tip_ConCon	= @Str_Uno begin
		select 	Hiu_FolUsu, Hiu_Estatus, Hiu_FecEst, Hiu_Usuari, Hiu_Sucurs, 
				Hiu_Canal,  Hiu_DesEst
			from SOHISUSU noholdlock
			where Hiu_FecEst > @Hiu_FecIni
			and   Hiu_FecEst < @Hiu_FecFin
			order by Hiu_FecEst
	end
	
	/* conuslta por sucursal y rango de fecha */
	if @Tip_ConCon	= @Str_Dos begin
		select 	Hiu_FolUsu, Hiu_Estatus, Hiu_FecEst, Hiu_Usuari, Hiu_Sucurs, 
				Hiu_Canal,  Hiu_DesEst
			from SOHISUSU noholdlock
			where Hiu_Sucurs = @Hiu_Sucurs
			and	  Hiu_FecEst > @Hiu_FecIni
			and   Hiu_FecEst < @Hiu_FecFin
			order by Hiu_FecEst
	end
end else begin
	
	select 	Hiu_FolUsu, Hiu_Estatus, Hiu_FecEst, Hiu_Usuari, Hiu_Sucurs, 
			Hiu_Canal,  Hiu_DesEst
	from SOHISUSU noholdlock
	
end