create procedure SOCLCAPECON (
	@Clp_NumPer	char(8),
	@Tip_Consul	char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/**************************************************************************/
/* DESCRIPCION: ** Consulta de Clasificacin de Cartera de Personas 	***/
/**************************************************************************/
/* REFERENCIAS:															***/
/****************************************************************************
**       			STORE CONVERTIDO                 					****
****************************************************************************
** Modifico:	Raul Muniz												****
** Fecha:		14/Septiembre/2021										****
** Help:		1504301													****
** Descripción	Se agrega consulta C2 para regresar actividad 			****
**				preponderante											****
****************************************************************************
** Modificó:	Edwin E. Pérez Requena									****
** Fecha:		08/Mayo/2014											****
** Help:		652393													****
** Descripción	Se agregó  Clp_LocINE y Clp_EntINE a					****
**				resultado												****
****************************************************************************
** Creó:		Abraham Sánchez   			 							****
** Fecha:		11/Febrere/2014											****
** Help:		538910													****
****************************************************************************/

/* Declaracion de Variables */
declare	@Tip_ConTip	char(1),		/* Tipo Lista o Consulta */
		@Tip_ConCon	char(1)			/* Tipo Consulta */
		
/* Declaracion de Constantes	*/
declare	@Str_Consul	char(1),		/* Cadena consulta */
		@Str_Uno	char(1),		/* Cadena Uno */
		@Str_Dos	char(1),		/* Cadena Dos */
		@Sta_Activo	bit				/* Estatus Activo */

/* Asignacion de Constantes */
select	@Str_Consul	= 'C',			/* Consulta */
		@Str_Uno	= '1',			/* Cadena Uno */
		@Str_Dos	= '2',			/* Cadena Dos */
		@Sta_Activo	= 1				/* Estatus Activo */
		
select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = @Str_Consul begin		/* 'C':  Consulta */
	if @Tip_ConCon = @Str_Uno begin				/* Consulta la Clasificacin de Cartera por Persona */
		select	Clp_NumPer,	Clp_InsReg,	Clp_OtoCre,	Clp_Bancar,	Clp_SubBan,
				Clp_Fideic,	Clp_TipSoc,	Clp_NomSoc,	Clp_EntFin,	Clp_UsBuCr,
				Clp_LocINE,	Clp_EntINE
			from SOCLCAPE noholdlock
			where	Clp_NumPer	= @Clp_NumPer
	end else if @Tip_ConCon = @Str_Dos begin	/* C2 que regresa actividad preponderante */
		select	Clp_NumPer,	Clp_InsReg,	Clp_OtoCre,	Clp_Bancar,	Clp_SubBan,
				Clp_Fideic,	Clp_TipSoc,	Clp_NomSoc,	Clp_EntFin,	Clp_UsBuCr,
				Clp_LocINE,	Clp_EntINE,	Clp_ActPre,	Acp_Descri,	Sur_Numero,
				Sur_Descri,	Ram_Numero,	Ram_Subsec,	Ram_Descri
			into #ActividadSubRama			
			from SOCLCAPE noholdlock
			left join SOACTPRE noholdlock
				on Acp_Numero = Clp_ActPre and Acp_Activo = @Sta_Activo
			left join SOSUBRAM noholdlock
				on Sur_Numero = Acp_SubRam and Sur_Activo = @Sta_Activo
			left join SORAMA noholdlock
				on Ram_Numero = Sur_Rama and Ram_Activo = @Sta_Activo
			where	Clp_NumPer	= @Clp_NumPer
			
	
		select	Clp_NumPer,	Clp_InsReg,	Clp_OtoCre,	Clp_Bancar,	Clp_SubBan,
				Clp_Fideic,	Clp_TipSoc,	Clp_NomSoc,	Clp_EntFin,	Clp_UsBuCr,
				Clp_LocINE,	Clp_EntINE,	Clp_ActPre,	Acp_Descri,	Sur_Numero,
				Sur_Descri,	Ram_Numero,	Ram_Subsec,	Ram_Descri,	Sus_Numero,
				Sus_Descri,	Sec_Numero,	Sec_Descri
			from #ActividadSubRama noholdlock
			left join SOSUBSEC noholdlock
				on Sus_Numero = Ram_Subsec and Sus_Activo = @Sta_Activo
			left join SOSECTOR noholdlock
				on Sec_Numero = Sus_Sector and Sec_Activo = @Sta_Activo
			
		drop table #ActividadSubRama
	end
end