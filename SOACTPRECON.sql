create procedure SOACTPRECON (
	@Acp_Numero int,
	@Acp_Descri	varchar(254),
	@Act_Numero char(10),
	@Tip_Consul char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino	char(3),
	@Modulo char(2)) 
as

/***********************************************************************************/
/* DESCRIPCION: Consulta de registros de Actividad Preponderante				****/
/***********************************************************************************/
/** Modifica:		Raul Muniz												    ****/
/** Fecha:			09/05/2023			                           		        ****/
/** C.Cambios:		27203	 				 									****/
/** Descripcion:	Se modifican consultas para regresar actividad regulatoria	****/
/***********************************************************************************/
/** Modifica:		Jose R. Rodriguez Zenteno								    ****/
/** Fecha:			21/Diciembre/2021                           		        ****/
/** Help:			1504301 				 									****/
/** Descripcion:	Se modifica C1 para regresar MacroSector(SOMACSEC)			****/
/***********************************************************************************/
/** Modifica:		Eduardo Perez Santiago										****/
/** Fecha:			19 de noviembre del 2021                            		****/
/** Help:			1438184					 									****/
/** Descripcion:	Se crea la consulta L3 donde se le da salida a la actividad	****/
/**					proponderante dependindo de una actividad de CLACTIVI		****/
/***********************************************************************************/
/** Creo:			Raul Muniz													****/
/** Fecha:			09/09/2021                               					****/
/** Help:			1504301					 									****/
/***********************************************************************************/

/* Declaracion de Variables */
declare @Tip_ConTip	char(1),		/* Tipo consulta C/L */
        @Tip_ConCon	char(1)			/* Numero consulta */

/* Declaracion de Constantes */
declare @Str_C		char(1),		/* Caracter C */
		@Str_Uno	char(1),		/* Caracter 1 */
		@Str_Dos	char(1),		/* Caracter 2 */
		@Est_Activo	bit,			/* Estatus Activo */
		@Str_Porcen	char(1),		/* String Porcentaje */
		@Str_Tres   char(1)			/* String numero 3 */

select @Str_C = 'C',				/* Caracter C */
       @Str_Uno = '1',				/* Caracter 1 */
       @Str_Dos = '2',				/* Caracter 2 */
	   @Est_Activo = 1,				/* Estatus Activo */
	   @Str_Porcen	= '%',			/* String Porcentaje */
	   @Str_Tres = '3'				/* String numero 3 */

select @Tip_ConTip = substring(@Tip_Consul, 1, 1),
       @Tip_ConCon = substring(@Tip_Consul, 2, 1) 


if @Tip_ConTip	= @Str_C begin /* 'C': Consulta */
	if @Tip_ConCon = @Str_Uno begin		/* C1 */
		select	Acp_Numero,	Acp_Descri,	Acp_Activo,	Acp_ActReg,	Sur_Numero,
				Sur_Descri,	Ram_Numero,	Ram_Descri,	Ram_Subsec
			into #ActividadSubRama
			from SOACTPRE noholdlock
			inner join	SOSUBRAM noholdlock
				on Sur_Numero = Acp_SubRam
			inner join	SORAMA noholdlock
				on Ram_Numero = Sur_Rama
			where	Acp_Numero	= @Acp_Numero
	
		select	Acp_Numero,	Acp_Descri,	Acp_Activo,	Acp_ActReg,	Sur_Numero,
				Sur_Descri,	Ram_Numero,	Ram_Descri,	Sus_Numero,	Sus_Descri,
				Sec_Numero,	Sec_Descri, Mac_Numero, Mac_Descri
			from #ActividadSubRama noholdlock
			inner join	SOSUBSEC noholdlock
				on Sus_Numero = Ram_Subsec
			inner join	SOSECTOR noholdlock
				on Sec_Numero = Sus_Sector
			inner join SOMACSEC noholdlock
				on Mac_Numero = Sec_MacSec
			where	Acp_Numero	= @Acp_Numero
			
		drop table #ActividadSubRama
	end
end else begin
	if @Tip_ConCon = @Str_Uno begin		/* L1 */
		select	Acp_Numero,	Acp_Descri,	Acp_Activo,	Acp_SubRam,	Acp_ActReg,
				NumTransac,	Transaccio,	Usuario,	FechaSis,	SucOrigen,
				SucDestino
			from SOACTPRE noholdlock
			where	Acp_Activo = @Est_Activo
	end else if @Tip_ConCon = @Str_Dos begin		/* L2 */
		select	@Acp_Descri = ltrim(rtrim(@Acp_Descri))
		
		select	Acp_Numero,	Acp_Descri,	Acp_Activo,	Acp_SubRam,	Acp_ActReg,
				NumTransac,	Transaccio,	Usuario,	FechaSis,	SucOrigen,
				SucDestino
			from SOACTPRE noholdlock
			where	Acp_Activo	= @Est_Activo
			  and	Acp_Descri like @Str_Porcen + @Acp_Descri + @Str_Porcen
			order by Acp_Descri
	end else if  @Tip_ConCon = @Str_Tres begin  /* L3 */
		 	select	Acp_Numero,	Acp_Descri
				from CLACTIVI noholdlock
					inner join SOACPRCL noholdlock on Apc_Activi = Act_Numero
					inner join SOACTPRE noholdlock on Acp_Numero = Apc_ActPre
					where	Act_Numero	= @Act_Numero and Acp_Activo = @Est_Activo
	end
end