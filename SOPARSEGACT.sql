create procedure SOPARSEGACT (
	@Pas_HoInAC	int,
	@Pas_HoFiAC	int,
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*****************Actualización de Parámetros de Seguridad************************/

/*
****************************************************************************
** Creó:			Manuel Martínez Muñoz 						****
** Fecha:		16/Mayo/2012								****
** Help:		      462064										****
****************************************************************************
*/

/* Declaración de Constantes */
declare	@Par_HoVaIn int,
		@Par_HoVaFi	int

/* Asignación de Constantes */
select	@Par_HoVaIn = 0,
		@Par_HoVaFi = 235959
		
if 	@Pas_HoInAC < @Par_HoVaIn begin
	select	Err_Codigo	= '000001', 
			Err_Mensaj	= 'Parametro de Inicio AC no debe ser menor a 0', 
			Err_Variab	= 'Pas_HoInAC'
	rollback
	return 1
end

if 	@Pas_HoFiAC > @Par_HoVaFi begin
	select	Err_Codigo	= '000002', 
			Err_Mensaj	= 'Parametro de Fin AC no debe ser mayor a 235959', 
			Err_Variab	= 'Pas_HoFiAC'
	rollback
	return 1
end

update	SOPARSEG set
	Pas_HoInAC	= @Pas_HoInAC,
	Pas_HoFiAC	= @Pas_HoFiAC
	
select	Err_Codigo	= '000000', 
		Err_Mensaj	= 'Registro Modificado'
