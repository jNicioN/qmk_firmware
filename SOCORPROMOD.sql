create procedure SOCORPROMOD (
	@Cop_Folio	int,
	@Cop_Nombre	varchar(50), 
	@Cop_Correo	varchar(100), 
	@Cop_Tipo	char(1),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*****************************************************************************/
/* DESCRIPCION: Modificación de Correos por Proceso							 */
/*****************************************************************************/

/** REFERENCIAS:
****************************************************************************
** Creó:			Marco A. Morales Ventura							****
** Fecha:			11/Julio/2013										****
** Help:		    00468177											****
*****************************************************************************/

/* Declaración de Variables */
declare @Cop_FolAux	int,
		@Prm_Numero	char(3) ,
		@Mod_Codigo char(2)

/* Declaración de Constantes */
declare	@Str_Vacio	char(1),
		@Str_Uno	char(1),
		@Str_Dos	char(2),
		@Ent_Cero	int

/* Asignación de Constantes */
select	@Str_Vacio	= '',			/* String Vacío */
		@Str_Uno	= '1',			/* String Uno */
		@Str_Dos	= '2',			/* String Dos */
		@Ent_Cero	= 0				/* Entero en Cero */

select	@Cop_FolAux = Cop_Folio
	from SOCORPRO noholdlock
	where Cop_Folio = @Cop_Folio

if isnull(@Cop_FolAux, @Ent_Cero) = @Ent_Cero begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Registro de Correo no existe',
			Err_Foco	= ''
	rollback
	return 1
end

if isnull(@Cop_Nombre, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Nombre Incorrecto',
			Err_Foco	= 'txtPrm_Numero'
	rollback
	return 1
end

if isnull(@Cop_Correo, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Correo Incorrecto',
			Err_Foco	= 'txtCop_Correo'
	rollback
	return 1
end

if not @Cop_Tipo in (@Str_Uno, @Str_Dos) begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'Tipo de Correo Incorrecto',
			Err_Foco	= 'txtCop_Correo'
	rollback
	return 1
end

update SOCORPRO set
	Cop_Nombre	= @Cop_Nombre, 
	Cop_Correo	= @Cop_Correo, 
	Cop_Tipo	= @Cop_Tipo,
	
	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino
	where Cop_Folio	= @Cop_Folio
