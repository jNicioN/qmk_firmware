create procedure SOANAPASALT (
   @Anp_Numero int,
   @Anp_EFTiCu int,
   @Anp_VariCp numeric(10,2),
   @Anp_VariLp numeric(10,2),
   @Anp_VarTot numeric(10,2),
   @Anp_Total numeric(10,2),
   @Anp_VarObs varchar(50),
   @Anp_EstAna int,
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as

/*******************************************************************
** DESCRIPCION: Alta de registros de analitica pasivo        	  **
********************************************************************
** Creo:		Felipe Castillo Rendon                     		  **
** Fecha:		19/05/2017                               		  **
** Help:		929417 					 						  **
********************************************************************/

/* Declaracion de Variables */

DECLARE @Int_Uno int
SELECT  @Int_Uno = 1

Insert Into SOANAPAS 
	(Anp_EFTiCu,	Anp_VariCp,		Anp_VariLp,		Anp_VarTot,		Anp_Total, 
	Anp_VarObs,		Anp_EstAna,		NumTransac,		Transaccio,		Usuario, 
	FechaSis,		SucOrigen,		SucDestino) 
	values (
	@Anp_EFTiCu,    @Anp_VariCp,    @Anp_VariLp,    @Anp_VarTot,    @Anp_Total, 
	@Anp_VarObs,    @Anp_EstAna,    @NumTransac,    @Transaccio,    @Usuario, 
	@FechaSis,		@SucOrigen,		@SucDestino) 

select @Anp_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
     		Err_Mensaj = 'Relacion agregada correctamente', 
     		Anp_Numero= @Anp_Numero 
end
