create procedure SOCANALCON (
	@Can_Numero	int,
	@Can_Nombre char(50),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2)
)
as
/*****************************************************************************/
/* DESCRIPCION: ** Consulta de Canal ** */
/*****************************************************************************/
/** REFERENCIAS:
****************************************************************************
** Modifico:	Julio Cesar Diaz Lopez	                 	    		****
** Fecha:		27 de Julio del 2022			  	 					****
** Descripcion:	Se hizo modificacion en L1 validación para buscar 		****
**				por nombre												****
** Help			1609249         										****
****************************************************************************
** Modifico:	Erick Eduardo Vielma Martinez							****
** Fecha:		25 de Julio del 2022									****
** Help:		15787      												****
** Descripcion:	Se crea sp para la consulta de canales             		****
****************************************************************************/

declare @Tip_ConTip char(1),				/* Declaración de Variables */
		@Tip_ConCon char(1)

declare	@Tra_Consul	char(1),				/* Declaración de Constantes */
		@Tra_Lista	char(1),
		@Str_Uno    char(1),
		@Ent_Uno	int,
		@Ent_Dos	int,
		@Str_Porcen	char(1),
		@Str_Vacio  char(1)

/* Asignación de Constantes */
select	@Tra_Consul	= 'C',					/* Transacción Tipo Consulta */
		@Tra_Lista	= 'L',					/* Transacción Tipo Lista */
		@Str_Uno    = '1',					/* String 1*/
		@Ent_Uno	= 1,					/* Entero Uno*/
		@Ent_Dos	= 2,					/* Entero Dos*/
		@Str_Porcen	= '%',					/* Cadena Porcentaje*/
		@Str_Vacio  = ''    				/*  String Vacio*/

select	@Tip_ConTip	= substring(@Tip_Consul, @Ent_Uno, @Ent_Uno),
		@Tip_ConCon	= substring(@Tip_Consul, @Ent_Dos, @Ent_Uno)

if @Tip_ConTip = @Tra_Consul begin
	if @Tip_ConCon = @Str_Uno begin				/* Consulta de llave Principal */

		select	Can_Numero,	Can_Nombre,	Can_Abrevi,	Can_Origen,	Can_Tipo
			from SOCANAL noholdlock
			where	Can_Numero	= @Can_Numero
	end
end else if @Tip_ConTip = @Tra_Lista begin 		/* Consulta por Lista */
	if @Tip_ConCon = @Str_Uno begin
		if isnull(@Can_Nombre,@Str_Vacio) = @Str_Vacio begin
			select	Can_Numero,	Can_Nombre,	Can_Abrevi,	Can_Origen,	Can_Tipo
				from SOCANAL noholdlock
				order by Can_Numero
		end else begin
			select Can_Numero, Can_Nombre, Can_Abrevi, Can_Origen, Can_Tipo
				from SOCANAL noholdlock
				where upper(Can_Nombre) like @Str_Porcen + upper(ltrim(rtrim(@Can_Nombre))) + @Str_Porcen
				order by Can_Numero
		end
	end
end