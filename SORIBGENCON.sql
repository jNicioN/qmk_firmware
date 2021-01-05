create procedure SORIBGENCON (
	@Rig_Numero int,
	@Rig_NumRib int,
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
/* DESCRIPCION: Consulta de registros de Generalidades RIB		*/
/****************************************************************/
/** Creo:			Raul Muniz									*/
/** Fecha:			04/11/2020                               	*/
/** Help:			1433413					 					*/
/****************************************************************/

/* Declaracion de Variables */
declare @Tip_ConTip	char(1),		/* Tipo consulta C/L */
        @Tip_ConCon	char(1)			/* Numero consulta */

/* Declaracion de Constantes */
declare @Str_Uno	char(1),		/* Caracter 1 */
		@Str_Dos	char(1),		/* Caracter 2 */
		@Str_C		char(1),		/* Caracter C */
		@Est_Activo	bit				/* Bit valor 1 */

select @Str_C = 'C',
       @Str_Uno = '1',
	   @Str_Dos = '2',
	   @Est_Activo = 1

select @Tip_ConTip = substring(@Tip_Consul, 1, 1),
       @Tip_ConCon = substring(@Tip_Consul, 2, 1) 


if @Tip_ConTip	= @Str_C begin /* 'C': Consulta */
	if @Tip_ConCon = @Str_Uno begin		/* C1 */
		select
			Rig_Numero,		Rig_NumRib,		Rig_TiDeGo,		Rig_DepGob,		Rig_TieExp,
			Rig_Export,		Rig_PorExp,		Rig_TiGeDi,		Rig_GeCoMa,		Rig_Activo,
			NumTransac,		Transaccio,		Usuario,		FechaSis,		SucOrigen,
			SucDestino
		from SORIBGEN noholdlock
		where	Rig_Numero	= @Rig_Numero
	end
end else begin
	if @Tip_ConCon = @Str_Uno begin		/* L1 */
		select
			Rig_Numero,		Rig_NumRib,		Rig_TiDeGo,		Rig_DepGob,		Rig_TieExp,
			Rig_Export,		Rig_PorExp,		Rig_TiGeDi,		Rig_GeCoMa,		Rig_Activo,
			NumTransac,		Transaccio,		Usuario,		FechaSis,		SucOrigen,
			SucDestino
		from SORIBGEN noholdlock
		where Rig_Activo = @Est_Activo
	end
	if @Tip_ConCon = @Str_Dos begin		/* L2 */
		select
			Rig_Numero,		Rig_NumRib,		Rig_TiDeGo,		Rig_DepGob,		Rig_TieExp,
			Rig_Export,		Rig_PorExp,		Rig_TiGeDi,		Rig_GeCoMa,		Rig_Activo,
			NumTransac,		Transaccio,		Usuario,		FechaSis,		SucOrigen,
			SucDestino
		from SORIBGEN noholdlock
		where Rig_NumRib = @Rig_NumRib
		  and Rig_Activo = @Est_Activo
	end
end