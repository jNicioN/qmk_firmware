create procedure SOANAPASACT (
   @Anp_Numero int,
   @Anp_EFTiCu int,
   @Anp_VarTot numeric(10,2),
   @Anp_Total numeric(10,2),
   @Tip_Actual char(1),
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
as

/*********************************************************************
** DESCRIPCION: Creado para actualizar registros de SOANAPAS      	**
**********************************************************************
** Creo:		Felipe Castillo		                     			**
** Fecha:		21/05/2017                               			**
** Help:		929417 					 							**
*********************************************************************/

/* Declaracion de variables  */

/* Declaración de constantes */
declare	@Tip_ActA char(1),
		@Tip_ActB char(1)

/* Asignación de constantes */
select	@Tip_ActA = 'A',
		@Tip_ActB = 'B'
		
if @Tip_Actual = @Tip_ActA begin
	update SOANAPAS set 
		Anp_VarTot = (select (snp.Anp_Total - sum(snc.Apc_Total ))
						from SOANAPAS snp noholdlock
						inner join SOANPACO snc noholdlock
							 on snp.Anp_Numero = snc.Apc_AnaPas
					     where snp.Anp_Numero = @Anp_Numero
					     group by snp.Anp_EFTiCu),
		NumTransac = @NumTransac, 
		Transaccio = @Transaccio, 
		Usuario    = @Usuario, 
		FechaSis   = @FechaSis, 
		SucOrigen  = @SucOrigen, 
		SucDestino = @SucDestino
     	where Anp_Numero = @Anp_Numero
	
	select	Err_Codigo	= '000000',	
			Err_Mensaj	= 'Registro Actualizado'
	
end
