create procedure SOREUSSUALT(
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
/* DESCRIPCION:	Alta de Relacion entre Usuario y sucursales de Origen y Destino*/
/*******************************************************************************/

/* REFERENCIAS:
***************************************************************************
** Nodifico:	Miguel A. Hernandez M.									****
** Fecha:		11/Junio/2013											****
** Help:		561876													****
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

if not exists (select	Usu_Numero
				from SOREUSSU noholdlock
				where	ltrim(rtrim(Usu_Numero))	= ltrim(rtrim(@Usu_Numero)) and
						ltrim(rtrim(Usu_SucOpe))	= ltrim(rtrim(@Usu_SucOpe)) and
						ltrim(rtrim(Usu_SucDes))	= ltrim(rtrim(@Usu_SucDes)) ) begin


	insert into SOREUSSU ( 
		Usu_Numero,		Usu_SucOpe,		Usu_SucDes,		NumTransac,		Transaccio,
		Usuario,		FechaSis,		SucOrigen,		SucDestino )
		values ( 
		@Usu_Numero,	@Usu_SucOpe,	@Usu_SucDes,	@NumTransac,	@Transaccio,
		@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino)

	execute @Status = SYTABLOCACT
		@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
		@SucOrigen, 	@SucDestino,	@Modulo
	if @Status <> 0 begin
		rollback
		return 1
	end

	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'La Relacion fue dada de alta'
end else begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Ya existe la relacion',
			Err_Variab	= 'Usu_Numero',
			Err_Foco	= 'numUsuario'
	rollback
	return 1
end
