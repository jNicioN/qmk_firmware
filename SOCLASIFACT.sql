create procedure SOCLASIFACT (
	@Cla_Numero int,
	@Cla_Descri varchar(50),
	@Cla_Compan char(2),
	@Cla_Status char(1),
	@Tip_Actual char(1),

	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino char(3),
	@Modulo char(2))

as

/***************************************************************************/
/* DESCRIPCION:   Actualizacion de clasificacion de compania 	     */
/** REFERENCIAS:
*****************************************************************************
** Creo:	Oscar Daniel Trevino Quintanilla							****
** Fecha:	07/08/2020													****
** Help:	01415639													****
****************************************************************************/

/*	Declaracion de Constantes	*/
declare	@Str_Vacio	char(1),
	@Ent_Uno	int,
	@Str_Uno	char(1)

/* Asignacion de Constantes */
select	@Str_Vacio	= '',			/* Tipo consulta*/
	@Ent_Uno	= 1,			/* Entero Uno*/
	@Str_Uno	= '1'			/* Caracter Uno*/


if @Tip_Actual = @Str_Uno begin 						/*	Actualiza descripcion por compania */

	
	if isnull(@Cla_Descri,@Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'La descripcion es incorrecta',
				Err_Variab	= 'Cla_Descri'
		rollback
		return @Ent_Uno
	end
	
	if not exists (	select	 Com_Numero 
							from SOCOMPAN	noholdlock
							where  Com_Numero  	= @Cla_Compan) begin
		select	Err_Codigo	= '000002',
				Err_Mensaj	= 'La compañia no existe',
				Err_Variab	= 'Cla_Compan'
		rollback
		return @Ent_Uno
	end
	
	update SOCLASIF set
		Cla_Descri	=	@Cla_Descri,
		
		NumTransac	=	@NumTransac,
		Transaccio	=	@Transaccio,
		Usuario	=	@Usuario,
		FechaSis	=	@FechaSis,
		SucOrigen	=	@SucOrigen,
		SucDestino	=	@SucDestino
	where Cla_Numero = @Cla_Compan
		
end