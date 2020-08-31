create procedure SOCLASIFBAJ (
	@Cla_Numero int,
	
	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino char(3),
	@Modulo char(2))

as

/***************************************************************************/
/* DESCRIPCION:   Baja de clasificacion de compania			 	       */
/** REFERENCIAS:
*****************************************************************************
** Creo:	Oscar Daniel Trevino Quintanilla							****
** Fecha:	07/08/2020													****
** Help:	01415639													****
****************************************************************************/

/*	Declaracion de Constantes	*/
declare @Str_Vacio	char(1),
		@Ent_Uno	int,
		@Str_Uno	char(1),
		@Sta_Activo char(1),
		@Sta_Inacti char(1)

/* Asignacion de Constantes */
select	@Str_Vacio	= '',			/* Tipo consulta*/
		@Ent_Uno	= 1,			/* Entero Uno*/
		@Str_Uno	= '1'	,		/* Caracter Uno*/
		@Sta_Activo  = 'A',			/* Estatus Activo */
		@Sta_Inacti = 'I'			/* Estatus Inactivo */

select @FechaSis = getdate()

update SOCLASIF
	set Cla_Status = @Sta_Inacti,
		NumTransac	=	@NumTransac,
		Transaccio	=	@Transaccio,
		Usuario	=	@Usuario,
		FechaSis	=	@FechaSis,
		SucOrigen	=	@SucOrigen,
		SucDestino	=	@SucDestino
		where Cla_Numero = @Cla_Numero
