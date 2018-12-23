create procedure SOESTRUCALT (
	@Est_Numero 	char(8),
	@Est_Puesto 	char(8),
	@Est_Nombre 	char(80),
	@Est_Nivel 		int,
	@Est_Depend 	char(8),
	@Est_Usuari		char(6),
	@Est_Raiz 		char(1),
	@Est_Serial		char(160),
	
	@NumTransac 	char(10),
	@Transaccio 	char(3),
	@Usuario 		char(6),
	@FechaSis 		datetime,
	@SucOrigen 		char(3),
	@SucDestino 	char(3),
	@Modulo 		char(2))
as

declare @Status int, /* Declaracion de Variables */
		@Tab_Nombre char(8),
		@Fol_Numero int

select @Tab_Nombre = 'SOESTRUC'
select @Fol_Numero = 0

execute @Status = GCFOLIOSACT
		@Fol_Tabla = @Tab_Nombre,
		@Fol_Numero = @Fol_Numero output

select @Est_Numero = convert(char(8), @Fol_Numero)

exec UTCERIZQ
	@Valor = @Est_Numero output,
	@Longitud = 8

/*select @Est_Nivel = (@Est_Nivel * 10) + 1 */
select @Est_Nivel 	= @Est_Nivel + 1 
select @Est_Serial 	= rtrim(@Est_Serial) + @Est_Numero

insert into SOESTRUC values (
		@Est_Numero,	@Est_Puesto,	@Est_Nombre, 	@Est_Nivel, 	
		@Est_Depend, 	@Est_Usuari,	@Est_Raiz,		@Est_Serial,
		@NumTransac, 	@Transaccio,	@Usuario, 		@FechaSis,
		@SucOrigen, 	@SucDestino)


select 	Err_Codigo = '000000',
		Err_Mensaj = 'Registro modificado',
		Est_Numero = @Est_Numero

