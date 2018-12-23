create procedure SOCOMPANALT (
	@Com_Numero	char(2) output,
	@Com_Descri	varchar(150),
	@Com_RFC	char(15),
	@Com_Calle	char(40),
	@Com_CalNum	char(10),
	@Com_Coloni	char(80),
	@Com_CodPos	char(6),
	@Com_Ciudad	char(3),
	@Com_Estado	char(2),
	@Com_Pais	char(3),
	@Com_Abrevi	varchar(25),
	@Com_ClaIns	char(3),
	@Com_FolEle	char(10),
	@Com_CorEle	char(30),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as


/****************************************************************************/
/*	DESCRIPCION: ** Alta de Compañías **			*/
/****************************************************************************/
/**	REFERENCIAS:
****************************************************************************
**								STORE CONVERTIDO						****
****************************************************************************
** Modificó:		Jaret Guanajuato Ruvalcava								****
** Fecha:		10/Dic/2013												****
** Help:		00591890												****
** Descripción:	Se agregan campos y parametros que faltaban en insert	****
****************************************************************************
**								STORE CONVERTIDO						****
****************************************************************************
** Creó:		Karla Dosal		     									****
** Fecha:		27/Nov/12												****
** Help:		416571													****
** Descripción:	Alta de Compañías en la tabla SOCOMPAN					****
****************************************************************************
*/

declare	@Status		int,				/*	Declaración de Variables	*/
		@Int_Folio	int

declare	@Str_Vacio	char(1),			/*	Declaración de Constantes	*/
		@Com_Sofome	char(1),
		@Com_Banco	char(1),
		@Str_Cero	char(1),
		@Tab_Nombre	char(8),
		@Ent_Cero	int

/*	Asignación de Constantes	*/
select	@Str_Vacio	= '',				/*	String: Vacío				*/
		@Com_Sofome	= '1',				/*	Tipo Compañía: SOFOME		*/
		@Com_Banco	= '2',				/*	Tipo Compañía: Banco		*/
		@Str_Cero	= '0',				/*	String: Cero				*/
		@Tab_Nombre	= 'SOCOMPAN',		/*	Tabla: SOCOMPAN				*/
		@Ent_Cero	= 0					/*	Entero: Cero				*/
		

select	@Com_Numero	= isnull(@Com_Numero, @Str_Vacio),
		@Com_Descri	= isnull(@Com_Descri, @Str_Vacio),
		@Com_RFC	= isnull(@Com_RFC, @Str_Vacio),
		@Com_Calle	= isnull(@Com_Calle, @Str_Vacio),
		@Com_CalNum	= isnull(@Com_CalNum, @Str_Vacio),
		@Com_Coloni	= isnull(@Com_Coloni, @Str_Vacio),
		@Com_CodPos	= isnull(@Com_CodPos, @Str_Vacio),
		@Com_Ciudad	= isnull(@Com_Ciudad, @Str_Vacio),
		@Com_Estado	= isnull(@Com_Estado, @Str_Vacio),
		@Com_Pais	= isnull(@Com_Pais, @Str_Vacio),
		@Com_Abrevi	= isnull(@Com_Abrevi, @Str_Vacio),
		@Com_ClaIns	= isnull(@Com_ClaIns, @Str_Vacio)

execute @Status = SOFOLIOSACT
	@Fol_Tabla  = @Tab_Nombre,
	@Fol_Numero = @Int_Folio output

if @Status <> @Ent_Cero begin
	rollback
	return 1
end

select	@Com_Numero	= right('00' + ltrim(rtrim(convert(char, @Int_Folio))), 2)

if exists (select Com_Numero
			 from SOCOMPAN noholdlock
			 where	Com_Numero	= @Com_Numero) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'La Compañía ya existe'
	rollback
	return 1
end

if (@Com_Descri = @Str_Vacio) begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Descripción de la Compañía incorrecta'
	rollback
	return 1
end

if (@Com_RFC = @Str_Vacio) begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'RFC de la Compañía incorrecto'
	rollback
	return 1
end

if (@Com_Calle = @Str_Vacio) begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'Calle incorrecta'
	rollback
	return 1
end

if (@Com_CalNum = @Str_Vacio) begin
	select	Err_Codigo	= '000005',
			Err_Mensaj	= 'Número de Calle incorrecto'
	rollback
	return 1
end

if (@Com_Coloni = @Str_Vacio) begin
	select	Err_Codigo	= '000006',
			Err_Mensaj	= 'Nombre de Colonia incorrecto'
	rollback
	return 1
end

if (@Com_Ciudad = @Str_Vacio) begin
	select	Err_Codigo	= '000007',
			Err_Mensaj	= 'Ciudad incorrecta'
	rollback
	return 1
end

if not exists(select  Ciu_Numero 
				from SOCIUDAD noholdlock
				where	 Ciu_Numero 	= @Com_Ciudad) begin
	select	Err_Codigo	= '000008',
			Err_Mensaj	= 'La Ciudad no existe'
	rollback
	return 1
end

if (@Com_Estado = @Str_Vacio) begin
	select	Err_Codigo	= '000009',
			Err_Mensaj	= 'Estado incorrecto'
	rollback
	return 1
end

if not exists(select   Est_Numero  
				from SOESTADO noholdlock
				where	  Est_Numero  	= @Com_Estado) begin
	select	Err_Codigo	= '000010',
			Err_Mensaj	= 'El Estado no existe'
	rollback
	return 1
end

if (@Com_Pais = @Str_Vacio) begin
	select	Err_Codigo	= '000011',
			Err_Mensaj	= 'Estado incorrecto'
	rollback
	return 1
end

if not exists(select   Pai_Numero  
				from SOPAIS noholdlock
				where	  Pai_Numero  	= @Com_Pais) begin
	select	Err_Codigo	= '000012',
			Err_Mensaj	= 'El País no existe'
	rollback
	return 1
end

if (@Com_CodPos = @Str_Vacio) begin
	select	Err_Codigo	= '000013',
			Err_Mensaj	= 'Código Postal incorrecto'
	rollback
	return 1
end

if not exists(select Cpc_CodPos
				from CLCODPOS noholdlock
				where	Cpc_CodPos	= @Com_CodPos) begin
	select	Err_Codigo	= '000014',
			Err_Mensaj	= 'El Código Postal no existe'
	rollback
	return 1
end

if not exists(select Cpc_CodPos
				from CLCODPOS noholdlock
				where	Cpc_CodPos	= @Com_CodPos) begin
	select	Err_Codigo	= '000015',
			Err_Mensaj	= 'El Código Postal no existe'
	rollback
	return 1
end

insert into SOCOMPAN
	values ( @Com_Numero,	@Com_Descri,	@Com_RFC,		@Com_Calle,		@Com_CalNum,
			 @Com_Coloni,	@Com_CodPos,	@Com_Ciudad,	@Com_Estado,	@Com_Pais,
			 @Com_Abrevi,	@Com_ClaIns,	@Com_FolEle,	@Com_CorEle,	@NumTransac,	
			 @Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino)

if @@nestlevel = 1 begin
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro Agregado',
			Com_Numero	= @Com_Numero
end
