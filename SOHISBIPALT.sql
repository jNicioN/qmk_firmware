create procedure SOHISBIPALT (
	@Bit_NumPer	char(8),
	@Bit_Fecha	smalldatetime,
	@Bit_NumTra	char(10),
	@Bit_Tipo	char(1),
	@Bit_NuSeFi	varchar(30),
	@Bit_Titulo	varchar(10),
	@Bit_Nombre	varchar(40),
	@Bit_ApePat	varchar(40),
	@Bit_ApeMat	varchar(40),
	@Bit_RazSoc	varchar(150),
	@Bit_Comple	varchar(150),
	@Bit_ComOrd	varchar(150),
	@Bit_RFC	char(15),
	@Bit_CURP	char(18),
	@Bit_Calle	char(40),
	@Bit_CalNum	varchar(10),
	@Bit_Coloni	varchar(150),
	@Bit_Entida	char(3),
	@Bit_Locali	char(8),
	@Bit_CodPos	char(6),
	@Bit_ApaPos	char(6),
	@Bit_LadTel	varchar(8),
	@Bit_Telefo	char(15),
	@Bit_Email	varchar(50),
	@Bit_ComDom	char(1),
	@Bit_EstCiv	varchar(20),
	@Bit_Nacion	char(3),
	@Bit_ActEmp	char(1),
	@Bit_Giro	char(30),
	@Bit_Sector	char(3),
	@Bit_Activi	char(10),
	@Bit_ActINE	varchar(10),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*******************************************************************
** DESCRIPCION:  ** ALTA DE REGISTRO EN HISTORICO DE BITACORA 	****
					DE PERSONAS									****
********************************************************************
** REFERENCIAS:													****
********************************************************************
** Modificó:	Carlos Copto									****
** Fecha:		28/05/2024									   	****
** Help: 		41724 											****
** Descripcion:	Se crea SP 										****
*******************************************************************/

--Declaracion de Variables

--Declaracion de Constantes
declare	@Ent_Uno	int

--Asignacion de Constantes
select	@Ent_Uno	= 1			-- Entero : 1

insert into SOHISBIP(
	Bit_NumPer,	Bit_Fecha,	Bit_NumTra,	Bit_TipPer,	Bit_NuSeFi, 
	Bit_Titulo,	Bit_Nombre,	Bit_ApePat,	Bit_ApeMat,	Bit_RazSoc,	
	Bit_Comple,	Bit_ComOrd,	Bit_RFC,	Bit_CURP,	Bit_Calle, 	
	Bit_CalNum,	Bit_Coloni,	Bit_Entida,	Bit_Locali, Bit_CodPos, 
	Bit_ApaPos,	Bit_LadTel,	Bit_Telefo,	Bit_Email, 	Bit_ComDom, 
	Bit_EstCiv,	Bit_Nacion,	Bit_ActEmp,	Bit_Giro,	Bit_Sector, 
	Bit_Activi,	Bit_ActINE,	NumTransac,	Transaccio,	Usuario, 	
	FechaSis,	SucOrigen,	SucDestino)
values (
	@Bit_NumPer,	@Bit_Fecha,		@Bit_NumTra,	@Bit_Tipo,		@Bit_NuSeFi,
	@Bit_Titulo,	@Bit_Nombre,	@Bit_ApePat,	@Bit_ApeMat,	@Bit_RazSoc,
	@Bit_Comple,	@Bit_ComOrd,	@Bit_RFC,		@Bit_CURP,		@Bit_Calle,
	@Bit_CalNum,	@Bit_Coloni,	@Bit_Entida,	@Bit_Locali,	@Bit_CodPos,
	@Bit_ApaPos,	@Bit_LadTel,	@Bit_Telefo,	@Bit_Email,		@Bit_ComDom,
	@Bit_EstCiv,	@Bit_Nacion,	@Bit_ActEmp,	@Bit_Giro,		@Bit_Sector,
	@Bit_Activi,	@Bit_ActINE,	@NumTransac,	@Transaccio,	@Usuario,
	@FechaSis,		@SucOrigen,		@SucDestino)

if @@nestlevel = @Ent_Uno
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro agregado'
