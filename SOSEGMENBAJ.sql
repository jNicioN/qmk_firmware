create procedure SOSEGMENBAJ (
    @Seg_Numero	int,
	@Seg_Nombre	varchar(35),
	@Seg_Status	char(1),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/****************************************************************************/
/* DESCRIPCION: Bajas de Segmentos											*/
/****************************************************************************/
/* REFERENCIAS: 															*/
/*****************************************************************************
**Creo  :    	  Erick Gloria                                   	  	  ****
**Fecha:          26/03/2018                                              ****
**				      										    		  ****
** Help Desk: 1093350 											          ****
******************************************************************************/
/* Baja de los datos de la pantalla */
declare @Ent_Si 	int,
		@Ent_No	int,
		@Str_Estatus	char(1)

declare @Ent_Valida int

select	@Ent_Si = 1,   /*Constante Si*/
		@Ent_No = 0,   /*Constante No*/
		@Str_Estatus = '0'  /*Valor Estatus*/
		
select @Ent_Valida = @Ent_No
select @Ent_Valida = @Ent_Si
	from SOSEGMEN noholdlock
	where Seg_Numero = @Seg_Numero
	
if @Ent_Valida = @Ent_No begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'No existe el Segmento',
			Err_Variab	= 'Seg_Numero'
	rollback
	return 1
end

UPDATE SOSEGMEN SET Seg_Status = @Str_Estatus
	where Seg_Numero = @Seg_Numero

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Segmento Eliminado'
