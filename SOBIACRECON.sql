create procedure SOBIACRECON (
    @Bar_Usuari  char(6),
    @Fec_Inicio  smalldatetime,
    @Fec_Fin     smalldatetime,
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
** DESCRIPCIÓN: Consulta de bitácora de cambios en perfiles restringidos **
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
		@Tip_ConUno char(1),
		@Fec_Vacia  smalldatetime

/* Asignación de constantes */
select	@Tip_ConInd	= 'C',		     /* Tipo Consulta Individual*/
		@Tip_ConLis	= 'L',		     /* Tipo Consulta Lista */
		@Tip_ConUno	= '1',		     /* Tipo Consulta Uno */
		@Fec_Vacia	= '1900-01-01'   /* Fecha Vacia	*/

select @Tip_ConTip = substring(@Tip_Consul, 1, 1),
       @Tip_ConCon = substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = @Tip_ConInd begin
    if @Tip_ConCon = @Tip_ConUno begin
        select Bar_ResAct, Bar_FecReg, Bar_MotCam, Bar_PeAcRe, Bar_Pantal, Bar_Usuari
        from SOBIACRE noholdlock
        where Bar_Usuari = @Bar_Usuari
    end
else if @Tip_ConTip = @Tip_ConLis begin
	if @Tip_ConCon = @Tip_ConUno begin
		if isnull(@Fec_Inicio, @Fec_Vacia) = @Fec_Vacia
	    	select	Err_Codigo	= '000001', 
					Err_Mensaj	= 'La fecha de inicio y fecha de fin son obligatorios para la consulta.'
			return 1
	    end else begin
	        select Bar_ResAct, Bar_FecReg, Bar_MotCam, Bar_PeAcRe, Bar_Pantal, Bar_Usuari
	        from SOBIACRE noholdlock
	        where Bar_FecReg between @Fec_Inicio and @Fec_Fin
	        order by Bar_FecReg asc
        end
    end
end