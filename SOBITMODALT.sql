create procedure SOBITMODALT (
	@Bit_Numero char(8),
	@Bit_Tipo	char(1),
	@Bit_Usuari char(6),
	@Bit_Fecha 	char(10),
	@Bit_Hora 	char(8),
	@Bit_Archiv	char(80),
	@Bit_Nombre char(20),
	@Bit_Refere char(20),
	@Bit_Coment char(400),
	@Bit_RegIni int,
	@Bit_RegCar int,
	@Bit_RegFin int,
	
	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario 	char(6),
	@FechaSis 	datetime,
	@SucOrigen 	char(3),
	@SucDestino char(3),
	@Modulo 	char(2))
as

/***************************************************************************
 DESCRIPCION: ** Consultas de Bitacoras de Instalaciones                 ***
****************************************************************************
 REFERENCIAS: 
****************************************************************************
** Modificó:	Adriana Maldonado Rangel								****
** Fecha:		10/07/2017											    ****
** Help Desk:	991452													****
** Descripción:	Se Amplio Bit_Coment a 400 caracteres					****
****************************************************************************/
declare @Status int, /* Declaracion de Variables */
	@Tab_Nombre char(8),
	@Fol_Numero int

select @Tab_Nombre = 'SOBITMOD'
select @Fol_Numero = 0

execute @Status = GCFOLIOSACT
	@Fol_Tabla = @Tab_Nombre,
	@Fol_Numero = @Fol_Numero output

select @Bit_Numero	= convert(char(8), @Fol_Numero)

exec UTCERIZQ
	@Valor = @Bit_Numero output,
	@Longitud = 8

insert into SOBITMOD values (
	@Bit_Numero, @Bit_Tipo,		@Bit_Usuari, 	@Bit_Fecha, 	
	@Bit_Hora,	 @Bit_Archiv, 	@Bit_Nombre, 	@Bit_Refere,	
	@Bit_Coment, @Bit_RegIni, 	@Bit_RegCar, 	@Bit_RegFin,	
	@NumTransac, @Transaccio, 	@Usuario, 		@FechaSis, 		
	@SucOrigen , @SucDestino)
	
select 	Err_Codigo = '000000',
		Err_Mensaj = 'Registro modificado'
