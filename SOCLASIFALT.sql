create procedure SOCLASIFALT (
	@Cla_Descri varchar(50),
	@Cla_Compan char(2),
	@Cla_Status char(1),

	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino char(3),
	@Modulo char(2))

as

/***************************************************************************/
/* DESCRIPCION:   Alta de clasificaciones de compania	 	           */
/** REFERENCIAS:
*****************************************************************************
** Creo:	Oscar Daniel Trevino Quintanilla							****
** Fecha:	07/08/2020													****
** Help:	01415639													****
****************************************************************************/

/*	Declaracion de Constantes	*/
declare	@Str_Vacio	char(1),
	@Ent_Uno	int,
	@Sta_Activo char(1),
	@Sta_Inacti char(1)


/* Asignacion de Constantes */
select	@Str_Vacio	= '',			/* Tipo consulta*/
	@Ent_Uno	= 1,			/* Entero Uno*/
	@Sta_Activo  = 'A',			/* Estatus Activo */
	@Sta_Inacti = 'I'			/* Estatus Inactivo */


if isnull(@Cla_Descri,@Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'La descripcion es incorrecta',
			Err_Variab	= 'Cla_Descri'
	rollback
	return @Ent_Uno
end

if not exists (	select	 Com_Numero 
						from SOCOMPAN	noholdlock
						where  Com_Numero  	= @Cla_Compan) begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'La compania no existe',
			Err_Variab	= 'Cla_Compan'
	rollback
	return @Ent_Uno
end


if @Cla_Status not in (@Sta_Activo, @Sta_Inacti) begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'El estatus de la clasificacion es incorrecto',
			Err_Variab	= 'Cla_Status'
	rollback
	return @Ent_Uno
end

insert into SOCLASIF (
		Cla_Descri, Cla_Compan,	Cla_Status,	NumTransac, 	Transaccio, 	
		Usuario,	FechaSis, 	SucOrigen, SucDestino)
	values (
		@Cla_Descri, @Cla_Compan,	@Cla_Status,	@NumTransac, 	@Transaccio,
		@Usuario,	@FechaSis,	@SucOrigen,	@SucDestino)