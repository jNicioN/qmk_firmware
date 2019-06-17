create procedure SOTRANSACON (
	@Tipo_Clave	char(1),
	@FechaConIn	smalldatetime,
	@FechaConFi	smalldatetime,
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*	Declaración de Constantes */
declare	@Tip_TraBan	char(1),
		@Tip_TraPib	char(1),
		@Tip_TraSpe	char(1),
		@Bit_AltBan	char(3),
		@Bit_AltPib	char(3),
		@Bit_AltSpe	char(3)

/*	Asignación de Constantes */		
select	@Tip_TraBan	= 'A',
		@Tip_TraPib	= 'B',
		@Tip_TraSpe	= 'C',
		@Bit_AltBan	= '007',
		@Bit_AltPib	= '029',
		@Bit_AltSpe	= '035'

if @Tipo_Clave = @Tip_TraBan begin	/*	Transferencia Banregio  (traban)	*/
	select distinct Cca_Client, Cca_Cuenta,
		   Bit_TCPDir, FechaSis  
	from BECLCUAB a noholdlock, BEBITACO b noholdlock 
	where Bit_Fecha >= @FechaConIn 
	  and Bit_Fecha <= @FechaConFi 
	  and Cca_Client = Bit_Client 
	  and Bit_Operac = @Bit_AltBan
	order by Cca_Client
end

if @Tipo_Clave = @Tip_TraPib begin	/*	Cuentas Pagos Interbancarios (piban)	*/
	select Distinct Bpi_Client, Bpi_CtaExt,
		   Bpi_BanExt, Bit_TCPDir,
		   FechaSis 
	from BECLCUPI a noholdlock, BEBITACO b noholdlock 
	where Bit_Fecha >= @FechaConIn 
	  and Bit_Fecha <= @FechaConFi  
	  and Bpi_Client = Bit_Client 
	  and Bit_Operac = @Bit_AltPib
	order by Bpi_Client
end

if @Tipo_Clave = @Tip_TraSpe begin	/* ALta de cuentas para Spei (spei) */
	select Distinct Spe_Client, Spe_CtaExt, 
		   Spe_BanExt, Bit_TCPDir,
		   FechaSis 
	from BECLCUSP a noholdlock, BEBITACO b noholdlock 
	where Bit_Fecha >= @FechaConIn 
	  and Bit_Fecha <= @FechaConFi  
	  and Spe_Client = Bit_Client 
	  and Bit_Operac = @Bit_AltSpe
	order by Spe_Client, Spe_CtaExt
end
