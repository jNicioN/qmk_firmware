create procedure SOPUESTOALT (
@Pue_Numero 	char(8),
@Pue_Nombre 	char(80),
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

select @Tab_Nombre = 'SOPUESTO'
select @Fol_Numero = 0

execute @Status = GCFOLIOSACT
		@Fol_Tabla = @Tab_Nombre,
		@Fol_Numero = @Fol_Numero output

select @Pue_Numero	= convert(char(8), @Fol_Numero)

exec UTCERIZQ
	@Valor = @Pue_Numero output,
	@Longitud = 8

insert into SOPUESTO values (
	@Pue_Numero, 	@Pue_Nombre, 	@NumTransac,	@Transaccio,
	@Usuario, 		@FechaSis, 		@SucOrigen, 	@SucDestino)

select Err_Codigo = '000000',
Err_Mensaj = 'Registro modificado'
