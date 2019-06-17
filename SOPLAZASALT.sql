create procedure SOPLAZASALT(
	@Pla_Nombre varchar(70),
	@Pla_Abrevi varchar(30),
	@Pla_CenPro	char(3),
	@Pla_PlaCec	char(2),
	@Pla_Clabe	char(3),
	@Pla_ClaMin	char(7),
	
	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino char(3),
	@Modulo char(2))
as

/*****************************************************************************/
/* DESCRIPCION: Alta de Plazas												 */
/*****************************************************************************/
/***************************************************************************
** Modificó:	Alfredo Olivas											****
** Fecha:		21/Mar/2017												****
** Descripción:	Se agrego @Pla_Numero para que regrese el consecutivo. 	****
** Help			00598646												****
****************************************************************************
** Modificó:		Eugenio Salazar     								****
** Fecha:		26/Marzo/2015											****
** Help:	   	    	746309											****
** Descripción:	Agregar Region Vacio									****
****************************************************************************
** Modificó:		Sandra Almaguer     								****
** Fecha:		11/Junio/2009											****
** Help:	   	    	176509											****
** Descripción:	Poner como opcional el Centro Cecoban					****
****************************************************************************
** Modificó:		Fernando Marcos Esquivel Velázquez					****
** Fecha:		14/Diciembre/2006										****
** Help:		      00003613											****
** Descripción:	Se quito Exec a CHLEESCUALT								****
****************************************************************************
** Modificó:		Ma de Lourdes Valdés Ramírez						****
** Fecha:		05/Junio/2006											****
** Descripción:	Agregar campo Pla_ClaMin								****
** HelpDesk:	00088144												****
****************************************************************************
** Modifico:		Sandra Almaguer										****
** Fecha:		01/Julio/2004											****
** Descripción: 	Cambiar Err_Mensaje por Err_Mensaj					****
****************************************************************************
** Modificó:		Raul Gonzalez										****
** Fecha:		13/Jun/2003												****
** Descripción:	Se le agrego un espacio a varios return1				****
****************************************************************************
** Modificó:		Raul Gonzalez										****
** Fecha:		13/Jun/2003												****
** Descripción:	Se le agrego un espacio a varios return1				****
****************************************************************************
** Modificó:		Raúl González										****
** Fecha:		21/Ene/2003												****
** Descripción:	Se le agrego un exec al Sp que da de alta una			****
**				Sucursal en CHLEESCU									****
****************************************************************************
** Modificó:		Ma de Lourdes Valdés								****
** Fecha:			5/Abr/2002											****
** Descripción:	agregar Pla_PlaCec, Pla_Clabe							**** 
****************************************************************************
** Modificó:		Sandra Almaguer										****
** Fecha:		26/Mar/2002												****
** Descripción:	agregar SoPlazaID, SoCenProID							**** 
***************************************************************************/

declare @Pla_Numero char(3),			/*	Declaración de Variables	*/
		@SoCenProID	int,
		@SoPlaCecID int,
		@Consec 	int,
		@Status		int

declare	@Str_Vacio	char(1),			/*	Declaración de Constantes	*/
		@Tip_Plaza	char(1)

/* Asignación de Constantes */
select	@Str_Vacio	= '',				/*	String Vacio					*/
		@Tip_Plaza	= 'A'				/*	Tipo de alta en Leyendas: PLAZA	*/

if isnull(@Pla_Nombre, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000001', 
			Err_Mensaj	= 'Nombre incorrecto', 
			Err_Variab	= 'Pla_Nombre'
	rollback
	return 1
end

if isnull(@Pla_PlaCec, @Str_Vacio) <> @Str_Vacio and not exists (select	Plc_Numero
																	from SOPLACEC noholdlock
																	where	Plc_Numero	= @Pla_PlaCec) begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'La Plaza de CECOBAN no existe',
			Err_Variab	= 'Pla_PlaCec'
	rollback
	return 1
end 

if @Pla_Clabe = @Str_Vacio begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'La Plaza para Clabe no puede estar vacia',
			Err_Variab	= 'Pla_Clabe'
	rollback
	return 1
end

if exists (select	Pla_Clabe
			from SOPLAZAS noholdlock
			where	Pla_Clabe	= @Pla_Clabe) begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'La Plaza para Clabe ya existe',
			Err_Variab	= 'Pla_Clabe'
	rollback
	return 1
end

if not exists (select	Cen_Numero
				from SOCENPRO noholdlock
				where	Cen_Numero	= @Pla_CenPro) begin
	select	Err_Codigo	= '000005',
			Err_Mensaj	= 'No Existe el Centro de Procesamiento',
			Err_Variab	= 'Cen_Numero'
	rollback
	return 1
end 

if @Pla_ClaMin = @Str_Vacio begin
	select	Err_Codigo	= '000006',
			Err_Mensaj	= 'La Plaza para Minds no puede estar vacia',
			Err_Variab	= 'Pla_ClaMin'
	rollback
	return 1
end

select	@SoCenProID	= convert(int, @Pla_CenPro),
		@SoPlaCecID	= convert(int, @Pla_PlaCec)

select	@Pla_Numero	= max(Pla_Numero)
	from SOPLAZAS noholdlock

select	@Consec	= convert(int, @Pla_Numero) + 1

select	@Pla_Numero	= convert(char, @Consec)

exec UTCERIZQ
	@Valor		= @Pla_Numero output,
	@Longitud	= 3

insert into SOPLAZAS values(
	@Consec,		@Pla_Numero,	@Pla_Nombre,	@Pla_Abrevi,	@SoCenProID,
	@Pla_CenPro,	@SoPlaCecID,	@Pla_PlaCec,	@Pla_Clabe,		@Pla_ClaMin,
	@Str_Vacio,		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
	@SucOrigen,		@SucDestino)

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Agregado',
		Pla_Numero	= @Pla_Numero
