create procedure SOAPEDIAVVA (
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

/******************************************************************
** Creó:		Fernando Patiño BRM2966                        ****
** Fecha:		26/Sep/12                                      ****
** Help:		493712                                         ****
** Descripción: Verificación de Validación de Apertura diaria  ****
** mediante la  Generación de los Reportes siguientes reportes:****
** Inicio de Cámara,Bitacora de Inicio de Cámara,SPEI fuera de ****
** horario,Nominas pendientes,Desglose de Nomina,PROSA 325/510,****
** Reporte 325/510                                             ****
******************************************************************/

declare		@Ent_count		int,
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
			@Str_TDC        char(3),
			@Str_TDD        char(3),
			@Str_Tipo1		char(20),
			@Str_Tipo2		char(20),
			@Str_Tipo3		char(20),
			@Str_Tipo4		char(20),
			@Str_Tipo5		char(20),
			@Str_Tipo6		char(20)
			
			
select 		@Ent_count		= 0,
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
			@Str_TDC        = 'TDC',
			@Str_TDD        = 'TDD',
			@Str_Tipo1		= 'CTCONPOS No Aplicadas',
			@Str_Tipo2		= 'TACONPOS No Aplicadas',
			@Str_Tipo3		= 'CTCONPOS Nac' ,
			@Str_Tipo4		= 'TACONPOS Nac' ,
			@Str_Tipo5		= 'CTCONPOS Int' ,
			@Str_Tipo6		= 'TACONPOS Int'

			
create table #ProsaDes(
	Con_TipTran	char(3),
    Con_Error	char(65),
	Con_FecCon	smalldatetime,
	Con_FecPro	smalldatetime,
	Con_FecApl	smalldatetime,
	Con_TipTra	char(2),
	Con_Tarjet	char(16),
	Con_BaReTx	char(2),
	Con_NumAfi	char(9),
	Con_NomCom	varchar(30),
	Con_PobCom	char(13),
	Con_RfcCom	char(13),
	Con_GiCoNa	char(5),
	Con_GiCoIn	char(5),
	Con_IdTerm	char(10),
	Con_Cantid	money,
	Con_MonCon	char(3),
	Con_CanCon	money,	
	Con_TipCam	double precision,
	Con_NumAut	char(6),
	Con_Refere	char(23),
	Con_MotDev	char(2),
	Con_Origen	char(2),
	Con_EmPaEl	varchar(16),
	Con_PlaMes	int,
	Con_Status	char(1),
	Con_ImpCom	money,
	Con_ImpCuI	money,
	Con_IndInt	char(2),
	Con_ImpTot	money,
	NumTransac	char(10),
	Transaccio	char(3),
	Usuario   	char(6),
	FechaSis  	smalldatetime,
	SucOrigen 	char(3),
	SucDestino	char(3))
	
create table #Prosa(
	Tipo 		char(20),
	Cantidad	int,
	Monto		money)	

if @Tip_Consul = @Tip_CABIPAFI begin
	select	Bpf_Transa,
			Bpf_Fecha
		from	CABIPAFI noholdlock
		where	Bpf_Fecha >= @Fecha		
end  

if @Tip_Consul = @Tip_ESBIINDI begin
	select	Bin_Transa,
			Bin_Fecha
		from	ESBIINDI noholdlock	
		where	Bin_Fecha	>= @Fecha
end

if @Tip_Consul = @Tip_NBSPFUHO begin
	select	Sfh_Cuenta,
			Sfh_Cantid,
			Sfh_FecOpe
		from	NBSPFUHO noholdlock
		where	Sfh_FecOpe	= @Fecha 
		  and	Sfh_Status	= @Str_Alta		
end

if @Tip_Consul = @Tip_NomDes begin	
	select	Ren_NumTra, 
			Ren_Fecha, 
			Ren_FecHor, 
			Ren_CueCar,
			Ren_Cantid, 
			Ren_NumPag
		from	CHREPANO noholdlock
		where	Ren_Fecha	= @Fecha 
 		  and	Ren_TipDis	= @Str_D
		  and	Ren_Status	<> @Str_R
	order by Ren_FecHor	
end

