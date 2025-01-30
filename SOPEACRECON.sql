create procedure SOPEACRECON (
    @Par_Numero  int,
    @Par_ResAcc  int,
    @Tip_Consul  char(2),
    @NumTransac  char(10),
    @Transaccio  char(3),
    @Usuario     char(6),
    @FechaSis    smalldatetime,
    @SucOrigen   char(3),
    @SucDestino  char(3),
    @Modulo      char(2))
as
/***************************************************************************
** DESCRIPCIÓN: Consulta de perfiles con accesos restringidos            **
****************************************************************************
**                                                                       **
** REFERENCIAS:                                                          **
****************************************************************************
** Creó: Félix González Morales                                          **
** Fecha: 20/Diciembre/2024                                              **
** HelpDesk: 49934                                                       **
****************************************************************************/

/* Declaración de variables */
declare @Tip_ConTip char(1), 
		@Tip_ConCon char(1)
		
/* Declaración de constantes */
declare	@Tip_ConInd	char(1),
		@Tip_ConLis	char(1),
		@Tip_ConUno	char(1)

/* Asignación de constantes */
select	@Tip_ConInd	= 'C',		/* Tipo Consulta Individual*/
		@Tip_ConLis	= 'L',		/* Tipo Consulta Lista*/
		@Tip_ConUno	= '1'		/* Tipo Consulta Uno */

select @Tip_ConTip = substring(@Tip_Consul, 1, 1),
       @Tip_ConCon = substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = @Tip_ConInd begin
    if @Tip_ConCon = @Tip_ConUno begin
        select Par_ResAct, Par_FecReg, Par_ResAcc, Par_Pantal, Par_Perfil
        from SOPEACRE noholdlock
        where Par_Numero = @Par_Numero
    end
end else if @Tip_ConTip = @Tip_ConLis begin
	if @Tip_ConCon = @Tip_ConUno begin
        select Par_ResAct, Par_FecReg, Par_ResAcc, Par_Pantal, Par_Perfil
        from SOPEACRE noholdlock
        where Par_ResAcc = @Par_ResAcc
    end
end