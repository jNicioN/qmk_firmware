create procedure SOBITMONALT (
	@Bim_Moneda char(2),
	@Bim_Fecha  smalldatetime, 
	@Bim_EfeCom float,
	@Bim_EfeVen	float,
	@Bim_DocCom	float,
	@Bim_DocVen	float,
	@Bim_FixCom	float,
	@Bim_FixVen	float,
	@Bim_CieCom float,
	@Bim_CieVen float,
	@Bim_SpoCom float,
	@Bim_SpoVen float,	
	@Bim_CieDia	float,
	@Bim_FixVal	float,	

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@SoMonedaID	int					/* Declaración de Variables */
	
if exists ( select	Mon_Descri
				from SOMONEDA noholdlock
				where	Mon_Numero	= @Bim_Moneda ) begin
	
	select	@SoMonedaID	= convert(int, @Bim_Moneda)
											
	insert into SOBITMON values (
		@SoMonedaID,	@Bim_Moneda,	@Bim_Fecha,		@Bim_EfeCom,	@Bim_EfeVen, 	
		@Bim_DocCom,	@Bim_DocVen,	@Bim_FixCom,	@Bim_FixVen,	@Bim_CieCom,	
		@Bim_CieVen,	@Bim_SpoCom,	@Bim_SpoVen,	@Bim_CieDia,	@Bim_FixVal,	
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		
		@SucDestino)
end
