create procedure SOREPRESALT (
    @Rep_Cuenta char(15),
    @Rep_NumApo char(3),
    @Rep_Numero char(3),
    @Rep_Tipo   char(2),
    @Rep_Nombre varchar(40),
    @Rep_ApePat varchar(40),
    @Rep_ApeMat varchar(40),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/* alta del representante */

if @Rep_Cuenta = '' or @Rep_NumApo = '' or @Rep_Numero = '' or @Rep_Tipo = '' begin
  	select Err_Codigo = '000001', Err_Mensaj = 'La inf. del representante esta incorrecta', Err_Variab = 'Rep_Cuenta'
	rollback
	return 1
end

if exists (Select Rep_Cuenta from SOREPRES
				where	Rep_Cuenta 	= @Rep_Cuenta
					and Rep_NumApo	= @Rep_NumApo
					and Rep_Numero 	= @Rep_Numero
					and Rep_Tipo	= @Rep_Tipo) begin
	
	select Err_Codigo = '000002', Err_Mensaj = 'El Registro ya existe', Err_Variab = 'Rep_Cuenta'
	rollback
	return 1
end

insert into SOREPRES values (@Rep_Cuenta, @Rep_NumApo, @Rep_Numero, @Rep_Tipo, @Rep_Nombre, @Rep_ApePat, @Rep_ApeMat, @NumTransac, @Transaccio, @Usuario, @FechaSis, @SucOrigen, @SucDestino)

select Err_Codigo = '000000', Err_Mensaj = 'Registro Agregado'

