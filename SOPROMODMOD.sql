create procedure SOPROMODMOD (
	@Prm_Numero char(3),
   	@Prm_Descri varchar(50),
   	@Prm_Observ varchar(250),
   
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*****************************************************************************/
/* DESCRIPCION: Modificación de Procesos por Módulo							 */
/*****************************************************************************/

/** REFERENCIAS:
****************************************************************************
** Creó:			Marco A. Morales Ventura							****
** Fecha:			10/Julio/2013										****
** Help:		    00468177											****
*****************************************************************************/

/* Declaración de Variables */
declare @Prm_Folio	int,
		@Prm_NumAux	char(3)

/* Declaración de Constantes */
declare	@Ent_Cero	int,
		@Ent_Uno	int,
		@Str_Vacio	char(1)

/* Asignación de Constantes */
select	@Ent_Cero	= 0,			/* Entero en Cero */
		@Ent_Uno 	= 1,			/* Entero en Uno */
		@Str_Vacio	= ''			/* String Vacío */

select	@Prm_NumAux = Prm_Numero
	from SOPROMOD noholdlock
	where Prm_Numero = @Prm_Numero

if isnull(@Prm_NumAux, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Proceso no existe',
			Err_Foco	= ''
	rollback
	return 1
end

if isnull(@Prm_Descri, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Descripción del Proceso Incorrecto',
			Err_Foco	= 'txtPrm_Descri'
	rollback
	return 1
end

update SOPROMOD set
	Prm_Descri	= @Prm_Descri, 	
	Prm_Observ	= @Prm_Observ,
	
	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino
	where Prm_Numero = @Prm_Numero
