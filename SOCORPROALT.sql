create procedure SOCORPROALT (
	@Cop_Modulo	char(2), 
	@Cop_Proces	char(3),
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
/* DESCRIPCION: Alta de Correos por Proceso									 */
/*****************************************************************************/

/** REFERENCIAS:
****************************************************************************
** Creó:			Marco A. Morales Ventura							****
** Fecha:			11/Julio/2013										****
** Help:		    00468177											****
*****************************************************************************/

/* Declaración de Variables */
declare @Prm_Folio	int,
		@Prm_Numero	char(3) ,
		@Mod_Codigo char(2)

/* Declaración de Constantes */
declare	@Str_Vacio	char(1),
		@Str_Uno	char(1),
		@Str_Dos	char(2)

/* Asignación de Constantes */
select	@Str_Vacio	= '',			/* String Vacío */
		@Str_Uno	= '1',			/* String Uno */
		@Str_Dos	= '2'			/* String Dos */

if isnull(@Cop_Modulo, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Módulo Incorrecto',
			Err_Foco	= ''
	rollback
	return 1
end

select	@Mod_Codigo = Mod_Codigo
	from SYMODULO noholdlock
	where Mod_Codigo = @Cop_Modulo

if isnull(@Mod_Codigo, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Módulo no Existe',
			Err_Foco	= ''
	rollback
	return 1
end

if isnull(@Cop_Proces, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Proceso Incorrecto',
			Err_Foco	= 'txtCob_Numero'
	rollback
	return 1
end

select	@Prm_Numero = Prm_Numero
	from SOPROMOD noholdlock
	where Prm_Numero = @Cop_Proces

if isnull(@Prm_Numero, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'Proceso Incorrecto',
			Err_Foco	= 'txtPrm_Numero'
	rollback
	return 1
end

if isnull(@Cop_Nombre, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000005',
			Err_Mensaj	= 'Nombre Incorrecto',
			Err_Foco	= 'txtPrm_Numero'
	rollback
	return 1
end

if isnull(@Cop_Correo, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000006',
			Err_Mensaj	= 'Correo Incorrecto',
			Err_Foco	= 'txtCop_Correo'
	rollback
	return 1
end

if not @Cop_Tipo in (@Str_Uno, @Str_Dos) begin
	select	Err_Codigo	= '000007',
			Err_Mensaj	= 'Tipo de Correo Incorrecto',
			Err_Foco	= 'txtCop_Correo'
	rollback
	return 1
end

insert into SOCORPRO values(
		@Cop_Modulo, 	@Cop_Proces, 	@Cop_Nombre, 	@Cop_Correo, 	@Cop_Tipo, 		
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		
		@SucDestino)
