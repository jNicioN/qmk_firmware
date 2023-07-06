create procedure SORIBALT (
   @Rib_Numero int,
   @Rib_NumPer char(8),
   @Rib_NumInt int,
   @Rib_NumSol int,
   @Rib_TipSol int,
   @Rib_TipRib int,
   @Rib_FecEla datetime,
   @Rib_SucSol varchar(3),
   @Rib_ConNom varchar(80),
   @Rib_ConPue varchar(75),
   @Rib_PagWeb varchar(50),
   @Rib_ActCat varchar(10),
   @Rib_ActEsp varchar(75),
   @Rib_MerObj bit,
   @Rib_LlViOc varchar(30),
   @Rib_UsuCap varchar(6),
   @Rib_NoAlGo varchar(50),
   @Rib_PaEnPo varchar(50),
   @Rib_CabCon varchar(50),
   @Rib_FeCaPo datetime,
   @Rib_EmOtCr bit,
   @Rib_EmSuRe bit,
   @Rib_FeInOp datetime,
   @Rib_DurSoc int,
   @Rib_CotBol bit,
   @Rib_NumApo varchar(8),
   @Rib_NumCon char(8),
   @Rib_CliSuc int,
   @Rib_ZonUsu int,
   @Rib_EdoCiv int,
   @Rib_NumExt varchar(5),
   @Rib_LugCon varchar(150),
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2))
as

/****************************************************************/
/* DESCRIPCION: Alta de Reporte de Informacion Basica	      	*/
/****************************************************************/
/* Modifico:		Raul Muniz									*/
/* Fecha:			06/07/2023									*/
/* C.Cambios:		29013										*/
/* Descripcion:		Se agrega validacion para evitar duplicidad	*/
/*					de RIB base									*/
/****************************************************************/
/** Modifica:		Victor Osorio								*/
/** Descripcion:	Se agrega campo Rib_LugCon					*/
/** Fecha:			18/10/2017                               	*/
/** Help:			929417 					 					*/
/****************************************************************/
/** Creo:			Jorge Armando Garcia						*/
/** Fecha:			30/03/2017                               	*/
/** Help:			929417 					 					*/
/****************************************************************/

/* Declaracion de Constantes */
DECLARE @Int_Cero	int,			/* Constante para valor Cero */
		@Int_Uno 	int,			/* Constante para valor Uno */
		@Fec_Null	smalldatetime,	/* Constante con valor de la fecha null */
		@Status		int				/* Campo de retorno */


/* Asignacion de Constantes */
SELECT	@Int_Cero	= 0,
		@Int_Uno 	= 1,
		@Fec_Null	= null
		
