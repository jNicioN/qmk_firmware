create procedure SOESFITIACT (
	@Eft_Numero	int,
	@Eft_EstFin int,
	@Eft_TipCue int,
	@Eft_TieAna bit,
	@Tip_Actual char(1),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2)
)
as

/****************************************************************/
/** DESCRIPCION: Actualizacion de estado financiero tipo cuenta	*/
/****************************************************************/
/** Creo:		Felipe Castillo									*/
/** Fecha:		19/05/2017                               		*/
/** Help:		929417 					 						*/
/****************************************************************/

declare @Tip_ActA char(1)
		
SET @Tip_ActA = 'A'
	
if @Tip_Actual = @Tip_ActA begin
	update SOESFITI set 
		Eft_TieAna	= @Eft_TieAna,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino 	= @SucDestino
		where Eft_EstFin = @Eft_EstFin 
		  and Eft_TipCue = @Eft_TipCue
		
	select	Err_Codigo	= '000000',	
			Err_Mensaj	= 'Registro Actualizado'
end
