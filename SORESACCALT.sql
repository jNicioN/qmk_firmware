create procedure SORESACCALT(
	@Rea_Numero		int,
	@Rea_Descri 	varchar(254),
	@Rea_TipRes		int,
	@Rea_FecRes     smalldatetime,
	@NumTransac		char(10),
	@Transaccio		char(3),
	@Usuario		char(6),
	@FechaSis		smalldatetime,
	@SucOrigen		char(3),
	@SucDestino		char(3),
	@Modulo			char(2))
as
/***************************************************************************
** DESCRIPCIÓN: Alta de restricción de accesos                           **
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
		@Int_Uno	int,
		@Int_Dos	int,
		@Fec_Vacia  smalldatetime

/* Asignación de constantes */
select	@Ent_Cero = 0,
		@Int_Uno = 1,
		@Int_Dos = 2,
		@Fec_Vacia	= '1900-01-01'

if isnull(@Rea_Numero, @Ent_Cero) = @Ent_Cero begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'ID incorrecto',
			Err_Variab	= 'Rea_Numero'
	rollback
	return 1
end

if exists(select Rea_Numero from SORESACC noholdlock where Rea_Numero = @Rea_Numero) begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'El registro ya existe',
			Err_Variab	= 'Rea_Numero'
	rollback
	return 1
end

if @Rea_TipRes not in (@Int_Uno, @Int_Dos) begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Tipo de restriccion no valido',
			Err_Variab	= 'Rea_TipRes'
	rollback
	return 1
end

if isnull(@Rea_FecRes, @Fec_Vacia) = @Fec_Vacia begin
	select @Rea_FecRes = getdate()
end

insert into SORESACC (
	Rea_Numero, Rea_Descri, Rea_TipRes, Rea_FecRes,
	NumTransac, Transaccio, Usuario, FechaSis, SucOrigen, SucDestino)
	values (
	@Rea_Numero, @Rea_Descri, @Rea_TipRes, @Rea_FecRes, @NumTransac, @Transaccio, 
	@Usuario, @FechaSis, @SucOrigen, @SucDestino)

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro agregado'