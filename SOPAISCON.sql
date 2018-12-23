create procedure SOPAISCON   (
	@Pai_Numero	char(3),
	@Pai_Nombre	varchar(30),
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
/* DESCRIPCION: ** Consulta de paises** */
/*****************************************************************************/
/** REFERENCIAS:
****************************************************************************
** Modifico:	Jorge Alejandro Garza Alvarado				****
** Fecha:		17/Julio/2014								****
** Req:			00538044									****
** Modificar:	Se agrega a consulta L1 @Pai_IdCNBV			****
****************************************************************************
** Modifico:		Tania De la Garza						****
** Fecha:		28/Junio/2011								****
** Req:			00389100									****
** Modificar:		Se agrega @Pai_IdCNBV					****
****************************************************************************
** 				STORE CONVERTIDO							****
** Convirtió:		Karina Chavarría Tovar					****
** Fecha:		13/Abril/2007								****
****************************************************************************
** Modificó:		Diego Olvera Garza						****
** Fecha:		15/Ene/2007									****
** Help:			00007741								****
** Modificación:	Agregar consulta del campo Pai_IdeBMX	****
****************************************************************************
** Creó:			JMALDONADO     							****
** Fecha:		31/Oct/04									****
****************************************************************************/

/*	Declaracion De Variables	*/
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1)

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = 'C' begin					/*	C O N S U L T A S	*/
	if @Tip_ConCon = '1' begin	/*	Consulta por Llave Principal	*/
		select	Pai_Numero,	Pai_Nombre,	Pai_Abrevi,	Pai_ISR, Pai_Gentil, Pai_IdeBMX, Pai_IdCNBV
			from SOPAIS noholdlock
			where	Pai_Numero	= @Pai_Numero
	end
end else begin								/*	L I S T A S	*/
	select	@Pai_Nombre	= ltrim(rtrim(@Pai_Nombre)) + '%'
	
	if @Tip_ConCon = '1' begin	/* Lista de Catálogo */		
		select	Pai_Numero,	Pai_Nombre,	Pai_Abrevi,	Pai_ISR, Pai_Gentil, Pai_IdeBMX, Pai_IdCNBV
			from SOPAIS noholdlock
			where	Pai_Nombre	like @Pai_Nombre
			order by Pai_Nombre
	end
	
	if @Tip_ConCon = '2' begin	/* Lista por gentilicio */		
		select	Pai_Gentil,	Pai_Nombre, Pai_Numero
			from SOPAIS noholdlock
			where	Pai_Gentil	like @Pai_Nombre
			order by Pai_Gentil
	end	
end
