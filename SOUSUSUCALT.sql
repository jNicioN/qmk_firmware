create procedure SOUSUSUCALT (
	@Usl_Numero	int,
	@Usl_Usuari	char(6),
	@Usl_Sucurs	char(3),
	@Usl_Activo	char(1),
	@Usl_FecIna	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************/
/* DESCRIPCION:	Alta de relación de usuarios con sucursales					*/
/****************************************************************************/
/* REFERENCIAS:																*/
/*****************************************************************************
** Creo:		Fernando Del Angel Sánchez								  ****
** Fecha:		28/Mayo/2013											  ****
** Descripción:	Store de Alta de relación de usuarios con sucursales	  ****
** Help Desk:	539205													  ****
******************************************************************************/

declare	@Suc_Numero	char(3),				/* Declaración de Variables */
		@Usu_Numero char(6)
		
select	@Suc_Numero = '',
        @Usu_Numero = ''
        
declare @Str_Vacio	char(1),				/* Declaración de Constantes */
		@Usl_Total	int, 
		@Suc_Total	int

/* Asignación de Constantes */
select	@Str_Vacio	= '',			/* String Vacio */
		@Usl_Total = 0,				/* Total de usuarios */
        @Suc_Total = 0				/* Total de sucursales */
       
--Validaciones previas a insertar
select @Usl_Total	= count(*)
	from SOUSUSUC noholdlock
	where	Usl_Usuari	= @Usl_Usuari
	  and	Usl_Sucurs	= @Usl_Sucurs

if @Usl_Total	> 0 begin

	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Ya esta dada de alta esta sucursal para este usuario'
	rollback
	return 1
end		

select	@Usu_Numero	= Usu_Numero
	from SOUSUARI noholdlock
	where	Usu_Numero	= @Usl_Usuari

if isnull(@Usu_Numero, @Str_Vacio)	= @Str_Vacio begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'El usuario no existe.'
	rollback
	return 1
end

select	@Suc_Numero	= Suc_Numero
	from SOSUCURS noholdlock
	where	Suc_Numero	= @Usl_Sucurs

if isnull(@Suc_Numero, @Str_Vacio)	= @Str_Vacio begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'La Sucursal no existe.'
	rollback
	return 1
end

/* Inserta los datos de la relación usuarios sucursales */
insert into SOUSUSUC
	(Usl_Usuari,	Usl_Sucurs,		Usl_Activo,		Usl_FecIna,		NumTransac,
	Transaccio,		Usuario,		FechaSis,		SucOrigen,		SucDestino)
	values (
		@Usl_Usuari,	@Usl_Sucurs,	@Usl_Activo,	@Usl_FecIna,	@NumTransac,
		@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino)

select	Usl_Numero	= @@identity,
		Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Agregado'
