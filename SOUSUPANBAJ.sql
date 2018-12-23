CREATE PROCEDURE SOUSUPANBAJ	(
	@Usu_Nombre	varchar(50),
	@Usu_Pantal	varchar(8),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Tab_Nombre char(8)			/* Declaración de Constantes */

/* Asignación de Constantes */
select	@Tab_Nombre = 'SOUSUPAN'	/* Nombre de la Tabla */

if not exists(select	Usu_Nombre 
				from SOUSUPAN noholdlock
				where	Usu_Nombre	= @Usu_Nombre 
				  and	Usu_Pantal	= @Usu_Pantal) begin
	select	Err_Codigo	= '000001', 
			Err_Mensaj	= 'Usuario y pantalla no existen', 
			Err_Variab	= 'Usu_Nombre'
	rollback
	return 1
end

delete from SOUSUPAN 
	where	Usu_Nombre	= @Usu_Nombre 
	  and	Usu_Pantal	= @Usu_Pantal

exec SYTABLOCACT	
	@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,	@FechaSis,		
	@SucOrigen,		@SucDestino,	@Modulo
	
select	Err_Codigo	= '000000', 
		Err_Mensaj	= 'Registro borrado', 
		Err_Variab	= ''

