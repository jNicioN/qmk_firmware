create procedure SOANAESTACT (
   @Ane_Numero int,
   @Ane_EsFiCu int,
   @Ane_Total numeric(10,2),
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
** DESCRIPCION: Creado para actualizar registros de SOANAEST      	**
**********************************************************************
** Creo:		Felipe Castillo		                     			**
** Fecha:		18/05/2017                               			**
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
	update SOANAEST set 
		Ane_VarMon = (select (Ane_Total - sum(Aec_Monto))
						from SOANESCO ses noholdlock
						inner join SOANAEST sae noholdlock
							 on sae.Ane_Numero = ses.Aec_AnaEst
						where sae.Ane_EsFiCu = @Ane_EsFiCu
						group by sae.Ane_EsFiCu),
		NumTransac = @NumTransac, 
		Transaccio = @Transaccio, 
		Usuario    = @Usuario, 
		FechaSis   = @FechaSis, 
		SucOrigen  = @SucOrigen, 
		SucDestino = @SucDestino
		where Ane_EsFiCu = @Ane_EsFiCu
	
	select	Err_Codigo	= '000000',	
			Err_Mensaj	= 'Registro Actualizado'
	
end
if @Tip_Actual = @Tip_ActB begin
	update SOANAEST set 
		Ane_Total = @Ane_Total,
		NumTransac = @NumTransac, 
		Transaccio = @Transaccio, 
		Usuario    = @Usuario, 
		FechaSis   = @FechaSis, 
		SucOrigen  = @SucOrigen, 
		SucDestino = @SucDestino
		where Ane_EsFiCu = @Ane_EsFiCu
	
	select	Err_Codigo	= '000000',	
			Err_Mensaj	= 'Registro Actualizado'
end
