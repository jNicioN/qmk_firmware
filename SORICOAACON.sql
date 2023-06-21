create procedure SORICOAACON (
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
/*				Adicional de RIB								*/
/****************************************************************/
/* Modifico:	Raul Muniz										*/
/* Fecha:		21/06/2023										*/
/* C.Cambios:	29013											*/
/* Descripcion: Se modifican consultas C1, L1 y L2 para 		*/
/*				regresar campos de inclusion de la mujer		*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
/* Declaracion de Variables */
declare @Tip_ConTip char(1),
        @Tip_ConCon char(1), 
        @Str_C char(1) 

declare @Str_Uno char(1), 
        @Str_Dos char(1) 

select @Str_C = 'C',
       @Str_Uno = '1',
       @Str_Dos = '2' 

select @Tip_ConTip = substring(@Tip_Consul, 1, 1),
       @Tip_ConCon = substring(@Tip_Consul, 2, 1) 


if @Tip_ConTip	= @Str_C begin /* 'C': Consulta */
   if @Tip_ConCon = @Str_Uno begin		/* C1 */
     select 
          Rca_Numero,	Rca_NumRib,	Rca_Tipo,	Rca_PoPaMu,	Rca_ConMuj,
          Rca_PeAlDi, 	Rca_MuAlDi,	Rca_DiPrMi,	Rca_GeDiGe,	Rca_GePrCo
     from SORICOAA noholdlock 
     where Rca_Numero = @Rca_Numero
   end
end else begin
   if @Tip_ConCon = @Str_Uno begin		/* L1 */
     select 
          Rca_Numero,	Rca_NumRib,	Rca_Tipo,	Rca_PoPaMu,	Rca_ConMuj,
          Rca_PeAlDi, 	Rca_MuAlDi,	Rca_DiPrMi,	Rca_GeDiGe,	Rca_GePrCo
     from SORICOAA noholdlock 
  end

   if @Tip_ConCon = @Str_Dos begin 
     select 
          Rca_Numero,	Rca_NumRib,	Rca_Tipo,	Rca_PoPaMu,	Rca_ConMuj,
          Rca_PeAlDi, 	Rca_MuAlDi,	Rca_DiPrMi,	Rca_GeDiGe,	Rca_GePrCo
     from SORICOAA noholdlock 
      where Rca_NumRib = @Rca_NumRib 
   end 
end