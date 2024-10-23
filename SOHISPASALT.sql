create procedure SOHISPASALT (
	@Hip_Usuari	char(8),
	@Hip_PassWo	char(345),		

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@SoUsuariID	int			/* Declaración de Variables */

select	@FechaSis	= getdate()

select	@SoUsuariID	= convert(int, @Hip_Usuari),
		@Hip_PassWo	= rtrim(@Hip_PassWo)

if exists (select	Hip_Usuari
			from SOHISPAS noholdlock
			where	Hip_Usuari	= @Hip_Usuari
			  and	rtrim(Hip_PassWo)	= @Hip_PassWo) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Password Utilizado con Anterioridad, Introducir uno Diferente',
			Err_Variab	= 'm.Usu_PassWo'
	rollback
	return 1
end

insert into SOHISPAS values (
	@SoUsuariID,	@Hip_Usuari,	@Hip_PassWo,	@FechaSis,	@NumTransac,
	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	@SucDestino)
