create procedure SORIBMOD (
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
   @Rib_NumCon varchar(8),
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
/* DESCRIPCION: Modificacion de Reporte de Informacion Basica	*/
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

if not exists (select Rib_Numero
				from SORIB noholdlock
				where Rib_Numero = @Rib_Numero) begin
   select  Err_Codigo = '000001',
           Err_Mensaj	= 'El Número de ID: ' +  convert(varchar,@Rib_Numero) + ' No Existe',
           Err_Variab	= 'Rib_Numero'
   rollback
   return 1
end

/* Declaracion de Constantes */
declare @Int_Cero	int			/* Entero Cero */

/* Asignacion de Constantes */
select	@Int_Cero	= 0
		
Update SORIB set
	Rib_NumPer	= @Rib_NumPer,
	Rib_NumInt	= @Rib_NumInt,
	Rib_NumSol	= @Rib_NumSol,
	Rib_TipSol	= @Rib_TipSol,
	Rib_TipRib	= @Rib_TipRib,
	Rib_FecEla	= @Rib_FecEla,
	Rib_SucSol	= @Rib_SucSol,
	Rib_ConNom	= @Rib_ConNom,
	Rib_ConPue	= @Rib_ConPue,
	Rib_PagWeb	= @Rib_PagWeb, 
	Rib_ActCat	= @Rib_ActCat, 
	Rib_ActEsp	= @Rib_ActEsp, 
	Rib_MerObj	= @Rib_MerObj, 
	Rib_LlViOc	= @Rib_LlViOc, 
	Rib_UsuCap	= @Rib_UsuCap,
	Rib_NoAlGo	= @Rib_NoAlGo, 
	Rib_PaEnPo	= @Rib_PaEnPo, 
	Rib_CabCon	= @Rib_CabCon, 
	Rib_FeCaPo	= @Rib_FeCaPo,
	Rib_EmOtCr	= @Rib_EmOtCr,
	Rib_EmSuRe	= @Rib_EmSuRe,
	Rib_FeInOp	= @Rib_FeInOp,
	Rib_DurSoc	= @Rib_DurSoc,
	Rib_CotBol	= @Rib_CotBol,
	Rib_NumApo	= @Rib_NumApo,
	Rib_NumCon  = @Rib_NumCon,
	Rib_CliSuc  = @Rib_CliSuc,
	Rib_ZonUsu  = @Rib_ZonUsu,
	Rib_EdoCiv  = nullif(@Rib_EdoCiv, @Int_Cero),
	Rib_NumExt	= @Rib_NumExt,
	Rib_LugCon	= @Rib_LugCon,
	NumTransac	= @NumTransac, 
	Transaccio	= @Transaccio, 
	Usuario		= @Usuario, 
	FechaSis	= @FechaSis, 
	SucOrigen	= @SucOrigen, 
	SucDestino	= @SucDestino
where Rib_Numero = @Rib_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Rib_Numero = @Rib_Numero
