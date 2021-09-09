create procedure SOSUBRAMCON (
	@Sur_Numero int,
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
/* DESCRIPCION: Consulta de registros de Rama					*/
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
		@Str_C		char(1),		/* Caracter C */
		@Est_Activo	char(1)				/* Bit valor 1 */

select @Str_C = 'C',
       @Str_Uno = '1',
	   @Est_Activo = 'A'

select @Tip_ConTip = substring(@Tip_Consul, 1, 1),
       @Tip_ConCon = substring(@Tip_Consul, 2, 1) 


if @Tip_ConTip	= @Str_C begin /* 'C': Consulta */
	if @Tip_ConCon = @Str_Uno begin		/* C1 */
		select	Sur_Numero,	Sur_Descri,		Sur_Status,		Sur_Rama,		NumTransac,
				Transaccio,	Usuario,		FechaSis,		SucOrigen,		SucDestino
		from SOSUBRAM noholdlock
		where	Sur_Numero	= @Sur_Numero
	end
end else begin
	if @Tip_ConCon = @Str_Uno begin		/* L1 */
		select	Sur_Numero,	Sur_Descri,		Sur_Status,		Sur_Rama,		NumTransac,
				Transaccio,	Usuario,		FechaSis,		SucOrigen,		SucDestino
		from SOSUBRAM noholdlock
	end
end