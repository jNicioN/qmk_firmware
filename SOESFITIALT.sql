create procedure SOESFITIALT (
   @Eft_Numero int,
   @Eft_EstFin int,
   @Eft_TipCue int,
   @Eft_Valor numeric(17,4),
   @Eft_Porcen numeric(10,2),
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as

/****************************************************************/
/** DESCRIPCION: Alta de registros de estado financiero			*/
/**				tipo cuenta en SOESFITI							*/
/****************************************************************/
/** Modifico:		Raul Muniz									*/
/** Fecha:			12/12/2019                             		*/
/** Help:			1318047				 						*/
/** Descripcion:	Se modifico parametro @Eft_Valor a numeric	*/
/**					(17,4)										*/
/****************************************************************/
/** Creo:			Felipe Castillo								*/
/** Fecha:			19/05/2017                             		*/
/** Help:			929417 				 						*/
/****************************************************************/

/* Declaracion de Variables */
declare	@Int_Uno int
select	@Int_Uno = 0

Insert Into SOESFITI 
	(Eft_EstFin,    Eft_TipCue,		Eft_Valor,		Eft_Porcen,		NumTransac, 
	Transaccio,		Usuario,		FechaSis,		SucOrigen,		SucDestino) 
	values (
	@Eft_EstFin,	@Eft_TipCue,	@Eft_Valor,		@Eft_Porcen,	@NumTransac, 
	@Transaccio,    @Usuario,    	@FechaSis,		@SucOrigen, 	@SucDestino) 

select @Eft_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
			Err_Mensaj = 'Relacion agregada correctamente', 
			Eft_Numero= @Eft_Numero 
end