/* Validar si es RIB Base */
if	@Rib_NumSol = @Int_Cero begin
	/* Si existe Rib Persona Base, se actualiza registro */
	if exists (select Rib_Numero from SORIB where Rib_NumPer = @Rib_NumPer and Rib_NumSol = @Int_Cero) begin
		exec @Status = SORIBMOD
			@Rib_Numero,	@Rib_NumPer,	@Rib_NumInt,	@Rib_NumSol,	@Rib_TipSol,
			@Rib_TipRib,	@Rib_FecEla,	@Rib_SucSol,	@Rib_ConNom,	@Rib_ConPue,
			@Rib_PagWeb,	@Rib_ActCat,	@Rib_ActEsp,	@Rib_MerObj,	@Rib_LlViOc,
			@Rib_UsuCap,	@Rib_NoAlGo,	@Rib_PaEnPo,	@Rib_CabCon,	@Rib_FeCaPo,
			@Rib_EmOtCr,	@Rib_EmSuRe,	@Rib_FeInOp,	@Rib_DurSoc,	@Rib_CotBol,
			@Rib_NumApo,	@Rib_NumCon,	@Rib_CliSuc,	@Rib_ZonUsu,	@Rib_EdoCiv,
			@Rib_NumExt,	@Rib_LugCon,	@NumTransac,	@Transaccio,	@Usuario,
			@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
			
		if @Status <> @Int_Cero begin
			select	Err_Codigo	= '000001',
				Err_Mensaj	= 'Error en proceso de modificacion de Rib BASE'

			rollback
			return @Int_Uno
		end
	end else begin
		insert into SORIB (
				Rib_NumPer,    	Rib_NumInt,		Rib_NumSol,    	Rib_TipSol,		Rib_TipRib,
				Rib_FecEla,		Rib_SucSol,    	Rib_ConNom,		Rib_ConPue,    	Rib_PagWeb,
				Rib_ActCat,		Rib_ActEsp,    	Rib_MerObj,		Rib_LlViOc,    	Rib_UsuCap,
				Rib_NoAlGo,		Rib_PaEnPo,		Rib_CabCon,		Rib_FeCaPo,		Rib_EmOtCr,
				Rib_EmSuRe,		Rib_FeInOp,		Rib_DurSoc,		Rib_CotBol,		Rib_NumApo,
				Rib_NumCon,	    Rib_CliSuc, 	Rib_ZonUsu, 	Rib_EdoCiv, 	Rib_NumExt,
				Rib_LugCon,		NumTransac,		Transaccio,		Usuario,		FechaSis,
				SucOrigen,		SucDestino)
		values (@Rib_NumPer,    @Rib_NumInt,	@Rib_NumSol,    @Rib_TipSol,	@Rib_TipRib,
				@Fec_Null,		@Rib_SucSol,    @Rib_ConNom,	@Rib_ConPue,    @Rib_PagWeb,
				@Rib_ActCat,	@Rib_ActEsp,    @Rib_MerObj,	@Rib_LlViOc,    @Rib_UsuCap,
				@Rib_NoAlGo,	@Rib_PaEnPo,	@Rib_CabCon,    @Rib_FeCaPo,	@Rib_EmOtCr,
				@Rib_EmSuRe,	@Rib_FeInOp,	@Rib_DurSoc,	@Rib_CotBol,	@Rib_NumApo,
				@Rib_NumCon,	@Rib_CliSuc,	@Rib_ZonUsu,	nullif(@Rib_EdoCiv, @Int_Cero),
				@Rib_NumExt,	@Rib_LugCon,	@NumTransac,	@Transaccio,	@Usuario,
				@FechaSis,		@SucOrigen,		@SucDestino)
	end
end else begin
	insert into SORIB (
			Rib_NumPer,    	Rib_NumInt,		Rib_NumSol,    	Rib_TipSol,		Rib_TipRib,
			Rib_FecEla,		Rib_SucSol,    	Rib_ConNom,		Rib_ConPue,    	Rib_PagWeb,
			Rib_ActCat,		Rib_ActEsp,    	Rib_MerObj,		Rib_LlViOc,    	Rib_UsuCap,
			Rib_NoAlGo,		Rib_PaEnPo,		Rib_CabCon,		Rib_FeCaPo,		Rib_EmOtCr,
			Rib_EmSuRe,		Rib_FeInOp,		Rib_DurSoc,		Rib_CotBol,		Rib_NumApo,
			Rib_NumCon,	    Rib_CliSuc, 	Rib_ZonUsu, 	Rib_EdoCiv, 	Rib_NumExt,
			Rib_LugCon,		NumTransac,		Transaccio,		Usuario,		FechaSis,
			SucOrigen,		SucDestino)
	values (@Rib_NumPer,    @Rib_NumInt,	@Rib_NumSol,    @Rib_TipSol,	@Rib_TipRib,
			@Fec_Null,		@Rib_SucSol,    @Rib_ConNom,	@Rib_ConPue,    @Rib_PagWeb,
			@Rib_ActCat,	@Rib_ActEsp,    @Rib_MerObj,	@Rib_LlViOc,    @Rib_UsuCap,
			@Rib_NoAlGo,	@Rib_PaEnPo,	@Rib_CabCon,    @Rib_FeCaPo,	@Rib_EmOtCr,
			@Rib_EmSuRe,	@Rib_FeInOp,	@Rib_DurSoc,	@Rib_CotBol,	@Rib_NumApo,
			@Rib_NumCon,	@Rib_CliSuc,	@Rib_ZonUsu,	nullif(@Rib_EdoCiv, @Int_Cero),
			@Rib_NumExt,	@Rib_LugCon,	@NumTransac,	@Transaccio,	@Usuario,
			@FechaSis,		@SucOrigen,		@SucDestino)
end

select @Rib_Numero = @@IDENTITY

if @@nestlevel = @Int_Uno begin
     select Err_Codigo = '000000',
			Err_Mensaj = 'Registro agregada correctamente',
			Rib_Numero= @Rib_Numero
end