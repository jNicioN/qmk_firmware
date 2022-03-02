create  procedure    SOBANACTCON    (
    @Est_BanAct	int output,

    @NumTransac	char(10),
    @Transaccio	char(3),
    @Usuario	char(6),
    @FechaSis	smalldatetime,
    @SucOrigen	char(3),
    @SucDestino	char(3),
    @Modulo		char(2))

as

/***********************************************************************
*   DESCRIPCION:  Consulta el banco actual                             *
************************************************************************
**  REFERENCIAS:
*************************************************************************
**  Creó:    Maria Maritza                                           ****
**  Fecha:   01/MARZO/2022                                           ****
**  Help:                                                            ****
*************************************************************************/

/*  VARIABLES */
declare @Est_SepAct int

/*  CONSTANTES */
declare @Par_SepAct varchar(50),
        @Par_BanAct varchar(50),
        @Ent_Cero   int,
        @Str_Cero   char(1)

/*  ASIGNACION DE CONSTANTES */
select  @Ent_Cero   =   0,
        @Par_SepAct =   'SeparacionActiva',         /*1: SI, 0: NO*/
        @Par_BanAct =   'BancoActual',               /*Banco Actual 1-HEY, 2-Banregio*/
        @Str_Cero   =   '0'

select  @Est_SepAct = cast(isnull(Par_Valor, @Str_Cero) as int)
from    SOPARGEN noholdlock
where   Par_Nombre = @Par_SepAct

if @Est_SepAct = @Ent_Cero begin 
    select @Est_BanAct = @Ent_Cero
end else begin
    select  @Est_BanAct = cast(isnull(Par_Valor, @Str_Cero) as int)
    from    SOPARGEN noholdlock
    where   Par_Nombre = @Par_BanAct
end 

