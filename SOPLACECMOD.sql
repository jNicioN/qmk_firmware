create procedure SOPLACECMOD (
	@Plc_Numero char(2),
	@Plc_Nombre varchar(35), 
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

/***************************************************************************/
/* DESCRIPCION: Modificacion de Plazas de Cecoban       				   */
/***************************************************************************/
/** REFERENCIAS: 
****************************************************************************
****************************************************************************
** Modificó:	Alfredo Olivas											****
** Fecha:		08/Mar/2017												****
** Descripción:	Se modifica parametro @Plc_Numero de char(3) a char(2)	****
** Help			00598646												****
****************************************************************************
** Modifico:		Sandra Almaguer										****
** Fecha:		01/Julio/2004											****
** Descripción: 	Cambiar Err_Mensaje por Err_Mensaj					****
****************************************************************************
** Modificó:		Raul Gonzalez										****
** Fecha:		13/Jun/2003												****
** Descripción:	Se le agrego un espacio a varios return1				****
****************************************************************************
** Modificó:		Ma de Lourdes Valdés								****
** Fecha:			5/Abr/2002											****
** Descripción:	Se modifico Plc_Numero, Plc_Nombre						**** 
****************************************************************************
** Creó:			JLOZANO        										****
** Fecha:		04/Ago/00												****
****************************************************************************/

declare	@Str_Vacio	char(1)			/* Declaración de Constantes */

/* Asignación de Constantes */
select	@Str_Vacio	= ''

if not exists (select	Plc_Numero
				from SOPLACEC noholdlock
				where	Plc_Numero	= @Plc_Numero) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'La plaza de Cecoban no existe',
			Err_Variab 	= 'Plc_Numero'
	rollback
	return 1
end 

if (@Plc_Nombre = @Str_Vacio) begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Nombre incorrecto',
			Err_Variab 	= 'Plc_Nombre'
	rollback
	return 1
end 

update SOPLACEC set
	Plc_Nombre	= @Plc_Nombre,

	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino
	where	Plc_Numero	= @Plc_Numero

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Modificado'
