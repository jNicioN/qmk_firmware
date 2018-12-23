create procedure SORIEMFICON (
   @Ref_Numero int,
   @Ref_NumRib int,
   @Ref_NumPer char(8),
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
/* DESCRIPCION: Consulta de registros de Empresas Filiales RIB	*/
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
        @Str_Dos char(1),
        @Ref_Activo int

select @Str_C = 'C',
       @Str_Uno = '1',
       @Str_Dos = '2' 

select @Tip_ConTip = substring(@Tip_Consul, 1, 1),
       @Tip_ConCon = substring(@Tip_Consul, 2, 1) ,
       @Ref_Activo = 1


if @Tip_ConTip	= @Str_C begin /* 'C': Consulta */
   if @Tip_ConCon = @Str_Uno begin		/* C1 */
     select 
          Ref_Numero,    Ref_NumRib,    Ref_NumPer,    Ref_PriAct,    Ref_TiReNe, 
          Ref_TiReOt,    Ref_PeSiRf,    Ref_Activo 
     from SORIEMFI noholdlock 
     where Ref_Numero = @Ref_Numero
   end
end else begin
   if @Tip_ConCon = @Str_Uno begin		/* L1 */
     select 
          Ref_Numero,    Ref_NumRib,    Ref_NumPer,    Ref_PriAct,    Ref_TiReNe, 
          Ref_TiReOt,    Ref_PeSiRf,    Ref_Activo 
     from SORIEMFI noholdlock 
  end

   if @Tip_ConCon = @Str_Dos begin 
     select 
          Ref_Numero,    Ref_NumRib,    Ref_NumPer,    Ref_PriAct,    Ref_TiReNe, 
          Ref_TiReOt,    Ref_PeSiRf,    Ref_Activo 
     from SORIEMFI noholdlock 
      where Ref_NumRib = @Ref_NumRib 
        and Ref_Activo = @Ref_Activo
   end 
end