if @Tip_Consul = @Tip_Prosa begin
	insert into #ProsaDes
		select	@Str_TDC,
			Err_Descri,
			Con_FecCon,
			Con_FecPro,
			Con_FecApl,
			Con_TipTra,
			Con_Tarjet,
			Con_BaReTx,
			Con_NumAfi,
			Con_NomCom,
			Con_PobCom,
			Con_RfcCom,
			Con_GiCoNa,
			Con_GiCoIn,
			Con_IdTerm,
			Con_Cantid,
			Con_MonCon,
			Con_CanCon,
			Con_TipCam,
			Con_NumAut,
			Con_Refere,
			Con_MotDev,
			Con_Origen,
			Con_EmPaEl,
			Con_PlaMes,
			Con_Status,
			Con_ImpCom,
			Con_ImpCuI,
			Con_IndInt,
			Con_ImpTot,
			TACONPOS.NumTransac,
			TACONPOS.Transaccio,
			TACONPOS.Usuario,
			TACONPOS.FechaSis,
			TACONPOS.SucOrigen,
			TACONPOS.SucDestino	
			from	TACONPOS noholdlock,
					TALOGERR noholdlock
			where	Con_FecApl	= @Fecha
			  and	Con_Status	= @Str_N
			  and	Err_Tarjet	= Con_Tarjet	 
	insert into #ProsaDes
		select	@Str_TDD,
			Err_Descri,
			Con_FecCon,
			Con_FecPro,
			Con_FecApl,
			Con_TipTra,
			Con_Tarjet,
			Con_BaReTx,
			Con_NumAfi,
			Con_NomCom,
			Con_PobCom,
			Con_RfcCom,
			Con_GiCoNa,
			Con_GiCoIn,
			Con_IdTerm,
			Con_Cantid,
			Con_MonCon,
			Con_CanCon,
			Con_TipCam,
			Con_NumAut,
			Con_Refere,
			Con_MotDev,
			Con_Origen,
			Con_EmPaEl,
			Con_PlaMes,
			Con_Status,
			Con_ImpCom,
			Con_ImpCuI,
			Con_IndInt,
			Con_ImpTot,
			CTCONPOS.NumTransac	,
			CTCONPOS.Transaccio,
			CTCONPOS.Usuario,
			CTCONPOS.FechaSis,
			CTCONPOS.SucOrigen,
			CTCONPOS.SucDestino			
		from	CTCONPOS noholdlock,
				CTLOGERR noholdlock
		where	Con_FecApl	= @Fecha
		  and	Con_Status	= @Str_N
		  and	Err_Tarjet	= Con_Tarjet	  
	/* Adaptive Server has expanded all '*' elements in the following statement */ select #ProsaDes.Con_TipTran, #ProsaDes.Con_Error, #ProsaDes.Con_FecCon, #ProsaDes.Con_FecPro, #ProsaDes.Con_FecApl, #ProsaDes.Con_TipTra, #ProsaDes.Con_Tarjet, #ProsaDes.Con_BaReTx, #ProsaDes.Con_NumAfi, #ProsaDes.Con_NomCom, #ProsaDes.Con_PobCom, #ProsaDes.Con_RfcCom, #ProsaDes.Con_GiCoNa, #ProsaDes.Con_GiCoIn, #ProsaDes.Con_IdTerm, #ProsaDes.Con_Cantid, #ProsaDes.Con_MonCon, #ProsaDes.Con_CanCon, #ProsaDes.Con_TipCam, #ProsaDes.Con_NumAut, #ProsaDes.Con_Refere, #ProsaDes.Con_MotDev, #ProsaDes.Con_Origen, #ProsaDes.Con_EmPaEl, #ProsaDes.Con_PlaMes, #ProsaDes.Con_Status, #ProsaDes.Con_ImpCom, #ProsaDes.Con_ImpCuI, #ProsaDes.Con_IndInt, #ProsaDes.Con_ImpTot, #ProsaDes.NumTransac, #ProsaDes.Transaccio, #ProsaDes.Usuario, #ProsaDes.FechaSis, #ProsaDes.SucOrigen, #ProsaDes.SucDestino 
		from #ProsaDes
end 

if @Tip_Consul = @Tip_ProRep begin
	insert into #Prosa
		select 	@Str_Tipo1, 
			count(*), 
			Sum(Con_Cantid)
		from CTCONPOS noholdlock
		where	Con_FecApl	= @Fecha
		  and	Con_Status	= @Str_N

	insert into #Prosa
		select	@Str_Tipo2, 
				count(*), 
				Sum(Con_Cantid)	
		from	TACONPOS noholdlock
		where	Con_FecApl	= @Fecha
		  and	Con_Status	= @Str_N

	insert into #Prosa
		select	@Str_Tipo3, 
				count(*), 
				Sum(Con_Cantid)
		from	CTCONPOS noholdlock
		where	Con_FecApl	= @Fecha
		  and	Con_IndInt not in (@Str_06,@Str_61)

	insert into #Prosa
		select	@Str_Tipo4, 
				count(*), 
				Sum(Con_Cantid)	
		from 	TACONPOS noholdlock
		where	Con_FecApl=@Fecha
		  and	Con_IndInt not in (@Str_06,@Str_61)

	insert into #Prosa
		Select	@Str_Tipo5, 
				count(*), 
				Sum(Con_Cantid)
		from 	CTCONPOS noholdlock
		where	Con_FecApl=@Fecha
		  and	Con_IndInt in (@Str_06,@Str_61)

	insert into #Prosa
		select 	@Str_Tipo6, 
				count(*), 
				Sum(Con_Cantid)	
		from	TACONPOS noholdlock
		where	Con_FecApl=@Fecha
		  and	Con_IndInt in (@Str_06,@Str_61)

	/* Adaptive Server has expanded all '*' elements in the following statement */ select	#Prosa.Tipo, #Prosa.Cantidad, #Prosa.Monto 
		from  #Prosa	
end

drop table #Prosa,#ProsaDes
