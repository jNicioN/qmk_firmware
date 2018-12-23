create procedure SOTICUCLCON (
   @Tcc_Numero int,
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
/** DESCRIPCION: Consulta de registros de tipo cuenta			*/
/**				clasificacion estado financiero					*/
/****************************************************************/
/** Creo:		Felipe Castillo									*/
/** Fecha:		19/05/2017                               		*/
/** Help:		929417 					 						*/
/****************************************************************/

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
     select	Tcc_Numero,    	Tcc_TipCue,    	Tcc_ClEsFi,    Tcc_Formul,    Tcc_Captur, 
			Tcc_ForBas,    	Tcc_ForPor,    	NumTransac,    Transaccio,    Usuario, 
			FechaSis,		SucOrigen,		SucDestino
		 from SOTICUCL noholdlock 
		 where Tcc_Numero = @Tcc_Numero
   end
end else begin
   if @Tip_ConCon = @Str_Uno begin		/* L1 */
     select	Tcc_Numero,    	Tcc_TipCue,    	Tcc_ClEsFi,    Tcc_Formul,    Tcc_Captur, 
			Tcc_ForBas,    	Tcc_ForPor,    	NumTransac,    Transaccio,    Usuario, 
			FechaSis,		SucOrigen,		SucDestino
		from SOTICUCL noholdlock  
   end 
end
