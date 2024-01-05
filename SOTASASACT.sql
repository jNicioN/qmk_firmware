create procedure SOTASASACT(
    @Tas_Numero char(2),
    @Tas_StaAct char(1),
    
    @NumTransac char(10),
    @Transaccio char(3),
    @Usuario 	char(6),
    @FechaSis 	smalldatetime,
    @SucOrigen 	char(3),
    @SucDestino char(3),
	@Modulo 	char(2)
) as 

/*
****************************************************************************
** Descripción : Actualiza el estatus de una tasa.               		****
****************************************************************************
** REFERENCIAS:                       									****
****************************************************************************
** Creo: 		Gerardo Santos                  				        ****
** Fecha: 		17/11/2023										        ****
** Helpdesk:    TCELTO-6430								                ****	
***************************************************************************/

/* Declaracion de constantes */
declare @Sta_Activa	char(1), 
        @Sta_Inacti char(1),
        @Ent_Uno	int,
        @Str_Vacio	char(1)

/* Asignacion de valores a constantes */
select 	@Sta_Activa 	= 'S',  /* Estatus: Activa   */
       	@Sta_Inacti 	= 'N',  /* Estatus: Inactiva */
        @Ent_Uno	    =  1,	/* Numero: Uno       */
        @Str_Vacio		= ''	/* String Vacio 	 */

/* Inicialización de variables */
select @Modulo = isnull(@Modulo,@Str_Vacio)

if not exists ( select	Tas_Numero
					from SOTASAS noholdlock
					where	Tas_Numero	= @Tas_Numero) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'La Tasa No Existe'
    rollback
	return @Ent_Uno
end 

if  @Tas_StaAct != @Sta_Activa and @Tas_StaAct != @Sta_Inacti begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Estatus no valido'
    rollback
	return @Ent_Uno
end


update SOTASAS set

    Tas_StaAct	= @Tas_StaAct,
    
    NumTransac	= @NumTransac,
    Transaccio	= @Transaccio,
    Usuario		= @Usuario,
    FechaSis	= @FechaSis,
    SucOrigen	= @SucOrigen,
    SucDestino	= @SucDestino

    where	Tas_Numero	= @Tas_Numero