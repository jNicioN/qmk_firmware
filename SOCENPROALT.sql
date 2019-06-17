create procedure SOCENPROALT(
	@Cen_Numero char(3),
	@Cen_Nombre varchar(70),
	@Cen_Plaza	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
	
as

declare	@Par_FecAct	smalldatetime,		/* Declaración de Variables */
		@SoCenProID	int
		
declare	@Str_Vacio	char(1)				/* Declaración de Constantes */

/* Asignación de Constantes */
select	@Str_Vacio	= ''

select	@Par_FecAct = Par_FecAct
	from SOPARAMS noholdlock
	where	Par_Sucurs = @SucOrigen 

if @Cen_Numero = @Str_Vacio begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'No. Centro de Procesamiento incorrecto',
			Err_Variab 	= 'Cen_Numero'
	rollback
	return 1
end
if exists (select	Cen_Numero
			from SOCENPRO noholdlock
			where	Cen_Numero	= @Cen_Numero) begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'El Centro de Procesamiento ya existe',
			Err_Variab 	= 'Cen_Numero'
	rollback
	return 1
end

if @Cen_Nombre = @Str_Vacio begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Nombre incorrecto', 
			Err_Variab 	= 'Cen_Nombre'
	rollback
	return 1
end

if not exists (select	Plc_Numero
				from SOPLACEC noholdlock
				where 	Plc_Numero	= @Cen_Plaza) begin
	select 	Err_Codigo	= '000004', 
			Err_Mensaj	= 'No. de Plaza incorrecto', 
			Err_Variab	= 'Cen_Plaza'
	rollback
	return 1
end	

select	@SoCenProID	= convert(int, @Cen_Numero)

insert into SOCENPRO values(
	@SoCenProID,	@Cen_Numero,	@Cen_Nombre,	@Par_FecAct,	@Cen_Plaza,		
	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		
	@SucDestino)

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Agregado'

