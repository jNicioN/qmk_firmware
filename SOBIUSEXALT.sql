create procedure SOBIUSEXALT (
	@Bue_Numero		int,	
	@Bue_NomUsu		varchar(40), 
	@Bue_ApPaUs		varchar(40), 
	@Bue_ApMaUs		varchar(40),
	@Bue_FecNac		smalldatetime,			
	@Bue_SexUsu		char(1),
	@Bue_PaNaUs		char(3), 
	@Bue_LuNaUs		varchar(50),
	@Bue_CaDoUs		varchar(40),
	@Bue_PrEnCa		varchar(40),
	@Bue_SeEnCa		varchar(40), 
	@Bue_NuDoUs		char(10),
	@Bue_CoDoUs		varchar(150), 
	@Bue_EntDom		char(3),
	@Bue_LocDom		char(8), 
	@Bue_CpDoUs		char(6),
	@Bue_LaTeUs		char(8),
	@Bue_TelUsu		char(15),
	@Bue_CorUsu		varchar(50), 
	@Bue_ActUsu		char(10),
	@Bue_AcInUs		char(10), 
	@Bue_OcuUsu		varchar(30), 
	@Bue_TiIdUs		char(1), 
	@Bue_NumIde		varchar(30),
	@Bue_ViIdUs		char(1),
	@Bue_FeExId		smalldatetime, 		
	@Bue_FeVeId		smalldatetime, 
	@Bue_CaDoEx		varchar(40), 
	@Bue_NuDoEx		char(10), 
	@Bue_CoDoEx		varchar(150), 
	@Bue_LoDoEx		varchar(40),
	@Bue_EnDoEx		varchar(40),
	@Bue_PaDoEx		char(3), 
	@Bue_CpDoEx		char(6),
	@Bue_TelExt		varchar(20),

	@NumTransac	char(10),
	@Transaccio char(3), 
	@Usuario	char(6), 
	@FechaSis	smalldatetime, 
	@SucOrigen	char(3),
	@SucDestino char(3))

as

/**
*****************************************************************
** Descripción : Alta de Bitacora de Usuario Extranjero			*
*				 para compra de dolares.						*
*****************************************************************
** Referencias: 												*
*****************************************************************
* ** Creo:	Francisco Minajas								 ****
** Fecha:		19/01/2026							         ****
** Jira:	    TRAAC-9198									 ****
** Descripción:	Se crea SP									 ****
*****************************************************************
**/

declare @Use_NumInt int,
		@Use_ViIdUs	char(1),
		@Ent_Identi	int,
		@Control	int	
		
--Declaracion de constantes
declare	@Ent_Uno	int,
		@Fec_Actual  	smalldatetime,
		@Bue_NoCoUs	varchar(120),
		@Str_Vacio	char(1),
		@Use_Numero		char(8),
		@Ent_Cero	int

--Asignaciýn de valores a constantes 	
select	@Ent_Uno 	= 1,
		@Str_Vacio	= '',
		@Ent_Cero	= 0,			/* Entero en Cero */
		@Ent_Uno	= 1			/* Entero en Uno */
	

select @Use_Numero = (convert(char(8), Une_IdeUsu ))
from SOUSNAEX noholdlock inner join SOUSUEXT noholdlock on Une_IdeUsu = Use_IdUsEx 
where Une_Identi = @Bue_Numero

if isnull(@Use_Numero, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000013',
			Err_Mensaj	= 'Proporcione numero de usuario'
	rollback
	return @Ent_Uno
end

select	@Use_NumInt	= (convert(int, @Use_Numero ))	


select @Fec_Actual = Par_FecAct
from SOPARAMS noholdlock
where Par_Sucurs = @SucOrigen

select @Bue_NoCoUs = (ltrim(rtrim(@Bue_ApPaUs))+' '+ltrim(rtrim(@Bue_ApMaUs))+' '+ltrim(rtrim(@Bue_NomUsu)))

insert into SOBIUSEX (
	Bue_IdUsEx,
	Bue_NumSuc, Bue_FecCre, Bue_NomUsu, Bue_ApPaUs, Bue_ApMaUs,	
	Bue_NoCoUs, Bue_FecNac, Bue_SexUsu, Bue_PaNaUs, Bue_LuNaUs, 
	Bue_CaDoUs,	Bue_PrEnCa, Bue_SeEnCa, Bue_NuDoUs, Bue_CoDoUs, 
	Bue_EntDom,	Bue_LocDom, Bue_CpDoUs, Bue_LaTeUs, Bue_TelUsu,
	Bue_CorUsu,	Bue_ActUsu, Bue_AcInUs, Bue_OcuUsu, Bue_TiIdUs,	
	Bue_NumIde, Bue_ViIdUs, Bue_FeExId, Bue_FeVeId, Bue_CaDoEx, 
	Bue_NuDoEx,	Bue_CoDoEx, Bue_LoDoEx, Bue_EnDoEx, Bue_PaDoEx,	
	Bue_CpDoEx,	Bue_TelExt, NumTransac, Transaccio, Usuario,    
	FechaSis, 	SucOrigen,  SucDestino		
) values	(
	@Use_NumInt,
	@SucOrigen, @Fec_Actual,  @Bue_NomUsu, @Bue_ApPaUs, @Bue_ApMaUs,	
	@Bue_NoCoUs, @Bue_FecNac, @Bue_SexUsu, @Bue_PaNaUs, @Bue_LuNaUs, 	
	@Bue_CaDoUs, @Bue_PrEnCa, @Bue_SeEnCa, @Bue_NuDoUs, @Bue_CoDoUs, 
	@Bue_EntDom, @Bue_LocDom, @Bue_CpDoUs, @Bue_LaTeUs, @Bue_TelUsu,	
	@Bue_CorUsu, @Bue_ActUsu, @Bue_AcInUs, @Bue_OcuUsu, @Bue_TiIdUs, 	
	@Bue_NumIde, @Bue_ViIdUs, @Bue_FeExId, @Bue_FeVeId, @Bue_CaDoEx, 	
	@Bue_NuDoEx, @Bue_CoDoEx, @Bue_LoDoEx, @Bue_EnDoEx, @Bue_PaDoEx,		
	@Bue_CpDoEx, @Bue_TelExt, @NumTransac, @Transaccio, @Usuario,    
	@FechaSis,   @SucOrigen,  @SucDestino		
)

if @@nestlevel = @Ent_Uno
	select	Err_Codigo = '000000',
			Err_Mensaj = 'Registro Agregado'
