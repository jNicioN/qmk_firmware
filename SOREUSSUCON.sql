create procedure SOREUSSUCON (
	@Usu_Numero	char(6),
	@Usu_SucOpe	char(3),
	@Usu_SucDes	char(3),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*******************************************************************************/
/* DESCRIPCION:	Consulta Relacion entre Usuario y sucursal  de Origen y Destino*/
/*******************************************************************************/

/* REFERENCIAS:
***************************************************************************
** Creó:		Miguel A. Hernandez M.									****
** Fecha:		20/Febrero/2013											****
** Help:		444440													****
***************************************************************************/

/* Declaracion de Variables */

declare	@Tip_ConTip	char(1),		/* Declaración de Variables */
		@Tip_ConCon	char(1)

		
select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)
		
if @Tip_ConTip = 'C' begin					/* 'C':  Consulta */

	if @Tip_ConCon = '1' begin					/* Consulta por Llave Principal */
		SELECT count(*) existe, 
			(case when count(*) = 0 then 'No existe relacion' else 'Si esta dado de alta' end) mensaje
		FROM SOREUSSU relacion 
		WHERE
			relacion.Usu_Numero	= @Usu_Numero and
			relacion.Usu_SucOpe = @Usu_SucOpe and 
			relacion.Usu_SucDes = @Usu_SucDes
	end else if @Tip_ConCon = '2' begin	
		SELECT count(*) existe, 
			(case when count(*) = 0 then 'No hay Boveda Relacionada' else 'Si esta dado de alta' end) mensaje
		FROM SOREUSSU relacion 
		WHERE
			relacion.Usu_Numero	= @Usu_Numero and
			relacion.Usu_SucOpe = @Usu_SucOpe 
	end
end else if @Tip_ConTip = 'L' begin					/* 'L':  Lista */

	if @Tip_ConCon = '1' begin					/* Lista por Llave Principal */
		
		SELECT
			relacion.Usu_Numero numUsuario, relacion.Usu_SucOpe bovedaOpera, 
			(select Suc_Nombre from SOSUCURS noholdlock where Suc_Numero = relacion.Usu_SucOpe ) bovedaOperaNombre,
			relacion.Usu_SucDes sucursalDestino, 
			(select Suc_Nombre from SOSUCURS noholdlock where Suc_Numero = relacion.Usu_SucDes ) sucursalDestinoNombre
		FROM SOREUSSU relacion 
		WHERE
			relacion.Usu_Numero	= @Usu_Numero
		ORDER BY
			relacion.Usu_SucOpe, relacion.Usu_SucDes
	end 
end
