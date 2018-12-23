create procedure SOBIMOUSCON (
	@Bmu_Numero	int ,
	@Bmu_Usuari	char(6),
	@Bmu_Motivo	char(1),
	@Bmu_TipMov	char(1),
	@Bmu_FecIni	smalldatetime,
	@Bmu_FecFin	smalldatetime,
	@Tip_Consul char(2),
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as
/***************************************************************************
** DESCRIPCION: 														****
****************************************************************************
** REFERENCIAS:															****
****************************************************************************
** Creo:			Carlos Adrian Bermea								****
** Fecha:			08/Febrero/2016										****
** Descripcion: 	Consulta de BitÃ¡cora de Movimientos					****
** Help Desk:		837755 												****
***************************************************************************/
declare	@Tip_ConTip	char(1),		/* DeclaraciÃ³n de Variables */
		@Tip_ConCon	char(1)

declare	@Str_Vacio	char(1),		/* DeclaraciÃ³n de Constantes */
		@Tra_TipLis	char(1),
		@Tra_TipCon	char(1),
		@Mod_FabCon	char(2),
		@Str_Uno	char(1),
		@Str_Dos	char(1),
		@Str_Tres	char(1)

/* AsignaciÃ³n de Constantes */
select	@Str_Vacio	= '',			/* String VacÃ­o												*/
		@Tra_TipLis	= 'L',			/* Tipo : Lista												*/
		@Tra_TipCon	= 'C',			/* Tipo : Consulta											*/
		@Mod_FabCon	= 'SA',			/* MÃ³dulo Seguridad y Acceso								*/
		@Str_Uno	= '1',			/* String para consulta 1									*/
		@Str_Dos	= '2',			/* String para consulta 2									*/
		@Str_Tres	= '3'			/* String para consulta 3									*/
		
select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)
		
if @Tip_ConTip = @Tra_TipLis begin					/* 'L':  Lista */

	if @Tip_ConCon = @Str_Uno begin					/* Todos los movimientos */    

		select Bmu_Numero, Bmu_Usuari, Bmu_Motivo, 
			Bmu_TipMov, Bmu_FecIni, Bmu_FecFin, 
			bm.NumTransac, bm.Transaccio, bm.Usuario, 
			bm.FechaSis, bm.SucOrigen, bm.SucDestino, 
			bm.Modulo, Usu_Numero, Usu_Nombre, Usu_Clave
			from SOBIMOUS bm noholdlock
			join SOUSUARI us noholdlock on Bmu_Usuari = Usu_Numero
			order by Bmu_FecIni desc
			
	end 
	
	if @Tip_ConCon = @Str_Dos begin		/* Todos los movimientos por clave de usuario */

		select Bmu_Numero, Bmu_Usuari, Bmu_Motivo, 
			Bmu_TipMov, Bmu_FecIni, Bmu_FecFin, 
			bm.NumTransac, bm.Transaccio, bm.Usuario, 
			bm.FechaSis, bm.SucOrigen, bm.SucDestino, 
			bm.Modulo, Usu_Numero, Usu_Nombre, Usu_Clave
			from SOBIMOUS bm noholdlock
			join SOUSUARI us noholdlock on Bmu_Usuari = Usu_Numero
			where Bmu_Usuari = @Bmu_Usuari
			order by Bmu_FecIni desc 
	
	end
	
	if @Tip_ConCon = @Str_Tres begin		/* Todos los movimientos por fecha */

		select Bmu_Numero, Bmu_Usuari, Bmu_Motivo, 
			Bmu_TipMov, Bmu_FecIni, Bmu_FecFin, 
			bm.NumTransac, bm.Transaccio, bm.Usuario, 
			bm.FechaSis, bm.SucOrigen, bm.SucDestino, 
			bm.Modulo, Usu_Numero, Usu_Nombre, Usu_Clave
			from SOBIMOUS bm noholdlock
			join SOUSUARI us noholdlock on Bmu_Usuari = Usu_Numero
			where @Bmu_FecIni between Bmu_FecIni and Bmu_FecFin 
			order by Bmu_FecIni desc 
	
	end
	
end
