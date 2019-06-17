create procedure SOUSUREGALT (
	@Usr_Numero	int output,
	@Usr_Usuari	char(6),
	@Usr_Region	int,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/******************************************************************/
/* DESCRIPCION: Alta de Usuario-Regiones				  */
/******************************************************************/
/* Modifica:	Jorge A. Garcia Leal							****
** Fecha:		05/12/2016										****
** Help:		931787 											****
** Modifica:	Se cambia estructura de tabla 					***/
/******************************************************************/
/* DESCRIPCION: Alta de Usuario-Regiones					  */
/******************************************************************/
/* Creo:		Claudia V Sandoval P							****
** Fecha:		04/10/2016										****
** Help:		903360 											****
********************************************************************/
/* Asignacion de Constantes */
declare	@Str_Vacio	char(1),
		@Str_Activo	char(1),
		@Int_Si		tinyint,
		@Int_No		tinyint

declare	@Int_Existe	tinyint

select	@Str_Vacio	= '',			/* Caracter Vacio			*/
		@Str_Activo	= 'A',
		@Int_Si		= 1,
		@Int_No		= 0

select	@Int_Existe	= @Int_No
select	@Int_Existe	= @Int_Si
	from SOUSUREG noholdlock
	where	Usr_Region = @Usr_Region
	  and	Usr_Usuari = @Usr_Usuari

if @Int_Existe	= @Int_Si begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'La relacion ya existe'

	rollback
	return 1
end

select	@Int_Existe	= @Int_No
select	@Int_Existe	= @Int_Si
	from SOUSUARI noholdlock
	where	Usu_Numero = @Usr_Usuari
	  and	Usu_Status = @Str_Activo

if @Int_Existe	= @Int_No begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'El Usuario no existe o no esta activo'

	rollback
	return 1
end

select	@Int_Existe	= @Int_No
select	@Int_Existe	= @Int_Si
	from SOREGION noholdlock
	where	Reg_Numero = @Usr_Region
	  and	Reg_Status = @Str_Activo

if @Int_Existe	= @Int_No begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'La Region no existe o no esta activa'

	rollback
	return 1
end

insert into SOUSUREG (
	Usr_Usuari,		Usr_Region,		NumTransac,		Transaccio,		Usuario,
	FechaSis,	SucOrigen,	SucDestino )
	values(
	@Usr_Usuari,	@Usr_Region,	@NumTransac,	@Transaccio,	@Usuario,
	@FechaSis,	@SucOrigen,	@SucDestino )

select	@Usr_Numero	= @@IDENTITY

if @@nestlevel = 1 begin
	select 	Err_Codigo = '000000',
			Err_Mensaj = 'Relacion Usuario-Region agregada',
			Usr_Numero = @Usr_Numero
end
