create procedure SOFECPARACT (
	@Tip_Actual char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/***************************************************************************
**	DESCRIPCION:  Actualizar parametro y cambio de fecha de sucursal 	****
****************************************************************************
**	REFERENCIAS: 
****************************************************************************
** Creo:		José Rivera											    ****
** Fecha:		25/Agosto/2021    										****
** Help:		1527605  												****
****************************************************************************/	
/*Declaración de Variables*/
declare @Status		int

/*Declaración de Constantes*/
declare @Tip_Inacti char(1),
		@Tip_Progre char(1),
		@Tip_Termin char(1),
		@Fec_Vacia  smalldatetime,
		@Ent_Cero   int,
		@Fecha smalldatetime,
		@Suc_300	char(3),
		@Suc_001	char(3)

/*Asignación de Constantes*/		
select @Tip_Inacti = 'I',
	   @Tip_Progre = 'P',
	   @Tip_Termin = 'T',
	   @Fec_Vacia  = '19000101',
	   @Ent_Cero   = 0,
	   @Suc_300    = '300',
	   @Suc_001    = '001'
	   
select @Fecha = getdate()
	   
if @Tip_Actual = @Tip_Inacti begin 
	
	exec @Status =  CHPACIMEACT 
		@Tip_Inacti, 	@NumTransac, 	@Transaccio, 	@Usuario, 	@FechaSis, 
		@SucOrigen, 	@SucDestino, 	@Modulo
	if @Status <> @Ent_Cero begin 
		select	Err_Codigo	= '000001', 	
				Err_Mensaj	= 'Error al actualizar en parametro en CHPARAMS'
		rollback
	end
end

if @Tip_Actual = @Tip_Progre begin
	
	exec @Status =  ESAPESUCPRO 
		@Fecha, 		@NumTransac, 	@Transaccio, 	@Usuario, 	@FechaSis, 
		@Suc_300, 		@Suc_300, 		@Modulo
	if @Status <> @Ent_Cero begin 
		select	Err_Codigo	= '000004', 	
				Err_Mensaj	= 'Error al actualizar la fecha de la sucursal 300'
		rollback
	end
	
	exec @Status =  ESAPESUCPRO 
		@Fecha, 		@NumTransac, 	@Transaccio, 	@Usuario, 	@FechaSis, 
		@Suc_001, 		@Suc_001, 		@Modulo
	if @Status <> @Ent_Cero begin 
		select	Err_Codigo	= '000005', 	
				Err_Mensaj	= 'Error al actualizar la fecha de la sucursal 001'
		rollback
	end

	exec @Status =  CHPACIMEACT 
		@Tip_Progre, 	@NumTransac, 	@Transaccio, 	@Usuario, 	@FechaSis, 
		@SucOrigen, 	@SucDestino, 	@Modulo
	if @Status <> @Ent_Cero begin 
		select	Err_Codigo	= '000002', 	
				Err_Mensaj	= 'Error al actualizar en parametro en CHPARAMS'
		rollback
	end
	
end

if @Tip_Actual = @Tip_Termin begin
	
	exec @Status =  CHPACIMEACT 
		@Tip_Termin, 	@NumTransac, 	@Transaccio, 	@Usuario, 	@FechaSis, 
		@SucOrigen, 	@SucDestino, 	@Modulo
	if @Status <> @Ent_Cero begin 
		select	Err_Codigo	= '000003', 	
				Err_Mensaj	= 'Error al actualizar en parametro en CHPARAMS'
		rollback
	end
end