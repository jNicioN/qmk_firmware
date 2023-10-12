create procedure SOADIUSUCON (
	@SoUsuariID	integer,
	@Usu_Nombre	varchar(50),
	@Usu_Clave	char(15),
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
/* DESCRIPCION: Consulta de usuarios por ID 																*/
/****************************************************************************/
/** REFERENCIAS:
****************************************************************************
** Creado por:		Raul Apolonio del angel karr													****
** Fecha:			10 de Octubre del 2023																		****
** Id Jira:			TCELIDC-707																							****
** Descripcion:		Se agrega consulta para busqueda por id en la tabla 	****
**								de usuarios																						****
***************************************************************************/

declare	@Tip_ConTip	char(1),		/* Declaracion de Variables */
		@Tip_ConCon	char(1)

declare	@Str_Vacio	char(1),		/* Declaracion de Constantes */
		@Tra_TipCon	char(1),
		@Str_Porcen	char(1),
		@Str_Uno	char(1)

/* Asignacion de Constantes */
select	@Str_Vacio	= '',			/* String vacio												*/
		@Tra_TipCon	= 'C',			/* Tipo : Consulta											*/
		@Str_Porcen	= '%',			/* String Porcentaje										*/
		@Str_Uno	= '1'			/* String para consulta 1									*/

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = @Tra_TipCon begin					/* 'C':  Consulta */
	if @Tip_ConCon = @Str_Uno begin					/* Consulta de Llave Principal */
		select
			Usu.Usu_ImEsCu,	Usu.Usu_CoEsCu,	Usu.Usu_Status,	Usu.Usu_EMail,	Usu.Usu_Sucurs,
			Usu.SoUsuariID, Usu.Usu_Numero,	Usu.Usu_Nombre,	Usu.Usu_Clave,	Usu.Usu_Autori,	Usu.Usu_Nivel,
			Usu.Usu_PassWo,	Usu.Usu_FeAcPa,	Usu.SaPerfilID,	Usu.Usu_Activo,
			Usu.Usu_IPSesi,	Usu.Usu_Depart
		from
			SOUSUARI Usu noholdlock
		where
			Usu.SoUsuariID	= @SoUsuariID
	end
end else begin					/* 'L':  Lista */
	select @Usu_Nombre = ltrim(rtrim(@Usu_Nombre)) + @Str_Porcen
	if @Tip_ConCon = @Str_Uno begin				/* Lista General */
		select
			Usu_Numero,	Usu_Nombre,	Usu_Clave,	Usu_EMail
		from
			SOUSUARI noholdlock
		where
			Usu_Nombre
		like
			@Usu_Nombre
		order by
			Usu_Nombre
	end
end
