create procedure SORICOACCON (
   @Rca_Numero int,
   @Rca_NumRib int,
   @Tip_Consul char(2),
   @NumTransac	char(10),
   @Transaccio	char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino	char(3),
   @Modulo char(2)) 
 as 
/****************************************************************/
/* DESCRIPCION: Consulta de registros de Composicion Accionaria	*/
/****************************************************************/
/** Modifico:	Antonio Contreras											*/
/** Fecha:		27/08/2025													*/
/** ID Jira:	TCELEM-13418												*/
/** Descripcion: Se modifica consulta L2 para regresa el 		*/
/**					ultimo registro										*/
/****************************************************************/
/** Modifico:	Jose Rodriguez									*/
/** Fecha:		07/06/2019                               		*/
/** Help:		1229452					 						*/
/** Descripcion: Se agrega un campo     						*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
/* Declaracion de Variables */
declare @Tip_ConTip char(1),		/* Tipo de consulta    */
        @Tip_ConCon char(1), 		/* Subtipo de consulta */
        @Str_C char(1) 				/* Constante tipo C    */

declare @Str_Uno char(1), 			/* Constante tipo Uno  */
        @Str_Dos char(1) 			/* Constante tipo Dos  */

select @Str_C = 'C',
       @Str_Uno = '1',
       @Str_Dos = '2' 

select @Tip_ConTip = substring(@Tip_Consul, 1, 1),
       @Tip_ConCon = substring(@Tip_Consul, 2, 1) 


if @Tip_ConTip	= @Str_C begin /* 'C': Consulta */
   if @Tip_ConCon = @Str_Uno begin		/* C1 */
     select 
          Rca_Numero,    Rca_NumRib,    Rca_CoPaGP,    Rca_TipAdm,    Rca_NuCoTo, 
          Rca_NuCoIn,    Rca_TiAdUn,    Rca_PlaSuc,    Rca_OrAdSe,    Rca_ArACIn, 
          Rca_PrCuAd,    Rca_CuExBa,    Rca_CuExPr,    Rca_EdFiAu,    Rca_PrExBa, 
          Rca_EnCuEm,    Rca_ExPoPr,    Rca_InArRi 
     from SORICOAC noholdlock 
     where Rca_Numero = @Rca_Numero
   end
end else begin
   if @Tip_ConCon = @Str_Uno begin		/* L1 */
     select 
          Rca_Numero,    Rca_NumRib,    Rca_CoPaGP,    Rca_TipAdm,    Rca_NuCoTo, 
          Rca_NuCoIn,    Rca_TiAdUn,    Rca_PlaSuc,    Rca_OrAdSe,    Rca_ArACIn, 
          Rca_PrCuAd,    Rca_CuExBa,    Rca_CuExPr,    Rca_EdFiAu,    Rca_PrExBa, 
          Rca_EnCuEm,    Rca_ExPoPr,    Rca_InArRi 
     from SORICOAC noholdlock 
  end

   if @Tip_ConCon = @Str_Dos begin 
     select top 1
          Rca_Numero,    Rca_NumRib,    Rca_CoPaGP,    Rca_TipAdm,    Rca_NuCoTo, 
          Rca_NuCoIn,    Rca_TiAdUn,    Rca_PlaSuc,    Rca_OrAdSe,    Rca_ArACIn, 
          Rca_PrCuAd,    Rca_CuExBa,    Rca_CuExPr,    Rca_EdFiAu,    Rca_PrExBa, 
          Rca_EnCuEm,	 Rca_ExPoPr,    Rca_InArRi 
     from SORICOAC noholdlock 
      where Rca_NumRib = @Rca_NumRib 
      order by Rca_Numero desc
   end 
end