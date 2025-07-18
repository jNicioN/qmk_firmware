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
*** Modifico:	Oscar Trevino											****
** Fecha:		17/07/2025												****
** Jira:		TCELPLD-8082											****
** Modificar:	Se modifica L3 para validar modulo. Regrea los paises	****
**				sin sancion o en cuarentena o que no esten bloqueados 	****
**				para el modulo											****
****************************************************************************
** Modifico:	Jonatan Diaz Garces							****
** Fecha:		07/03/2020									****
** Jira:		TCELTU-1302									****
** Modificar:	Se modifica L3								****
****************************************************************************
** Modifico:	Joel Barcenas								****
** Fecha:		06/03/2020									****
** Req:			1367345										****
** Modificar:	Se agrega L3 para filtrar por paises 		****
**				sancionados									****
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

/*	Declaracion De Constantes	*/
declare @Ent_Cero	int,
		@Est_Bloque int,
		@Par_UsBaEl varchar(50),
		@Mod_BanEle char(2)
		
/*	Declaracion De Variables	*/
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1),
		@Usu_BanEle	varchar(6)
		
		
select @Ent_Cero	= 0,
	   @Est_Bloque	= 2,
	   @Par_UsBaEl = 'UsuarioBancaElectronica',
	   @Mod_BanEle = 'BE'

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

		
select @Usu_BanEle = Par_Valor
	from SOPARGEN noholdlock
	where Par_Nombre = @Par_UsBaEl

if @Usuario = @Usu_BanEle begin
	select @Modulo = @Mod_BanEle
end

		
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
	if @Tip_ConCon = '3' begin	/* Lista de paises filtrados por paises sancionados swift */	
		
		select distinct p.Pai_Numero,	p.Pai_Nombre,	p.Pai_Abrevi,	p.Pai_ISR, p.Pai_Gentil, p.Pai_IdeBMX, p.Pai_IdCNBV, isnull(Pas.Pas_EstPai,@Ent_Cero) as Pas_EstPai
		from SOPAIS p noholdlock
		left join LDPAISAN Pas noholdlock on p.Pai_IdCNBV = Pas.Pas_ClaPai and Pas.Pas_TipMod = @Modulo
		where Pai_Nombre	like @Pai_Nombre
		  and (Pas.Pas_EstPai <> @Est_Bloque or Pas.Pas_Numero  is null)
		order by Pai_Nombre
		
		
	end
end