create procedure SORESACCCON (
    @Rea_Numero  int,
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
** DESCRIPCIÓN: Consulta de restricción de accesos                       **
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
		@Tip_ConUno	char(1)

/* Asignación de constantes */
select	@Tip_ConInd	= 'C',		/* Tipo Consulta Individual*/
		@Tip_ConUno	= '1'		/* Tipo Consulta Uno */

select @Tip_ConTip = substring(@Tip_Consul, 1, 1),
       @Tip_ConCon = substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = @Tip_ConInd begin
    if @Tip_ConCon = @Tip_ConUno begin
        select Rea_Descri, Rea_TipRes, Rea_FecRes
        from SORESACC noholdlock
        where Rea_Numero = @Rea_Numero
    end
end