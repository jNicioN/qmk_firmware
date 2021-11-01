create procedure SOPEINCOCON (
	@Pic_PerNum int,
	
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
/* DESCRIPCION: Consulta de Persona Informacion	Complemento		*/
/****************************************************************/
/** Creo:			Raul Muniz									*/
/** Fecha:			05/10/2021                               	*/
/** Help:			1504301					 					*/
/****************************************************************/

/* Declaracion de Variables */
declare @Tip_ConTip	char(1),		/* Tipo consulta C/L */
        @Tip_ConCon	char(1)			/* Numero consulta */

/* Declaracion de Constantes */
declare	@Str_C		char(1),		/* Caracter C */
		@Str_Uno	char(1),		/* Caracter 1 */
		@Str_Dos	char(1),		/* Caracter 2 */
		@Sta_Activo	bit				/* Estatus Activo */

select	@Str_C = 'C',				/* Caracter C */
		@Str_Uno = '1',				/* Caracter 1 */
		@Str_Dos = '2',				/* Caracter 2 */
		@Sta_Activo	= 1				/* Estatus Activo */

select @Tip_ConTip = substring(@Tip_Consul, 1, 1),
       @Tip_ConCon = substring(@Tip_Consul, 2, 1) 


if @Tip_ConTip	= @Str_C begin /* 'C': Consulta */
	if @Tip_ConCon = @Str_Uno begin		/* C1 */
		select	Pic_PerNum,	Pic_ActPre,	NumTransac,	Transaccio,	Usuario,
				FechaSis,	SucOrigen,	SucDestino
			from SOPEINCO noholdlock
			where	Pic_PerNum	= @Pic_PerNum
	end else if @Tip_ConCon = @Str_Dos begin
		select	Pic_PerNum,	Pic_ActPre,	Acp_Descri,	Sur_Numero,	Sur_Descri,
				Ram_Numero,	Ram_Subsec,	Ram_Descri
			into #ActividadSubRama
			from SOPEINCO noholdlock
			left join SOACTPRE noholdlock
				on Acp_Numero = Pic_ActPre and Acp_Activo = @Sta_Activo
			left join SOSUBRAM noholdlock
				on Sur_Numero = Acp_SubRam and Sur_Activo = @Sta_Activo
			left join SORAMA noholdlock
				on Ram_Numero = Sur_Rama and Ram_Activo = @Sta_Activo
			where	Pic_PerNum	= @Pic_PerNum
			
		select	Pic_PerNum,	Pic_ActPre,	Acp_Descri,	Sur_Numero,	Sur_Descri,
				Ram_Numero,	Ram_Subsec,	Ram_Descri,	Sus_Numero,	Sus_Descri,
				Sec_Numero,	Sec_Descri
			from #ActividadSubRama noholdlock
			left join SOSUBSEC noholdlock
				on Sus_Numero = Ram_Subsec and Sus_Activo = @Sta_Activo
			left join SOSECTOR noholdlock
				on Sec_Numero = Sus_Sector and Sec_Activo = @Sta_Activo
			
		drop table #ActividadSubRama
	end
end