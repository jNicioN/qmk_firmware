create procedure SODOENEXALT (
	@PerPersoID	int,
	@Dee_NumIde	char(2),
	@Dee_FolIde	varchar(25),
	@Dee_FecEmi	smalldatetime,
	@Dee_FecVen	smalldatetime,
	@Dee_Clave	varchar(18),
	@Dee_NumEmi	varchar(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
	
as

/* *****************************************************************
** DESCRIPCION: Alta de documento de enrolamiento de extranjero	****
********************************************************************
** Creó:		Francisco Javier Carrillo Rojas					****
** Fecha:		07/Ago/2019										****
** Help:		01278846										****
** Descripcion:	Alta de documento de enrolamiento de extranjero	****
********************************************************************/
/* Declaracion de Variables */
declare	@Dee_Id int

/* Declaracion de Constantes */
declare	@Str_C		char(1),
		@Str_Uno	char(1),
		@Str_Dos    char(1),
		@Ent_Uno	int,
		@Tip_INE	char(2),
		@Fec_Vacia	smalldatetime,
		@Str_Vacio	char(1)

/* Asignacion de Constantes */
select	@Str_C		= 'C',			/*	Tipo C 			*/
		@Str_Uno	= '1',			/*	Tipo 1 			*/
		@Str_Dos    = '2',			/*	Tipo 2			*/
		@Ent_Uno	= 1,			/*	Entero: Uno		*/
		@Tip_INE	= '01',			/*	Tipo INE 		*/
		@Fec_Vacia	= '1900-01-01',	/*	Fecha vacía		*/
		@Str_Vacio	= ''			/*	String en vacío	*/
		
select	@FechaSis	= getdate()

if not exists(select Per_Numero
				from	SOPERSON noholdlock
						inner join SOUNIPER noholdlock on Peu_Grupo	= Per_Numero
				where PerPersoID	= @PerPersoID) begin				
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'No se encontró el registro de la persona'
	rollback
	return @Ent_Uno
end

if not exists(select Tid_Numero
				from CLTIPIDE noholdlock
				where	Tid_Numero	= @Dee_NumIde) begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'No se encontró el registro de la identificación con número ' + @Dee_NumIde
	rollback
	return @Ent_Uno				
end

if isnull(ltrim(rtrim(@Dee_FolIde)), @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'El folio de identificación no puede ser vacío'
	rollback
	return @Ent_Uno				
end 

if @Dee_NumIde = @Tip_INE begin
	if isnull(@Dee_FecEmi, @Fec_Vacia) =  @Fec_Vacia begin
		select	Err_Codigo	= '000004',
				Err_Mensaj	= 'La fecha de emisión no puede ser vacía'
		rollback
		return @Ent_Uno					
	end

	if isnull(@Dee_FecVen, @Fec_Vacia) =  @Fec_Vacia begin
		select	Err_Codigo	= '000005',
				Err_Mensaj	= 'La fecha de vencimiento no puede ser vacía'
		rollback
		return @Ent_Uno				
	end
	
	if isnull(ltrim(rtrim(@Dee_Clave)), @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000006',
				Err_Mensaj	= 'La clave de elector no puede ser vacía'
		rollback
		return @Ent_Uno				
	end

	if isnull(ltrim(rtrim(@Dee_NumEmi)), @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000007',
				Err_Mensaj	= 'El número de emisión no puede ser vacío'
		rollback
		return @Ent_Uno				
	end	
end else begin
		select	@Dee_FecEmi	= @Str_Vacio,
				@Dee_FecVen	= @Fec_Vacia,
				@Dee_Clave	= @Str_Vacio,
				@Dee_NumEmi	= @Str_Vacio
end

insert into SODOENEX (PerPersoID,	Dee_NumIde,	Dee_FolIde,	Dee_FecEmi,	Dee_FecVen,
					Dee_Clave,		Dee_NumEmi,	NumTransac,	Transaccio,	Usuario,
					FechaSis,		SucOrigen,	SucDestino )
	values (@PerPersoID,	@Dee_NumIde,	@Dee_FolIde,	@Dee_FecEmi,	@Dee_FecVen,
			@Dee_Clave,		@Dee_NumEmi,	@NumTransac,	@Transaccio,	@Usuario,	
			@FechaSis,		@SucOrigen,		@SucDestino )
		
select @Dee_Id	= max(Dee_Id)
	from SODOENEX noholdlock
	where	PerPersoID	= @PerPersoID
	  and	Dee_NumIde	= @Dee_NumEmi

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro agregado',
		Dee_Id		= @Dee_Id