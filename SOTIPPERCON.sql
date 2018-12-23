create procedure SOTIPPERCON (
	@Tpe_Numero	char(2),
	@Tpe_Descri	varchar(30),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

if @Tpe_Numero = '' and @Tpe_Descri = ''
	/* Adaptive Server has expanded all '*' elements in the following statement */ select SOTIPPER.Tpe_Numero, SOTIPPER.Tpe_Descri, SOTIPPER.Tpe_Abrevi, SOTIPPER.NumTransac, SOTIPPER.Transaccio, SOTIPPER.Usuario, SOTIPPER.FechaSis, SOTIPPER.SucOrigen, SOTIPPER.SucDestino
	from SOTIPPER
	order by Tpe_Descri
else if @Tpe_Descri = ''
	/* Adaptive Server has expanded all '*' elements in the following statement */ select SOTIPPER.Tpe_Numero, SOTIPPER.Tpe_Descri, SOTIPPER.Tpe_Abrevi, SOTIPPER.NumTransac, SOTIPPER.Transaccio, SOTIPPER.Usuario, SOTIPPER.FechaSis, SOTIPPER.SucOrigen, SOTIPPER.SucDestino
	from SOTIPPER (index SOTIPPERNUM)
	where Tpe_Numero = @Tpe_Numero
	order by Tpe_Descri
else/* Adaptive Server has expanded all '*' elements in the following statement */ 
	select SOTIPPER.Tpe_Numero, SOTIPPER.Tpe_Descri, SOTIPPER.Tpe_Abrevi, SOTIPPER.NumTransac, SOTIPPER.Transaccio, SOTIPPER.Usuario, SOTIPPER.FechaSis, SOTIPPER.SucOrigen, SOTIPPER.SucDestino
	from SOTIPPER
	where Tpe_Descri like @Tpe_Descri + '%'

