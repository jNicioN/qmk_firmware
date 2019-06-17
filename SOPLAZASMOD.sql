create procedure SOPLAZASMOD(
	@Pla_Numero char(3),
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

declare @SoCenProID	int,				/* Declaración de Variables */
		@SoPlaCecID	int,
		@Consec int

declare	@Str_Vacio	char(1)				/* Declaración de Constantes */

/* Asignación de Constantes */
select	@Str_Vacio	= ''				/* String Vacio */

if not exists (select	Pla_Numero
				from SOPLAZAS noholdlock
				where	Pla_Numero	= @Pla_Numero) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'La plaza no existe',
			Err_Variab	= 'Pla_Numero'
	rollback
	return 1	
end 

if isnull(@Pla_Nombre, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000002', 
			Err_Mensaj	= 'Nombre incorrecto', 
			Err_Variab	= 'Pla_Nombre'
	rollback
	return 1	
end 

if isnull(@Pla_PlaCec, @Str_Vacio) <> @Str_Vacio and not exists (select	Plc_Numero
																	from SOPLACEC noholdlock
																	where	Plc_Numero	= @Pla_PlaCec) begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'La Plaza de CECOBAN no existe',
			Err_Variab	= 'Pla_PlaCec'
	rollback
	return 1
end 

if @Pla_Clabe = @Str_Vacio begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'La Plaza para Clabe no debe estar vacia',
			Err_Variab	= 'Pla_Clabe'
	rollback
	return 1
end

if exists (select	Pla_Clabe
			from SOPLAZAS noholdlock
			where	Pla_Clabe 	= @Pla_Clabe
			  and	Pla_Numero	<> @Pla_Numero) begin
	select	Err_Codigo	= '000005',
			Err_Mensaj	= 'La Plaza para Clabe ya existe para otra plaza',
			Err_Variab	= 'Pla_Clabe'
	rollback
	return 1
end

if not exists (select	Cen_Numero
				from SOCENPRO noholdlock
				where	Cen_Numero	= @Pla_CenPro) begin
	select	Err_Codigo	= '000006',
			Err_Mensaj	= 'No Existe el Centro de Procesamiento',
			Err_Variab	= 'Cen_Numero'
	rollback
	return 1		
end 

if @Pla_ClaMin = @Str_Vacio begin
	select	Err_Codigo	= '000007',
			Err_Mensaj	= 'La Plaza para Minds no debe estar vacia',
			Err_Variab	= 'Pla_ClaMin'
	rollback
	return 1
end

select	@SoCenProID	= convert(int, @Pla_CenPro),
		@SoPlaCecID	= convert(int, @Pla_PlaCec)

update SOPLAZAS set
	Pla_Nombre	= @Pla_Nombre,
	Pla_Abrevi	= @Pla_Abrevi,
	SoCenProID	= @SoCenProID,
	Pla_CenPro	= @Pla_CenPro,
	SoPlaCecID	= @SoPlaCecID,
	Pla_PlaCec	= @Pla_PlaCec,
	Pla_Clabe	= @Pla_Clabe,
	Pla_ClaMin	= @Pla_ClaMin
	where	Pla_Numero	= @Pla_Numero

select	Err_Codigo	= '000000', 
		Err_Mensaj	= 'Registro Modificado'

