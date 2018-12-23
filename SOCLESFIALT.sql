create procedure SOCLESFIALT (
   @Cef_Numero int,
   @Cef_Descrip varchar(50),
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as

/****************************************************************/
/* DESCRIPCION: Alta de registros de clasificacion de			*/
/*				estado financiero								*/
/****************************************************************/
/** Creo:		Felipe Castillo									*/
/** Fecha:		19/05/2017                               		*/
/** Help:		929417 					 						*/
/****************************************************************/

/* Declaracion de Variables */
DECLARE @Int_Uno int
SELECT  @Int_Uno = 1

insert into SOCLESFI 
	(Cef_Descrip,	NumTransac,		Transaccio,		Usuario,	FechaSis, 
	SucOrigen,		SucDestino) 
	values (
	@Cef_Descrip,	@NumTransac,	@Transaccio,	@Usuario,	@FechaSis, 
    @SucOrigen,		@SucDestino) 

select @Cef_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
			Err_Mensaj = 'Relacion agregada correctamente', 
			Cef_Numero= @Cef_Numero 
end
