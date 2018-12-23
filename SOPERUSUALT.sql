create procedure SOPERUSUALT (
	@Peu_Usuari	char(6),
	@Peu_Status	char(1),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Status	int	/* Declaración de variables */			
				
declare	@Str_Vacio	char(1),	/* Declaración de constantes */	
		@Str_No		char(1),
		@Str_Si		char(1)
		
/* Asignación de constantes */
select	@Str_Vacio	= '',	/* String Vacio */
		@Str_No		= 'N',	/* String No */
		@Str_Si		= 'S'	/* String Si */
		
if @Peu_Usuari = @Str_Vacio begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Usuario Incorrecto',
			Err_Variab	= 'm.Peu_Usuari'
	rollback
	return 1
end

if not exists (select	Usu_Numero
				from SOUSUARI noholdlock
			   where	Usu_Numero	= @Peu_Usuari) begin
		select	Err_Codigo	= '000002',
				Err_Mensaj	= 'El Usuario no existe',
				Err_Variab	= 'm.Peu_Usuari'
		rollback
		return 1
end

if exists (select	Peu_Usuari
			from SOPERUSU noholdlock
		   where	Peu_Usuari	= @Peu_Usuari) begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'El Usuario ya existe en el Catálogo',
			Err_Variab	= 'm.Peu_Usuari'
	rollback
	return 1
end

if @Peu_Status <> @Str_No AND @Peu_Status <> @Str_Si begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'Status Incorrecto',
			Err_Variab	= 'm.Peu_Status'
	rollback
	return 1
end

insert into SOPERUSU values	(
	@Peu_Usuari,	@Peu_Status,	@NumTransac,	@Transaccio,	@Usuario,	
	@FechaSis,		@SucOrigen,		@SucDestino)	

if @@nestlevel = 1
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro agregado '
			
exec @Status = SOPEUSBIALT
	@Peu_Usuari,	@Peu_Status,	@NumTransac,	@Transaccio,	@Usuario,
	@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
if @Status <> 0 begin
	rollback
	return 1
end
	


