create procedure SOREGIONBAJ (
    @Reg_Numero	int,
	@Reg_Descri	varchar(35),
	@Reg_SegNum	int,
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/****************************************************************************/
/* DESCRIPCION: Bajas de Regiones									        */
/****************************************************************************/
/* REFERENCIAS: 															*/
/*****************************************************************************
**Creo  :    	  Erick Gloria                                   	      ****
**Fecha:          26/03/2018                                              ****
**				      										    		  ****
**Help Desk:      1093350                                                 ****
******************************************************************************/
/* Baja de los datos de la pantalla */
declare @Int_Si 	int,
		@Int_No		int,
		@Str_Estatu	char(1)

declare @Int_Valida int

select	@Int_Si = 1,   /*Constante Si*/
		@Int_No = 0,   /*Constante No*/
		@Str_Estatu = 'C'  /*Valor Estatus*/
		
select @Int_Valida = @Int_No
select @Int_Valida = @Int_Si
	from SOREGION noholdlock
	where Reg_Numero = @Reg_Numero
	
if @Int_Valida = @Int_No begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'La region no existe',
			Err_Variab	= @Reg_Numero
	rollback
	return 1
end

UPDATE SOREGION SET 
	Reg_Status = @Str_Estatu
	where Reg_Numero = @Reg_Numero

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Zona Eliminada'
