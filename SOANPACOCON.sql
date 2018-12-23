create procedure SOANPACOCON (
   @Apc_Numero numeric,
   @Apc_AnaPas int,
   @Tip_Consul char(2),
   @NumTransac	char(10),
   @Transaccio	char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino	char(3),
   @Modulo char(2)) 
 as

/*********************************************************************
** DESCRIPCION: Se elimina campo Apc_FecVen y se agrega Apc_Vencim	**
**********************************************************************
** Modifico:	Edwin Dennis    	                    		    **
** Fecha:		15/06/2018                               			**
** Help:		1114960 					 						**
*********************************************************************
** DESCRIPCION: Consulta de registros de analitica pasivo concepto	**
**********************************************************************
** Creo:		Felipe Castillo		                    			**
** Fecha:		19/05/2017                               			**
** Help:		929417 					 							**
*********************************************************************/

/* Declaracion de Variables */
declare @Tip_ConTip char(1), /* Consulta Tipo C/L*/
        @Tip_ConCon char(1), /* Tipo Consecutivo */
        @Str_C char(1),      /* Tipo C */
        @Str_Uno char(1),    /* Tipo 1 */
        @Str_Dos char(1)     /* Tipo 2 */

select @Tip_ConTip = substring(@Tip_Consul, 1, 1),
       @Tip_ConCon = substring(@Tip_Consul, 2, 1), 
       @Str_C = 'C',
       @Str_Uno = '1',
       @Str_Dos = '2' 

if @Tip_ConTip	= @Str_C begin /* Consulta */
   if @Tip_ConCon = @Str_Uno begin		/* C1 */
     select 
          Apc_Numero,   Apc_AnaPas,    	Apc_Concep,    	Apc_MonOri,    	Apc_Vencim, 
          Apc_Cp,    	Apc_Lp,    		Apc_Total,    	Apc_Observ,    	Apc_Banreg, 
          NumTransac,   Transaccio,    	Usuario,    	FechaSis,    	SucOrigen, 
          SucDestino 
     from SOANPACO noholdlock 
     where Apc_Numero = @Apc_Numero
   end
end else begin
   if @Tip_ConCon = @Str_Uno begin		/* L1 */
     select 
          Apc_Numero,   Apc_AnaPas,    	Apc_Concep,    	Apc_MonOri,    	Apc_Vencim, 
          Apc_Cp,    	Apc_Lp,    		Apc_Total,    	Apc_Observ,    	Apc_Banreg, 
          NumTransac,   Transaccio,    	Usuario,    	FechaSis,    	SucOrigen, 
          SucDestino 
     from SOANPACO noholdlock   
   end
    if @Tip_ConCon = @Str_Dos begin		/* L2 */
     select 
          spc.Apc_Numero,    	spc.Apc_AnaPas,    	spc.Apc_Concep,    	spc.Apc_MonOri,    	spc.Apc_Vencim, 
          spc.Apc_Cp,    		spc.Apc_Lp,    		spc.Apc_Total,    	spc.Apc_Observ,    	spc.Apc_Banreg, 
          spc.NumTransac,    	spc.Transaccio,    	spc.Usuario,    	spc.FechaSis,    	spc.SucOrigen, 
          spc.SucDestino 
     from SOANPACO spc noholdlock
     inner join SOANAPAS snp noholdlock
		 on spc.Apc_AnaPas = snp.Anp_Numero
     where Apc_AnaPas = @Apc_AnaPas
   end
end
