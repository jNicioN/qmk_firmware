create procedure SOUSUSUCCON (
	@Usl_Numero	int,
	@Usl_Usuari	char(6),
	@Usl_Sucurs	char(3),
	@Usl_Activo	char(1),
	@Usl_FecIna	smalldatetime,
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************/
/* DESCRIPCION:	Consulta de relación de usuarios con sucursales				*/
/****************************************************************************/
/* REFERENCIAS:																*/
/*****************************************************************************
** Creo:		Fernando Del Angel Sánchez								  ****
** Fecha:		28/Mayo/2013											  ****
** Descripción:	Store de Consulta de relación de usuarios con sucursales  ****
** Help Desk:	539205													  ****
******************************************************************************/

declare	@Tip_ConTip	char(1),		/* Declaración de variables */
		@Tip_ConCon	char(1)

/* Asignación de valores a variables */
select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip	= 'L' begin			/* 'C':  Consulta */
	/* Obtiene los datos de la relación usuarios con sucursales por id */
	if @Tip_ConCon	= '1' begin			/* Obtener por id */
		select	Usl_Numero,		Usl_Usuari,		Usl_Sucurs,		Usl_Activo,		Usl_FecIna,
				NumTransac,		Transaccio,		Usuario,		FechaSis,		SucOrigen,
				SucDestino
			from SOUSUSUC noholdlock
			where	Usl_Numero	= @Usl_Numero
	end else if @Tip_ConCon	= '2' begin		/*Obtiene todas los sucursales que tiene un usuario*/
		select	Usl_Numero,		Usl_Usuari,		Usl_Sucurs,		Usl_Activo,		Usl_FecIna,
				Suc_Nombre
			from SOUSUSUC noholdlock
			inner join	SOSUCURS noholdlock on (Suc_Numero	= Usl_Sucurs )
			where	Usl_Usuari	= @Usl_Usuari
			order by Suc_Nombre
	end
end
