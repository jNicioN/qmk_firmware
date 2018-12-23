create procedure SOUSUACTMOD (
	@Usa_Usuari	char(6),
	@Usa_Status	char(1),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as
		
/* Declaración de constantes */
declare	@Str_Vacio	char(1),	
		@Str_No		char(1),
		@Str_Si		char(1)
		
/* Asignación de constantes */
select	@Str_Vacio	= '',	/* String Vacio */
		@Str_No		= 'N',	/* String No */
		@Str_Si		= 'S'	/* String Si */
		
if @Usa_Usuari = @Str_Vacio begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Usuario Incorrecto',
			Err_Variab	= 'm.Usa_Usuari'
	rollback
	return 1
end

if not exists (select	Usu_Numero
				from SOUSUARI noholdlock
			   where	Usu_Numero	= @Usa_Usuari) begin
		select	Err_Codigo	= '000002',
				Err_Mensaj	= 'El Usuario no existe',
				Err_Variab	= 'm.Usa_Usuari'
		rollback
		return 1
end

if not exists (select	Usa_Usuari
				from SOUSUACT noholdlock
			   where	Usa_Usuari	= @Usa_Usuari) begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'El Usuario no existe',
			Err_Variab	= 'm.Usa_Usuari'
	rollback
	return 1
end

if @Usa_Status <> @Str_No AND @Usa_Status <> @Str_Si begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'Status Incorrecto',
			Err_Variab	= 'm.Usa_Status'
	rollback
	return 1
end

update SOUSUACT set
	Usa_Status	= @Usa_Status,
	
	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino
	where	Usa_Usuari	= @Usa_Usuari

if @@nestlevel = 1
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro modificado '
