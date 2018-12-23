create procedure SOCIUDADCON (
	@Ciu_Numero	varchar(3),
	@Ciu_Nombre	varchar(50),
	@Ciu_Estado	varchar(2),
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
***	** Consulta alfabetica o numerica de Ciudades **
****************************************************************************
*/

/*
****************************************************************************
** Modificó:		Roberto Pascuale Morales Chavez			****
** Fecha:		29/Marzo/2012								****
** Help:			401531										****
** Descripción:	Agregar Clave de CNBV (Ciu_CoCNBV)		****
****************************************************************************
** Modificó:		Ricardo Salinas								****
** Fecha:		11/Jul/2007									****
** HD:			24673										****
** Descripción:	Se Agrego campo Est_Abrevi	a C2			**** 
****************************************************************************
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
** Modificó:		FCHIA          								****
** Fecha:		22/Jun/04									****
** Descripción:	C2											****
** Modificó:		Laura V. Vázquez Nieto						****
** Fecha:		16/Abril/2004								****
** Descripción:	Agregar la abreviación del estado a la consulta***
****************************************************************************
** Modificó:		Laura Elena Cervantes D						****
** Fecha:		13/Octubre/1999							****
** Descripción:	@Tip_Consul p/ Cons. Tipificadas de Visual.	****
****************************************************************************
** Modificó:		Yadira Salazar Guanajuato					****
** Fecha:		22/Octubre/98								****
** Descripción:	Agregar Ciu_Plaza							****
*****************************************************************************
*/

declare	@Tip_ConTip	char(1),		/* Declaración de variables */
		@Tip_ConCon	char(1)
		
declare	@Str_Vacio	char(1),		/* Declaración de constantes */
		@Str_Porcen	char(1)

/* Asignación de valores a las constantes */
select	@Str_Vacio	= '',			/* String Vacio */
		@Str_Porcen	= '%'			/* String de Porcentaje */

if @Tip_Consul = @Str_Vacio begin	/* Cliente:  FoxPro */

	if (@Ciu_Nombre = @Str_Vacio) and (@Ciu_Numero = @Str_Vacio) and (@Ciu_Estado <> @Str_Vacio)
		select	Ciu_Numero,	Ciu_Nombre,	Ciu_Estado,	Ciu_CobRem, Ciu_Plaza,
				Est_Numero,	Est_Nombre,	Est_Abrevi,	Ciu_ClaABM,	Ciu_CoCNBV
			from SOCIUDAD noholdlock,
				 SOESTADO noholdlock
			where	@Ciu_Estado	= Ciu_Estado
			  and	Ciu_Estado	= Est_Numero
			order by Ciu_Nombre
	else if (@Ciu_Nombre = @Str_Vacio) and (@Ciu_Numero <> @Str_Vacio) and (@Ciu_Estado <> @Str_Vacio)
		select	Ciu_Numero,	Ciu_Nombre,	Ciu_Estado,	Ciu_CobRem, Ciu_Plaza,
				Est_Numero,	Est_Nombre,	Est_Abrevi,	Ciu_ClaABM,	Ciu_CoCNBV
			from SOCIUDAD noholdlock,
				 SOESTADO noholdlock
			where	@Ciu_Numero	= Ciu_Numero
			  and	@Ciu_Estado	= Ciu_Estado
			  and	Ciu_Estado	= Est_Numero
	else if (@Ciu_Estado <> @Str_Vacio) and (@Ciu_Nombre <> @Str_Vacio)
		select	Ciu_Numero,	Ciu_Nombre,	Ciu_Estado,	Ciu_CobRem, Ciu_Plaza,
				Est_Numero,	Est_Nombre,	Est_Abrevi,	Ciu_ClaABM,	Ciu_CoCNBV
			from SOCIUDAD noholdlock,
				 SOESTADO noholdlock
			where	@Ciu_Estado	= Ciu_Estado 
			  and	Ciu_Nombre	like @Ciu_Nombre + @Str_Porcen
			  and	Ciu_Estado	= Est_Numero
			order by Ciu_Nombre
	else
		select	Ciu_Numero,	Ciu_Nombre,	Ciu_Estado,	Ciu_CobRem, Ciu_Plaza,
				Est_Numero,	Est_Nombre,	Est_Abrevi,	Ciu_ClaABM,	Ciu_CoCNBV
			from SOCIUDAD noholdlock,
				 SOESTADO noholdlock
			where	Ciu_Nombre like @Str_Porcen + @Ciu_Nombre + @Str_Porcen
			  and	Ciu_Estado = Est_Numero
			order by Ciu_Nombre
end else begin			/* Cliente:  Visual Basic */

	select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
			@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

	if @Tip_ConTip = 'C' begin		/* 'C':  Consulta */
		if @Tip_ConCon = '1' begin				/* Consulta de Llave Principal */
			select	Ciu_Numero,	Ciu_Nombre,	Ciu_Estado,	Ciu_CobRem, Ciu_Plaza
				from SOCIUDAD noholdlock
				where	Ciu_Numero  = @Ciu_Numero
		end else if @Tip_ConCon = '2' begin		/* Consulta de Llave Foranea */
			select	Ciu_Numero,	Ciu_Nombre, Est_Nombre,	Est_Abrevi
				from SOCIUDAD noholdlock,
					 SOESTADO noholdlock
				where	Ciu_Estado	= Est_Numero
				  and	Ciu_Numero  = @Ciu_Numero
				  and	Ciu_Estado  = @Ciu_Estado
		end
	end else begin					/* 'L':  Lista */
		select	@Ciu_Nombre	= ltrim(rtrim(@Ciu_Nombre)) + @Str_Porcen
		if @Tip_ConCon = '1' begin				/* Lista General */
			select	Ciu_Numero,	Ciu_Nombre, Ciu_Plaza
				from SOCIUDAD noholdlock
				where	upper(Ciu_Nombre) like upper(@Ciu_Nombre)
				  and 	Ciu_Estado  = @Ciu_Estado
				order by Ciu_Nombre
		end
	end
end
