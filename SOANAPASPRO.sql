create procedure SOANAPASPRO (
	@Anp_Numero int,
	@Tip_Proces char(1),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2)
)
as

/*******************************************************************
** DESCRIPCION: Proceso de guardado de analitica pasivo		  	  **
********************************************************************
** Modifico:	Edwin Santiago							          **
** Fecha:		05/06/2018										  **
** Descripcion: Se agrego el tipo de proceso B para analitica de  ** 
**				pasivos bancarios                                 **  
** Help:		1114960  										  **
********************************************************************
** Creo:		Felipe Castillo									  **
** Fecha:		10/05/2017										  **
** Help:		929417 											  **
********************************************************************/

declare @Tip_ProA char(1), /* Caracter A */
		@Tip_ProB char(1), /* Caracter B */
		@Ent_Cero int      /* Entero Cero */
		
SET @Tip_ProA = 'A',
	@Tip_ProB = 'B',
	@Ent_Cero = 0
	
if @Tip_Proces = @Tip_ProA begin
	update SOANAPAS set 
		Anp_VarTot = (select (snp.Anp_Total - sum(snc.Apc_Total ))
						from SOANAPAS snp noholdlock
						inner join SOANPACO snc noholdlock
							 on snp.Anp_Numero = snc.Apc_AnaPas
					     where snp.Anp_Numero = @Anp_Numero
					     group by snp.Anp_EFTiCu),
		NumTransac = @NumTransac, 
		Transaccio = @Transaccio, 
		Usuario    = @Usuario, 
		FechaSis   = @FechaSis, 
		SucOrigen  = @SucOrigen, 
		SucDestino = @SucDestino
     where Anp_Numero = @Anp_Numero
	
	select	Err_Codigo	= '000000',	
			Err_Mensaj	= 'Registro Actualizado'
			
end else if @Tip_Proces = @Tip_ProB begin
	update SOANAPAS set 
		Anp_VarTot = (select (sum(snc.Apc_Total ))
						from SOANAPAS snp noholdlock
						inner join SOANPACO snc noholdlock
							 on snp.Anp_Numero = snc.Apc_AnaPas
					     where snp.Anp_Numero = @Anp_Numero
					     group by snp.Anp_EFTiCu),
		NumTransac = @NumTransac, 
		Transaccio = @Transaccio, 
		Usuario    = @Usuario, 
		FechaSis   = @FechaSis, 
		SucOrigen  = @SucOrigen, 
		SucDestino = @SucDestino
     where Anp_Numero = @Anp_Numero
	
	select	Err_Codigo	= '000000',	
			Err_Mensaj	= 'Registro Actualizado'
end
