create procedure SOESTADOALT(
	@Est_Numero	char(2),
	@Est_Nombre	varchar(50),
	@Est_Abrevi	varchar(10),
	@Est_Pais	char(2),
	@Est_ClaABM	char(2),
	@Est_Region	char(1),
	@Est_CoCNBV	int,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*
****************************************************************************
***	Alta de un estado
****************************************************************************
*/

/*
****************************************************************************
** Modificó:		Roberto Pascuale Morales Chavez			****
** Fecha:		29/Marzo/2012								****
** Help:			401531										****
** Descripción:	Agregar el parámetro Clave de CNBV			****
**				@Est_CoCNBV								****
****************************************************************************
** Modificó:		Roberto Pascuale Morales Chavez			****
** Fecha:		29/Marzo/2012								****
** Help:			453782										****
** Descripción:	Agregar los parámetros @Est_Abrevi			****
**				y @Est_Pais									****
****************************************************************************
** Creó:			Eleazar Alejandro Nevarez Leyva				****
** Fecha:		29/Oct/10									****
** Help:		      00306710									****
** Descripcion:	Se agregó la region							****
****************************************************************************
** Modificó:		Gerardo Flores Martinez						****
** Fecha:		03/Mayo/2006								****
** HD:			125332										****
** Descripción:	agregar ClaABM								**** 
****************************************************************************
** Modificó:		Sandra Almaguer							****
** Fecha:		27/Mar/2002								****
** Descripción:	agregar SoEstadoID, ClPaisID				**** ****************************************************************************
** Modificó:		Hugo Perez M.       							****
** Fecha:		26/Jul/01									****
** Descripción:	Se agrego el campo de de Pais				****
****************************************************************************
*/

declare	@SoEstadoID	int,				/* Declaración de Variables */
		@ClPaisesID	int,
		@Status		int

declare	@Tab_Nombre char(8),			/* Declaración de Constantes */
		@Str_Vacio	char(1),
		@Ent_Cero	int

/* Asignación de Constantes */
select	@Tab_Nombre = 'SOESTADO',		/* Nombre de la Tabla */
		@Str_Vacio	= '',				/* String Vacio */
		@Ent_Cero	= 0					/* Entero en Cero */

select	@SoEstadoID	= convert(int, @Est_Numero),
		@ClPaisesID	= convert(int, @Est_Pais)
	
if @SoEstadoID = @Ent_Cero begin
	select	Err_Codigo = '000001', 
			Err_Mensaj = 'Numero incorrecto',
			Err_Variab = 'Est_Numero'
	rollback
	return 1
end 

if exists (select	Est_Numero
				from SOESTADO noholdlock
				where	Est_Numero	= @Est_Numero) begin
	select	Err_Codigo = '000002',
			Err_Mensaj = 'Numero ya existe',
			Err_Variab = 'Est_Numero'
	rollback
	return 1
end 

if isnull(@Est_Nombre, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo = '000003',
			Err_Mensaj = 'Nombre incorrecto',
			Err_Variab = 'Est_Nombre'
	rollback
	return 1
end

if isnull(@Est_Abrevi, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo = '000005',
			Err_Mensaj = 'Abreviacion incorrecta',
			Err_Variab = 'Est_Abrevi'
	rollback
	return 1
end

if isnull(@Est_Region, @Str_Vacio) <> @Str_Vacio and not exists (select	Reg_Region
																	from ADREGION noholdlock
																	where	Reg_Region	= @Est_Region) begin
	select	Err_Codigo = '000004',
			Err_Mensaj = 'Region No Existe',
			Err_Variab = 'Est_Region'
	rollback
	return 1
end

if not exists (select	Pai_Numero
					from CLPAISES noholdlock
					where	Pai_Numero	= @Est_Pais) begin
	select	Err_Codigo = '000006',
			Err_Mensaj = 'Pais No Existe',
			Err_Variab = 'Est_Pais'
	rollback
	return 1
end

if exists (select	Est_CoCNBV
				from SOESTADO noholdlock
				where	Est_CoCNBV	= @Est_CoCNBV
				  and	Est_CoCNBV	<> @Ent_Cero) begin
	select	Err_Codigo = '000007',
			Err_Mensaj = 'Clave de la CNBV ya existe',
			Err_Variab = 'Est_CoCNBV'
	rollback
	return 1
end

insert into SOESTADO values (
	@SoEstadoID,	@Est_Numero,	@Est_Nombre,	@Est_Abrevi,	@ClPaisesID,
	@Est_Pais,		@Est_ClaABM,	@Est_Region,	@Est_CoCNBV,	@NumTransac,
	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino)

exec @Status = SYTABLOCACT
	@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
	@SucOrigen,		@SucDestino,	@Modulo
if @Status <> 0 begin
	rollback
	return 1
end

select	Err_Codigo = '000000',
		Err_Mensaj = 'Registro Agregado'
