create procedure SOINCLREPRO (
	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario 	char(6),
	@FechaSis 	smalldatetime,
	@SucOrigen 	char(3),
	@SucDestino char(3),
	@Modulo 	char(2))

as


/***************************************************************************
* DESCRIPCION: Proceso de obtencion de informacion y productos de clientes *
*			   con mas de un id   										   *
****************************************************************************
** REFERENCIAS: 														   *
****************************************************************************
** Modificó:    Victor Hugo Garcia                                    	****
** Fecha:       26/Enero/2026                                         	****
** HelpDesk:    TCELTC-7901                                           	****
** Descripcion: Se agrega bandera día cero para mercado capitales     	****
****************************************************************************
** Modifico:	Fatima Sanchez Luis										****
** Fecha:		22/Junio/2022											****
** Help:		1637684													****
** Descripcion:	Se quita actualización de cuentas que no son hey		****
****************************************************************************
** Creo:		Fatima Sanchez Luis										****
** Fecha:		31/Mayo/2022											****
** Help:		1637684													****
****************************************************************************/

/* Declaración de variables */
declare @Act_EcMeCa	char(1)

-- Declaración de constantes 
declare	@Str_SI		char(1),
		@Str_Activo	char(1),
		@Str_Bloque	char(1),
		@Str_Cancel	char(1),
		@Str_Vigent	char(1),
		@Str_Castig	char(1),
		@Str_ResCas	char(1),
		@Str_Pagado	char(1),
		@Tip_CueHey	char(2),
		@Tip_CuHeSm	char(2),
		@Tip_CuHSmX	char(2),
		@Tip_CueHSm	char(2),
		@Tip_CuentH	char(2),
		@Tip_CuHSma	char(2),
		@Tip_CuSmMe	char(2),
		@Cla_ClaHey int,
		@Str_Vacio char(1),
		@Ent_Uno	int,
		@Pro_HeyRec char(4),
		@Cue_Tipo   char(2),
		@Str_LetraV char(1),
		@Dce_MerCap char(23)

-- Asignación de Constantes 
select	@Str_SI		= 'S',		-- String Si 
		@Str_Activo	= 'A',		-- String estatus Activo
		@Str_Bloque	= 'B',		-- String estatus Bloqueo
		@Str_Cancel	= 'C',		-- String estatus Cancelado
		@Str_Vigent	= 'N',		-- String estatus Vigente
		@Str_Castig	= 'M',		-- String estatus Castigado
		@Str_ResCas	= 'Q',		-- String estatus Castigado
		@Str_Pagado	= 'P',		-- String estatus Pagado
		@Tip_CueHey	= '29',		-- Valor tipo de cuenta CUENTA HEY
		@Tip_CuHeSm	= '51',     -- Valor tipo de cuenta CUENTA HEY SMART
		@Tip_CuHSmX	= '52',     -- Valor tipo de cuenta CUENTA HEY SMARTX
		@Tip_CueHSm	= '55',     -- Valor tipo de cuenta HEY SMART
		@Tip_CuentH	= '56',     -- Valor tipo de cuenta CUENTA HEY
		@Tip_CuHSma	= '57',     -- Valor tipo de cuenta CUENTA HEY SMART
		@Tip_CuSmMe	= '88',     -- Valor tipo de cuenta CUENTA HEY SMART MENORES
		@Cla_ClaHey	= 1,			-- Clasificacion clientes hey
		@Str_Vacio  = '',
		@Ent_Uno	= 1,
		@Pro_HeyRec = '0228',
		@Cue_Tipo	= '50',
		@Str_LetraV = 'V',
		@Dce_MerCap = 'DiaCeroMercadoCapitales'		-- Bandera para obtener la información Dia cero de mercado capitales

		
-- Cantidad de lineas de credito por cliente
create table #CantidadLineasCre (
Cli_Client char(8),
Cli_Cantid int )

create table #ClientesLinCreCas (
Cli_Client char(8),
Cli_Cantid int
)

create table #CantidadLineasV (
Cli_Client char(8),
Cli_Cantid int
)

create table #Saldos (
Sal_Client char(8),
Sal_Cantid int,
Sal_Saldo money ) 

create table #CuentasRec (
Cue_Client char(8),
Cue_Cantid	int )

create table #NBCUEORI (
Cor_Grupo char(8),
Cor_Usuari char(6), 
Cor_Cantid int ) 

create table #NBTABRCO (
Brc_Grupo char(8),
Brc_Usuari char(6), 
Brc_Cantid int ) 

