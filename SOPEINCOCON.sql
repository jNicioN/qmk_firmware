create procedure SOPEINCOCON (
	@Pic_PerNum int,
	@Cli_Numero char(8),
	
	@Tip_Consul char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino	char(3),
	@Modulo char(2)) 
as

/***************************************************************************/
/* DESCRIPCION: Consulta de Persona Informacion	Complemento				****/
/***************************************************************************/
/** Modifico:		Raul Muniz										    ****/
/** Fecha:			11/05/2023	                           		        ****/
/** C.Cambios:		27203			 									****/
/** Descripcion:	Se modifican consultas para regresar actividad 		****/
/**					regulatoria											****/
/***************************************************************************/
/** Modifico:		Jose R. Rodriguez Zenteno							****/
/** Fecha:			21/Diciembre/2021                          			****/
/** Help:			1504301					 							****/
/**	Descripcion:	Se modifica consulta C1 para regresar MacroSector 	****/
/***************************************************************************/
/** Modifico:		Eduardo Perez Santiago								****/
/** Fecha:			06/12/2021                              			****/
/** Help:			1438184					 							****/
/**	Descripcion:	Se crea la consulta C3 para consultar la actividad 	****/
/**					preponderante dependiendo de un cliente				****/
/***************************************************************************/
/** Creo:			Raul Muniz											****/
/** Fecha:			05/10/2021                               			****/
/** Help:			1504301					 							****/
/***************************************************************************/

/* Declaracion de Variables */
declare @Tip_ConTip	char(1),		/* Tipo consulta C/L */
        @Tip_ConCon	char(1),		/* Numero consulta */
        @Acp_Numero int,			/*Numero de activida Preponderante*/
		@Tmp_Regist int	,			/*nuemero de registros*/
		@Str_Descri char(254),		/*Descripcion*/
		@Tmp_PerNum	int

/* Declaracion de Constantes */
declare	@Str_C		char(1),		/* Caracter C */
		@Str_Uno	char(1),		/* Caracter 1 */
		@Str_Dos	char(1),		/* Caracter 2 */
		@Str_Tres	char(1),		/* Caracter 3 */
		@Sta_Activo	bit	,			/* Estatus Activo */
		@Ent_Cero 	int				/*Numero cero*/



select	@Str_C = 'C',				/* Caracter C */
		@Str_Uno = '1',				/* Caracter 1 */
		@Str_Dos = '2',				/* Caracter 2 */
		@Str_Tres = '3',			/* Caracter 3 */
		@Sta_Activo	= 1,			/* Estatus Activo */
		@Ent_Cero	= 0				/*Numero cero*/

select @Tip_ConTip = substring(@Tip_Consul, 1, 1),
       @Tip_ConCon = substring(@Tip_Consul, 2, 1) 


if @Tip_ConTip	= @Str_C begin /* 'C': Consulta */
	if @Tip_ConCon = @Str_Uno begin		/* C1 */
		select	Pic_PerNum,	Pic_ActPre,	NumTransac,	Transaccio,	Usuario,
				FechaSis,	SucOrigen,	SucDestino
			from SOPEINCO noholdlock
			where	Pic_PerNum	= @Pic_PerNum
	end else if @Tip_ConCon = @Str_Dos begin
		select	Pic_PerNum,	Pic_ActPre,	Acp_Descri,	Acp_ActReg,	Sur_Numero,
				Sur_Descri,	Ram_Numero,	Ram_Subsec,	Ram_Descri
			into #ActividadSubRama
			from SOPEINCO noholdlock
			left join SOACTPRE noholdlock
				on Acp_Numero = Pic_ActPre and Acp_Activo = @Sta_Activo
			left join SOSUBRAM noholdlock
				on Sur_Numero = Acp_SubRam and Sur_Activo = @Sta_Activo
			left join SORAMA noholdlock
				on Ram_Numero = Sur_Rama and Ram_Activo = @Sta_Activo
			where	Pic_PerNum	= @Pic_PerNum
			
		select	Pic_PerNum,	Pic_ActPre,	Acp_Descri,	Acp_ActReg,	Sur_Numero,
				Sur_Descri,	Ram_Numero,	Ram_Subsec,	Ram_Descri,	Sus_Numero,
				Sus_Descri,	Sec_Numero,	Sec_Descri, Mac_Numero, Mac_Descri
			from #ActividadSubRama noholdlock
			left join SOSUBSEC noholdlock
				on Sus_Numero = Ram_Subsec and Sus_Activo = @Sta_Activo
			left join SOSECTOR noholdlock
				on Sec_Numero = Sus_Sector and Sec_Activo = @Sta_Activo
			left join SOMACSEC noholdlock on Mac_Numero = Sec_MacSec
			
		drop table #ActividadSubRama
	end else if @Tip_ConCon = @Str_Tres begin
		 select 	Adi_Client,	Pic_PerNum,	Pic_ActPre,	@Ent_Cero as Acp_Numero,	@Str_Descri as Acp_Descri
		 	into #ActividadCliente
			 from CLADICIO noholdlock
				inner join SOPERSON noholdlock on Per_Numero = Adi_NumPer
				inner join SOPEINCO noholdlock on Pic_PerNum = PerPersoID
				where Adi_Client = @Cli_Numero
				
		select @Tmp_PerNum = Pic_PerNum 
			from #ActividadCliente 
				where Adi_Client = @Cli_Numero
		
		select 	Pic_PerNum,	Pic_ActPre,	Acp_Numero,	Acp_Descri
		 	into #Actividad
			 from SOPEINCO noholdlock 
				inner join SOACTPRE noholdlock on Acp_Numero = Pic_ActPre
				where Pic_PerNum = @Tmp_PerNum
				
		select @Tmp_Regist = count(*) from #Actividad
		select @Tmp_Regist = isnull(@Tmp_Regist, @Ent_Cero)
		
		if @Tmp_Regist > @Ent_Cero begin
			
			update #ActividadCliente set 
			Acp_Numero = act.Acp_Numero,
			Acp_Descri = act.Acp_Descri
			from #Actividad as act
			where act.Pic_PerNum = #ActividadCliente.Pic_PerNum
			
		end
		drop table #Actividad
		
		select 	Adi_Client,	Pic_PerNum,	Pic_ActPre,	Acp_Numero,	Acp_Descri
			from #ActividadCliente
		 
		 drop table #ActividadCliente

	end
end