create procedure SORIDILICON (
   @Rdl_Numero int,
   @Rdl_NumRib int,
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
/* DESCRIPCION: Consulta de registros de Diversificacion Lineas	*/
/*				de RIB											*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
/* Declaracion de Variables */
declare @Tip_ConTip char(1),
        @Tip_ConCon char(1), 
        @Str_C char(1),
		@Act_Uno	int	

declare @Str_Uno char(1), 
        @Str_Dos char(1) 

select @Str_C = 'C',
       @Str_Uno = '1',
       @Str_Dos = '2', 
	   @Act_Uno = 1

select @Tip_ConTip = substring(@Tip_Consul, 1, 1),
       @Tip_ConCon = substring(@Tip_Consul, 2, 1) 


if @Tip_ConTip	= @Str_C begin /* 'C': Consulta */
   if @Tip_ConCon = @Str_Uno begin		/* C1 */
     select 
          Rdl_Numero,    Rdl_NumRib,    Rdl_Tipo 
     from SORIDILI noholdlock 
     where Rdl_Numero = @Rdl_Numero
	 and Rdl_Activo = @Act_Uno
   end
end else begin
   if @Tip_ConCon = @Str_Uno begin		/* L1 */
     select 
          Rdl_Numero,    Rdl_NumRib,    Rdl_Tipo 
     from SORIDILI noholdlock 
	  where Rdl_Activo = @Act_Uno
  end

   if @Tip_ConCon = @Str_Dos begin 
     select 
          Rdl_Numero,    Rdl_NumRib,    Rdl_Tipo 
     from SORIDILI noholdlock 
      where Rdl_NumRib = @Rdl_NumRib 
	   and Rdl_Activo = @Act_Uno
   end 
end
