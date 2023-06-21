create procedure SOGENPERCON(
	@Gep_Numero	int,
	@Tip_Consul	char(2),
	
	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario    char(6),
	@FechaSis   smalldatetime,
	@SucOrigen  char(3),
	@SucDestino char(3),
	@Modulo 	char(2))
as
/*************************************************************
** DESCRIPCION: 	Consulta Generos de Personas			**
**************************************************************
** REFERENCIAS: 											**
**************************************************************
** Creo:			Raul Muniz								**
** Fecha:			21/06/2023								**
** C.Cambios:		29013									**
** Descripcion:		Se crea SP de consulta					**
*************************************************************/

/*Declaracion de constantes*/
declare @Tip_ConC		char(1),			/* Tipo de consulta C */
		@Tip_ConL	 	char(1),			/*	Tipo de consulta L	*/
		@Str_Uno		char(1),			/* Cadena uno */
		@Str_Dos		char(1),			/* Cadena dos */
		@Est_Activo		int					/* Estatus Activo */
		
/*Declaracion de variables*/
declare @Tip_ConTip	char(1),				/* Tipo de consulta */
		@Tip_ConCon	char(1)					/* Numero de consulta  */

/*Asignacion de constantes*/
select  @Tip_ConC		= 'C',
		@Tip_ConL		= 'L',
		@Str_Uno		= '1',
		@Str_Dos		= '2',
		@Est_Activo		= 1
		
/* Asignacion de valores a variables */
select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = @Tip_ConC begin
	if (@Tip_ConCon = @Str_Uno) begin		/* Consulta por numero */
		select	Gep_Numero,	Gep_Descri,	Gep_Activo,	NumTransac,	Transaccio,
				Usuario, 	FechaSis, 	SucOrigen,	SucDestino
			from	SOGENPER noholdlock
			where	Gep_Numero	= @Gep_Numero
	end
end
else if @Tip_ConTip	= @Tip_ConL begin		/* Consulta de todos los tipos de programas */
	if (@Tip_ConCon = @Str_Uno) begin
		select	Gep_Numero,	Gep_Descri,	Gep_Activo,	NumTransac,	Transaccio,
				Usuario, 	FechaSis, 	SucOrigen,	SucDestino
			from	SOGENPER noholdlock
	end
	else if (@Tip_ConCon = @Str_Dos) begin	/* Consulta de todos los tipos de programas activos */
		select	Gep_Numero,	Gep_Descri,	Gep_Activo,	NumTransac,	Transaccio,
				Usuario, 	FechaSis, 	SucOrigen,	SucDestino
			from	SOGENPER noholdlock
			where	Gep_Activo	= @Est_Activo
	end
end