create procedure SOESTADOCON (
	@Est_Numero	char(2),
	@Est_Nombre	varchar(50),
	@Tip_Consul char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*
****************************************************************************
***	** Consulta alfabetica o numerica de estados **
****************************************************************************
*/

/*
****************************************************************************
** Modificó:		Roberto Pascuale Morales Chavez			****
** Fecha:		29/Marzo/2012								****
** Help:			401531										****
** Descripción:	Agregar Clave de CNBV (Est_CoCNBV) en		****
**				todas las consultas							****
****************************************************************************
** Modificó:		Roberto Pascuale Morales Chavez			****
** Fecha:		29/Marzo/2012								****
** Help:			453782										****
** Descripción:	Agregar Est_Abrevi y Est_Pais en todas las	****
**				consultas									****
****************************************************************************
** Creó:			Eleazar Alejandro Nevarez Leyva				****
** Fecha:		29/Oct/10									****
** Help:		      00306710									****
** Descripcion:	Se agregó la region							****
****************************************************************************
**					STORE CONVERTIDO					****
** Convirtió: 		Perla Judith Abundis Orozco				****
** Fecha:     12/May/06										****
****************************************************************************
** Modificó:		Gerardo Flores Martinez						****
** Fecha:		03/Mayo/2006								****
** HD:			125332										****
** Descripción:	agregar ClaABM								**** 
****************************************************************************
**                           Store CONVERTIDO 						****
****************************************************************************
** Modificó:		Laura Elena Cervantes D						****
** Fecha:		13/Octubre/1999							****
** Descripción:	@Tip_Consul p/ Cons. Tipificadas de Visual.	****
****************************************************************************
*/

declare	@Tip_ConTip	char(1),		/* Declaración de Variables */
		@Tip_ConCon	char(1)

declare	@Str_Vacio	char(1),		/* Declaración de Constantes */
		@Str_Porcen	char(1)

/* Asignación de Constantes */
select	@Str_Vacio	= '',			/* String Vacio */
		@Str_Porcen	= '%'			/* String Porcentaje */

if @Tip_Consul = @Str_Vacio begin	/* Cliente:  FoxPro */

	if (@Est_Nombre = @Str_Vacio) and (@Est_Numero = @Str_Vacio)
		select	Est_Numero,	Est_Nombre,	Est_Abrevi, Est_Pais,	Est_ClaABM,
				Est_Region,	Est_CoCNBV
			from SOESTADO noholdlock
			order by Est_Nombre
	else if (@Est_Nombre = @Str_Vacio)
		select	Est_Numero,	Est_Nombre,	Est_Abrevi, Est_Pais,	Est_ClaABM,
				Est_Region,	Est_CoCNBV
			from SOESTADO noholdlock
			where	Est_Numero	= @Est_Numero
	else
		select	Est_Numero,	Est_Nombre, Est_Abrevi, Est_Pais,	Est_ClaABM,
				Est_Region,	Est_CoCNBV
			from SOESTADO noholdlock
			where	Est_Nombre	like @Est_Nombre + @Str_Porcen
			order by Est_Nombre
end else begin						/* Cliente:  Visual Basic */

	select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
			@Tip_ConCon	= substring(@Tip_Consul, 2, 1)
	
	if @Tip_ConTip = 'C' begin			/* 'C':  Consulta */
		if @Tip_ConCon = '1' begin				/* Consulta de General */
			select	Est_Numero,	Est_Nombre, Est_Abrevi, Est_Pais,	Est_ClaABM,
					Est_Region,	Est_CoCNBV
				from SOESTADO noholdlock
				where	Est_Numero	= @Est_Numero
		end
	end else begin						/* 'L':  Lista */
		select	@Est_Nombre	= ltrim(rtrim(@Est_Nombre)) + @Str_Porcen
		if @Tip_ConCon = '1' begin				/* Lista General */
			select	Est_Numero,	Est_Nombre, Est_Abrevi, Est_Pais,	Est_ClaABM,
					Est_Region,	Est_CoCNBV
				from SOESTADO noholdlock
				where	upper(Est_Nombre)	like upper(@Est_Nombre)
				order by Est_Nombre
		end
	end
end
