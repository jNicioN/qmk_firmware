create procedure SOCOTITUCON (
    @Per_Comple	char(181),
	@Tip_Consul	char(2),

    @NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2)
)
as


/**************************************************************************/
/* DESCRIPCION:		Consulta de cotitulares de un cliente				***/
/**************************************************************************/
/* REFERENCIAS:															***/
/***************************************************************************
** Creo:		    Angel Encalada            							****
** Fecha:			03/Octubre/2025										****
** Help:		    60027   											****
***************************************************************************/

/* Declaracion de Variables */
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1)

/* Declaracion de Constantes */
declare	@Str_Uno	char(1),
		@Str_TipCon	char(1),
        @Str_CobTip char(1) --Tipo de Cotitular

/* Asignacion de Constantes */
select	@Str_Uno	= '1',
		@Str_TipCon	= 'C',
        @Str_CobTip = '3'

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = @Str_TipCon begin
	if @Tip_ConCon	= @Str_Uno begin -- CONSULTA POR NUMERO DE PERSONA 

        -- Validación: El parámetro @Per_Comple debe tener mínimo 4 caracteres
        if @Per_Comple is not null and len(@Per_Comple) < 4 begin
            select	Err_Codigo	= '000001',
                    Err_Mensaj	= 'El parámetro @Per_Comple debe tener mínimo 4 caracteres',
                    Err_Variab	= 'Per_Comple'
            return 1
        end

        SELECT 
            cli.ClClientID, cli.Cli_Numero, cli.Cli_Comple, cli.Cli_RFC,	cli.Cli_CURP,  
            cot.Cob_Person, cot.Cob_Cuenta, per.Per_Nombre, per.Per_ApePat,	per.Per_ApeMat, 
            per.Per_Comple, cot.Cob_Tipo  
        FROM dbo.CHCOTBEN cot noholdlock
        INNER JOIN dbo.CHCUENTA cue noholdlock on cot.Cob_Cuenta = cue.Cue_Numero 
        INNER JOIN dbo.CLCLIENT cli noholdlock on cue.Cue_Client = cli.Cli_Numero 
        INNER JOIN dbo.SOPERSON per noholdlock on per.Per_Numero = cot.Cob_Person 
        WHERE per.Per_Comple = @Per_Comple
        AND cot.Cob_Tipo = @Str_CobTip
    end
end