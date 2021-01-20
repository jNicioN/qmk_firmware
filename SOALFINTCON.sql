create procedure SOALFINTCON(
	@Ali_ChaCon varchar(4),   --Consecutivo char
	@Ali_IntCon int out,      --Consecutivo int
	@Ali_Select char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2)
)
as	

/*******************************************************************
** DESCRIPCION: Consulta Alfanumerico a entero para casteo     	****
********************************************************************
********************************************************************
**	REFERENCIAS:
********************************************************************
** Crea:		Andrea Ramirez									****
** Fecha:		25/Nov/2020										****
** Help:		1453282											****
********************************************************************/
/*Variables */
declare @Aux_Idx    int,
		@Aux_Pos    int,
		@Aux_Len    tinyint,
		@Aux_Str    char(4)

/*Constantes */
declare @Chr_Print  varchar(40),		
		@Num_Base   tinyint,			
		@Lim_Offset int,				
		@Str_Si	    char(1),				
		@Aux_Dec    unsigned bigint,
		@Str_CuaCer char(4),
		@Ent_Cuatro int,
		@Ent_Cero   int

/*Asignacion de Constantes */
select 	@Chr_Print  = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ',		/* Caracteres a imprimir*/
		@Num_Base   = 36,											/* Numero Base 36 (Caracteres de @Chr_Print*/
		@Lim_Offset = 456560,          								/* Offset entero (evita gap entre el maximo int y el siguiente alpha)*/
		@Aux_Dec    = 0,											/* Valor Auxiliar cero*/
		@Str_Si     = 'S',											/* String 'Si' */
		@Str_CuaCer = '0000',										/* String Cuatro ceros */
		@Ent_Cuatro = 4,											/* Entero cuatro */
		@Ent_Cero   = 0												/* Entero cero */


select @Aux_Str= right(@Str_CuaCer+ rtrim(@Ali_ChaCon),@Ent_Cuatro)
select @Aux_Len = len(@Ali_ChaCon)

if @Ali_ChaCon like '%[^0-9]%' 
begin

	select  @Aux_Idx = @Aux_Len
	
	while @Aux_Idx > @Ent_Cero
	begin
		
		select  @Aux_Pos = charindex(SUBSTRING(@Ali_ChaCon,@Aux_Idx,1),@Chr_Print)
		
		select @Aux_Dec = @Aux_Dec + (@Aux_Pos -1) * power(@Num_Base,@Aux_Len-@Aux_Idx)
		
		select @Aux_Idx = @Aux_Idx -1
	end	
	
	set @Ali_IntCon = @Aux_Dec - @Lim_Offset
end
else
begin
	set @Ali_IntCon = cast(@Ali_ChaCon as int)
end

if @Ali_Select = @Str_Si
select Ali_IntCon = @Ali_IntCon