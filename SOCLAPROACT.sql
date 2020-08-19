create procedure SOCLAPROACT (
	@Clp_Numero int,
	@Clp_Clasif int,
	@Clp_Produc int,
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
/* DESCRIPCION:   Actualizacion de clasificacion de producto 	       */
/** REFERENCIAS:
*****************************************************************************
** Creo:	Oscar Daniel Trevino Quintanilla							****
** Fecha:	07/08/2020													****
** Help:	01415639													****
****************************************************************************/

/*	Declaracion de Constantes	*/
declare	@Ent_Uno	int,
	@Str_Uno	char(1)

/* Asignacion de Constantes */
select	@Ent_Uno	= 1,			/* Entero Uno*/
	@Str_Uno	= '1'			/* Caracter Uno*/

if @Tip_Actual = @Str_Uno begin 						/*	Actualiza clasificacion de producto */
	if not exists (	select	 Cla_Numero 
							from SOCLASIF	noholdlock
							where  Cla_Numero  	= @Clp_Clasif) begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'La clasificacion no existe',
				Err_Variab	= 'Clp_Clasif'
		rollback
		return @Ent_Uno
	end
		
	if not exists (	select	 Pro_Numero 
							from SOPRODUC	noholdlock
							where  Pro_Numero  = @Clp_Produc) begin
		select	Err_Codigo	= '000002',
				Err_Mensaj	= 'El producto no existe',
				Err_Variab	= 'Clp_Produc'
		rollback
		return @Ent_Uno
	end

	update SOCLAPRO set
		Clp_Clasif	=	@Clp_Clasif,
		NumTransac	=	@NumTransac,
		Transaccio	=	@Transaccio,
		Usuario	=	@Usuario,
		FechaSis	=	@FechaSis,
		SucOrigen	=	@SucOrigen,
		SucDestino	=	@SucDestino
	where Clp_Produc	=	@Clp_Produc
	
end