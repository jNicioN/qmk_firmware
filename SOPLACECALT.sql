create procedure SOPLACECALT (
	@Plc_Numero char(2),
	@Plc_Nombre varchar(35),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
	
as

declare	@Str_Vacio	char(1)				/* Declaración de Constantes */

/* Asignación de Constantes */
select	@Str_Vacio	= ''

if @Plc_Numero = @Str_Vacio begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'No. Plaza de Cecoban incorrecto',
			Err_Variab 	= 'Plc_Numero'
	rollback
	return 1
end

if exists (select	Plc_Numero
			from SOPLACEC noholdlock
			where	Plc_Numero	= @Plc_Numero) begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'La Plaza de Cecoban ya existe',
			Err_Variab 	= 'Plc_Numero'
	rollback
	return 1
end 

if @Plc_Nombre = @Str_Vacio begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Nombre incorrecto', 
			Err_Variab	= 'Plc_Nombre'
	rollback
	return 1
end

insert into SOPLACEC values(
	@Plc_Numero,	@Plc_Nombre,	@NumTransac,	@Transaccio,	@Usuario,
	@FechaSis,		@SucOrigen,		@SucDestino)

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Agregado'

