create procedure SOTICUCLMOD (
   @Tcc_Numero int,
   @Tcc_TipCue int,
   @Tcc_ClEsFi int,
   @Tcc_Formul varchar(150),
   @Tcc_Captur bit,
   @Tcc_ForBas varchar(400),
   @Tcc_ForPor varchar(50),
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
as

/****************************************************************/
/* DESCRIPCION: Modificacion registros de tipo cuenta 			*/
/*				clasificacion estado financiero  				*/
/****************************************************************/
/** Creo:		Felipe Castillo									*/
/** Fecha:		19/05/2017                               		*/
/** Help:		929417 					 						*/
/****************************************************************/

update SOTICUCL set 
   Tcc_TipCue = @Tcc_TipCue, 
   Tcc_ClEsFi = @Tcc_ClEsFi, 
   Tcc_Formul = @Tcc_Formul, 
   Tcc_Captur = @Tcc_Captur, 
   Tcc_ForBas = @Tcc_ForBas, 
   Tcc_ForPor = @Tcc_ForPor, 
   NumTransac = @NumTransac, 
   Transaccio = @Transaccio, 
   Usuario    = @Usuario, 
   FechaSis   = @FechaSis, 
   SucOrigen  = @SucOrigen, 
   SucDestino = @SucDestino
where Tcc_Numero = @Tcc_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Tcc_Numero = @Tcc_Numero