create table #CuentasNOHey (
Cue_Client char(8),
Cue_Cantid	int ) 

create table #InvClientes (
Inv_Client char(8),
Inv_Cantid	int ) 

create table #ClientesCre (
Cre_Client char(8),
Cre_Cantid	int ) 

create table #ClientesCreCas (
Cre_Client char(8),
Cre_Cantid	int ) 

create table #ClientesCreAB (
Cra_Client char(8),
Cra_Cantid	int ) 

create table #ClientesCreCasAB (
Crc_Client char(8),
Crc_Cantid	int )

create table #ClientesCreCC (
Ccc_Client char(8),
Ccc_Cantid	int )

create table #ClientesCreCasCC (
Ccc_Client char(8),
Ccc_Cantid	int )

create table #ClientesFondos (
Fon_Client char(8),
Fon_Cantid	int )

create table #CEDClientes (
Ced_Client char(8),
Ced_Cantid	int )

create table #Capitales (
Cap_Client char(8),
Cap_Cantid	int )


create table #Menores(
Men_Client char(8),
Men_Cantid	int )

create table #MDClientes(
Mdi_Client char(8),
Mdi_Cantid	int )

create table #TitulosClientes(
Tit_Client char(8),
Tit_Cantid	int )

		
-----------------------------------------------------------------------------------------
-- Actualizacion de datos
-----------------------------------------------------------------------------------------
select @Act_EcMeCa = isnull(Par_Valor, @Str_Cero)
	from SOPARGEN noholdlock
	where Par_Nombre = @Dce_MerCap
	
update SOCLIREC set 
	Clr_Nbusua	= @Str_SI,
	Clr_UsuBan	= Usu_Numero,
	Clr_UsrSta  = Usu_Status
	from SOCLIREC noholdlock
	inner join NBUSUARI	noholdlock	on Usu_Client = Clr_CliNum
									and Usu_Status = @Str_Activo
	
	
update SOCLIREC set 
	Clr_Nbusua	= @Str_SI,
	Clr_UsuBan	= Usu_Numero,
	Clr_UsrSta  = Usu_Status
	from SOCLIREC  noholdlock
	inner join NBUSUARI  noholdlock	on Usu_Client = Clr_CliNum
									and Usu_Status = @Str_Bloque
	
	
	
update SOCLIREC set 
	Clr_LinVir  = Vir.Lin_Numero,
	Clr_StLiVi  = Vir.Lin_Status,
	Clr_ProRec	= Vir.Lin_Produc
	from SOCLIREC noholdlock
	inner join TALINVIR Vir	noholdlock	on Vir.Lin_Client = Clr_CliNum 
										and Vir.Lin_Status <> @Str_Cancel
	
	
update SOCLIREC set 
	Clr_LinVir  = Vir.Lin_Numero,
	Clr_StLiVi  = Vir.Lin_Status,
	Clr_ProRec	= Vir.Lin_Produc
	from SOCLIREC noholdlock	
	inner join TALINVIR Vir	noholdlock	on Vir.Lin_Client = Clr_CliNum 
										and Vir.Lin_Status= @Str_Cancel
	
	where Clr_LinVir = @Str_Vacio



update SOCLIREC set 
	Clr_LinCre	= Lin.Lin_Numero,
	Clr_LinSta	= Lin.Lin_Status, 
	Clr_SalCre  = Lin.Lin_Saldo + Lin.Lin_SalBlo
	from SOCLIREC noholdlock	
	inner join TALINEAS Lin 	noholdlock	on Lin.Lin_Client = Clr_CliNum
											and Lin.Lin_Status in( @Str_Vigent,@Str_Bloque,@Str_Castig,@Str_ResCas)
	

	
-- Cantidad de lineas de credito por cliente
insert into #CantidadLineasCre
select Clr_CliNum, count(*)
	from SOCLIREC	noholdlock
	inner join TALINEAS noholdlock	on Lin_Client  =  Clr_CliNum 
									and Lin_Status in(@Str_Vigent,@Str_Bloque,@Str_Castig,@Str_ResCas)
	group by 	Clr_CliNum	

	
update SOCLIREC set 
	Clr_CaLiCr = Cli_Cantid
	from SOCLIREC noholdlock		
	inner join #CantidadLineasCre noholdlock	on  Cli_Client = Clr_CliNum
	
	
