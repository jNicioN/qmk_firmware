create procedure SODIRPERMOD (
	@PerPersoID int,
	@Dip_TipDir	int,
	@ClClientID	int,
	@Dip_Calle	char(60),
	@Dip_NumExt	char(10),
	@Dip_NumInt	char(10),
	@Dip_NumCP	char(6),
	@Dip_EntCa1	varchar(255),
	@Dip_EntCa2	varchar(255),
	@Dip_Refere	varchar(255),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/***************************************************************************
** Descripción:	 Modificación de Descripcion							****
****************************************************************************
** Modifico:		Alberto Pineda										****
** Fecha:			15-07-2022											****
** Help:			TRACL-5312												****
** Descripcion: 	Se agregan mas caracteres al campo Dip_Calle        ****
                    De 40 se pasa a 60                          		****
****************************************************************************
** Modifico:		Adriana Gomez										****
** Fecha:		    06-06-2022											****
** Help:		    1621179												****
** Descripcion:		Se modifica validacion cliente y persona			****
****************************************************************************
** Modifico:		Carlos Ramirez										****
** Fecha:		    17-12-2020											****
** Help:		    1437949												****
** Descripcion:		Se agrega validacion para @Dim_NumCP				****
****************************************************************************
** Modifico:		Carlos Ramirez										****
** Fecha:		    17-12-2020											****
** Help:		    1437949												****
** Descripcion:		Se agrega validacion para @Dim_NumCP				****
****************************************************************************
** Modifico:			Norma Tijerina									****
** Fecha:		    31-05-2017											****
** Help:		    00946339											****
** Descripcion:	Se sacan del select la Bdp_FecCam y El Modulo			****
****************************************************************************
** Modifico:			Norma Tijerina									****
** Fecha:		    04-05-2017											****
** Help:		    00946339											****
****************************************************************************
** Creó:			Roberto Saldivar									****
** Fecha:		    17-03-2017											****
** Help:		    00909908											****
****************************************************************************/

										/* Declaracion de variables */
declare @Val_Existe int

										/* Declaración de constantes */
declare	@Status		int,
		@Str_Vacio	char(1),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Bdp_TipDir int,
		@Bdp_Calle	char(60), 
		@Bdp_NumExt char(10),
		@Bdp_NumInt char(10),
		@Bdp_NumCP  char(6),
		@Bdp_EntCa1 varchar(255),
		@Bdp_EntCa2 varchar(255),
		@Bdp_Refere varchar(255),
		@Bdp_Status	char(1),
		@Bdp_FecCam	smalldatetime,
		@Bdp_NumTra	char(10),
		@Bdp_Transa	char(3),
		@Bdp_Usuari	char(6),
		@Bdp_FecSis	smalldatetime,
		@Bdp_SucOri	char(3),
		@Bdp_SucDes	char(3),
		@Str_A		char(1), 
		@Bdp_Modulo	char(2)
										/* Asignación de constantes */
select	@Str_Vacio	= '',				/* String vacío */
		@Ent_Cero	= 0,				/* Entero en cero */
		@Ent_Uno	= 1	,				/* Entero en uno */
		@Str_A		= 'A'
		
		
/* Validaciones */
if @PerPersoID = @Ent_Cero and @ClClientID = @Ent_Cero begin

	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Error con el parámetro:@PerPersoID o  @ClClientID.',
			Err_Variab	= '@ClClientID'
	rollback
	return @Ent_Uno

end

if @Dip_TipDir = @Ent_Cero begin

	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Error con el parámetro: @Dip_TipDir.',
			Err_Variab	= '@Dip_TipDir'
	rollback
	return @Ent_Uno

end

--Se agrega validacion para @Dip_NumCP
select @Val_Existe = @Ent_Cero
	select @Val_Existe = count(Cpc_Numero)
		from CLCODPOS noholdlock
			where	Cpc_Numero	= @Dip_NumCP
		if @Val_Existe <= @Ent_Cero 
		begin
			select	Err_Codigo	= '000004',
					Err_Mensaj	= 'El parámetro @Dip_NumCP no es valido.',
					Err_Variab	= '@Dip_NumCP'
			rollback
		end

select 
	@Bdp_TipDir 	= Dip_TipDir,
	@Bdp_Calle		= Dip_Calle, 
	@Bdp_NumExt    	= Dip_NumExt,
	@Bdp_NumInt    	= Dip_NumInt,
	@Bdp_NumCP     	= Dip_NumCP,
	@Bdp_EntCa1    	= Dip_EntCa1,
	@Bdp_EntCa2    	= Dip_EntCa2,
	@Bdp_Refere    	= Dip_Refere,
	@Bdp_Status		= Dip_Status,
	@Bdp_NumTra		= NumTransac,
	@Bdp_Transa		= Transaccio,
	@Bdp_Usuari		= Usuario,
	@Bdp_FecSis		= FechaSis,
	@Bdp_SucOri		= SucOrigen,
	@Bdp_SucDes		= SucDestino
	from SODIRPER noholdlock 
	where PerPersoID	= @PerPersoID
		and Dip_TipDir	= @Dip_TipDir
		and ClClientID	= @ClClientID
		
select @Bdp_FecCam = @FechaSis,
	   @Bdp_Modulo = @Modulo	


/*Agregamos a registro a la bitacora de Direcciones de Persona*/
exec @Status = 	SOBIDIPEALT 	
	@PerPersoID, 	@Bdp_TipDir,	 @ClClientID, 	@Bdp_Calle, 	 @Bdp_NumExt,	@Bdp_NumInt, 	
	@Bdp_NumCP, 	@Bdp_EntCa1,	 @Bdp_EntCa2, 	@Bdp_Refere,	 @Bdp_Status,	@Bdp_FecCam, 	
	@Bdp_NumTra, 	@Bdp_Transa, 	@Bdp_Usuari, 	 @Bdp_FecSis, 	@Bdp_SucOri, 	@Bdp_SucDes, @Bdp_Modulo
	

if @Status <> @Ent_Cero begin
		rollback
		return 1
	end


/* Modificación de Descripcion */
update SODIRPER set
	Dip_Calle	= @Dip_Calle,
	Dip_NumExt	= @Dip_NumExt,
	Dip_NumInt	= @Dip_NumInt,
	Dip_NumCP	= @Dip_NumCP,
	Dip_EntCa1	= @Dip_EntCa1,
	Dip_EntCa2	= @Dip_EntCa2,
	Dip_Refere	= @Dip_Refere,
	Dip_Status  = @Str_A,
	
	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino
	where	ClClientID	= @ClClientID
	and		Dip_TipDir = @Dip_TipDir
	and 	PerPersoID	= @PerPersoID

if @@nestlevel = @Ent_Uno
select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro modificado'