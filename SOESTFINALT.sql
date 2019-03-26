create procedure SOESTFINALT (
   @Esf_Numero int,
   @Esf_TipFor int,
   @Esf_Anio int,
   @Esf_MesIni int,
   @Esf_MesFin int,
   @Esf_TiEsFi int,
   @Esf_ExpCif int,
   @Esf_Moneda varchar(2),
   @Esf_PerNum int,
   @Esf_Solici int,
   @Esf_EsEsFi int,
   @Esf_ValInp float,
   @Esf_ConAct  int,
   @Esf_AplIca bit,
   @Esf_Icap numeric(10,2),
   @Esf_CapNet numeric(10,2),
   @Esf_AcSuRi numeric(10,2),
   @Esf_TipSol int,
   @Esf_TipLiq int,
   @Esf_TipEfi int,
   @Esf_Status bit,
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as 
 
/****************************************************************/
/* DESCRIPCION: Alta de registros de estados financieros        */
/****************************************************************/
/** Modifico:	Edwin Santiago								    */
/** Fecha:		27/11/2018                               		*/
/** Descripcion: Se agrega campo Eft_ConAct						*/
/** Help:		1074432 					 					*/
/****************************************************************/
/** Creo:		Felipe Castillo									*/
/** Fecha:		19/05/2017                               		*/
/** Help:		929417 					 						*/
/****************************************************************/

/* Declaracion de Constantes */
declare @Int_Uno int	/* Entero Uno*/

/* Asignacion de constantes*/
select  @Int_Uno = 1

insert into SOESTFIN 
	(Esf_TipFor,	Esf_Anio,		Esf_MesIni,		Esf_MesFin,		Esf_TiEsFi, 
    Esf_ExpCif,		Esf_Moneda,		Esf_PerNum,		Esf_Solici,		Esf_EsEsFi,
	Esf_ValInp,		Esf_AplIca,		Esf_Icap,		Esf_CapNet,		Esf_AcSuRi,
	Esf_TipSol,		Esf_TipLiq,		Esf_TipEfi,		Esf_Status,		Esf_ConAct ,
	Esf_UsuCre,		Esf_FecCre,		Esf_UsuMod,		Esf_FecMod,		NumTransac,		
	Transaccio,		Usuario,		FechaSis,		SucOrigen,		SucDestino)
values (
	@Esf_TipFor,	@Esf_Anio,		@Esf_MesIni,	@Esf_MesFin,	@Esf_TiEsFi,
    @Esf_ExpCif,    @Esf_Moneda,	@Esf_PerNum,	@Esf_Solici,	@Esf_EsEsFi,
	@Esf_ValInp,    @Esf_AplIca,	@Esf_Icap,		@Esf_CapNet,	@Esf_AcSuRi,
	@Esf_TipSol,    @Esf_TipLiq,	@Esf_TipEfi,    @Esf_Status,	@Esf_ConAct ,
	@Usuario,		@FechaSis,		@Usuario,		@FechaSis,		@NumTransac,    
	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino)

select @Esf_Numero = @@IDENTITY

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
			Err_Mensaj = 'Relacion agregada correctamente', 
			Esf_Numero= @Esf_Numero 
end