-- Cantidad de Lineas de credito castigadas por cliente CR
insert into #ClientesLinCreCas
select Clr_CliNum, count(*)
	from SOCLIREC noholdlock
	inner join TALINEAS Lin 	noholdlock	on Lin.Lin_Client = Clr_CliNum
											and Lin.Lin_Status in(@Str_Castig,@Str_ResCas)
	group by Clr_CliNum

update SOCLIREC set 
	Clr_CanCas	= Clr_CanCas + Cli_Cantid
	from SOCLIREC noholdlock
	inner join #ClientesLinCreCas	noholdlock	on Cli_Client = Clr_CliNum	



-- Cantidad de lineas virtuales de recompensas por cliente	
insert into #CantidadLineasV 		
select Clr_CliNum, count(*)
	from SOCLIREC 	noholdlock
	inner join TALINVIR noholdlock	on Lin_Client  =  Clr_CliNum 
									and Lin_Status in(@Str_Vigent,@Str_Bloque)
									
	group by 	Clr_CliNum	
	having count(*)  >= @Ent_Uno
	

update SOCLIREC set 
	Clr_CanLiv = Cli_Cantid
	from SOCLIREC noholdlock		
	inner join #CantidadLineasV noholdlock	on  Cli_Client = Clr_CliNum



insert into #Saldos	
select Clr_CliNum,	count(*), sum(Cue_Dispon)
	from SOCLIREC noholdlock
	inner join CHCUENTA noholdlock	on Cue_Client =  Clr_CliNum 
									and Cue_Status IN( @Str_Activo,@Str_Bloque)
									and Cue_Tipo <> @Cue_Tipo
	group by 	Clr_CliNum		
	
	
update SOCLIREC set 
	Clr_CueAct	= Sal_Cantid,
	Clr_SalCue	= Sal_Saldo
	from SOCLIREC Rec noholdlock
	inner join #Saldos noholdlock	on Sal_Client = Clr_CliNum

	
-- Cantidad de cuentas que son de tipo que generan recompensas
insert into #CuentasRec
select Clr_CliNum,	count(*)
	from SOCLIREC noholdlock
	inner join CHCUENTA noholdlock	on Cue_Client =  Clr_CliNum 
									and Cue_Status in( @Str_Activo,@Str_Bloque)
									and Cue_Tipo in (@Tip_CueHey,	@Tip_CuHeSm,	@Tip_CuHSmX, @Tip_CueHSm,
													@Tip_CuentH,	@Tip_CuHSma,	@Tip_CuSmMe ) 	
	group by 	Clr_CliNum	
	
	
update SOCLIREC set 
	Clr_CaCuRe	= Cue_Cantid
	from SOCLIREC Rec noholdlock
	inner join #CuentasRec noholdlock	on Cue_Client = Clr_CliNum


-- Determinacion de NBCUEORI
insert into #NBCUEORI 
select Clr_Grupo, Cor_Usuari, count(*)
	from SOCLIREC noholdlock
	inner join NBCUEORI noholdlock	on Cor_Usuari = Clr_UsuBan
									and  Cor_Status = @Str_Activo
	where Clr_CliNum <> Cor_Client
	group by Clr_Grupo, Cor_Usuari
		
update SOCLIREC set 
	Clr_NbCuOr	= @Str_SI
	from SOCLIREC noholdlock
	inner join #NBCUEORI noholdlock	on Cor_Grupo = Clr_Grupo


-- Determinacion de NBTABRCO con tarjeta que no le pertenece
insert into #NBTABRCO
select Clr_Grupo, Tcc_Usuari, count(*)
	from SOCLIREC noholdlock
	inner join NBTABRCO noholdlock	on Tcc_Usuari = Clr_UsuBan
									and  Tcc_Status = @Str_Activo
	inner join CTTARPRO noholdlock	on TaP_Tarjet = Tcc_Tarjet
									and TaP_TipTar =  @Pro_HeyRec   --agregar productos PFAE
	where Clr_CliNum <> Tcc_Client
	group by Clr_Grupo, Tcc_Usuari

update SOCLIREC set 
	Clr_NbTaBr	= @Str_SI
	from SOCLIREC noholdlock
	inner join #NBTABRCO noholdlock on Brc_Grupo = Clr_Grupo


-- Indica si el cliente existe en la tabla NBTABRCO ACTIVO
update SOCLIREC set 
	Clr_TieNbt	= @Str_SI
	from SOCLIREC noholdlock
	inner join NBTABRCO noholdlock	on Tcc_Client = Clr_CliNum
									and  Tcc_Status = @Str_Activo


