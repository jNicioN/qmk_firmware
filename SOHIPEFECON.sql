create procedure SOHIPEFECON (
	@Per_Numero	char(8),
	@Bit_Fecha	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*******************************************************************
** DESCRIPCION:  ** Consulta de Historico de Personas por numero****
**					de persona y a partir de una fecha 			****
********************************************************************
** REFERENCIAS:													****
********************************************************************
** Modificó:	Carlos Copto									****
** Fecha:		28/05/2024									   	****
** Help: 		41724 											****
** Descripcion:	Se crea SP para consulta de historico de 		****
				personas por numero de Persona y fecha			****
*******************************************************************/

--Declaracion de Variables

--Declaracion de Constantes
declare	@Str_Vacio	char(1),
		@Ent_Uno	int,
		@Fec_Vacia	smalldatetime

--Asignacion de Constantes
select	@Str_Vacio	= '',			-- String Vacio
		@Ent_Uno	= 1,			-- Entero : 1
		@Fec_Vacia	= '1900-01-01'	--Fecha Vacia	

if isnull(@Per_Numero, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Ingrese un numero de persona'
	rollback
	return @Ent_Uno
end

--Si se manda vacia la fecha se toma la fecha vacia como base para traer todos los registros
if isnull(@Bit_Fecha, @Str_Vacio) = @Str_Vacio begin
	select @Bit_Fecha = @Fec_Vacia
end

select  Bit_Consec, Bit_NumPer,	Bit_Fecha,	Bit_NumTra,	Bit_TipPer,		
		Bit_NuSeFi, Bit_Titulo,	Bit_Nombre,	Bit_ApePat,	Bit_ApeMat,	
		Bit_RazSoc,	Bit_Comple,	Bit_ComOrd,	Bit_RFC,	Bit_CURP,		
		Bit_Calle, 	Bit_CalNum,	Bit_Coloni,	Bit_Entida,	Bit_Locali,	
		Bit_CodPos, Bit_ApaPos,	Bit_LadTel,	Bit_Telefo,	Bit_Email,		
		Bit_ComDom, Bit_EstCiv,	Bit_Nacion,	Bit_ActEmp,	Bit_Giro,		
		Bit_Sector, Bit_Activi,	Bit_ActINE,	NumTransac,	Transaccio,	
		Usuario, 	FechaSis,	SucOrigen,	SucDestino
	from SOHISBIP noholdlock
	where Bit_NumPer = @Per_Numero 
	and Bit_Fecha >= @Bit_Fecha
