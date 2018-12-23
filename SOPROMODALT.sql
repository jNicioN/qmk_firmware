create procedure SOPROMODALT (
	@Prm_Modulo   char(2),
   	@Prm_Descri   varchar(50),
   	@Prm_Observ   varchar(250),
   
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*****************************************************************************/
/* DESCRIPCION: Alta de Procesos por Módulo									 */
/*****************************************************************************/

/** REFERENCIAS:
****************************************************************************
** Creó:			Marco A. Morales Ventura							****
** Fecha:			10/Julio/2013										****
** Help:		    00468177											****
*****************************************************************************/

/* Declaración de Variables */
declare @Prm_Folio	int,
		@Prm_Numero	char(3) ,
		@Mod_Codigo char(2)

/* Declaración de Constantes */
declare	@Ent_Cero	int,
		@Ent_Uno	int,
		@Str_Vacio	char(1)

/* Asignación de Constantes */
select	@Ent_Cero	= 0,			/* Entero en Cero */
		@Ent_Uno 	= 1,			/* Entero en Uno */
		@Str_Vacio	= ''			/* String Vacío */

if isnull(@Prm_Modulo, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Módulo Incorrecto',
			Err_Foco	= 'txtFor_Modulo'
	rollback
	return 1
end

select	@Mod_Codigo = Mod_Codigo
	from SYMODULO noholdlock
	where Mod_Codigo = @Prm_Modulo

if isnull(@Mod_Codigo, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Módulo no Existe',
			Err_Foco	= 'txtFor_Modulo'
	rollback
	return 1
end

if isnull(@Prm_Descri, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Descripción del Proceso Incorrecto',
			Err_Foco	= 'txtPrm_Descri'
	rollback
	return 1
end

select	@Prm_Folio = isNull(max(Prm_Folio),@Ent_Cero) + @Ent_Uno
	from SOPROMOD noholdlock

select	@Prm_Numero	= rtrim(ltrim(convert(char(3), @Prm_Folio)))

exec UTCERIZQ @Prm_Numero output, 3

insert into SOPROMOD values(
	@Prm_Folio,		@Prm_Numero,	@Prm_Modulo, 	@Prm_Descri, 	@Prm_Observ,
	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		
	@SucDestino)
