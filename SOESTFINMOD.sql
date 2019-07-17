create procedure SOESTFINMOD (
   @Esf_Numero int,
   @Esf_TipFor int,
   @Esf_Anio   int,
   @Esf_MesIni int,
   @Esf_MesFin int,
   @Esf_TiEsFi int,
   @Esf_ExpCif int,
   @Esf_Moneda varchar(2),
   @Esf_NomCon varchar(180),
   @Esf_NuCePr varchar(180),
   @Esf_DesDic varchar(180),
   @Esf_PerNum int,
   @Esf_Solici int,
   @Esf_EsEsFi int,
   @Esf_ValInp float,
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as
 
/****************************************************************/
/* DESCRIPCION: Modifica registros de estado financiero			*/
/****************************************************************/
/** Modifico:    Jose Rodriguez									*/
/** Fecha:		 16/07/2019                               		*/
/** Descripcion: Se agregan campos Esf_NomCon, Esf_NuCePr y     */
/**				 Esf_DesDic  									*/
/** Help:		 1264694				 						*/
/****************************************************************/
/** Creo:		Felipe Castillo									*/
/** Fecha:		19/05/2017                               		*/
/** Help:		929417 					 						*/
/****************************************************************/

update SOESTFIN set
   Esf_Anio		= @Esf_Anio,
   Esf_MesIni	= @Esf_MesIni,
   Esf_MesFin	= @Esf_MesFin,
   Esf_TiEsFi	= @Esf_TiEsFi,
   Esf_Moneda	= @Esf_Moneda,
   Esf_NomCon	= @Esf_NomCon,
   Esf_NuCePr	= @Esf_NuCePr,	
   Esf_DesDic	= @Esf_DesDic,
   Esf_Solici	= @Esf_Solici,
   Esf_PerNum	= @Esf_PerNum,
   Esf_EsEsFi	= @Esf_EsEsFi,
   Esf_ValInp	= @Esf_ValInp,
   Esf_UsuMod	= @Usuario,
   Esf_FecMod	= @FechaSis,
   NumTransac	= @NumTransac,
   Transaccio	= @Transaccio,
   Usuario		= @Usuario,
   FechaSis		= @FechaSis,
   SucOrigen	= @SucOrigen,
   SucDestino	= @SucDestino
where Esf_Numero = @Esf_Numero

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Esf_Numero = @Esf_Numero