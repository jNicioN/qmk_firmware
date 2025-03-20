create procedure SOPEACREALT(
	@Par_Numero		int,
	@Par_ResAct		bit,
	@Par_FecReg		smalldatetime,
	@Par_ResAcc		int,
	@Par_Pantal		char(8),
	@Par_Perfil		char(3),
	@NumTransac		char(10),
	@Transaccio		char(3),
	@Usuario		char(6),
	@FechaSis		smalldatetime,
	@SucOrigen		char(3),
	@SucDestino		char(3),
	@Modulo			char(2))
as
/***************************************************************************
** DESCRIPCIÓN: Alta de perfiles con accesos restringidos                **
****************************************************************************
**                                                                       **
** REFERENCIAS:                                                          **
****************************************************************************
** Creó: Félix González Morales                                          **
** Fecha: 20/Diciembre/2024                                              **
** HelpDesk: 49934                                                       **
****************************************************************************/

/* Declaración de constantes */
declare	@Ent_Cero	int,
		@Bit_Cero	bit,
		@Bit_Uno	bit,
		@Fec_Vacia  smalldatetime

/* Asignación de constantes */
select	@Ent_Cero = 0,
		@Bit_Cero = 0,
		@Bit_Uno = 1,
		@Fec_Vacia	= '1900-01-01'

if isnull(@Par_Numero, @Ent_Cero) = @Ent_Cero begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'ID incorrecto',
			Err_Variab	= 'Par_Numero'
	rollback
	return 1
end

if exists(select Par_Numero from SOPEACRE noholdlock where Par_Numero = @Par_Numero) begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'El registro ya existe',
			Err_Variab	= 'Par_Numero'
	rollback
	return 1
end

if @Par_ResAct not in (@Bit_Cero, @Bit_Uno) begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Estatus activo o inactivo incorrecto',
			Err_Variab	= 'Par_ResAct'
	rollback
	return 1
end

if not exists(select Rea_Numero from SORESACC noholdlock where Rea_Numero = @Par_ResAcc) begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'No existe la restriccion de acceso',
			Err_Variab	= 'Par_ResAcc'
	rollback
	return 1
end

if not exists(select Pan_Nombre from SAPANTAL noholdlock where Pan_Nombre = @Par_Pantal) begin
	select	Err_Codigo	= '000005',
			Err_Mensaj	= 'No existe la pantalla',
			Err_Variab	= 'Par_Pantal'
	rollback
	return 1
end

if not exists(select Per_Numero from SAPERFIL noholdlock where Per_Numero = @Par_Perfil) begin
	select	Err_Codigo	= '000006',
			Err_Mensaj	= 'No existe el perfil',
			Err_Variab	= 'Par_Perfil'
	rollback
	return 1
end

if isnull(@Par_FecReg, @Fec_Vacia) = @Fec_Vacia begin
	select @Par_FecReg = getdate()
end

insert into SOPEACRE (
	Par_Numero, Par_ResAct, Par_FecReg, Par_ResAcc, Par_Pantal, Par_Perfil,
	NumTransac, Transaccio, Usuario, FechaSis, SucOrigen, SucDestino)
	values (
	@Par_Numero, @Par_ResAct, @Par_FecReg, @Par_ResAcc, @Par_Pantal, @Par_Perfil, 
	@NumTransac, @Transaccio, @Usuario, @FechaSis, @SucOrigen, @SucDestino)

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro agregado'