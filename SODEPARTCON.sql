create procedure SODEPARTCON (
	@Dep_Numero	char(3),
	@Dep_Nombre	varchar(40),
	@Tip_Consul char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare @Tip_ConTip char(1),				/* Declaracion de Variables */
		@Tip_ConCon char(1)

declare	@Sta_Activo	char(1),				/* Declaracion de Constantes */
		@Sta_Inacti	char(1),
		@Sta_ActDes	char(6),
		@Sta_InaDes	char(8),
		@Sta_SinDes	char(15),
		@Str_Porcen	char(1)

/* Asignacion de Constantes */
select	@Sta_Activo	= 'A',					/* Status de Activo */
		@Sta_Inacti	= 'I',					/* Status de Inactivo */
		@Sta_ActDes	= 'ACTIVO',				/* Descripcion del Status de Activo */
		@Sta_InaDes	= 'INACTIVO',			/* Descripcion del Status de Inactivo */
		@Sta_SinDes	= 'SIN DESCRIPCION',	/* Status sin descripcion */
		@Str_Porcen	= '%'					/* String de porcentaje */

select 	@Tip_ConTip = substring(@Tip_Consul,1,1),
		@Tip_ConCon = substring(@Tip_Consul,2,1)

if @Tip_ConTip = 'C' begin  	/* 'C' = Consulta */
	if @Tip_ConCon = '1' 					/* Consulta General */
		select	Dep_Numero,	Dep_Nombre,	Dep_Status,
				Dep_StaDes	= case	when Dep_Status = @Sta_Activo then @Sta_ActDes
									when Dep_Status = @Sta_Inacti then @Sta_InaDes
									else @Sta_SinDes end
			from SODEPART noholdlock
			where	Dep_Numero	= @Dep_Numero
end else begin					/* 'L' = Lista */
	if @Tip_ConCon = '1' 					/* Lista General */
		select	@Dep_Nombre	= ltrim(rtrim(@Dep_Nombre)) + @Str_Porcen

		select	Dep_Numero,	Dep_Nombre,	Dep_Status,
				Dep_StaDes	= case	when Dep_Status = @Sta_Activo then @Sta_ActDes
									when Dep_Status = @Sta_Inacti then @Sta_InaDes
									else @Sta_SinDes end
			from SODEPART noholdlock
			where	Dep_Nombre	like @Dep_Nombre
			order by Dep_Numero
end
