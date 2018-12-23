create procedure SODOCUMEALT (
    @Doc_Cuenta char(15),
    @Doc_Apoder char(3),
    @Doc_Numero char(3),
    @Doc_Tipo   char(2),
    @Doc_NumEsc varchar(15),
    @Doc_Fecha  smalldatetime,
    @Doc_Notari varchar(50),
    @Doc_NumNot char(6),
    @Doc_Ciudad char(8),
    @Doc_Estado char(3),
    @Doc_NumReg varchar(10),
    @Doc_Volume varchar(10),
    @Doc_Libro  varchar(10),
    @Doc_FecReg smalldatetime,
    @Doc_EntReg char(3),
    @Doc_LocReg char(8),
    @Doc_Descri varchar(250),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/* alta del documento que acredita al apoderado como tal */

if @Doc_Cuenta = '' or @Doc_Apoder = '' or @Doc_Numero = '' or @Doc_Tipo = '' begin
	select Err_Codigo = '000001', Err_Mensaj = 'La inf. del documento esta incorrecta', Err_Variab = 'Doc_Cuenta'
	rollback
	return 1
end

if exists (Select Doc_Cuenta from SODOCUME
				where	Doc_Cuenta 	= @Doc_Cuenta
					and Doc_Apoder	= @Doc_Apoder
					and Doc_Numero 	= @Doc_Numero
					and Doc_Tipo	= @Doc_Tipo) begin

	select Err_Codigo = '000002', Err_Mensaj = 'El Registro ya existe', Err_Variab = 'Doc_Cuenta'
	rollback
	return 1
end

insert into SODOCUME values (@Doc_Cuenta ,@Doc_Apoder, @Doc_Numero,
@Doc_Tipo, @Doc_NumEsc, @Doc_Fecha, @Doc_Notari, @Doc_NumNot, @Doc_Ciudad, @Doc_Estado, @Doc_NumReg, @Doc_Volume, @Doc_Libro, @Doc_FecReg, @Doc_EntReg, @Doc_LocReg, @Doc_Descri, @NumTransac, @Transaccio, @Usuario, @FechaSis, @SucOrigen, @SucDestino)

select Err_Codigo = '000000', Err_Mensaj = 'Registro Agregado'


