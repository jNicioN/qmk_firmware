create procedure SOANAESTPRO (
	@Ane_Numero int,
	@Ane_EsFiCu int,
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
** DESCRIPCION: Proceso de guardado de analitica estandar		  **
********************************************************************
** Creo:		Felipe Castillo									  **
** Fecha:		10/05/2017										  **
** Help:		929417 											  **
********************************************************************/

declare @Tip_ProA char(1),
		@Ent_Cero int
		
SET @Tip_ProA = 'A',
	@Ent_Cero = 0
	
if @Tip_Proces = @Tip_ProA begin
	update SOANAEST set 
		Ane_VarMon = (select (Ane_Total - sum(Aec_Monto))
						from SOANESCO ses noholdlock
						inner join SOANAEST sae noholdlock
							 on sae.Ane_Numero = ses.Aec_AnaEst
					    where sae.Ane_EsFiCu = @Ane_EsFiCu
					    group by sae.Ane_EsFiCu),
		NumTransac = @NumTransac, 
		Transaccio = @Transaccio, 
		Usuario    = @Usuario, 
		FechaSis   = @FechaSis, 
		SucOrigen  = @SucOrigen, 
		SucDestino = @SucDestino
	    where Ane_EsFiCu = @Ane_EsFiCu
	
	select	Err_Codigo	= '000000',	
			Err_Mensaj	= 'Registro Actualizado'
end
