create procedure SOANATERPRO (
   @Ant_Numero int,
   @Ant_EFTiCu int,
   @Ant_Varios numeric(14,2),
   @Ant_Total numeric(14,2),
   @Tip_Proces char(1),
   
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)
)
as

/*******************************************************************
** DESCRIPCION: Proceso de guardado de analitica terreno		  **
********************************************************************
** Creo:		Felipe Castillo									  **
** Fecha:		03/09/2017										  **
** Help:		929417 											  **
********************************************************************/

declare @Tip_ProA char(1)		/* Variable de tipo cadena con valor A */
		
SET @Tip_ProA = 'A'
	
if @Tip_Proces = @Tip_ProA begin
	update SOANATER set
		Ant_Varios = @Ant_Varios,
		Ant_Total  = @Ant_Total,
		
		NumTransac = @NumTransac,
		Transaccio = @Transaccio,
		Usuario    = @Usuario,
		FechaSis   = @FechaSis,
		SucOrigen  = @SucOrigen,
		SucDestino = @SucDestino
	where Ant_EFTiCu = @Ant_EFTiCu
	
	select	Err_Codigo	= '000000',	Err_Mensaj	= 'Registro Actualizado'
end
