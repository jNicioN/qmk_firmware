create procedure SOBANACTCON (
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
/** REFERENCIAS: 
************************************************************************
** Modificó:	Librado Santiago									****
** Fecha:		06/04/2022											****
** Help Desk:	1640569												****
** Descripción:	Se agrega @@nestlevel				 				****/
************************************************************************
**  Creó:    Maria De La Cruz                                        ***
**  Fecha:   01/03/2022                                              ***
**  Help:    1629075                                                 ***
***********************************************************************/

/* Declaracion de Variables */
declare @Est_SepAct int

/* Declaracion de Constantes */
declare @Par_SepAct varchar(50),
        @Par_BanAct varchar(50),
        @Ent_Cero   int,
        @Ent_Dos    int

/* Asignacion de Constantes */
select  @Par_SepAct =   'SeparacionActiva',         /*1: SI, 0: NO*/
        @Par_BanAct =   'BancoActual',               /*Banco Actual 1-HEY, 2-Banregio*/
        @Ent_Cero   =   0,
        @Ent_Dos    =   2
        

select  @Est_SepAct = cast(Par_Valor as int)
from    SOPARGEN noholdlock
where   Par_Nombre = @Par_SepAct

if isnull(@Est_SepAct, @Ent_Cero) = @Ent_Cero begin 
    select @Est_BanAct = @Ent_Cero
end else begin
    select  @Est_BanAct = cast(Par_Valor as int)
    from    SOPARGEN noholdlock
    where   Par_Nombre = @Par_BanAct

    select @Est_BanAct = isnull(@Est_BanAct, @Ent_Dos)
         
end

if @@nestlevel = 1 begin
	select	Err_Numero	= '00000',
			Err_Mensaj	= '',
			Est_BanAct = @Est_BanAct
end