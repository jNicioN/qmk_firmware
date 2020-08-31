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

/*	Declaracion de Variables	*/
declare @Cla_Numero int,
		@Pro_Numero int

/*	Declaracion de Constantes	*/
declare	@Ent_Uno	int,
		@Ent_Cero int

/* Asignacion de Constantes */
select	@Ent_Uno	= 1,			/* Entero Uno*/
		@Ent_Cero	= 0			/* Entero Cero*/

select @FechaSis = getdate()

select @Cla_Numero =  Cla_Numero 
	from SOCLASIF	noholdlock
	where  Cla_Numero  	= @Clp_Clasif 
	
select	@Pro_Numero =  Pro_Numero 
	from SOPRODUC	noholdlock
	where  Pro_Numero  = @Clp_Produc

if isnull(@Cla_Numero,@Ent_Cero) = @Ent_Cero begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'La clasificacion no existe',
			Err_Variab	= 'Clp_Clasif'
	rollback
	return @Ent_Uno
end
	
if  isnull(@Pro_Numero,@Ent_Cero) = @Ent_Cero begin
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

