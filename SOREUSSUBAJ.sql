create procedure SOREUSSUBAJ(
	@Usu_Numero	char(6),
	@Usu_SucOpe	char(3),
	@Usu_SucDes	char(3),
	
	@NumTransac char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*******************************************************************************/
/* DESCRIPCION:	Baja de Relacion entre Usuario y sucursales de Origen y Destino*/
/*******************************************************************************/

/* REFERENCIAS:
***************************************************************************
** Creó:		Miguel A. Hernandez M.									****
** Fecha:		20/Febrero/2013											****
** Help:		444440													****
***************************************************************************/

/* Declaracion de Variables */
declare	@Status		int

/* Declaración de Constantes */
declare	@Tab_Nombre	char(8)	

/* Asignación de Constantes */
select	@Tab_Nombre	= 'SOREUSSU'	

if exists (select	Usu_Numero
				from SOREUSSU noholdlock
				where	ltrim(rtrim(Usu_Numero))	= ltrim(rtrim(@Usu_Numero)) and
						ltrim(rtrim(Usu_SucOpe))	= ltrim(rtrim(@Usu_SucOpe)) and
						ltrim(rtrim(Usu_SucDes))	= ltrim(rtrim(@Usu_SucDes)) ) begin


	delete from SOREUSSU where 
		Usu_Numero=@Usu_Numero and Usu_SucOpe=@Usu_SucOpe and Usu_SucDes=@Usu_SucDes
		
	execute @Status = SYTABLOCACT
		@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
		@SucOrigen, 	@SucDestino,	@Modulo
	if @Status <> 0 begin
		rollback
		return 1
	end

	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'La Relacion fue dada de baja'
end else begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'La relacion NO existe para el usuario',
			Err_Variab	= 'Usu_Numero',
			Err_Foco	= 'numUsuario'
	rollback
	return 1
end
