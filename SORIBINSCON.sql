create procedure SORIBINSCON (
   @Rii_Numero int,
   @Rii_NumRib int,
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
/* DESCRIPCION: Consulta registros de Instalaciones de RIB		*/
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
          Rii_Numero,	Rii_NumRib,		Rii_TipIns,		Rii_Por,		Rii_ReMeIn, 
          Rii_RMInMo,	Rii_ArrIns,		Rii_AnCoIn,		Rii_VeCoIn,		Rii_AseIns, 
		  Rii_AraIns,	Rii_PlPoIn,		Rii_VePoIn,		Rii_MoCoIn,		Rii_MCInMo,
		  Rii_CubInc,	Rii_CubTer,		Rii_CubHur,		Rii_CubInu,		Rii_CubOtr,
		  Rii_CuOtEs,	Rii_PrePor,		Rii_RMInVa,		Rii_RMIVaM,		Rii_RMInPa,
		  Rii_RMIPaM 
     from SORIBINS noholdlock 
     where Rii_Numero = @Rii_Numero
   end
end else begin
   if @Tip_ConCon = @Str_Uno begin		/* L1 */
     select 
          Rii_Numero,	Rii_NumRib,		Rii_TipIns,		Rii_Por,		Rii_ReMeIn, 
          Rii_RMInMo,	Rii_ArrIns,		Rii_AnCoIn,		Rii_VeCoIn,		Rii_AseIns, 
		  Rii_AraIns,	Rii_PlPoIn,		Rii_VePoIn,		Rii_MoCoIn,		Rii_MCInMo,
		  Rii_CubInc,	Rii_CubTer,		Rii_CubHur,		Rii_CubInu,		Rii_CubOtr,
		  Rii_CuOtEs,	Rii_PrePor,		Rii_RMInVa,		Rii_RMIVaM,		Rii_RMInPa,
		  Rii_RMIPaM 
     from SORIBINS noholdlock 
  end

   if @Tip_ConCon = @Str_Dos begin 
     select 
          Rii_Numero,	Rii_NumRib,		Rii_TipIns,		Rii_Por,		Rii_ReMeIn, 
          Rii_RMInMo,	Rii_ArrIns,		Rii_AnCoIn,		Rii_VeCoIn,		Rii_AseIns, 
		  Rii_AraIns,	Rii_PlPoIn,		Rii_VePoIn,		Rii_MoCoIn,		Rii_MCInMo,
		  Rii_CubInc,	Rii_CubTer,		Rii_CubHur,		Rii_CubInu,		Rii_CubOtr,
		  Rii_CuOtEs,	Rii_PrePor,		Rii_RMInVa,		Rii_RMIVaM,		Rii_RMInPa,
		  Rii_RMIPaM 
     from SORIBINS noholdlock 
      where Rii_NumRib = @Rii_NumRib 
   end 
end
