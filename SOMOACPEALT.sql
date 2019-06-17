create procedure SOMOACPEALT (
	@Map_FecAct	smalldatetime,
	@Map_FecIni	smalldatetime,
	@Map_FecFin	smalldatetime,
	@Map_TotAct int,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3))

as

/**************************************************************************/
/* DESCRIPCION:		Alta Monitoreo Actualización Personas  				***/
/**************************************************************************/
/* REFERENCIAS:															***/
/***************************************************************************
** Creó:			Ma. Dolores Hdz.     								****
** Fecha:			24/Mar/15											****
** Help:		    00751891											****
** Descrip:			Alta Monitoreo Actualización Personas 				****
***************************************************************************/


/* Declaración de Variables	*/
declare	@Map_Numero int
		
/* Declaración de Constantes*/
declare	@Ent_Uno	int,
		@Ent_Cero	int

/*Asignación de Constantes*/		
select	@Ent_Uno	= 1,
		@Ent_Cero	= 0

select	@Map_Numero	= max(Map_Numero) 
	from SOMOACPE noholdlock 

select 	@Map_Numero = isnull(@Map_Numero, @Ent_Cero) + @Ent_Uno

insert into SOMOACPE values(
	@Map_Numero,	@Map_FecAct,	@Map_FecIni,	@Map_FecFin,	@Map_TotAct,	
	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		
	@SucDestino
	)

select 	Err_Codigo	= '000000', 
		Err_Mensaj	= 'Registro Agregado'
