create procedure SOPACAEXCON(
	@Tip_Consul char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as
/***********************************************************************************/
/*DESCRIPCION: Consulta las personas unicas pendiente de crear expediente	       */
/***********************************************************************************/
/*REFERENCIAS:
*************************************************************************************
** CreÃ³:		Josue Palomar     												 ****
** Fecha:		29/Octubre/2021													 ****
** Help:		1574028															****
************************************************************************************/


/* Declaracion de Variables */
declare @Tip_ConTip	char(1), 		/* Consulta Tipo							*/
		@Tip_ConCon char(1) 		/* Consulta 								*/

declare	@Ent_Uno 	smallint,
		@Ent_Dos 	smallint,
		@Sta_NoProc	smallint,
		@Sta_Pendie smallint,
		@Sta_Proces smallint,
		@Sta_Rechaz	smallint,
		@Sta_NoCump smallint,
		@Str_Lista	char(1),
		@Str_Uno	char(1),
		@Str_Dos	char(1),
		@Str_Tres 	char(1),
		@Str_Cuatro	char(1),
		@Str_Cinco	char(1)

select	@Ent_Uno 	= 1,			/* Entero uno									*/
		@Ent_Dos 	= 2,			/* Entero dos									*/
		@Sta_NoProc	= 0,			/* Estatus no procesado							*/
		@Sta_Pendie	= 1,			/* Estatus pendiente							*/
		@Sta_Proces	= 2,			/* Estatus procesado							*/
		@Sta_Rechaz	= 3,			/* Estatus rechazado							*/
		@Sta_NoCump	= 4,			/* Estatus no cumple							*/
		@Str_Lista	= 'L',			/* String de Lista								*/
		@Str_Uno	= '1',			/* Consulta de personas no procesadas			*/
		@Str_Dos	= '2',			/* Consulta de personas pendientes de procesar	*/
		@Str_Tres	= '3',			/* Consulta de personas con expediente			*/
		@Str_Cuatro	= '4',			/* Consulta de personas rechazadas				*/
		@Str_Cinco	= '5'			/* Consulta de personas con RFC que no cumple	*/

select	@Tip_ConTip	= substring(@Tip_Consul,@Ent_Uno,@Ent_Uno),
		@Tip_ConCon	= substring(@Tip_Consul,@Ent_Dos,@Ent_Uno)

if @Tip_ConTip = @Str_Lista begin
	if @Tip_ConCon = @Str_Uno begin
		select CRE.Pce_Numero,	CRE.Pce_UniPer,	CRE.Pce_Tipo,	CRE.Pce_RFC,	CRE.Pce_PerFis,
			   CRE.Pce_Reposi,  CRE.Pce_Nombre,	CRE.Pce_ApePat,	CRE.Pce_ApeMat,	CRE.Pce_RazSoc,
			   CRE.Pce_Curp,	CRE.Pce_FecNac,	CRE.NumTransac,	CRE.Transaccio,	CRE.Usuario,
			   CRE.FechaSis,	CRE.SucOrigen,	CRE.SucDestino
		from SOPACAEX CRE noholdlock
		inner join SOBICREX BCE noholdlock on CRE.Pce_UniPer = BCE.Bce_PerNum
		where	BCE.Bce_Status = @Sta_NoProc
	end else
	if @Tip_ConCon = @Str_Dos begin
		select CRE.Pce_Numero,CRE.Pce_UniPer,CRE.Pce_Tipo,CRE.Pce_RFC,CRE.Pce_PerFis,CRE.Pce_Reposi,
		CRE.Pce_Nombre,CRE.Pce_ApePat,CRE.Pce_ApeMat,CRE.Pce_RazSoc,CRE.Pce_Curp,CRE.Pce_FecNac,
		CRE.NumTransac,CRE.Transaccio,CRE.Usuario,CRE.FechaSis,CRE.SucOrigen,CRE.SucDestino
		from SOPACAEX CRE noholdlock
		inner join SOBICREX BCE noholdlock on CRE.Pce_UniPer = BCE.Bce_PerNum
		where	BCE.Bce_Status = @Sta_Pendie
	end else
	if @Tip_ConCon = @Str_Tres begin
		select CRE.Pce_Numero,CRE.Pce_UniPer,CRE.Pce_Tipo,CRE.Pce_RFC,CRE.Pce_PerFis,CRE.Pce_Reposi,
		CRE.Pce_Nombre,CRE.Pce_ApePat,CRE.Pce_ApeMat,CRE.Pce_RazSoc,CRE.Pce_Curp,CRE.Pce_FecNac,
		CRE.NumTransac,CRE.Transaccio,CRE.Usuario,CRE.FechaSis,CRE.SucOrigen,CRE.SucDestino
		from SOPACAEX CRE noholdlock
		inner join SOBICREX BCE noholdlock on CRE.Pce_UniPer = BCE.Bce_PerNum
		where	BCE.Bce_Status = @Sta_Proces
	end else
	if @Tip_ConCon = @Str_Cuatro begin
		select CRE.Pce_Numero,CRE.Pce_UniPer,CRE.Pce_Tipo,CRE.Pce_RFC,CRE.Pce_PerFis,CRE.Pce_Reposi,
		CRE.Pce_Nombre,CRE.Pce_ApePat,CRE.Pce_ApeMat,CRE.Pce_RazSoc,CRE.Pce_Curp,CRE.Pce_FecNac,
		CRE.NumTransac,CRE.Transaccio,CRE.Usuario,CRE.FechaSis,CRE.SucOrigen,CRE.SucDestino
		from SOPACAEX CRE noholdlock
		inner join SOBICREX BCE noholdlock on CRE.Pce_UniPer = BCE.Bce_PerNum
		where	BCE.Bce_Status = @Sta_Rechaz
	end else
	if @Tip_ConCon = @Str_Cinco begin
		select CRE.Pce_Numero,CRE.Pce_UniPer,CRE.Pce_Tipo,CRE.Pce_RFC,CRE.Pce_PerFis,CRE.Pce_Reposi,
		CRE.Pce_Nombre,CRE.Pce_ApePat,CRE.Pce_ApeMat,CRE.Pce_RazSoc,CRE.Pce_Curp,CRE.Pce_FecNac,
		CRE.NumTransac,CRE.Transaccio,CRE.Usuario,CRE.FechaSis,CRE.SucOrigen,CRE.SucDestino
		from SOPACAEX CRE noholdlock
		inner join SOBICREX BCE noholdlock on CRE.Pce_UniPer = BCE.Bce_PerNum
		where	BCE.Bce_Status = @Sta_NoCump
	end
end
