create procedure SONOMLARMOD (
    @Nol_Person int,       
    @Nol_Nombre varchar(84),
    @Nol_ApePat varchar(84),
    @Nol_ApeMat varchar(84),
    @Nol_RazSoc varchar(254),
    @Nol_Comple varchar(254),
    @Nol_ComOrd varchar(254),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*******************************************************************
** DESCRIPCION:  ** Modificacion de personas con nombre largo 	****
********************************************************************
** REFERENCIAS:													****
********************************************************************
** Modificó:	Carlos Copto									****
** Fecha:		10/01/2024										****
** Help: 		36841 											****
** Descripcion:	Se crea SP				 						****
*******************************************************************/

--declaracion de variables
declare	@Existe	 	int,
		@Status 	int

--Declaracion de Constantes
declare	@Str_Vacio	char(1),
		@Ent_Cero	int,
		@Ent_Uno	int

--Asignacion de constantes
select 	@Str_Vacio = '',			--string vacio
		@Ent_Cero	= 0,			-- Entero : 0
		@Ent_Uno	= 1				-- Entero : 1

if isnull(@Nol_Person, @Ent_Cero) = @Ent_Cero begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Ingrese un id de persona',
			Err_Variab	= 'Nol_Person'
	rollback
	return @Ent_Uno
end

if isnull(@Nol_RazSoc, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'La Razon Social no puede estar vacia',
			Err_Variab	= 'Nol_RazSoc'
	rollback
	return @Ent_Uno
end

if isnull(@Nol_Comple, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'El nombre completo no puede estar vacio',
			Err_Variab	= 'Nol_Comple'
	rollback
	return @Ent_Uno
end

if isnull(@Nol_ComOrd, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'El nombre completo ordenado no puede estar vacio',
			Err_Variab	= 'Nol_ComOrd'
	rollback
	return @Ent_Uno
end

--se valida si ya existe registro con ese id de cliente
select @Existe = @Ent_Cero
select @Existe = @Ent_Uno
from SONOMLAR noholdlock
where Nol_Person = @Nol_Person

--si no existe registro se inserta
if @Existe = @Ent_Cero begin

	exec @Status = SONOMLARALT
		@Nol_Person,	@Nol_Nombre,	@Nol_ApePat,	@Nol_ApeMat,	@Nol_RazSoc,
	    @Nol_Comple,	@Nol_ComOrd,	@NumTransac,	@Transaccio,	@Usuario,			
	    @FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end

end else begin  --Si ya existe un registro se modifica

	update SONOMLAR set 
		Nol_Nombre = @Nol_Nombre, 
	    Nol_ApePat = @Nol_ApePat,
	    Nol_ApeMat = @Nol_ApeMat, 
	    Nol_RazSoc = @Nol_RazSoc, 
	    Nol_Comple = @Nol_Comple, 
	    Nol_ComOrd = @Nol_ComOrd,

	    NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Nol_Person = @Nol_Person

end

--insertar en bitacora
exec @Status = SOBINOLAALT
	@Nol_Person,	@Nol_Nombre,	@Nol_ApePat,	@Nol_ApeMat,	@Nol_RazSoc,
    @Nol_Comple,	@Nol_ComOrd,	@NumTransac,	@Transaccio,	@Usuario,			
    @FechaSis,		@SucOrigen,		@SucDestino,	@Modulo

if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end
