create procedure SOBIACREALT(
	@Bar_ResAct		bit,
	@Bar_FecReg		smalldatetime,
	@Bar_MotCam		varchar(254),
	@Bar_PeAcRe		int,
	@Bar_Pantal		char(8),
	@Bar_Usuari		char(6),
	@NumTransac		char(10),
	@Transaccio		char(3),
	@Usuario		char(6),
	@FechaSis		smalldatetime,
	@SucOrigen		char(3),
	@SucDestino		char(3),
	@Modulo			char(2))
as
/***************************************************************************
** DESCRIPCIÓN: Alta de bitácora de cambios en perfiles restringidos     **
****************************************************************************
**                                                                       **
** REFERENCIAS:                                                          **
****************************************************************************
** Creó: Félix González Morales                                          **
** Fecha: 20/Diciembre/2024                                              **
** HelpDesk: 49934                                                       **
****************************************************************************/

/* Declaración de constantes */
declare	@Fec_Vacia  smalldatetime

/* Asignación de constantes */
select	@Fec_Vacia	= '1900-01-01'

if isnull(@Bar_FecReg, @Fec_Vacia) = @Fec_Vacia begin
	select @Bar_FecReg = getdate()
end

insert into SOBIACRE (
	Bar_ResAct, Bar_FecReg, Bar_MotCam, Bar_PeAcRe, Bar_Pantal, Bar_Usuari,
	NumTransac, Transaccio, Usuario, FechaSis, SucOrigen, SucDestino)
	values (
	@Bar_ResAct, @Bar_FecReg, @Bar_MotCam, @Bar_PeAcRe, @Bar_Pantal, @Bar_Usuari, 
	@NumTransac, @Transaccio, @Usuario, @FechaSis, @SucOrigen, @SucDestino)

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro agregado'