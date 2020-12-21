create procedure SOBITUSUCON (
	@Biu_FolUsu		int,				
	@Biu_Estatus	char(1,)				
	@Biu_FecEst		smalldatetime,		
	@Biu_Usuari		char(3),				
	@Biu_Sucurs		char(3),				
	@Biu_Canal 		char(3),				
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
		@Tip_ConCon	char(1),
		@Une_Estatu char(1)

/* Declaracion de Constantes */
declare	@Str_Vacio	char(1),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Sta_Activo	char(1)

/* Asignacion de Constantes */
select	@Str_Vacio	= '',			-- String Vacio
		@Ent_Cero	= 0,			-- Entero : 0
		@Ent_Uno	= 1,			-- Entero : 1
		@Sta_Activo	= 'A'			-- Status: Activo
		
select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = 'C' begin
	if @Tip_ConCon	= '1' begin
		/* consulta por folio de compra venta por rango de fecha*/
		select 	Biu_FolUsu, Biu_Estatus, Biu_FecEst, Biu_Usuari,
				Biu_Sucurs, Biu_Canal,   Biu_DesEst
			from SOBITUSU 
			where Biu_FolUsu = @Biu_FolUsu
			and Biu_FecEst > @Biu_FecIni
			and Biu_FecEst < @Biu_FecFin
			order by Biu_FecEst
	end
end	else if @Tip_ConTip	= 'L' begin	
	
	/* conuslta todo por rango de fecha */
	if @Tip_ConCon	= '1' begin
		select 	Biu_FolUsu, Biu_Estatus, Biu_FecEst, Biu_Usuari,
				Biu_Sucurs, Biu_Canal,   Biu_DesEst
			from SOBITUSU 
			where Biu_FecEst > @Biu_FecIni
			and   Biu_FecEst < @Biu_FecFin
			order by Biu_FecEst
	end
	
	/* conuslta por sucursal y rango de fecha */
	if @Tip_ConCon	= '2' begin
		select 	Biu_FolUsu, Biu_Estatus, Biu_FecEst, Biu_Usuari,
				Biu_Sucurs, Biu_Canal,   Biu_DesEst
			from SOBITUSU 
			where Biu_Sucurs = @Biu_Sucurs
			and	  Biu_FecEst > @Biu_FecIni
			and   Biu_FecEst < @Biu_FecFin
			order by Biu_FecEst
	end
end else begin
	
	select 	Biu_FolUsu, Biu_Estatus, Biu_FecEst, Biu_Usuari,
			Biu_Sucurs, Biu_Canal,   Biu_DesEst
	from SOBITUSU
	
end 
		
		
		
		
		
		
		
		
		
		