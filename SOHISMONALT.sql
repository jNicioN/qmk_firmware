create procedure SOHISMONALT (
	@Him_Moneda char(2),
	@Him_Fecha  smalldatetime, 
	@Him_EfeCom float,
	@Him_EfeVen	float,
	@Him_DocCom	float,
	@Him_DocVen	float,
	@Him_FixCom	float,
	@Him_FixVen	float,
	@Him_CieCom float,
	@Him_CieVen float,
	@Him_SpoCom float,
	@Him_SpoVen float,
	@Him_CieDia float,
	@Him_FixVal	float,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@SoMonedaID	int					/* Declaración de Variables */

declare	@Dob_Cero	double precision	/* Declaración de Constantes */

/* Asignación de Constantes */
select	@Dob_Cero	= 0					/* Double precision en ceros */
	
if exists ( select	Mon_Descri
				from SOMONEDA noholdlock
				where	Mon_Numero	= @Him_Moneda )
				
	if exists ( select	Him_Moneda
					from SOHISMON noholdlock
					where	Him_Moneda	= @Him_Moneda
					  and	Him_Fecha	= @Him_Fecha )
					  
		update SOHISMON set	
			Him_EfeCom	= @Him_EfeCom, 
			Him_EfeVen	= @Him_EfeVen,
			Him_DocCom	= @Him_DocCom, 
			Him_DocVen	= @Him_DocVen, 
			Him_FixCom	= @Him_FixCom, 
			Him_FixVen	= @Him_FixVen, 
			Him_CieCom	= @Him_CieCom, 
			Him_CieVen	= @Him_CieVen,
			Him_SpoCom	= @Him_SpoCom, 
			Him_SpoVen	= @Him_SpoVen,
			Him_CieDia	= @Him_CieDia,
			Him_FixVal	= @Him_FixVal,
			
			NumTransac	= @NumTransac,
			Transaccio	= @Transaccio,
			Usuario		= @Usuario,
			FechaSis	= @FechaSis,
			SucOrigen	= @SucOrigen,
			SucDestino	= @SucDestino

			where	Him_Moneda	= @Him_Moneda
			  and	Him_Fecha	= @Him_Fecha
	else begin
		select	@SoMonedaID	= convert(int, @Him_Moneda)

		insert into SOHISMON values (
			@SoMonedaID,	@Him_Moneda,	@Him_Fecha,		@Him_EfeCom,	@Him_EfeVen, 	
			@Him_DocCom,	@Him_DocVen,	@Him_FixCom,	@Him_FixVen,	@Him_CieCom,	
			@Him_CieVen,	@Him_SpoCom,	@Him_SpoVen,	@Him_CieDia,	@Him_FixVal,
			@Dob_Cero,		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		
			@SucOrigen,		@SucDestino)
	end
