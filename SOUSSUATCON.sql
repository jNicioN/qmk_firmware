create procedure SOUSSUATCON (
	@Usu_Sucurs	char(3),
	@Usu_Nombre	varchar(50),
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
/* DESCRIPCION: **Consulta Atomica de Usuarios por Sucursal Atiende Piso **	*/
/****************************************************************************/
/*****************************************************************************
** Creo:		Brandon Garcia 												**
** Help:		1352097														**
** Fecha:		18/Feb/20													**
*****************************************************************************/

/* Declaracion de Variables */
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1)

/* Declaracion de Constantes */
declare	@Str_Vacio	char(1),
		@Str_Porcen	char(1),
		@Ent_Dos	int,
		@Con_Lista	char(1),
		@Con_Consul	char(1),
		@Str_Uno	char(1),
		@Str_Dos	char(2)	

/* Asignacion de Constantes */
select	@Str_Vacio	= '',			/* String Vacio	*/
		@Str_Porcen	= '%',
		@Ent_Dos	= 2,
		@Con_Lista	= 'L',
		@Con_Consul	= 'C',
		@Str_Uno	= '1',
		@Str_Dos	= '2'

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)
		
select	@Usu_Nombre = ltrim(rtrim(@Usu_Nombre)) + @Str_Porcen

if @Tip_ConTip = @Con_Lista begin
	if @Tip_ConCon = @Str_Uno begin	/*CONSULTA DE USUARIO PERFIL 2 POR SUCURSAL ATIENDE*/
		select	Usu_Numero,	Usu_Nombre,	Usu_Clave,	Usu_EMail
		  from	SOUSUARI noholdlock
		 inner join CLPERPRO noholdlock on Usu_Perfil = Pep_Perfil
		 where	Usu_Nombre like @Usu_Nombre
		   and	Usu_Sucurs	= @Usu_Sucurs
		   and	Pep_TipPro	= @Ent_Dos
		   order by Usu_Nombre
		   
   end else begin					/*CONSULTA USUARIO PERFIL 2 CUALQUIER SUCURSAL*/
		select	Usu_Numero,	Usu_Nombre,	Usu_Clave,	Usu_EMail
		  from	SOUSUARI noholdlock
		 inner join CLPERPRO noholdlock on Usu_Perfil = Pep_Perfil
		 where	Usu_Nombre like @Usu_Nombre
		   and	Pep_TipPro	= @Ent_Dos
		   order by Usu_Nombre
		   
   end
end

