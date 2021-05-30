create procedure SOPARAMSMOD (
	@Par_Sucurs	char(3),  		
	@Par_CheCaj	int,           
	@Par_IVA	float, 
	@Par_ISR	float,  		
	@Par_DiBaIn	int,          
	@Par_DiBISR	int,          
	@Par_DiBaCr	int, 
 	@Par_DiBaCh	int,      		
 	@Par_ChLey1	varchar(80),   
 	@Par_ChLey2	varchar(80),
 	@Par_ChLey3	varchar(80),  	
 	@Par_CheCer	char(2),	   
 	@Par_DiaRem	smallint,
 	@Par_LimAut	float,    		
 	@Par_TranBR	char(11),      
 	@Par_CliInd	int,	 
 	@Par_BanFol	int,      		
 	@Par_FecAct	smalldatetime, 
 	@Par_CoCoIn	float,
 	@Par_CoReme	float, 	
 	@Par_OpeBan	int,	       
 	@Par_ConPap	int,
 	@Par_MonCom	char(2),   	
 	@Par_LinSob	char(20),       
 	@Par_EnvSPE	int,
 	@Par_Banco	char(3),   		
 	@Par_ComRem	char(12),      
 	@Par_IvaRem	char(12),
 	@Par_RemExt	char(12), 		
 	@Par_IVAREX	char(12),	   
 	@Par_GiBaEx	char(12),
 	@Par_GiBaNa	char(12), 		
 	@Par_IVAGBN char(12),      
 	@Par_IVAGBE	char(12),
 	@Par_ComSPE	char(12), 		
 	@Par_IVASPE	char(12),      
 	@Par_NumTes	char(3),
 	@Par_IncISR	char(12), 		
 	@Par_InsISR	char(12),	   
 	@Par_SPEUA 	char(12),
 	@Par_SIAC	char(12),		
 	@Par_CobInm	char(12),	   
 	@Par_FecRem	smalldatetime,
 	@Par_IntBan	char(15),
 	
 	@NumTransac	char(10), 		
 	@Transaccio	char(3), 	   
 	@Usuario	char(6), 
 	@FechaSis	smalldatetime, 	
 	@SucOrigen	char(3), 	   
 	@SucDestino	char(3),
 	@Modulo		char(2))

as


/***************************************************************************
** DESCRIPCION: ** Modificacion de Parametros  de Soporte 				****
****************************************************************************
** Modificó:	Fatima Sanchez 										 	****
** Fecha:		28/May/2021											    ****
** Help: 		1471507												    ****
** Descripcion:	Se agrega convert a tipo money a los parametros de		****
**				entrada @Par_LimAut y a smallmoney @Par_IVA, @Par_ISR, 	****
**				@Par_CoCoIn, @Par_CoReme que fueron cambiados a float	****
****************************************************************************
** REFERENCIAS: 														****
** Modificó:	Moises Ake Uc											****
** Fecha:		07/05/2021												****
** Help:		1471507													****
** Descripción: Se cambia tipo de dato smallmoney a float  del 			****
**				parametro de  entrada @Par_IVA,@Par_ISR,@Par_CoCoIn,	****
**				@Par_CoReme y como money a @Par_LimAut					****
****************************************************************************
** Modificó:		Ricardo Rivas 						****
** Fecha:		15/Julio/2019								****
** Help Desk:	00726428									****
** Descripcion: Se agrega campo Par_DiBISR para actualizar tabla	 	****
**Descripcion: 	y se estandariza sp															****
****************************************************************************
** Modificó:		Gabriela Alonso   							****
** Fecha:		04/Oct/05									****
** Descripción:	Modifique para que al modificar se actualice   ****
**				el iva tambien en la sucursal					****
****************************************************************************
** Modificó:		Sandra Almaguer   							****
** Fecha:		26/Sep/00									****
** Descripción:	Agregue Cue_Compan cuando se selecciona	****
**				info de COCUENTA							****
******************************************************************************
** Modificó:		Ruth Alemán	  							****
** Fecha:		28/Julio/98									****
** Descripción:	Campo Par_LinSob char(20), antes char(5)	****
****************************************************************************
** Modificó:		Ing. Laura Elena Cervantes D. 				****
** Fecha:		01/Jul/98									****
** Descripción:	Agregar Parámetros         					****
****************************************************************************/

/* Declaración de Variables */
declare	@Status	int

