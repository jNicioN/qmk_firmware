create procedure SOPRTITAALT (
	@Ptt_Numero int out,
	@Ptt_TipTar char(4),
	@Ptt_Produc int,

	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino char(3),
	@Modulo char(2))

as

/***************************************************************************/
/* DESCRIPCION:   Alta de relacion de productos de TA y TC con    */
/*								 Productos Globales												*/
/** REFERENCIAS:
*****************************************************************************
** Creo:	Oscar Daniel Trevino Quintanilla							****
** Fecha:	07/08/2020													****
** Help:	01415639													****
****************************************************************************/

/*	Declaracion de Variables	*/
declare @TiT_Numero char(4),
		@Pro_Numero int

/*	Declaracion de Constantes	*/
declare @Ent_Uno	int,
		@Ent_Cero	int,
		@Str_Vacio char(1)

/* Asignacion de Constantes */
select	@Ent_Uno	= 1,			/* Entero Uno*/
		@Ent_Cero	= 0,			/* Entero Cero*/
		@Str_Vacio = ''			/* Cadena Vacia */

select @FechaSis = getdate()

select @TiT_Numero = TiT_Numero  
	from CTTIPTAR	noholdlock
	where   TiT_Numero   = @Ptt_TipTar

select @Ptt_Produc = Pro_Numero 
	from SOPRODUC	noholdlock
	where  Pro_Numero  = @Ptt_Produc
						
if isnull(@TiT_Numero,@Str_Vacio) = @Str_Vacio   begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'El tipo de tarjeta no existe',
			Err_Variab	= 'Ptt_TipTar'
	rollback
	return @Ent_Uno
end
	
if isnull(@Ptt_Produc,@Ent_Cero) = @Ent_Cero  begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'El producto no existe',
			Err_Variab	= 'Ptt_Produc'
	rollback
	return @Ent_Uno
end


insert into SOPRTITA (
		Ptt_TipTar, 	Ptt_Produc, 	NumTransac, 	Transaccio, 	Usuario, 
		FechaSis, 	SucOrigen, 	SucDestino)
	values (
		@Ptt_TipTar, 	@Ptt_Produc, 	@NumTransac, 	@Transaccio, 	@Usuario, 
		@FechaSis, 	@SucOrigen, 	@SucDestino)

select @Ptt_Numero = @@identity
