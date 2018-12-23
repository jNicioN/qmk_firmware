create procedure SOCOMPANCON (
	@Com_Numero	char(2),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*****************************************************************************/
/* DESCRIPCION: ** Consulta de Compania ** */
/*****************************************************************************/
/** REFERENCIAS: 
****************************************************************************
** Modifico:	Jaret Guanajuato Ruvalcaba								****
** Fecha:		11/Diciembre/2013											****
** Help:		00591890													****
** Descripcion:	Agregar Com_FolEle,	Com_CorEle a C1						****
****************************************************************************
**				STORE CONVERTIDO						****
** Convirtió:		Armando Ivan Garcia Gonzalez				****
** Fecha:		25/Ene/2010								****
****************************************************************************
** Modifico:		Roberto Pascuale Morales Chavez			****
** Fecha:		25/Enero/2010								****
** Help:			223033										****
** Descri:		Agregar la Lista L1 por Com_Numero,			****
**				Com_Descri	y Estandarizar					****
****************************************************************************
** Modificó:		Adrián Labastida								****
** Fecha:		18/Enero/2007								****
** Modificación: Se agrego el campo Com_ClaIns a la cons C2	****
****************************************************************************
** Modificó:		Adrián Labastida								****
** Fecha:		12/Enero/2007								****
** Modificación: Se agregaron los ultimos 2 campos a la 		****
** 				consulta C2 (Est_Nombre y Est_Abrevi)		****
****************************************************************************
**				STORE CONVERTIDO						****
** Convirtió:		Karina Chavarría Tovar						****
** Fecha:		04/Ene/2007								****
****************************************************************************
** Modificó:		Adrián Labastida								****
** Fecha:		27/Diciembre/2006							****
** Modificación: Se agregaron los ultimos 2 campos a la 		****
** 				consulta general	 (Com_Abrevi y Com_ClaIns)	****
****************************************************************************
**				STORE CONVERTIDO						****
** Convirtió:		Karina Chavarría Tovar						****
** Fecha:		22/Diciembre/2006							****
****************************************************************************
** Modificó:		Adrián Labastida								****
** Fecha:		18/Diciembre/2006							****
** Modificación: Se agregaron los ultimos 7 campos a la 		****
** 				consulta general	 (Campo final:  Com_Pais)	****
****************************************************************************
**				STORE CONVERTIDO						****
** Convirtió:		Francisco Javier Cordero Guzmán				****
** Fecha:		01/Noviembre/2005							****
****************************************************************************
** Creó:			GFLORES        								****
** Fecha:		16/Ago/05									****
** Help:		       No. de Help al que pertenece la modificación	****
******************************************************************************/

declare @Tip_ConTip char(1),				/* Declaración de Variables */
		@Tip_ConCon char(1)

declare	@Tra_Consul	char(1),				/* Declaración de Constantes */
		@Tra_Lista	char(1)

/* Asignación de Constantes */
select	@Tra_Consul	= 'C',					/* Transacción Tipo Consulta */
		@Tra_Lista	= 'L'					/* Transacción Tipo Lista */

select 	@Tip_ConTip = substring(@Tip_Consul,1,1),
		@Tip_ConCon = substring(@Tip_Consul,2,1)

if @Tip_ConTip = @Tra_Consul begin
	if @Tip_ConCon = '1' begin				/* Consulta de llave Principal */

		select	Com_Numero,	Com_Descri,	Com_RFC,	Com_Calle,	Com_CalNum,
				Com_Coloni,	Com_CodPos,	Com_Ciudad,	Com_Estado,	Com_Pais,
				Com_Abrevi,	Com_ClaIns, Com_FolEle,	Com_CorEle
			from SOCOMPAN noholdlock
			where	Com_Numero	= @Com_Numero
	end

	if @Tip_ConCon = '2' begin				/* Consulta Nombre de Ciudad */
	
		select	Com_Numero,	Com_Descri,	Ciu_Nombre,	Ciu_Estado,	Est_Nombre,
				Est_Abrevi,	Com_ClaIns	
			from SOCOMPAN noholdlock,
				 SOCIUDAD noholdlock,
				 SOESTADO noholdlock
			where	Com_Numero	= @Com_Numero
			  and	Com_Ciudad	= Ciu_Numero
			  and	Com_Estado	= Est_Numero
			  and	Ciu_Estado	= Est_Numero
	end
end else if @Tip_ConTip = @Tra_Lista begin
	if @Tip_ConCon = '1' begin				
		select	Com_Numero,	Com_Descri
			from SOCOMPAN noholdlock
			order by Com_Numero
	end
end
