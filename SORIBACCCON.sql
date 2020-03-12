create procedure SORIBACCCON (
	@Ria_Numero int,
	@Ria_NumRib int,
	@Ria_NumPer char(8),
	@Ria_Activo bit,
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
/* DESCRIPCION: Consulta de registros de Accionistas RIB		*/
/****************************************************************/
/** Modifico:		Esthepny Aguilar							*/
/** Fecha:			25/02/2020                               	*/
/** Descripcion:	Se ordena desc por el campo Ria_PorPar en la*/
/** 				consulta L2               					*/
/** Help:			1355065					 					*/
/****************************************************************/
/** Modifico:		Ricardo García								*/
/** Fecha:			22/09/2017                               	*/
/** Descripcion:	Se agrega constante de Activo             	*/
/** Help:			929417 					 					*/
/****************************************************************/
/** Creo:			Victor Osorio								*/
/** Fecha:			07/04/2017                               	*/
/** Help:			929417 					 					*/
/****************************************************************/

/* Declaracion de Variables */
declare @Tip_ConTip	char(1),		/* Tipo consulta C/L */
        @Tip_ConCon	char(1)			/* Numero consulta */

/* Declaracion de Constantes */
declare @Str_Uno	char(1),		/* Caracter 1 */
		@Str_Dos	char(1),		/* Caracter 2 */
		@Str_C		char(1),		/* Caracter C */
		@Raa_Activo	bit				/* Bit valor 1 */

select @Str_C = 'C',
       @Str_Uno = '1',
	   @Str_Dos = '2',
	   @Raa_Activo = 1

select @Tip_ConTip = substring(@Tip_Consul, 1, 1),
       @Tip_ConCon = substring(@Tip_Consul, 2, 1) 


if @Tip_ConTip	= @Str_C begin /* 'C': Consulta */
	if @Tip_ConCon = @Str_Uno begin		/* C1 */
		select
			Ria_Numero,		Ria_NumRib,		Ria_NumPer,		Ria_PorPar,		Ria_Activo,
			NumTransac,		Transaccio,		Usuario,		FechaSis,		SucOrigen,		
			SucDestino
		from SORIBACC noholdlock
		where Ria_Numero = @Ria_Numero
	end
end else begin
	if @Tip_ConCon = @Str_Uno begin		/* L1 */
		select
			Ria_Numero,		Ria_NumRib,		Ria_NumPer,		Ria_PorPar,		Ria_Activo,
			NumTransac,		Transaccio,		Usuario,		FechaSis,		SucOrigen,		
			SucDestino
		from SORIBACC noholdlock
	   where Ria_Activo = @Raa_Activo
	end
	if @Tip_ConCon = @Str_Dos begin		/* L2 */
		select
			Ria_Numero,		Ria_NumRib,		Ria_NumPer,		Ria_PorPar,		Ria_Activo,
			NumTransac,		Transaccio,		Usuario,		FechaSis,		SucOrigen,		
			SucDestino
		from SORIBACC noholdlock
		where Ria_NumRib = @Ria_NumRib
		  and Ria_Activo = @Raa_Activo
		  order by Ria_PorPar desc
	end
end