create procedure SOANATERALT (
   @Ant_Numero int,
   @Ant_EFTiCu int,
   @Ant_Varios numeric(14,2),
   @Ant_Total numeric(14,2),
   
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as

/*******************************************************************
** DESCRIPCION: Alta de registros de analitica terreno        	  **
********************************************************************
** Modifico:		Felipe Castillo Rendon                    	  **
** Fecha:			22/08/2017                               	  **
** Descripcion:		Se quitan los campos Ant_BieInm y Ant_EstAna  **
** Help:			929417 					 					  **
********************************************************************
** Creo:		Felipe Castillo Rendon                     		  **
** Fecha:		19/05/2017                               		  **
** Help:		929417 					 						  **
********************************************************************/

/* Declaracion de Constantes */

DECLARE @Int_Uno int	/* Constante entera con valor 1 */
SELECT  @Int_Uno = 1

insert into SOANATER 
	(Ant_EFTiCu,	Ant_Varios,		Ant_Total, 
	NumTransac,		Transaccio,    Usuario,    		FechaSis,		SucOrigen, 
	SucDestino) 
	values (
	@Ant_EFTiCu,    @Ant_Varios,    @Ant_Total, 
	@NumTransac,    @Transaccio,    @Usuario,		@FechaSis,		@SucOrigen, 
	@SucDestino) 

select @Ant_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
     		Err_Mensaj = 'Relacion agregada correctamente', 
     		Ant_Numero= @Ant_Numero 
end
