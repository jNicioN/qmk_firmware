create procedure SOSUPIFIACT (
	@Spf_Numero	int,
	@Spf_Sucurs	char(3),
	@Spf_Status	char(1),
	@Spf_FecAlt	smalldatetime, 
	@Spf_FecBaj	smalldatetime,
	@Tip_Actual	char(1),
	
	@NumTransac	char(10),
	@Transaccio char(3), 
	@Usuario	char(6), 
	@FechaSis	smalldatetime, 
	@SucOrigen	char(3),
	@SucDestino char(3),
	@Modulo		char(2))

as

/**********************************************************
** Descripción : Actualiza sucursales piloto firmas		***
***********************************************************
** Referencias: Modulo soporte aplicaciones				***
***********************************************************
** creó:	Alma Cristina Perez Ramon					***
** Fecha:	05/02/2019									***
** Help:	1162911										***
***********************************************************/

								/* Declaracion de Variables */
declare	@Par_FecAct	smalldatetime,	/* Fecha actual */
		@Ent_Contad	int				/* Entero contador */
		
								/* Declaración de constantes */
declare	@Fec_Vacia	smalldatetime,
		@Str_Status	char(1),
		@Ent_Cero	int,
		@Str_TiAcBa	char(1)
		
								/* Asignación de valores a constantes */
select	@Fec_Vacia	= '1900-01-01',	/* Fecha Vacia */
		@Str_Status	= 'I',		/* Estatus Inactivo */
		@Ent_Cero	= 0,		/* Entero cero */
		@Str_TiAcBa	= 'B'		/* Tipo de actualización baja de registro */

select	@Par_FecAct	= Par_FecAct
	from SOPARAMS noholdlock
	where	 Par_Sucurs = @SucOrigen

select	@Par_FecAct = isnull(@Par_FecAct,@Fec_Vacia)

if  @Par_FecAct = @Fec_Vacia begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Fecha de actualización no válida'
	rollback
	return 1
end

if @Tip_Actual = @Str_TiAcBa begin
	update SOSUPIFI set
		Spf_Status	= @Str_Status,
		Spf_FecBaj	= @Par_FecAct,
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
		where	Spf_Numero	= @Spf_Numero
end

if @@rowcount = @Ent_Cero begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'No se encontraron registros para actualizar'
			rollback
			return 1
end else begin
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro Actualizado'
end
			