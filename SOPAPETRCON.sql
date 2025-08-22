create or replace procedure SOPAPETRCON (
    @Ppt_PerFis char(1),            -- Personalidad fiscal del cliente, SOPERFIS.Per_Numero. 1 = PM, 2 = PF, 3 = PFAE
    @Ppt_Valor  bit out,            -- Valor del parámetro. 0 = Inactivo, 1 = Activo

    @NumTransac char(10),
    @Transaccio char(3),
    @Usuario    char(6),
    @FechaSis   smalldatetime,
    @SucOrigen  char(3),
    @SucDestino char(3),
    @Modulo     char(2))

    as

/***********************************************************************************
** DESCRIPCION: Consulta parámetros para la operación de perfil transsaccional  ****
**              por personalidad fiscal                                         ****
************************************************************************************
**	REFERENCIAS:                                                                ****
************************************************************************************
** Creo:		Aldo Archundia Alvarez 									        ****
** Fecha:		20/Agosto/2025											        ****
** Help:		TCELCV-32996											        ****
***********************************************************************************/

/*Declaración de Variables */
declare @Str_Person varchar(4)

/*Declaración de Constantes */
declare @Ppt_Parame varchar(30),
        @Per_Moral  char(1),
        @Per_Fisica char(1),
        @Per_FiAcEm char(1),
        @Str_PerMor varchar(2),
        @Str_PerFis varchar(2),
        @Str_PeFiAc varchar(4),
        @Ent_Uno    int

select  @Ppt_Parame = 'PERFIL_TRANSACCIONAL_',  /* Constante del nombre del parámetro en SOPARGEN               */
        @Per_Moral  = '1',                        /* Personalidad moral                                           */
        @Per_Fisica = '2',                        /* Personalidad física                                          */
        @Per_FiAcEm = '3',                        /* Personalidad física con actividad empresarial                */
        @Str_PerMor = 'PM',                     /* Abreviatura de Personalidad Moral                            */
        @Str_PerFis = 'PF',                     /* Abreviatura de Personalidad Física                           */
        @Str_PeFiAc = 'PFAE',                   /* Abreviatura de Personalidad Física con Actividad Empresarial */
        @Ent_Uno    = 1                           /* Entero Uno              */

select  @Str_Person = case @Ppt_PerFis
                            when @Per_Moral  then @Str_PerMor
                            when @Per_Fisica then @Str_PerFis
                            when @Per_FiAcEm then @Str_PeFiAc
                      end

select @Ppt_Parame = ltrim(rtrim(@Ppt_Parame)) + ltrim(rtrim(@Str_Person))

select @Ppt_Valor = convert(bit,Par_Valor)
    from SOPARGEN noholdlock
    where Par_Nombre = @Ppt_Parame

if @@nestlevel = @Ent_Uno begin
    select @Ppt_Valor as Ppt_Valor
end