declare	@Cue_Compan	char(3),		/* Declaración de Constantes */
		@Tip_Actual	char(1),
		@Ent_Cero	int,
		@Ent_Anio int,
		@Ent_365 int,
		@Fec_Vacia	smalldatetime

/* Asignación de Constantes */
select	@Cue_Compan	= '001',		/* Compañia Contable BANREGIO */
		@Tip_Actual	= 'A',
		@Ent_Cero	= 0,				/* Entero en Cero			  */
		@Ent_Anio	= 360,				/* Anio */
		@Ent_365	= 365,				/* 365 Dias del anio */
		@Fec_Vacia	= '1990-01-01'		/* Fecha Vacia  */

select	@Par_IVA	= convert(smallmoney, @Par_IVA),
		@Par_ISR	= convert(smallmoney, @Par_ISR),	
		@Par_LimAut	= convert(money, @Par_LimAut),		
		@Par_CoCoIn	= convert(smallmoney, @Par_CoCoIn),
		@Par_CoReme	= convert(smallmoney, @Par_CoReme)	

if @Par_IVA <= @Ent_Cero begin
	select	Err_Codigo	= '000001', 
			Err_Mensaj	= 'IVA incorrecto', 
			Err_Variab	= 'Par_IVA'
	rollback 
	return 1
	
end else if @Par_ISR <= @Ent_Cero begin
	select	Err_Codigo	= '000002', 
			Err_Mensaj	= 'ISR incorrecto', 
			Err_Variab	= 'Par_ISR'
	rollback 
	return 1
	
end else if @Par_CheCaj < @Ent_Cero begin
	select	Err_Codigo	= '000003', 
			Err_Mensaj	= 'El num. de cheques de caja est  incorrecto', 
			Err_Variab	= 'Par_CheCaj'
	rollback 
	return 1
	
end else if @Par_DiBaIn < @Ent_Anio begin
	select	Err_Codigo	= '000004', 
			Err_Mensaj	= 'Número de días base de inversiones incorrecto', 
			Err_Variab	= 'Par_DiBaIn'
	rollback 
	return 1
	
end else if @Par_DiBaCr < @Ent_Anio  begin
	select	Err_Codigo	= '000005', 
			Err_Mensaj	= 'Número de días base de créditos incorrecto', 
			Err_Variab	= 'Par_DiBaCr'
	rollback 
	return 1
	
end else if @Par_DiBaCh < @Ent_Anio begin
	select	Err_Codigo	= '000006', 
			Err_Mensaj	= 'Número de días base de cheques incorrecto', 
			Err_Variab	= 'Par_DiBaCh'
	rollback 
	return 1
	
end else if convert(int, @Par_CheCer) < @Ent_Cero begin
	select	Err_Codigo	= '000007', 
			Err_Mensaj	= 'Número de Cheques certificados incorrecto', 
			Err_Variab	= 'Par_CheCer'
	rollback 
	return 1
	
end else if @Par_DiaRem < @Ent_Cero begin
	select	Err_Codigo	= '000008', 
			Err_Mensaj	= 'Número de días de remesa incorrecto', 
			Err_Variab	= 'Par_DiaRem'
	rollback 
	return 1
	
end else if @Par_LimAut < @Ent_Cero begin
	select	Err_Codigo	= '000009', 
			Err_Mensaj	= 'Cantidad de límite autorizado incorrecta', 
			Err_Variab	= 'Par_LimAut'
	rollback 
	return 1
	
end else if convert(float, @Par_TranBR) <= @Ent_Cero begin
	select	Err_Codigo	= '000010', 
			Err_Mensaj	= 'Tr nsito BanRegio está en ceros', 
			Err_Variab	= 'Par_TranBR'
	rollback 
	return 1
	
end else if @Par_CliInd < @Ent_Cero begin
	select	Err_Codigo	= '000011', 
			Err_Mensaj	= 'Número de cliente indeseables incorrecto', 
			Err_Variab	= 'Par_CliInd'
	rollback 
	return 1
	
end else if @Par_BanFol <= @Ent_Cero begin
	select	Err_Codigo	= '000011', 
			Err_Mensaj	= 'El folio está incorrecto', 
			Err_Variab	= 'Par_BanFol'
	rollback 
	return 1
	
end else if @Par_FecAct < @Fec_Vacia begin
	select	Err_Codigo	= '000012', 
			Err_Mensaj	= 'Fecha actual incorrecta', 
			Err_Variab	= 'Par_FecAct'
	rollback 
	return 1
	
