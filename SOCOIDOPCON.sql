create procedure SOCOIDOPCON (
	@Cue_Numero	char(12),
	@Cli_Numero	char(8),	
	@Opi_NuIdOp	int,
	@Cio_NuIdCo	int,
	@Cio_TipPer	varchar(1),
	@Cio_RegCue	varchar(1),
	@Cio_PodMan	varchar(1),
	@Cio_CliVIP	varchar(1),
	@Cio_TiMeDi	varchar(1),
	@Cio_MisCli	varchar(1),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
	
as

/* *****************************************************************
** DESCRIPCION: Consulta de configuración de identificación de    **
**				operaciones(Para huella)						  **
********************************************************************
**					STORE CONVERTIDO							****
** Convirtió:	Francisco Javier Carrillo Rojas					****
** Fecha:		19/Jun/2018										****
** Help:		01088831										****
********************************************************************
** Creó:		Francisco Javier Carrillo Rojas					****
** Fecha:		06/Jun/2018										****
** Help:		01088831										****
** Descripcion:	Consulta de configuración de identificación de 	****
**				operaciones(Para huella)						****
********************************************************************/
/* Declaracion de Variables */
declare	@Tip_ConTip	char(1),	/* Consulta Tipo C/L*/
		@Tip_ConCon	char(1),	/* Tipo Consecutivo */
		@Opi_TipOpe int,		/* Tipo de operación (Disposición, entrega de medios y contratación ver referencia de campo en tabla SOOPEIDE)*/
		@Opi_BasOpe varchar(4),	/* Tipo de base en parámetro recibido (ver metadata de campo en tabla SOPEIDE)*/
		@Cio_Status	char(1)		/* Estatus de configuración */

/* Declaracion de Constantes */
declare	@Str_C		char(1),
		@Str_Uno	char(1),
		@Str_Dos    char(1),
		@Str_Porcie	char(1),
		@Str_Vacio	char(1),
		@Ent_Cero	int,
		@Tip_PerMor	char(1),
		@Tip_Apoder	char(1),
		@Tip_IdeINE	char(1),
		@Tip_PerFis	char(1),
		@Tip_PeFiAc	char(1),
		@Tip_Titula	char(1),
		@Sta_Activo	char(1),
		@Tip_BasCli	varchar(4),
		@Tip_BasCue	varchar(4),
		@Sta_FirEsc	char(1)

/* Asignacion de Constantes */
select	@Str_C		= 'C',		/* Tipo C */
		@Str_Uno	= '1',		/* Tipo 1 */
		@Str_Dos    = '2',		/* Tipo 2 */
		@Str_Porcie	= '%',		/* String porciento */
		@Str_Vacio	= '',		/* String vacío */
		@Ent_Cero	= 0,		/* Entero en cero */
		@Tip_PerMor	= '1',		/* Tipo de apoderado/representante para persona moral, Cotitulares para persona física*/
		@Tip_Apoder	= '3',		/* Tipo de apoderado/representante para persona moral, Cotitulares para persona física*/	
		@Tip_IdeINE	= 'C',		/* Tipo de identificación INE/IFE */
		@Tip_PerFis	= '2',		/* Tipo de persona persona física */
		@Tip_PeFiAc	= '3',		/* Tipo de persona persona física con actividad empresarial*/
		@Tip_Titula	= '1',		/* Tipo de interviniente Titular */
		@Sta_Activo	= 'A',		/* Status Activo */
		@Tip_BasCli	= 'CLI',	/* Tipo base cliente(Operación con) */
		@Tip_BasCue	= 'CUE',	/* Tipo base cuenta(Operación con) */
		@Sta_FirEsc	= 'S'		/* Status de firma escaneada*/

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = @Str_C begin
	if @Tip_ConCon	= @Str_Uno begin /* C1 - Búsqueda de configuración por id de operación(principal) */
		select	Cio_NuIdCo,	Cio_NuIdOp,	Cio_TipPer,	Cio_RegCue,	Cio_PodMan,
				Cio_CliVIP,	Cio_IntReq,	Cio_TiMeDi,	Cio_AcDiEx,	Cio_AcDiLi,
				Cio_MisCli,	Cio_Status						
			from SOCOIDOP con noholdlock
				inner join SOOPEIDE ope noholdlock on con.Cio_NuIdOp	= ope.Opi_NuIdOp
			where	con.Cio_NuIdCo	= @Cio_NuIdCo			  	
	end else if @Tip_ConCon	= @Str_Dos begin /* C2 - Búsqueda de configuración claves de configuración, devuelve intervinientes autorizados y firmas de terceros, en caso de existir */
		select	@Cio_NuIdCo	= @Ent_Cero
		
		select	@Opi_TipOpe	= Opi_TipOpe,
				@Cio_NuIdCo	= Cio_NuIdCo,
				@Cio_Status	= Cio_Status
			from SOOPEIDE ope noholdlock
				left join SOCOIDOP con noholdlock on con.Cio_NuIdOp	= ope.Opi_NuIdOp
			where	con.Cio_NuIdOp	= @Opi_NuIdOp
			  and	con.Cio_TipPer	= @Cio_TipPer
			  and	con.Cio_RegCue	= @Cio_RegCue
			  and	con.Cio_PodMan	= @Cio_PodMan
			  and	con.Cio_CliVIP	= @Cio_CliVIP			  
			  and	con.Cio_TiMeDi	= @Cio_TiMeDi
			  and	con.Cio_MisCli	= @Cio_MisCli

			if isnull(@Opi_TipOpe, @Ent_Cero) != @Ent_Cero and isnull(@Cio_Status, @Str_Vacio) = @Sta_Activo begin
				--Salida de configuración
				select	Cio_NuIdCo,	Cio_NuIdOp,	Cio_TipPer,	Cio_RegCue,	Cio_PodMan,
						Cio_CliVIP,	Cio_IntReq,	Cio_TiMeDi,	Cio_AcDiEx,	Cio_AcDiLi,
						Cio_MisCli,	Cio_Status
					from SOCOIDOP con noholdlock
					where	con.Cio_NuIdCo	= @Cio_NuIdCo
					
				--Salida de Combinaciones de terceros autorizados (en caso de tenerlos)				
				select	Cft_NuIdCo,	Cft_IdCoOp,	Cft_APunta,	Cft_BPunta,	Cft_CPunta,
						Cft_PunMin
					from SOCOFITE noholdlock
					where	Cft_IdCoOp	= @Cio_NuIdCo
			end
	end
end
