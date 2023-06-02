create procedure SOMONEDAPRO(
    @So@MonedaID   int,
	@Mon_Numero   char(2),
	@Mon_Descri   varchar(30),
	@Mon_Simbol   varchar(10),
	@Mon_Tipo   char(1),
	@Mon_EqBaMa   varchar(35),
	@Mon_Fecha   smalldatetime,
	@Mon_EfeCom   float,
	@Mon_EfeVen   float,
	@Mon_DocCom   float,
	@Mon_DocVen   float,
	@Mon_FixCom   float,
	@Mon_FixVen   float,
	@Mon_Abrevi   varchar(10),
	@Mon_AbrISO   varchar(3),
	@Mon_CodISO   varchar(3),
	@Mon_DesCor   varchar(6),
	@Mon_DesLeg   varchar(60),
	@Mon_CtaEfe   char(12),
	@Mon_CtaBM   char(12),
	@Mon_CtaSBC   char(12),
	@Mon_CtaRem   char(12),
	@Mon_CieCom   float,
	@Mon_CieVen   float,
	@Mon_SpoCom   float,
	@Mon_SpoVen   float,
	@Mon_CieDia   float,
	@Mon_OpeCam   char(1),
	@Mon_FixVal   float,
	@Mon_ForMet   char(2),
	@Mon_RevBal   float,
	@Mon_NivRie   int,
	@Mon_ValMet	double precision,
	@Tip_Proces	char(1),
	
	@NumTransac char(10),
	@Transaccio char(3), 
	@Usuario	char(6),
	@FechaSis	smalldatetime, 
	@SucOrigen	char(3),
	@SucDestino char(3), 
	@Modulo		char(2))

as

/******************************************************************	
*** Descripcion: Procesos de Monedas							***
*******************************************************************
** Creo: 		Luis Enrique Ramirez Ortiz						***
** Fecha: 		30/05/2023										***
** Helpdesk: 	TCELTO-4797										***	
******************************************************************/

--Declaracion de Constantes
declare @Tip_AltIso char(1)

--Asignacion de Constantes
select @Tip_AltIso = 'I'

--Declaracion de variables
declare @Status int

if @Tip_Proces = @Tip_AltIso begin
	exec @Status = SOMONEDAALT
		@Mon_Numero,	@Mon_Descri,	@Mon_Simbol,	@Mon_Tipo,		@Mon_EqBaMa,
		@Mon_Fecha, 	@Mon_EfeCom,	@Mon_EfeVen,	@Mon_DocCom,	@Mon_DocVen,
		@Mon_FixCom,	@Mon_FixVen,	@Mon_Abrevi,	@Mon_DesCor,	@Mon_DesLeg,
		@Mon_CtaEfe,	@Mon_CtaBM,		@Mon_CtaSBC,	@Mon_CtaRem,	@Mon_CieCom,
		@Mon_CieVen,	@Mon_SpoCom,	@Mon_SpoVen,	@Mon_CieDia,	@Mon_FixVal,	
		@Mon_ForMet,	@NumTransac,	@Transaccio, 	@Usuario,		@FechaSis, 
		@SucOrigen,		@SucDestino, 	@Modulo
	if @Status <> 0 begin
		select 	Err_Codigo	= '00001',
				Err_Mensaj	= 'No se pudo dar de alta la moneda'
		rollback
		return 1
	end 	
	
	exec @Status = SOMONEDAACT 
		@Mon_Numero,	@Mon_SpoCom,	@Mon_SpoVen,	@Mon_ValMet,	@Mon_AbrISO,
		@Tip_AltIso,	@NumTransac,	@Transaccio, 	@Usuario,		@FechaSis, 
		@SucOrigen,		@SucDestino, 	@Modulo
	if @Status <> 0 begin
		select 	Err_Codigo	= '00002',
				Err_Mensaj	= 'No se pudo modificar el ISO de la moneda'
		rollback
		return 1
	end 
	
end