end else if @Par_CoCoIn <= @Ent_Cero begin
	select	Err_Codigo	= '000013', 
			Err_Mensaj	= 'Cantidad para Devolución Cobro Inmediato incorrecta', 
			Err_Variab	= 'Par_CoCoIn'
	rollback 
	return 1
	
end else if @Par_CoReme < @Ent_Cero begin
	select	Err_Codigo	= '000014', 
			Err_Mensaj	= 'Cantidad de Remesa en falso incorrecta', 
			Err_Variab	= 'Par_CoReme'
	rollback 
	return 1
	
end else if @Par_OpeBan < @Ent_Cero begin
	select	Err_Codigo	= '000015', 
			Err_Mensaj	= 'Número de operaciones incorrecto', 
			Err_Variab	= 'Par_OpeBan'
	rollback 
	return 1
	
end else if @Par_ConPap < @Ent_Cero begin
	select	Err_Codigo	= '000016', 
			Err_Mensaj	= 'Número de papel de mesa de dinero incorrecto', 
			Err_Variab	= 'Par_ConPap'
	rollback 
	return 1
	
end else if convert(int, @Par_MonCom) <= @Ent_Cero begin
	select	Err_Codigo	= '000017', 
			Err_Mensaj	= 'Número de Moneda de comisiones incorrecto', 
			Err_Variab	= 'Par_MonCom'
	rollback 
	return 1
	
end else if convert(int, @Par_LinSob) < @Ent_Cero begin
	select	Err_Codigo	= '000018', 
			Err_Mensaj	= 'Número de línea de sobregiro est  incorrecto', 
			Err_Variab	= 'Par_LinSob'
	rollback 
	return 1
	
end else if @Par_EnvSPE < @Ent_Cero begin
	select	Err_Codigo	= '000019', 
			Err_Mensaj	= 'Número de folio de SPEUA incorrecto', 
			Err_Variab	= 'Par_EnvSPE'
	rollback 
	return 1
	
end else if convert(int, @Par_Banco) <= @Ent_Cero begin
	select	Err_Codigo	= '000020',	
			Err_Mensaj	= 'Número de Banco incorrecto', 
			Err_Variab	= 'Par_Banco'
	rollback 
	return 1
	
end else if convert(int, @Par_NumTes) = @Ent_Cero begin
	select	Err_Codigo	= '000021', 
			Err_Mensaj	= 'El NumTes está en ceros', 
			Err_Variab	= 'Par_NumTes'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_ComRem
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000022', 
			Err_Mensaj	= 'La cuenta para Com. Rem. no existe', 
			Err_Variab	= 'Par_ComRem'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_IvaRem
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000023', 
			Err_Mensaj	= 'La cuenta para Iva. Rem. no existe', 
			Err_Variab	= 'Par_IvaRem'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_RemExt
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000024', 
			Err_Mensaj	= 'La cuenta para Rem. Ext. no existe', 
			Err_Variab	= 'Par_RemExt'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_IVAREX
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000025', 
			Err_Mensaj	= 'La cuenta para IVA. REX. no existe', 
			Err_Variab	= 'Par_IVAREX'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_GiBaEx
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000026', 
			Err_Mensaj	= 'La cuenta para Gir. Ban. Ex. no existe', 
			Err_Variab	= 'Par_GiBaEx'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_GiBaNa
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000027', 
			Err_Mensaj	= 'La cuenta para Gir. Ban. Na. no existe', 
			Err_Variab	= 'Par_GiBaNa'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_IVAGBN
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000028', 
			Err_Mensaj	= 'La cuenta para IVA Gir.Ban Na. no existe', 
			Err_Variab	= 'Par_IVAGBN'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_IVAGBE
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000029', 
			Err_Mensaj	= 'La cuenta para IVA Gir. Be. no existe', 
			Err_Variab	= 'Par_IVAGBE'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_ComSPE
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000030', 
			Err_Mensaj	= 'La cuenta para Comisión SPEUA no existe', 
			Err_Variab	= 'Par_ComSPE'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_IVASPE
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000031', 
			Err_Mensaj	= 'La cuenta para IVA SPEUA no existe', 
			Err_Variab	= 'Par_IVASPE'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_IncISR
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000032', 
			Err_Mensaj	= 'La cuenta para Inc ISR no existe', 
			Err_Variab	= 'Par_IncISR'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_InsISR
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000033', 
			Err_Mensaj	= 'La cuenta para Ins ISR no existe', 
			Err_Variab	= 'Par_InsISR'
	rollback 
	return 1
	
