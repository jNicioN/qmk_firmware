create procedure SOCIUDADMOD (
	@Ciu_Numero	char(3),
	@Ciu_Nombre	varchar(50),
	@Ciu_Estado	char(2),
	@Ciu_CobRem	char(1),
	@Ciu_Plaza	char(3),
	@Ciu_ClaABM char(3),
	@Ciu_CoCNBV	int,

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
***	Modificacion de Una ciudad existente
****************************************************************************
*/

/*
****************************************************************************
** Modificó:		Roberto Pascuale Morales Chavez			****
** Fecha:		29/Marzo/2012								****
** Help:			401531										****
** Descripción:	Agregar Clave de CNBV (Ciu_CoCNBV)		****
****************************************************************************
** Modificó:		Roberto Pascuale Morales Chavez			****
** Fecha:		29/Marzo/2012								****
** Help:			453782										****
** Descripción:	Agregar el parámetro @Ciu_Plaza				****
****************************************************************************
** Modificó:		Gerardo Flores Martinez						****
** Fecha:		03/Mayo/2006								****
** HD:			125332										****
** Descripción:	agregar ClaABM								**** 
****************************************************************************
** Modificó:		Sandra Almaguer							****
** Fecha:		26/Mar/2002								****
** Descripción:	agregar SoCiudadID, SoEstadoID				**** 
****************************************************************************
*/

declare	@Lim_EdoSuc	char(2),			/* Declaración de Variables */
		@Lim_CiuSuc	char(3),
		@Status		int

declare	@Tab_Nombre char(8),			/* Declaración de Constantes */
		@Str_Vacio	char(1),
		@Ent_Cero	int,
		@Tip_CobRem	char(4),
		@Tip_Cobro	char(1),
		@Tip_Remesa	char(1)

/* Asignación de Constantes */		
select	@Tab_Nombre = 'SOCIUDAD',		/* Nombre de la Tabla */
		@Str_Vacio	= '',				/* String Vacío */
		@Ent_Cero	= 0,				/* Entero en Cero */
		@Tip_CobRem	= '[CR]',			/* Tipos de Cobro Remesa */
		@Tip_Cobro	= 'C',				/* Tipo Cobro Inmediato */
		@Tip_Remesa = 'R'				/* Tipo Remesa */

select	@Lim_EdoSuc	= substring(Par_TranBR, 3, 2),
		@Lim_CiuSuc = substring(Par_TranBR, 5, 3)
	from SOPARAMS noholdlock
	where	Par_Sucurs	= @SucOrigen

if not exists (select	Ciu_Numero
				from SOCIUDAD noholdlock
				where	Ciu_Numero	= @Ciu_Numero 
				  and	Ciu_Estado	= @Ciu_Estado) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'La ciudad no existe',
			Err_Variab	= 'Ciu_Numero'
	rollback
	return 1
end

if isnull(@Ciu_Nombre, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Nombre incorrecto',
			Err_Variab	= 'Ciu_Nombre'
	rollback
	return 1
end

if not exists (select	Est_Numero
				from SOESTADO noholdlock
				where	Est_Numero	= @Ciu_Estado) begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'El estado no existe',
			Err_Variab	= 'Ciu_Estado'
	rollback
	return 1
end

if @Ciu_CobRem not like @Tip_CobRem begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'Clave de Cobro incorrecto',
			Err_Variab	= 'Ciu_CobRem'
	rollback
	return 1
end

if exists (select	Ciu_CoCNBV
				from SOCIUDAD noholdlock
				where	Ciu_CoCNBV	= @Ciu_CoCNBV
				  and	(	Ciu_Numero	<> @Ciu_Numero
				   or		Ciu_Estado	<> @Ciu_Estado	)
				  and	Ciu_CoCNBV	<> @Ent_Cero) begin
	select	Err_Codigo	= '000005',
			Err_Mensaj	= 'Clave de la CNBV ya existe',
			Err_Variab	= 'Ciu_CoCNBV'
	rollback
	return 1
end

update SOCIUDAD set
	Ciu_Nombre	= @Ciu_Nombre,
	Ciu_CobRem	= @Ciu_CobRem,
	Ciu_Plaza	= @Ciu_Plaza,
	Ciu_ClaABM	= @Ciu_ClaABM,
	Ciu_CoCNBV	= @Ciu_CoCNBV
	where	Ciu_Numero	= @Ciu_Numero
	  and	Ciu_Estado	= @Ciu_Estado

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Modificado'

exec @Status = SYTABLOCACT
	@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,	@FechaSis,
	@SucOrigen,		@SucDestino,	@Modulo
if @Status <> 0 begin
	rollback
	return 1
end

if @Ciu_CobRem = @Tip_Remesa begin
	exec @Status = SOLIMSBCBAJ
		@Lim_EdoSuc,	@Lim_CiuSuc,	@Ciu_Estado,	@Ciu_Numero,	@NumTransac,
		@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,
		@Modulo
	if @Status <> 0 begin
		rollback
		return 1
	end

end else if @Ciu_CobRem = @Tip_Cobro begin
	if not exists (select	Lim_CiuSbc
					from SOLIMSBC noholdlock
					where	Lim_EdoSuc	= @Lim_EdoSuc
					  and	Lim_CiuSuc	= @Lim_CiuSuc
					  and	Lim_EdoSbc	= @Ciu_Estado
					  and	Lim_CiuSbc	= @Ciu_Numero) begin
		exec @Status = SOLIMSBCALT
			@Lim_EdoSuc,	@Lim_CiuSuc,	@Str_Vacio,		@Ciu_Estado,	@Ciu_Numero,
			@Str_Vacio,		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
			@SucOrigen,		@SucDestino,	@Modulo
		if @Status <> 0 begin
			rollback
			return 1
		end
	end
end
