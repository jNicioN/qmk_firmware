create procedure SOBITUSUCON (
	@Biu_FolUsu		int,				
	@Biu_Estatu		char(1),			
	@Biu_FecEst		smalldatetime,		
	@Biu_Usuari		char(6),				
	@Biu_Sucurs		char(3),				
	@Biu_Canal 		int,				
	@Biu_DesEst 	char(180),			
	@Biu_FecIni		smalldatetime,
	@Biu_FecFin		smalldatetime,
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
** DESCRIPCION: ** Consulta de bitacora de usuarios						****
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
		@Tip_ConCon	char(1)

/* Declaracion de Constantes */
declare	@Str_C		char(1),
		@Str_L	    char(1),
		@Str_Uno	char(1),
		@Str_Dos	char(1)

/* Asignacion de Constantes */
select	@Str_C		= 'C',			-- Letra C
		@Str_L		= 'L',			-- Letra L
		@Str_Uno	= '1',			-- String 1
		@Str_Dos	= '2'			-- String 2
		
select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = @Str_C begin
	if @Tip_ConCon = @Str_Uno begin
		/* consulta por folio de compra venta por rango de fecha*/
		select 	Biu_FolUsu, Biu_Estatu, Biu_FecEst, Biu_Usuari, Biu_Sucurs, 
				Biu_Canal,   Biu_DesEst
			from SOBITUSU noholdlock
			where Biu_FolUsu = @Biu_FolUsu
			and Biu_FecEst > @Biu_FecIni
			and Biu_FecEst < @Biu_FecFin
			order by Biu_FecEst
	end
end	else if @Tip_ConTip	= @Str_L begin	
	
	/* conuslta todo por rango de fecha */
	if @Tip_ConCon = @Str_Uno begin
		select 	Biu_FolUsu, Biu_Estatu, Biu_FecEst, Biu_Usuari, Biu_Sucurs, 
				Biu_Canal,   Biu_DesEst
			from SOBITUSU noholdlock
			where Biu_FecEst > @Biu_FecIni
			and   Biu_FecEst < @Biu_FecFin
			order by Biu_FecEst
	end
	
	/* conuslta por sucursal y rango de fecha */
	if @Tip_ConCon = @Str_Dos begin
		select 	Biu_FolUsu, Biu_Estatu, Biu_FecEst, Biu_Usuari, Biu_Sucurs, 
				Biu_Canal,   Biu_DesEst
			from SOBITUSU noholdlock
			where Biu_Sucurs = @Biu_Sucurs
			and	  Biu_FecEst > @Biu_FecIni
			and   Biu_FecEst < @Biu_FecFin
			order by Biu_FecEst
	end
end else begin
	
	select 	Biu_FolUsu, Biu_Estatu, Biu_FecEst, Biu_Usuari, Biu_Sucurs, 
			Biu_Canal,   Biu_DesEst
	from SOBITUSU noholdlock
	
end 