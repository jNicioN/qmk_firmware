create procedure SOHIBIFECON (
	@Bit_FecIni	smalldatetime,
	@Bit_FecFin smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*******************************************************************
** DESCRIPCION:  ** Consulta de Historico de Personas por rango ****
					de fecha									****
********************************************************************
** REFERENCIAS:													****
********************************************************************
** Modificó:	Carlos Copto									****
** Fecha:		28/05/2024									   	****
** Help: 		38996 											****
** Descripcion:	Se crea SP para consulta de historico de 		****
				personas por rango de Fecha 					****
*******************************************************************/

-- Declaracion de Variables 

-- Declaracion de Constantes 
declare	@Str_Vacio	char(1),
		@Ent_Uno	int

-- Asignacion de Constantes 
select	@Str_Vacio	= '',			-- String Vacio
		@Ent_Uno	= 1				-- Entero : 1

if @Bit_FecIni = isnull(@Bit_FecIni, @Str_Vacio) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Ingrese una fecha de inicio'
	rollback
	return @Ent_Uno
end

if @Bit_FecFin = isnull(@Bit_FecFin, @Str_Vacio) begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Ingrese una fecha de fin'
	rollback
	return @Ent_Uno
end

select  Bit_Consec, Bit_NumPer,	Bit_Fecha,	Bit_NumTra,	Bit_Tipo,		
		Bit_NuSeFi, Bit_Titulo,	Bit_Nombre,	Bit_ApePat,	Bit_ApeMat,	
		Bit_RazSoc,	Bit_Comple,	Bit_ComOrd,	Bit_RFC,	Bit_CURP,		
		Bit_Calle, 	Bit_CalNum,	Bit_Coloni,	Bit_Entida,	Bit_Locali,	
		Bit_CodPos, Bit_ApaPos,	Bit_LadTel,	Bit_Telefo,	Bit_Email,		
		Bit_ComDom, Bit_EstCiv,	Bit_Nacion,	Bit_ActEmp,	Bit_Giro,		
		Bit_Sector, Bit_Activi,	Bit_ActINE,	NumTransac,	Transaccio,	
		Usuario, 	FechaSis,	SucOrigen,	SucDestino
	from SOHISBIP noholdlock
	where Bit_Fecha >= @Bit_FecIni
	and Bit_Fecha <= @Bit_FecFin
