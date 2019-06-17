create procedure SOCIULOCMOD (
	@Cil_Numero	char(3),
	@Cil_Ciudad	char(3),
	@Cil_Estado	char(2),
	@Cil_Locali	char(8),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Str_Vacio	char(1)		/* declaracion de constantes */

/* Asignacion de constantes */
select	@Str_Vacio	= ''		/* String vacio */	

if isnull(@Cil_Locali, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000001', 
			Err_Mensaj	= 'Localidad Incorrecta', 
			Err_Variab	= 'Cil_Locali'
	rollback
	return 1
end 

if not exists (	select	Suc_Numero
					from SOSUCURS noholdlock
					where	Suc_Numero	= @Cil_Numero) begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'El Numero de sucursal no existe',
			Err_Variab	= 'Suc_Numero'
	rollback
	return 1
end

if not exists (select	Est_Numero
				from SOESTADO noholdlock
				where	Est_Numero	= @Cil_Estado) begin
	select	Err_Codigo	= '000003', 
			Err_Mensaj	= 'El estado no existe', 
			Err_Variab	= 'Suc_Estado'
	rollback
	return 1
end 

if not exists (select	Ciu_Numero
				from SOCIUDAD noholdlock
				where	Ciu_Numero	= @Cil_Ciudad
				  and	Ciu_Estado	= @Cil_Estado) begin
	select	Err_Codigo	= '000004', 
			Err_Mensaj	= 'La ciudad no existe', 
			Err_Variab	= 'Suc_Ciudad'
	rollback
	return 1
end

if not exists (	select	Loc_Numero
				from CLLOCALI noholdlock
				where	Loc_Numero	= @Cil_Locali )	begin
	select 	Err_Codigo	= '000005',
			Err_Mensaj	= 'La Localidad No Existe',
			Err_variab	= 'Cil_Locali'
	rollback
	return 1
end

update SOCIULOC set
	Cil_Ciudad	= @Cil_Ciudad,
	Cil_Estado	= @Cil_Estado,
	Cil_Locali	= @Cil_Locali,
	
	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,	
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino
	where	Cil_Numero	= @Cil_Numero

