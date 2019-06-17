create procedure SOTRAHISCON (
	@Tipo_Clave		char(1),
	@FechaConIn		smalldatetime,
	@FechaConFi		smalldatetime,
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as


if @Tipo_Clave = 'A'	/*	Transferencia Banregio  (traban)	*/
	begin
		select distinct Cca_Client, Cca_Cuenta,
			   Bit_TCPDir, FechaSis  
		from BECLCUAB a noholdlock, BEBITHIS b noholdlock 
		where FechaSis >= @FechaConIn 
		  	  and FechaSis < @FechaConFi
			  and Cca_Client = Bit_Client 
			  and Bit_Operac = '007' 
		order by Cca_Client
	end
	
if @Tipo_Clave = 'B'	/*	Cuentas Pagos Interbancarios	*/
	begin
		select Distinct Bpi_Client, Bpi_CtaExt, 
			   Bpi_BanExt, FechaSis 
		from BECLCUPI a noholdlock, BEBITHIS b noholdlock
		where FechaSis >= @FechaConIn 
			  and FechaSis < @FechaConFi  
			  and Bpi_Client = Bit_Client 
			  and Bit_Operac = '029' 
		order by Bpi_Client
	end
	
if @Tipo_Clave = 'C'	/*	ALta de cuentas para Spei	*/
	begin
		select Distinct Spe_Client, Spe_CtaExt,
			   Spe_BanExt , FechaSis 
		from BECLCUSP a noholdlock, BEBITHIS b noholdlock 
		where FechaSis >= @FechaConIn 
			  and FechaSis <= @FechaConFi 
			  and Spe_Client = Bit_Client 
			  and Bit_Operac = '035'
		order by Spe_Client, Spe_CtaExt
	end	