end else if @Par_FecRem < @Fec_Vacia begin
	select	Err_Codigo	= '000037', 
			Err_Mensaj	= 'Fecha de Remesa incorrecta', 
			Err_Variab	= 'Par_FecRem'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_SPEUA
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000034', 
			Err_Mensaj	= 'La cuenta para Ins Trans. SPEUA no existe', 
			Err_Variab	= 'Par_SPEUA'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_SIAC
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000035', 
			Err_Mensaj	= 'La cuenta para Ins Trans. SIAC no existe', 
			Err_Variab	= 'Par_SIAC'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_CobInm
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000036', 
			Err_Mensaj	= 'La cuenta para Ins Trans. Cob. Inm. no existe', 
			Err_Variab	= 'Par_CobInm'
	rollback 
	return 1

end else if @Par_DiBISR < @Ent_365 begin
	select	Err_Codigo	= '000038', 
			Err_Mensaj	= 'Número de días base de ISR incorrecto', 
			Err_Variab	= 'Par_DiBISR'
	rollback 
	return 1	
	
end else begin
	update SOPARAMS set	
		Par_CheCaj	= @Par_CheCaj,
	 	Par_IVA		= @Par_IVA,			
	 	Par_ISR 	= @Par_ISR,
	 	Par_DiBaIn	= @Par_DiBaIn,    
	 	Par_DiBISR	= @Par_DiBISR,
	 	Par_DiBaCr	= @Par_DiBaCr,
	 	Par_DiBaCh	= @Par_DiBaCh,  	
	 	Par_ChLey1	= @Par_ChLey1,
	 	Par_ChLey2	= @Par_ChLey2, 	
	 	Par_ChLey3	= @Par_ChLey3,  
	 	Par_CheCer	= @Par_CheCer,	
	 	Par_DiaRem	= @Par_DiaRem,
	 	Par_LimAut	= @Par_LimAut,  	
	 	Par_TranBR	= @Par_TranBR,      
	 	Par_CliInd	= @Par_CliInd,	
	 	Par_BanFol	= @Par_BanFol,
	 	Par_FecAct	= @Par_FecAct, 	
	 	Par_CoCoIn	= @Par_CoCoIn,
	 	Par_CoReme	= @Par_CoReme,  	
	 	Par_OpeBan	= @Par_OpeBan,	 
	 	Par_ConPap	= @Par_ConPap,	
	 	Par_MonCom	= @Par_MonCom,  
	 	Par_LinSob	= @Par_LinSob,    
	 	Par_EnvSPE	= @Par_EnvSPE,
	 	Par_Banco	= @Par_Banco,   	
	 	Par_ComRem	= @Par_ComRem,
	 	Par_IvaRem	= @Par_IvaRem, 	
	 	Par_RemExt	= @Par_RemExt, 
	 	Par_IVAREX	= @Par_IVAREX,	
	 	Par_GiBaEx	= @Par_GiBaEx,
	 	Par_GiBaNa	= @Par_GiBaNa,   	
	 	Par_IVAGBN	= @Par_IVAGBN,
	 	Par_IVAGBE	= @Par_IVAGBE,	
	 	Par_ComSPE	= @Par_ComSPE,
	 	Par_IVASPE	= @Par_IVASPE,    
	 	Par_NumTes	= @Par_NumTes,
	 	Par_IncISR	= @Par_IncISR, 	
	 	Par_InsISR	= @Par_InsISR,
	 	Par_SPEUA	= @Par_SPEUA,		
	 	Par_SIAC	= @Par_SIAC,
	 	Par_CobInm	= @Par_CobInm,	
	 	Par_FecRem	= @Par_FecRem,
	 	Par_IntBan	= @Par_IntBan,
	 
	 	NumTransac	= @NumTransac, 	
	 	Transaccio	= @Transaccio,
	 	Usuario		= @Usuario,        	
	 	FechaSis	= @FechaSis, 
	 	SucOrigen	= @SucOrigen, 		
	 	SucDestino	= @SucDestino 
		where	Par_Sucurs	= @Par_Sucurs
		
		exec @Status = SOSUCURSACT
		@Par_Sucurs,	@Par_IVA,	@Tip_Actual,	@NumTransac,	@Transaccio,	@Usuario,	
		@FechaSis,		@SucOrigen,	@SucDestino,	@Modulo

		if @Status <> 0 begin
			rollback
			return 1
		end

	select	Err_Codigo	= '000000', 
			Err_Mensaj	= 'Registro Modificado'
end