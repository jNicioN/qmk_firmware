create procedure SORIBJUICON (
   @Rij_Numero int,
   @Rij_NumRib int,
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
/* DESCRIPCION: Consulta de registros de Juicios de RIB			*/
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
		@Int_Uno int

select @Str_C = 'C',
       @Str_Uno = '1',
       @Str_Dos = '2',
	   @Int_Uno = 1

select @Tip_ConTip = substring(@Tip_Consul, 1, 1),
       @Tip_ConCon = substring(@Tip_Consul, 2, 1) 


if @Tip_ConTip	= @Str_C begin /* 'C': Consulta */
   if @Tip_ConCon = @Str_Uno begin		/* C1 */
     select 
          Rij_Numero,    Rij_NumRib,    Rij_TipJui,    Rij_FecAct,    Rij_Descri, 
          Rij_Activo 
     from SORIBJUI noholdlock 
     where Rij_Numero = @Rij_Numero
   end
end else begin
   if @Tip_ConCon = @Str_Uno begin		/* L1 */
     select 
          Rij_Numero,    Rij_NumRib,    Rij_TipJui,    Rij_FecAct,    Rij_Descri, 
          Rij_Activo 
     from SORIBJUI noholdlock 
  end

   if @Tip_ConCon = @Str_Dos begin 
     select 
          Rij_Numero,    Rij_NumRib,    Rij_TipJui,    Rij_FecAct,    Rij_Descri, 
          Rij_Activo 
     from SORIBJUI noholdlock 
      where Rij_NumRib = @Rij_NumRib 
	  and Rij_Activo = @Int_Uno
   end 
end
