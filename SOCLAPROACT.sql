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

/*	Declaracion de Variables	*/
declare @Cla_Numero int,
		@Pro_Numero int

/*	Declaracion de Constantes	*/
declare	@Ent_Uno	int,
		@Ent_Cero int,
		@Str_Uno	char(1)

/* Asignacion de Constantes */
select	@Ent_Uno	= 1,			/* Entero Uno*/
		@Ent_Cero = 0, 			/* Entero Cero*/
		@Str_Uno	= '1'			/* Caracter Uno*/

select @FechaSis = getdate()

if @Tip_Actual = @Str_Uno begin 						/*	Actualiza clasificacion de producto */

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

	update SOCLAPRO 
		set Clp_Clasif	=	@Clp_Clasif,
			NumTransac	=	@NumTransac,
			Transaccio	=	@Transaccio,
			Usuario	=	@Usuario,
			FechaSis	=	@FechaSis,
			SucOrigen	=	@SucOrigen,
			SucDestino	=	@SucDestino
			where Clp_Produc	=	@Clp_Produc
	
end