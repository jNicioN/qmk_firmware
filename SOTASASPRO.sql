create procedure SOTASASPRO (
    @Tas_Numero char(2),
    @Tas_Descri varchar(80),
    @Tas_Abrevi varchar(10),
    @Tas_Valor double precision, 
    @Tas_Valor2 double precision, 
    @Tas_Fecha  smalldatetime,
    @Tas_Moneda char(2),
    @Tas_SelPar char(1), 
    @Tas_StaAct char(1),
    @Tip_Proces char(1),
    
    @NumTransac char(10),
    @Transaccio char(3),
    @Usuario    char(6),
    @FechaSis   smalldatetime,
    @SucOrigen  char(3),
    @SucDestino char(3),
    @Modulo     char(2) 
)
as

/*****************************************************************************/
/* DESCRIPCION: Alta y modificaciones de tasas para next                     */
/*****************************************************************************/
/** REFERENCIAS:                                                           ****  
*******************************************************************************
** Creó:	    Gerardo Santos          				                   ****
** Fecha:	    17/11/2023        					                       ****
** Helpdesk:    TCELTO-6430					                               ****
** Descripcion:	Da de alta tasas y actualiza su estatus segun dependa      ****
**              Modifica la informacion de las tasas                       ****    
**              Proceso creado para la migracion a next                    ****
******************************************************************************/

/*Declaracion de constantes*/
declare @Pro_Alta       char(1),
        @Pro_Modifi     char(1),
        @Sta_Activa     char(1),
        @Ent_Cero	int,
		@Ent_Uno	int


/*Asignacion de constantes*/
select  @Pro_Alta       = 'A',  /* Tipo de Proceso: Alta         */
        @Pro_Modifi     = 'M',  /* Tipo de Proceso: Modificacion */
        @Sta_Activa     = 'S',  /* Estatus:         Activa       */
		@Ent_Cero	    = 0,	/* Numero:          Cero         */
		@Ent_Uno	    = 1		/* Numero:          Uno          */

/*Declara variables*/
declare @Status		    int		/* Campo de retorno */

if @Tip_Proces	= @Pro_Alta begin
    begin transaction
        /*Se ejecuta el alta de la tasa */
        exec  @Status = SOTASASALT @Tas_Numero, @Tas_Descri, @Tas_Abrevi, @Tas_Valor,  @Tas_Fecha,
                                   @Tas_Moneda, @Tas_SelPar, @NumTransac, @Transaccio, @Usuario,
                                   @FechaSis,   @SucOrigen,  @SucDestino, @Modulo

        if @Status <> @Ent_Cero begin
                select	Err_Codigo	= '000001',
                        Err_Mensaj	= 'Error en proceso de alta'

                rollback
                return @Ent_Uno
        end

        /*Si el estatus de la tasa es inactiva se ejecuta la actualizacion del estatus*/
        if @Tas_StaAct <> @Sta_Activa begin
            exec  @Status = SOTASASACT @Tas_Numero, @Tas_StaAct, @NumTransac, @Transaccio, @Usuario,
                                       @FechaSis,   @SucOrigen,  @SucDestino, @Modulo

            if @Status <> @Ent_Cero begin
                    rollback
                    return @Ent_Uno
            end
        end
    commit
end else if @Tip_Proces = @Pro_Modifi begin

    begin transaction

        /*Se ejecuta la modificacion de las tasas */
        exec  @Status = SOTASASMOD @Tas_Numero, @Tas_Descri, @Tas_Abrevi, @Tas_Valor,  @Tas_Valor2, 
                                   @Tas_Fecha,  @Tas_Moneda, @Tas_SelPar, @NumTransac, @Transaccio,
                                   @Usuario,    @FechaSis,   @SucOrigen,  @SucDestino, @Modulo

        if @Status <> @Ent_Cero begin
                select	Err_Codigo	= '000002',
                        Err_Mensaj	= 'Error en proceso de modificacion'

                rollback
                return @Ent_Uno
        end
        /*Se ejecuta la actualizacion del estatus */
        exec  @Status = SOTASASACT @Tas_Numero, @Tas_StaAct, @NumTransac, @Transaccio, @Usuario,
                                   @FechaSis,   @SucOrigen,  @SucDestino, @Modulo

                if @Status <> @Ent_Cero begin
                        rollback
                        return @Ent_Uno
                end
    commit
end