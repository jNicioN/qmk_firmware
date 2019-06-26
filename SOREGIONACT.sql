create procedure SOREGIONACT(
   @Reg_Numero int,
   @Reg_Descri varchar(35),
   @Reg_Status char(1),
   @Reg_SegNum int,
   @Tip_Actual	char(1),
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2))
as


/****************************************************************/
/* DESCRIPCION: Actualizacion de Regiones						*/
/****************************************************************/
/** Creo:			Edwin Dennis Santiago						*/
/** Fecha:			11/06/2019                               	*/
/** Help:			1212881 					 				*/
/****************************************************************/

/* Declaracion de Constantes */
declare @Str_A char(1)		/* Caracter A */
		

/* Asignacion de Constantes */
select 	@Str_A = 'A'

if @Tip_Actual = @Str_A begin

	update SOREGION set
		Reg_Status	= @Reg_Status,
		NumTransac = @NumTransac,
		Transaccio = @Transaccio,
		Usuario    = @Usuario,
		FechaSis   = @FechaSis,
		SucOrigen  = @SucOrigen,
		SucDestino = @SucDestino
	where Reg_Numero = @Reg_Numero

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Actualizado Correctamente',
       Reg_Numero = @Reg_Numero
end
