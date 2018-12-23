create procedure SOAPEDIAVAL (
	@Tip_Consul	char(3),
	@Fecha		smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Modificó:	Adriana Maldonado Rangel          						 ****		
** Fecha:		06/12/2012         									     ****
** Help:		493712                                 			         ****
** Descripción: Corrección validación de contabilidad es >= a 8          ****
****************************************************************************/
/*
****************************************************************************
** Creó:		Fernando Patiño BRM2966  								****		
** Fecha:		26/Sep/12												****
** Help:		493712                                 			        ****
** Descripción: Validacion de Apertura Diaria                           ****
**              Valida los siguientes procesos de apertura:				****
**              Inicio de Cámara,Bitacora de Inicio de Cámara,          ****
**              SPEI fuera de horario,Nominas pendientes,Validaciones de****
**              contabilidad,Liquidación final SPEI                     ****
*****************************************************************************/

declare			@Ent_count		int,
			@Tip_CABIPAFI	char(3),
			@Tip_ESBIINDI	char(3),
			@Tip_NBSPFUHO	char(3),
			@Tip_NomTot		char(3),
			@Tip_NomDes		char(3),
			@Tip_Prosa		char(3),
			@Tip_ProRep		char(3),
			@Tip_ComPRO		char(3),
			@Ent_10			int,
			@Str_Alta		char(1),
			@Str_D			char(1),
			@Str_R			char(1),
			@Str_N			char(1),
			@Str_06			char(2),
			@Str_61			char(2),
			@Str_CFP		char(3),
			@Tip_LiqFin		char(3),
			@Par_FecApe		smalldatetime,
			@Par_FeSiAp		smalldatetime,
			@Ent_Cero		int
			
			
select 			@Ent_count		= 0,
			@Tip_CABIPAFI	= 'PAF',
			@Tip_ESBIINDI	= 'ESB',
			@Tip_NBSPFUHO	= 'SFH',
			@Tip_NomTot		= 'NOT',
			@Tip_NomDes		= 'NOD',
			@Tip_Prosa		= 'PRO',
			@Tip_ProRep		= 'PRR',
			@Tip_ComPRO		= 'CFP',
			@Ent_10			= 10,
			@Str_Alta		= 'A',
			@Str_D			= 'D',
			@Str_R			= 'R',
			@Str_N			= 'N',
			@Str_06			= '06',
			@Str_61			= '61',
			@Str_CFP		= 'CFP',
			@Tip_LiqFin		= 'LFS',
			@Ent_Cero		= 0


if @Tip_Consul = @Tip_CABIPAFI begin

	select @Ent_count = count(*) 
		from	CABIPAFI noholdlock
		where	Bpf_Fecha >= @Fecha
	
	if	@Ent_count < @Ent_10	begin
		
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'La apertura no se ha realizado por completo, validar con CAMARA DE COMPENSACION ' ,
				Err_Variab	= 'CABIPAFI'
		
	end
	if	@Ent_count >= @Ent_10	begin
	
		select	Err_Codigo	= '000002',
				Err_Mensaj	= 'El Inicio de Camara fue Exitoso' ,
				Err_Variab	= 'CABIPAFI'

		
	end
	
end  

If @Tip_Consul = @Tip_ESBIINDI begin

	if exists(select	Bin_Transa
					from	ESBIINDI noholdlock	
					where	Bin_Fecha	>= @Fecha) begin
		
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'El proceso de Inicio de Camara presento errores en algun proceso' ,
				Err_Variab	= 'ESBIINDI'
				
	end else begin 
		select	Err_Codigo	= '000002',
				Err_Mensaj	= 'El proceso de Inicio de Camara fue correcto' ,
				Err_Variab	= 'ESBIINDI'
	end
end

If @Tip_Consul = @Tip_NBSPFUHO begin

	select @Ent_count =	count(*)
		from 	NBSPFUHO noholdlock
	where	Sfh_FecOpe	= @Fecha 
	  and	Sfh_Status	= @Str_Alta


	if @Ent_count > @Ent_Cero begin
					  
		
			select	Err_Codigo	= '000001',
				Err_Mensaj	= 'Existen SPEI fuera de Horario sin enviar' ,
				Err_Variab	= 'NBSPFUHO'

		
	end else begin
		select	Err_Codigo	= '000002',
				Err_Mensaj	= 'Los SPEI fuera de Horario se enviaron correcctamente' ,
				Err_Variab	= 'NBSPFUHO'
	end
	
end

If @Tip_Consul = @Tip_NomTot  begin

		
	select 	@Ent_count	= count(*)	
		from	CHREPANO noholdlock
		where	Ren_Fecha	= @Fecha 
		  and	Ren_TipDis	= @Str_D
		  and	Ren_Status	<> @Str_R
		  
			select	Err_Codigo	= '000002',
				Err_Mensaj	= 'Existen ' + convert(char,  @Ent_count) + 'Nominas pendientes',
				Err_Variab	= 'CHREPANO'	  

	
end	

if @Tip_Consul = @Tip_ComPRO  begin

	select @Ent_count	= count(*) 
		from	SYDIACTA noholdlock
		where	Dic_Fecha = @Fecha 
		  and	Dic_Transa = @Str_CFP


	if	@Ent_count	< 8 begin
	
				select	Err_Codigo	= '000001',
					Err_Mensaj	= 'La contabilidad solamente registro ' + convert(char,  @Ent_count) + 'asientos contables favor de reportar',
					Err_Variab	= 'SYDIACTA'	  
	end
	
	if	@Ent_count >= 8 begin
		
		select		Err_Codigo	= '000002',
					Err_Mensaj	= 'La contabilidad genero correctamente los ' + convert(char,  @Ent_count) + 'asientos contables',
					Err_Variab	= 'SYDIACTA'	  
		
	end
	
	
end



if @Tip_Consul = @Tip_LiqFin begin

	select	@Par_FecApe	= Par_FecApe,
			@Par_FeSiAp = Par_FeSiAp
		from	SPPARAMS noholdlock
	
	select	@Ent_count	= count(*)
		from SPLIQFIN noholdlock
		where	Lif_Fecha = @Fecha
			
		
	if (@Par_FecApe	= @Par_FeSiAp) and @Ent_count = 0 begin
	
		select		Err_Codigo	= '000001',
					Err_Mensaj	= 'No se ha realizado la Liquidacion Final del SPEI ',
					Err_Variab	= 'SPPARAMS'	  
	
	
	
	end else begin
	
		select		Err_Codigo	= '000002',
					Err_Mensaj	= 'La Liquidacion Final del SPEI ha sido realizada',
					Err_Variab	= 'SPPARAMS'	  
					
	end
	
end
