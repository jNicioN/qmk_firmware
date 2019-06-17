create procedure SOANESCOCON (
   @Aec_Numero numeric,
   @Aec_EsFiCu int,
   @Tip_Consul char(2),
   @NumTransac	char(10),
   @Transaccio	char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino	char(3),
   @Modulo char(2)) 
 as

/*************************************************************************
** DESCRIPCION: consulta de registros de analitica estandar concepto	**
**************************************************************************
** Creo:		Felipe Castillo Rendon                     				**
** Fecha:		19/05/2017                               				**
** Help:		929417 					 								**
*************************************************************************/

/* Declaracion de Variables */
declare @Tip_ConTip char(1),
        @Tip_ConCon char(1), 
        @Str_C char(1), 
        @Str_Uno char(1), 
        @Str_Dos char(1) 

select @Tip_ConTip = substring(@Tip_Consul, 1, 1),
       @Tip_ConCon = substring(@Tip_Consul, 2, 1), 
       @Str_C = 'C',
       @Str_Uno = '1',
       @Str_Dos = '2' 

if @Tip_ConTip	= @Str_C begin /* Consulta */
   if @Tip_ConCon = @Str_Uno begin		/* C1 */
     select 
          Aec_Numero,    Aec_AnaEst,    Aec_Concep,    Aec_Monto,    Aec_Porcen,
          NumTransac,	 Transaccio,    Usuario,    	FechaSis,    SucOrigen,
          SucDestino 
     from SOANESCO noholdlock 
     where Aec_Numero = @Aec_Numero
   end
end else begin
   if @Tip_ConCon = @Str_Uno begin		/* L1 */
     select 
          Aec_Numero,    Aec_AnaEst,    Aec_Concep,    Aec_Monto,    	Aec_Porcen,
          NumTransac,	 Transaccio,    Usuario,       FechaSis,    	SucOrigen,    	
          SucDestino 
     from SOANESCO noholdlock   
   end
   if @Tip_ConCon = @Str_Dos begin		/* L2 */
     select 
          ses.Aec_Numero,    ses.Aec_AnaEst,    ses.Aec_Concep,    	ses.Aec_Monto,    	ses.Aec_Porcen,
          ses.NumTransac,	 ses.Transaccio,    ses.Usuario,    	ses.FechaSis,    	ses.SucOrigen,    	
          ses.SucDestino 
     from SOANAEST sae noholdlock
     inner join SOANESCO ses noholdlock
		 on ses.Aec_AnaEst = sae.Ane_Numero
     where sae.Ane_EsFiCu = @Aec_EsFiCu
   end
end
