create procedure SOESFITIACT (
	@Eft_Numero	int,
	@Eft_EstFin int,
	@Eft_TipCue int,
	@Eft_TieAna bit,
	@Tip_Actual char(1),
	@Eft_Valor numeric(17,4),
	@Eft_Porcen numeric(10,2),
	
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
/** Modifico:		Jose Rodriguez								*/
/** Fecha:			09/03/2020                             		*/
/** Help:			1370378 			 						*/
/** Descripcion:	Se agrega parametros de Entrada @Eft_Valor,	*/
/** @Eft_Porcen y Tipo De Actualizacion B						*/
/****************************************************************/
/** Creo:		Felipe Castillo									*/
/** Fecha:		19/05/2017                               		*/
/** Help:		929417 					 						*/
/****************************************************************/

/* Declaracion de Constantes*/
declare @Tip_ActA char(1),  /*Tipo Actualidacion A */
		@Tip_ActB char(1)   /*Tipo Actualidacion B */
		
/* Asiganacion*/
SET @Tip_ActA = 'A',
	@Tip_ActB = 'B'
	
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
end else if @Tip_Actual = @Tip_ActB begin
	update SOESFITI set
		Eft_Valor = @Eft_Valor,
		Eft_Porcen = @Eft_Porcen,
		
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