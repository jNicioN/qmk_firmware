create procedure SOTEPECLPRO (
    @Str_Telefo     char(20),
    @Per_Numero		char(8), 
	@Cli_Numero		char(8),

    @NumTransac	    char(10),
    @Transaccio	    char(3),
    @Usuario	    char(6),
    @FechaSis	    smalldatetime,
    @SucOrigen	    char(3),
    @SucDestino	    char(3),
    @Modulo		    char(2))
as
/***************************************************************************
** DESCRIPCION: Registro o Modificacion de SOTELPER con celular en char	****
****************************************************************************
** REFERENCIAS: 														****
****************************************************************************
** Creó: Job Jonathan Martinez Gonzalez									****
** Fecha: 29/Ene/2025 													****
** Help: 																****
** Descripción: 														****
***************************************************************************/

                    /*Declaracion Variables*/
declare @San_Telefo     bigint,
        @Val_Regist     int,
        @PerPersoID		int, 
	    @ClClientID		int,
        @Status			int,
	    @San_Lada		int


                    /*Declaracion de constantes*/
declare	@Str_Vacio	    char(1),
        @Ent_Cero	    int,
        @Ent_Uno	    int,
        @Cat_BOTs       int,
	    @Ent_Diez		int,
	    @Str_Guion		char(1),
	    @Ent_MenUno 	int,
	    @Ent_Dos		int

                    /*Asignación de Constantes*/
select	@Str_Vacio	= '',
        @Ent_Cero	= 0,
        @Ent_Uno	= 1,
        @Cat_BOTs   = 26,
        @Ent_Diez	=10,
        @Str_Guion	='-',
        @Ent_MenUno =-1,
        @Ent_Dos	= 2

if not isnull(@Str_Telefo, @Str_Vacio) = @Str_Vacio begin
    if (@Str_Telefo <> @Str_Guion) begin
        select @Str_Telefo = str_replace(@Str_Telefo,' ',null)
        select @Str_Telefo = str_replace(@Str_Telefo,'-',null)

        if(patindex('%[A-Za-z!-/:-@[-`{-~]%',@Str_Telefo) = 0) begin
            select @San_Telefo = cast(right(RTrim(@Str_Telefo), @Ent_Diez) as bigint)

            if @San_Telefo <> @Ent_Cero begin

                select @San_Lada = cast(left(@Str_Telefo,@Ent_Dos) as int)
                select @ClClientID = ClClientID from CLCLIENT noholdlock where Cli_Numero = @Cli_Numero
                select @PerPersoID = PerPersoID from SOPERSON noholdlock where Per_Numero = @Per_Numero
                select @Val_Regist = @Ent_Uno from SOTELPER noholdlock where ClClientID = @ClClientID and PerPersoID = @PerPersoID and Tep_TipTel = @Cat_BOTs

                if isnull(@Val_Regist, @Ent_Cero) = @Ent_Cero begin

                    select @Status = @Ent_MenUno

                    exec @Status = SOTELPERALT @PerPersoID, @Cat_BOTs, @ClClientID, @San_Lada , @San_Telefo, 
                                                @NumTransac ,@Transaccio ,@Usuario ,@FechaSis ,@SucOrigen ,
                                                @SucDestino ,@Modulo
                end
                else begin

                    select @Status = @Ent_MenUno

                    exec @Status = SOTELPERMOD @PerPersoID, @Cat_BOTs, @ClClientID, @San_Lada, @San_Telefo, 
                                                @NumTransac ,@Transaccio ,@Usuario ,@FechaSis ,@SucOrigen ,
                                                @SucDestino ,@Modulo
                end
            end
        end
    end
end 
