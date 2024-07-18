create procedure SOHISBIPPRO (

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*******************************************************************
** DESCRIPCION:  ** PROCESO DE PASO HISTORICO DE SOBITPER		****
********************************************************************
** REFERENCIAS:													****
********************************************************************
** Modificó:	Carlos Copto									****
** Fecha:		17/07/2024									   	****
** Help: 		43403 											****
** Descripcion:	Se crea SP 										****
*******************************************************************/

--Declaracion de Variables
declare @conteo			int,
		@Fec_Actual		smalldatetime,
		@Fec_Depura		smalldatetime

--Declaracion de Constantes
declare	@Ent_Uno	int

--Asignacion de Constantes
select	@Ent_Uno	= 1			-- Entero : 1

--se obtiene la fecha actual
select @Fec_Actual = getdate()

--se genera la fecha a partir de la cual se va a traspasar (se deja en SOBITPER los ultimos 2 años, lo anterior a eso se traspasa)
select @Fec_Depura = DateAdd(Year, -2, @Fec_Actual)

--se ejecuta el traspaso

insert into SOHISBIP(
			Bit_NumPer,	Bit_Fecha,	Bit_NumTra,	Bit_TipPer,		
			Bit_NuSeFi, Bit_Titulo,	Bit_Nombre,	Bit_ApePat,	Bit_ApeMat,	
			Bit_RazSoc,	Bit_Comple,	Bit_ComOrd,	Bit_RFC,	Bit_CURP,		
			Bit_Calle, 	Bit_CalNum,	Bit_Coloni,	Bit_Entida,	Bit_Locali,	
			Bit_CodPos, Bit_ApaPos,	Bit_LadTel,	Bit_Telefo,	Bit_Email,		
			Bit_ComDom, Bit_EstCiv,	Bit_Nacion,	Bit_ActEmp,	Bit_Giro,		
			Bit_Sector, Bit_Activi,	Bit_ActINE,	NumTransac,	Transaccio,	
			Usuario, 	FechaSis,	SucOrigen,	SucDestino)
	select  Bit_NumPer,	Bit_Fecha,	Bit_NumTra,	Bit_TipPer,		
			Bit_NuSeFi, Bit_Titulo,	Bit_Nombre,	Bit_ApePat,	Bit_ApeMat,	
			Bit_RazSoc,	Bit_Comple,	Bit_ComOrd,	Bit_RFC,	Bit_CURP,		
			Bit_Calle, 	Bit_CalNum,	Bit_Coloni,	Bit_Entida,	Bit_Locali,	
			Bit_CodPos, Bit_ApaPos,	Bit_LadTel,	Bit_Telefo,	Bit_Email,		
			Bit_ComDom, Bit_EstCiv,	Bit_Nacion,	Bit_ActEmp,	Bit_Giro,		
			Bit_Sector, Bit_Activi,	Bit_ActINE,	NumTransac,	Transaccio,	
			Usuario, 	FechaSis,	SucOrigen,	SucDestino
	from SOBITPER noholdlock
	where Bit_Fecha <= @Fec_Depura

--se eliminan los registros traspasados de la bitacora
delete from SOBITPER where Bit_Fecha <= @Fec_Depura

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Depuracion terminada'


