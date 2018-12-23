create procedure SOBITACOALT (
	@Bit_UsuNum	char(6),
	@Bit_Host	char(15),
	@Bit_Pantal	char(8),
	@Bit_Server	char(15),
	@Bit_Accion	char(60),
	@Bit_Instru	varchar(4000),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/* Declaración de Variables */
declare @Bit_DirIp	char(15),
		@Bit_Fecha	datetime

/* Declaracion de Constantes */
declare @Str_Vacio	char(1)

/* Asignacion de Constantes */
select	@Str_Vacio	= ''	/* String Vacio */

select	@Bit_Fecha	= getDate()

select	@Bit_DirIp	= Usu_IPSesi
	from SOUSUARI noholdlock
	where	Usu_Numero	= @Bit_UsuNum

select	@Bit_UsuNum	= isnull(@Bit_UsuNum, @Str_Vacio)
select	@Bit_Fecha	= isnull(@Bit_Fecha, @Str_Vacio)
select	@Bit_DirIp	= isnull(@Bit_DirIp, @Str_Vacio)
select	@Bit_Host	= isnull(@Bit_Host,	@Str_Vacio)
select	@Bit_Pantal	= isnull(@Bit_Pantal, @Str_Vacio)
select	@Bit_Server	= isnull(@Bit_Server, @Str_Vacio)
select	@Bit_Accion	= isnull(@Bit_Accion, @Str_Vacio)
select	@Bit_Instru	= isnull(@Bit_Instru, @Str_Vacio)

insert into SOBITACO values	(
	@Bit_UsuNum,	@Bit_Fecha,		@Bit_DirIp,		@Bit_Host,		@Bit_Pantal,	
	@Bit_Server,	@Bit_Accion,	@Bit_Instru,	@NumTransac,	@Transaccio,	
	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino)
