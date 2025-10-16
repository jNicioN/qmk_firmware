create procedure SOPARAMSACT(
	@Par_Sucurs	char(3),
	@Par_HoEnSp	smalldatetime,
	@Par_TiCaDi	char(3),
	@Tip_Actual	char(1),
    @Par_ISR	smallmoney,

 	@NumTransac	char(10), 		
 	@Transaccio	char(3), 	   
 	@Usuario	char(6), 
 	@FechaSis	smalldatetime, 	
 	@SucOrigen	char(3), 	   
 	@SucDestino	char(3),
 	@Modulo		char(2))

as


/***************************************************************************
** DESCRIPCION: ** Actualizacion de Parametros  de Soporte 				****
****************************************************************************
** REFERENCIAS: 														****
****************************************************************************
 *** Modificó:	Kevin Quiroz					 						****
** Fecha:		015/Octubre/2024										****
** Help Desk:	TCELER-15538-8668										****
** Descripcion: Se agrega actualiacion para Par_ISR	                    ****
****************************************************************************/

/* Declaraciòn de Envio */
declare	@Par_HorEnv	smalldatetime

/* Declaracion de Constantes	*/
declare	@Act_HorSpe	char(1),
		@Act_HorEnv	char(1),
		@Str_Vacio	char(1),
		@Act_TiCaDi	char(1),
		@Act_ISR	char(1)

/*Asignacion de Constantes		*/
select	@Act_HorSpe	= 'H',		/* Tipo de Actualizacion de Horario de SPEI	*/
		@Act_HorEnv	= 'E',		/* Tipo de Actualizacion de Envio de SPEI en todas las sucursales	*/
		@Str_Vacio	= '',		/* String Vacio								*/
		@Act_TiCaDi	= 'C',		/* Act. Tipo de Cambio Diferenciado	*/
		@Act_ISR	= 'I'		/* Act. ISR */

if @Tip_Actual not in (@Act_HorSpe, @Act_HorEnv, @Act_TiCaDi,@Act_ISR) begin
	select	Err_Codigo = '000001',
			Err_Mensaj = 'Tipo de Actualización Incorrecto',
			Err_Variab = @Str_Vacio
	rollback
	return 1
end

if @Tip_Actual = @Act_HorSpe begin
	if not exists (select Par_Sucurs 
						from SOPARAMS noholdlock
						where	Par_Sucurs	= @Par_Sucurs) begin
		select	Err_Codigo = '000002',
				Err_Mensaj = 'Los Parametros de la Sucursal no Existen',
				Err_Variab = @Str_Vacio
		rollback
		return 1
	end
	
	update SOPARAMS set
		Par_HoEnSp	= @Par_HoEnSp
		where	Par_Sucurs = @Par_Sucurs

end else if @Tip_Actual = @Act_HorEnv begin
	
	update SOPARAMS set
		Par_HoEnSp	= @Par_HoEnSp

end else if @Tip_Actual = @Act_TiCaDi begin
	update SOPARAMS set
		Par_TiCaDi	= @Par_TiCaDi
		where	Par_Sucurs	= @Par_Sucurs
end else if @Tip_Actual = @Act_ISR begin
    update SOPARAMS set
        Par_ISR = @Par_ISR
end