-- Determinacion de si al cliente de usuario de banca le pertenece la linea virtual de recompensas
update SOCLIREC set 
	Clr_LiViUs 	= @Str_SI
	from SOCLIREC noholdlock 
	inner join TALINVIR	noholdlock	on Lin_Client =  Clr_CliNum 
									and Lin_Numero = Clr_LinVir
	where Clr_UsuBan <> @Str_Vacio
	

-- Cantidad de clientes con inversiones activas
insert into #InvClientes
select Cue_Client, count(*)
	from SOCLIREC noholdlock
	inner join CHCUENTA noholdlock	on Cue_Client = Clr_CliNum
									and Cue_Status IN ( @Str_Activo,@Str_Bloque)
	inner join ININVERS noholdlock	on Inv_Cuenta = Cue_Numero
									and Inv_Status = @Str_Vigent
	group by  Cue_Client
	
update SOCLIREC set 
	Clr_CaInAc = Inv_Cantid
	from SOCLIREC noholdlock
	inner join #InvClientes noholdlock	on Inv_Client = Clr_CliNum
	


-- Saldo en recompensas 
update SOCLIREC set 
	Clr_SaLiVi = Lic_SalAct
	from SOCLIREC noholdlock	
	inner join TALICABA noholdlock	on Lic_LinVir = Clr_LinVir 
									and Lic_LinVir <> @Str_Vacio


-- Creditos CR activos de clientes hey 
insert into #ClientesCre 
select Clr_CliNum, count(*)
	from SOCLIREC noholdlock
	inner join CRCREDIT noholdlock on Cre_Client = Clr_CliNum
								   and Cre_Status in( @Str_Vigent,@Str_Castig,@Str_ResCas )	
	group by Clr_CliNum

update SOCLIREC set 
	Clr_CreAct	= Cre_Cantid
	from SOCLIREC noholdlock
	inner join #ClientesCre	noholdlock	on Cre_Client = Clr_CliNum



-- Cantidad de creditos castigados por cliente CR
insert into #ClientesCreCas 
select Clr_CliNum, count(*)
	from SOCLIREC noholdlock
	inner join CRCREDIT noholdlock on Cre_Client = Clr_CliNum
								   and Cre_Status in(@Str_Castig,@Str_ResCas )	
	group by Clr_CliNum

update SOCLIREC set 
	Clr_CanCas	= Clr_CanCas + Cre_Cantid
	from SOCLIREC noholdlock
	inner join #ClientesCreCas	noholdlock	on Cre_Client = Clr_CliNum	


-- Creditos AB activos de clientes hey 
insert into #ClientesCreAB 
select Clr_CliNum, count(*)
	from SOCLIREC noholdlock
	inner join ABCREDIT noholdlock on Cre_Client = Clr_CliNum
								  and Cre_Status in( @Str_Vigent,@Str_Castig,@Str_ResCas )	
	group by Clr_CliNum
	
	
update SOCLIREC set 
	Clr_CrABAc	= Cra_Cantid
	from SOCLIREC noholdlock
	inner join #ClientesCreAB	noholdlock	on Cra_Client = Clr_CliNum	


-- Cantidad de creditos castigados por cliente Arrenda
insert into #ClientesCreCasAB 
select Clr_CliNum, count(*)
	from SOCLIREC noholdlock
	inner join ABCREDIT noholdlock on Cre_Client = Clr_CliNum
								   and Cre_Status in(@Str_Castig,@Str_ResCas )	
	group by Clr_CliNum

update SOCLIREC set 
	Clr_CanCas	= Clr_CanCas + Crc_Cantid
	from SOCLIREC noholdlock 
	inner join #ClientesCreCasAB	noholdlock	on Crc_Client = Clr_CliNum	


-- Creditos CC activos de clientes hey 
insert into #ClientesCreCC 
select Clr_CliNum, count(*)
	
	from SOCLIREC noholdlock
	inner join CCCREDIT noholdlock on Cre_Client = Clr_CliNum
								   and Cre_Status in( @Str_Vigent,@Str_LetraV,@Str_Castig,@Str_ResCas )	
	group by Clr_CliNum

update  SOCLIREC set  
	Clr_CrCCAc	= Ccc_Cantid
	from SOCLIREC noholdlock
	inner join #ClientesCreCC   noholdlock	on Ccc_Client = Clr_CliNum
	
	
	
-- Cantidad de creditos castigados por cliente Consumo
insert into #ClientesCreCasCC
select Clr_CliNum, count(*)
	from SOCLIREC noholdlock
	inner join CCCREDIT noholdlock on Cre_Client = Clr_CliNum
								   and Cre_Status in(@Str_Castig,@Str_ResCas )	
	group by Clr_CliNum

