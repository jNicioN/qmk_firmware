create procedure SOSUBSECCON (
	@Sus_Numero int,
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
/* DESCRIPCION: Consulta de registros de Subsector				*/
/****************************************************************/
/** Creo:			Raul Muniz									*/
/** Fecha:			09/09/2021                               	*/
/** Help:			1504301					 					*/
/****************************************************************/

/* Declaracion de Variables */
declare @Tip_ConTip	char(1),		/* Tipo consulta C/L */
        @Tip_ConCon	char(1)			/* Numero consulta */

/* Declaracion de Constantes */
declare @Str_Uno	char(1),		/* Caracter 1 */
		@Str_C		char(1)			/* Caracter C */

select @Str_C = 'C',				/* Caracter C */
       @Str_Uno = '1'				/* Caracter 1 */

select @Tip_ConTip = substring(@Tip_Consul, 1, 1),
       @Tip_ConCon = substring(@Tip_Consul, 2, 1) 


if @Tip_ConTip	= @Str_C begin /* 'C': Consulta */
	if @Tip_ConCon = @Str_Uno begin		/* C1 */
		select	Sus_Numero,	Sus_Descri,		Sus_Activo,		Sus_Sector,		NumTransac,
				Transaccio,	Usuario,		FechaSis,		SucOrigen,		SucDestino
		from SOSUBSEC noholdlock
		where	Sus_Numero	= @Sus_Numero
	end
end else begin
	if @Tip_ConCon = @Str_Uno begin		/* L1 */
		select	Sus_Numero,	Sus_Descri,		Sus_Activo,		Sus_Sector,		NumTransac,
				Transaccio,	Usuario,		FechaSis,		SucOrigen,		SucDestino
		from SOSUBSEC noholdlock
	end
end