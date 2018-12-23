create procedure SOCOMPANBAJ (
	@Com_Numero	char(2),
	@Tip_Baja	char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************/
/*	DESCRIPCION: ** Baja de Compañías **			*/
/****************************************************************************/
/**	REFERENCIAS:
****************************************************************************
**								STORE CONVERTIDO						****
****************************************************************************
** Creó:		Karla Dosal												****
** Fecha:		27/Nov/12												****
** Help:		416571													****
** Descripción:	Baja de Compañías en la tabla SOCOMPAN					****
****************************************************************************
*/

declare	@Str_Vacio	char(1),			/*	Declaración de Constantes	*/
		@Tip_Compan	char(1)

/*	Asignación de Constantes	*/
select	@Str_Vacio	= '',				/*	String: Vacío				*/
		@Tip_Compan	= '1'				/*	Tipo Baja: Compañía			*/

select	@Com_Numero	= isnull(@Com_Numero, @Str_Vacio),		
		@Tip_Baja	= isnull(@Tip_Baja, @Str_Vacio)

if (@Tip_Baja = @Tip_Compan) begin
	if (@Com_Numero = @Str_Vacio) begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'La Compañía está vacía'
		rollback
		return 1
	end
	
	if not exists (select Com_Numero
					 from SOCOMPAN noholdlock
					 where	Com_Numero	= @Com_Numero) begin
		select	Err_Codigo	= '000002',
				Err_Mensaj	= 'La Compañía no existe'
		rollback
		return 1
	end
	
	if exists (select Com_ComSoc
				 from COCOMPAN noholdlock
				 where	Com_ComSoc	= @Com_Numero) begin
		select	Err_Codigo	= '000003',
				Err_Mensaj	= 'La Compañía tiene relación con otras tablas'
		rollback
		return 1
	end

	delete from SOCOMPAN
		where	Com_Numero	= @Com_Numero
end

if @@nestlevel = 1 begin
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro Eliminado'
end
