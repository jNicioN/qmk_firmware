create procedure SOACTUSUPRO (

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as
				
/* Declaración de constantes */	
declare	@Str_Si	char(1)
		
/* Asignación de constantes */
select	@Str_Si	= 'S'	/* String Si */
																				
update SOUSUARI
	set	Usu_Activo = @Str_Si
		from SOTMPUSU
		where	Usu_Numero = Tmu_Usuari	
		
delete from SOTMPUSU

if @@nestlevel = 1
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Usuarios Activados '
