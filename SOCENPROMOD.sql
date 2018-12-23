create procedure SOCENPROMOD (
	@Cen_Numero char(3),
	@Cen_Nombre varchar(70),
	@Cen_Plaza 	char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

declare	@Str_Vacio	char(1)		/* Declaración de Constantes */

/* Asignación de Constantes */
select	@Str_Vacio	= ''

if not exists (select	Cen_Numero
				from SOCENPRO noholdlock
				where	Cen_Numero	= @Cen_Numero) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'El Centro de Procesamiento no existe',
			Err_Variab  = 'Cen_Numero'
	rollback
	return 1
end
if @Cen_Nombre = @Str_Vacio begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Nombre incorrecto',
			Err_Variab 	= 'Cen_Nombre'
	rollback
	return 1
end
if not exists (select	Plc_Numero
				from SOPLACEC noholdlock
				where 	Plc_Numero	= @Cen_Plaza) begin
	select 	Err_Codigo	= '000003', 
			Err_Mensaj	= 'No. de Plaza incorrecto', 
			Err_Variab	= 'Plc_Numero'
	rollback
	return 1
end	

update SOCENPRO set
	Cen_Nombre	= @Cen_Nombre,
	Cen_Plaza	= @Cen_Plaza,
	
	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino
	where	Cen_Numero	= @Cen_Numero
	
select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Modificado'

