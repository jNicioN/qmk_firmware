create procedure SORELACIALT (
	@Rel_Numero 	char(8),
	@Rel_Nombre 	char(80),
	
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

select @Tab_Nombre = 'SORELACI'
select @Fol_Numero = 0

execute @Status = GCFOLIOSACT
		@Fol_Tabla = @Tab_Nombre,
		@Fol_Numero = @Fol_Numero output

select @Rel_Numero = convert(char(8), @Fol_Numero)

exec UTCERIZQ
	@Valor = @Rel_Numero output,
	@Longitud = 8

insert into SORELACI values (
		@Rel_Numero,	@Rel_Nombre, 	@NumTransac, 	@Transaccio,	
		@Usuario, 		@FechaSis, 		@SucOrigen, 	@SucDestino)


select 	Err_Codigo = '000000',
		Err_Mensaj = 'Registro modificado'
