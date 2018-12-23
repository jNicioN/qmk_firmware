create procedure SOANTECOBAJ (
   @Atc_Numero int,
   
   @NumTransac	char(10),
   @Transaccio	char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino	char(3),
   @Modulo char(2))
 as

/*****************************************************************
** DESCRIPCION: Baja de analitica terreno concepto				**
******************************************************************
*** Creo:		Felipe Castillo									**
*** Fecha:		29/08/2017                               		**
*** Help:		929417 					 						**
*****************************************************************/

declare @Ent_Cero int /* Variable de tipo de consulta o lista */

select @Ent_Cero = 0

update SOANTECO
	set 
	Atc_EstAna = @Ent_Cero,
	
	NumTransac = @NumTransac,
	Transaccio = @Transaccio,
	Usuario = @Usuario,
	FechaSis = @FechaSis,
	SucOrigen = @SucOrigen,
	SucDestino = @SucDestino
where Atc_Numero = @Atc_Numero

select	Err_Codigo = '000000',
Err_Mensaj = 'Registro Borrado Correctamente'
