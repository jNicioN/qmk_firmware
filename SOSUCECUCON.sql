create procedure SOSUCECUCON (
	@Suc_Inicio	char(3),
	@Suc_Final	char(3),
	@Tip_Consul	char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*****************************************************************************/
/* DESCRIPCION: Consulta de Sucursales de Estado de Cuenta Unico */
/*****************************************************************************/
/** REFERENCIAS: 
****************************************************************************
** Modificó:		Andrea Ramírez Mondragón					****
** Fecha:			06/Junio/2012								****
** Help:			00466682									****
** Descripción:		Omitir la suc 610 y 611 en la generación	****
****************************************************************************
** Modificó:		Andrea Ramírez								****
** Fecha:			10/Octubre/2011								****
** Help:			00414224									****
** Descripción:		Aumentar longitud del campos Suc_Path		****
****************************************************************************
** Creó:			Andrea Ramírez Mondragón					****
** Fecha:			09/Feb/2011									****
** Help:		       0361779									****
******************************************************************************/

declare	@Tip_ConTip	char(1),		/* Declaración de Variables */
		@Tip_ConCon	char(1)
		
declare	@Str_Vacio	char(1),			/* Declaración de Constantes */
		@Suc_CaVeAu char(3),
		@Suc_CaCoAu char(3)

/* Asignación de Constantes */
select	@Str_Vacio	= '',			/*	String Vacío 		*/
		@Suc_CaVeAu	= '610',		/*	Sucursal: CARTERA V AUTO 201105 */
		@Suc_CaCoAu	= '611'			/*	Sucursal: CARTERA C AUTO 201105 */

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = 'L' begin		/* 'L':  Lista */
	
	if @Tip_ConCon = '1' 		/* Todas las Sucursales */
		select	Suc_Numero,	Suc_Nombre,
				Suc_Path	= space(30),
				Suc_AniMes	= space(6),
				Suc_FecIni	= space(28),
				Suc_FecFin	= space(28)
			from SOSUCURS noholdlock
			where Suc_Numero not in (@Suc_CaVeAu, @Suc_CaCoAu)
			order by Suc_Numero
			
	else if @Tip_ConCon = '2' 		/* Lista por Rango */
				select	Suc_Numero,	Suc_Nombre,
						Suc_Path	= space(30),
						Suc_AniMes	= space(6),
						Suc_FecIni	= space(28),
						Suc_FecFin	= space(28)
					from SOSUCURS noholdlock
					where Suc_Numero >= @Suc_Inicio
					  and Suc_Numero <= @Suc_Final 
					  and Suc_Numero not in (@Suc_CaVeAu, @Suc_CaCoAu)
					order by Suc_Numero
end