update SOCLIREC set 
	Clr_CanCas	= Clr_CanCas + Ccc_Cantid
	from SOCLIREC noholdlock
	inner join #ClientesCreCasCC	noholdlock	on Ccc_Client = Clr_CliNum	


-- 	 Fondos de inversion
insert into #ClientesFondos
select Clr_CliNum, count(*) 
	from SOCLIREC noholdlock
	inner join FIOPERAC noholdlock	on Ope_Client = Clr_CliNum 
									and  Ope_Status not in(@Str_Pagado,@Str_Cancel)
	group by Clr_CliNum
	
						
update 	SOCLIREC set
	Clr_FonInv = Fon_Cantid
	from SOCLIREC noholdlock
	inner join #ClientesFondos noholdlock	on Fon_Client = Clr_CliNum

	
-- Cantidad de clientes con cedes activos
insert into #CEDClientes
select Clr_CliNum, count(*)
	from SOCLIREC noholdlock
	inner join CEINVERS noholdlock	on Inv_Client = Clr_CliNum
									and Inv_Status = @Str_Vigent
	group by  Clr_CliNum

update SOCLIREC set 
	Clr_CedAct = Ced_Cantid
	from SOCLIREC noholdlock
	inner join #CEDClientes noholdlock	on Ced_Client = Clr_CliNum

-- Clientes con capitales
if @Act_EcMeCa = @Str_Uno begin
	
	insert into #Capitales
	select Clr_CliNum, count(*)
		from SOCLIREC noholdlock
		inner join MCCONTRA noholdlock on Con_Client = Clr_CliIde
		group by  Clr_CliNum
		
end else begin
	
	insert into #Capitales
	select Clr_CliNum, count(*)
		from SOCLIREC noholdlock
		inner join FICOMECA noholdlock on Con_Client = Clr_CliNum
		group by  Clr_CliNum
end
	
update SOCLIREC set 
Clr_CapAct = Cap_Cantid
from SOCLIREC noholdlock  
inner join  #Capitales noholdlock	on Cap_Client = Clr_CliNum
 
   
-- Clientes con hey menores
insert into #Menores
select Clr_CliNum, count(*)
	from SOCLIREC noholdlock
	inner join CLPADHIJ noholdlock on Pah_ClIdPa = Clr_CliIde
	inner join CLCLIENT noholdlock on Pah_ClIdHi = ClClientID
	inner join CHCUENTA noholdlock on Cue_Client =  Cli_Numero
								   and Cue_Status =@Str_Activo
	group by Clr_CliNum

	
update  SOCLIREC set  
	Clr_CuMeAc	= Men_Cantid
	from SOCLIREC noholdlock
	inner join #Menores  noholdlock	on Men_Client = Clr_CliNum


-- Cantidad de clientes con MDINVERS activas
insert into #MDClientes
select Clr_CliNum, count(*)
	from SOCLIREC noholdlock
	inner join MDINVERS noholdlock	on Inv_Client = Clr_CliNum
									and Inv_Status in (@Str_Activo,@Str_Vigent)
	group by  Clr_CliNum
	
update SOCLIREC set 
	Clr_MDInve = Mdi_Cantid
	from SOCLIREC noholdlock
	inner join #MDClientes noholdlock	on Mdi_Client = Clr_CliNum
	
	
	
-- Cantidad de clientes con custodia de TitulosClientes activos
insert into #TitulosClientes
select Clr_CliNum, count(*)
	from SOCLIREC noholdlock
	inner join MDCUSTIT noholdlock	on Cut_Client = Clr_CliNum
									and Cut_Status = @Str_Activo
	group by  Clr_CliNum	
	
update SOCLIREC set 
	Clr_TitAct = Tit_Cantid
	from SOCLIREC noholdlock
	inner join #TitulosClientes noholdlock	on Tit_Client = Clr_CliNum
	
	
	
drop table	#Saldos,		#CantidadLineasV,	#CantidadLineasCre,	#CuentasRec,
			#NBCUEORI,		#NBTABRCO,			#InvClientes,		#CEDClientes,	
			#Capitales,		#ClientesFondos,	#ClientesCreCC,		#ClientesCreAB,
			#ClientesCre,	#Menores,			#ClientesCreCas,	#ClientesCreCasAB,
			#ClientesCreCasCC,	#MDClientes,	#TitulosClientes,	#ClientesLinCreCas 
		