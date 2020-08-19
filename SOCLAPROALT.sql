create procedure SOCLAPROALT (
	@Clp_Clasif int,
	@Clp_Produc int,

	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino char(3),
	@Modulo char(2))

as

/***************************************************************************/
/* DESCRIPCION:   Alta de  clasificacion de producto				       */
/** REFERENCIAS:
*****************************************************************************
** Creo:	Oscar Daniel Trevino Quintanilla							****
** Fecha:	07/08/2020													****
** Help:	01415639													****
****************************************************************************/

/*	Declaracion de Constantes	*/
declare	@Ent_Uno	int

/* Asignacion de Constantes */
select	@Ent_Uno	= 1			/* Entero Uno*/


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


insert into SOCLAPRO (
		Clp_Clasif, 	Clp_Produc, 	NumTransac, 	Transaccio, 	Usuario, 
		FechaSis, 	SucOrigen, 	SucDestino)
	values (
		@Clp_Clasif, 	@Clp_Produc, 	@NumTransac, 	@Transaccio, 	@Usuario, 
		@FechaSis, 	@SucOrigen, 	@SucDestino)

