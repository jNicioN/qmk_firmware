create procedure SOPERUSUCON (
	@Peu_Usuari	char(6),
	@Peu_Nombre	char(50),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/* Declaración de variables */
declare	@Tip_ConTip	char(1),	
		@Tip_ConCon	char(1)

/* Declaración de constantes */
declare	@Str_Vacio	char(1),
		@Tra_Consul	char(1),
		@Tra_Listad	char(1),
		@Str_Uno	char(1),
		@Str_Porcen	char(1),
		@Num_Uno	int,
		@Num_Dos	int
		
/* Asignación de constantes */
select	@Str_Vacio	= '',	/* String Vacio */
		@Tra_Consul	= 'C',	/* Transacción Tipo Consulta */
		@Tra_Listad	= 'L',	/* Transacción Tipo Listado */
		@Str_Uno	= '1',	/* String uno */
		@Str_Porcen = '%',	/* String de Porcentaje */
		@Num_Uno	= 1,	/* Numero uno */
		@Num_Dos	= 2		/* Numero dos */
		
select	@Tip_ConTip	= substring(@Tip_Consul, @Num_Uno, @Num_Uno),
		@Tip_ConCon	= substring(@Tip_Consul, @Num_Dos, @Num_Uno)

if @Tip_ConTip = @Tra_Consul begin			/* Consulta */

	if @Tip_ConCon = @Str_Uno begin
		select	Peu_Usuari,	Usu_Nombre,	Peu_Status
			from SOPERUSU noholdlock,
				 SOUSUARI noholdlock
			where	Peu_Usuari	= Usu_Numero	 
			  and	Peu_Usuari	= @Peu_Usuari
	end
end else begin
		if	@Tip_ConTip = @Tra_Listad begin	/* Listado */

		select	@Peu_Nombre	= ltrim(rtrim(@Peu_Nombre)) + @Str_Porcen

			if @Tip_ConCon = @Str_Uno begin
				select	Peu_Usuari,	Usu_Nombre,	Peu_Status
					from SOPERUSU noholdlock,
						 SOUSUARI noholdlock
					where	Peu_Usuari	= Usu_Numero
					  and	Usu_Nombre	like @Peu_Nombre
			end
		end
end
