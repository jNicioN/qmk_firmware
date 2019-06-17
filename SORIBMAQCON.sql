create procedure SORIBMAQCON (
   @Rim_Numero int,
   @Rim_NumRib int,
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
/* DESCRIPCION: Consulta de registros de Maquinaria de RIB		*/
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
          Rim_Numero,    Rim_NumRib,    Rim_TipMaq,    Rim_ReMeMa,    Rim_ArrMaq, 
          Rim_AnCoMa,    Rim_FVCoMa,    Rim_AseMaq,    Rim_AraMaq,    Rim_PlPoMa, 
          Rim_VePoMa,    Rim_MoCoMa,    Rim_MCMaMo,    Rim_RMMaMo 
     from SORIBMAQ noholdlock 
     where Rim_Numero = @Rim_Numero
   end
end else begin
   if @Tip_ConCon = @Str_Uno begin		/* L1 */
     select 
          Rim_Numero,    Rim_NumRib,    Rim_TipMaq,    Rim_ReMeMa,    Rim_ArrMaq, 
          Rim_AnCoMa,    Rim_FVCoMa,    Rim_AseMaq,    Rim_AraMaq,    Rim_PlPoMa, 
          Rim_VePoMa,    Rim_MoCoMa,    Rim_MCMaMo,    Rim_RMMaMo 
     from SORIBMAQ noholdlock 
  end

   if @Tip_ConCon = @Str_Dos begin 
     select 
          Rim_Numero,    Rim_NumRib,    Rim_TipMaq,    Rim_ReMeMa,    Rim_ArrMaq, 
          Rim_AnCoMa,    Rim_FVCoMa,    Rim_AseMaq,    Rim_AraMaq,    Rim_PlPoMa, 
          Rim_VePoMa,    Rim_MoCoMa,    Rim_MCMaMo,    Rim_RMMaMo 
     from SORIBMAQ noholdlock 
      where Rim_NumRib = @Rim_NumRib 
   end 
end
