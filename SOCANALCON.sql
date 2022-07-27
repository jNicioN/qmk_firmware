create procedure SOCANALCON (
	@Can_Numero	int,
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*****************************************************************************/
/* DESCRIPCION: ** Consulta de Canal ** */
/*****************************************************************************/
/** REFERENCIAS:
****************************************************************************
** Modifico:	Erick Eduardo Vielma Martinez							****
** Fecha:		25 de Julio del 2022									****
** Help:		        												****
** Descripcion:	Se crea sp para la consulta de canales             		****
****************************************************************************/

declare @Tip_ConTip char(1),				/* Declaración de Variables */
		@Tip_ConCon char(1)

declare	@Tra_Consul	char(1),				/* Declaración de Constantes */
		@Tra_Lista	char(1),
		@Str_Uno    char(1)

/* Asignación de Constantes */
select	@Tra_Consul	= 'C',					/* Transacción Tipo Consulta */
		@Tra_Lista	= 'L',					/* Transacción Tipo Lista */
		@Str_Uno    = '1'

select 	@Tip_ConTip = substring(@Tip_Consul,1,1),
		@Tip_ConCon = substring(@Tip_Consul,2,1)

if @Tip_ConTip = @Tra_Consul begin
	if @Tip_ConCon = @Str_Uno begin				/* Consulta de llave Principal */

		select	Can_Numero,	Can_Nombre,	Can_Abrevi,	Can_Origen,	Can_Tipo
			from SOCANAL noholdlock
			where	Can_Numero	= @Can_Numero
	end
end else if @Tip_ConTip = @Tra_Lista begin
	if @Tip_ConCon = @Str_Uno begin
		select	Can_Numero,	Can_Nombre,	Can_Abrevi,	Can_Origen,	Can_Tipo
			from SOCANAL noholdlock
			order by Can_Numero
	end
end