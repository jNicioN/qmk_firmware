create procedure SOANTECOCON (
   @Atc_Numero int,
   @Atc_AnaTer int,
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
** DESCRIPCION: Consulta de registros de analitica terreno concepto	**
**********************************************************************
** Creo:			Felipe Castillo Rendon                    	  	**
** Fecha:			22/08/2017                               	  	**
** Help:			929417 					 					  	**
*********************************************************************/

/* Declaracion de Variables */
declare @Tip_ConTip char(1),		/* Variable de tipo de consulta o lista */
        @Tip_ConCon char(1), 		/* Variable numero de la consulta o lista */
        @Str_C char(1), 			/* Variable de tipo cadena con valor C */
        @Str_Uno char(1), 			/* Variable entera con valor 1 */
        @Str_Dos char(1),			/* Variable entera con valor 2 */
        @Ent_Activo smallint		/* Variable entera activa */

select @Tip_ConTip = substring(@Tip_Consul, 1, 1),
       @Tip_ConCon = substring(@Tip_Consul, 2, 1), 
       @Str_C = 'C',
       @Str_Uno = '1',
       @Str_Dos = '2' ,
       @Ent_Activo = 1

if @Tip_ConTip	= @Str_C begin /* Consulta */
   if @Tip_ConCon = @Str_Uno begin		/* C1 Consulta por numero y analitica activa */
		select 	Atc_Numero,		Atc_AnaTer,		Atc_BieInm,		Atc_EstAna, 
				NumTransac,		Transaccio,		Usuario,		FechaSis, 
				SucOrigen,		SucDestino 
		from SOANTECO noholdlock 
		where Atc_Numero = @Atc_Numero
		and Atc_EstAna = @Ent_Activo
   end
end else begin
   if @Tip_ConCon = @Str_Uno begin		/* L1 Lista de todos los conceptos activos */
		select 	Atc_Numero,		Atc_AnaTer,		Atc_BieInm,		Atc_EstAna, 
				NumTransac,		Transaccio,		Usuario,		FechaSis, 
				SucOrigen,		SucDestino 
		from SOANTECO noholdlock
		where Atc_EstAna = @Ent_Activo
   end
   if @Tip_ConCon = @Str_Dos begin		/* L2 Lista de todos los conceptos activos por analitica */
		select 	Atc_Numero,		Atc_AnaTer,		Atc_BieInm,		Atc_EstAna, 
				NumTransac,		Transaccio,		Usuario,		FechaSis, 
				SucOrigen,		SucDestino 
		from SOANTECO noholdlock
		where Atc_AnaTer = @Atc_AnaTer
			and Atc_EstAna = @Ent_Activo
   end 
end
