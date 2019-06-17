create procedure SORIREINCON (
   @Rri_Numero int,
   @Rri_NumRib int,
   @Rri_Activo bit,
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
/* DESCRIPCION: Consulta de registros de Relaciones				*/
/*				Instituciones de RIB							*/
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
          Rri_Numero,    Rri_NumRib,    Rri_Instit,    Rri_Produc,    Rri_PorPar, 
          Rri_FePrC1,    Rri_MoPrC1,    Rri_MoPrC2,    Rri_MoPrC3,    Rri_FePrC2, 
          Rri_FePrC3 
     from SORIREIN noholdlock 
     where Rri_Numero = @Rri_Numero
   end
end else begin
   if @Tip_ConCon = @Str_Uno begin		/* L1 */
     select 
          Rri_Numero,    Rri_NumRib,    Rri_Instit,    Rri_Produc,    Rri_PorPar, 
          Rri_FePrC1,    Rri_MoPrC1,    Rri_MoPrC2,    Rri_MoPrC3,    Rri_FePrC2, 
          Rri_FePrC3 
     from SORIREIN noholdlock 
  end

   if @Tip_ConCon = @Str_Dos begin 
     select 
          Rri_Numero,    Rri_NumRib,    Rri_Instit,    Rri_Produc,    Rri_PorPar, 
          Rri_FePrC1,    Rri_MoPrC1,    Rri_MoPrC2,    Rri_MoPrC3,    Rri_FePrC2, 
          Rri_FePrC3 
     from SORIREIN noholdlock 
      where Rri_NumRib = @Rri_NumRib
        and Rri_Activo = @Rri_Activo
   end 
end
