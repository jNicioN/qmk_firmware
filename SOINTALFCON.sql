create procedure SOINTALFCON(
	@Ina_IntCon int,			--Consecutivo int
	@Ina_ChaCon char(4) out,    --Consecutivo char
	@Ina_Select char(1),

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
** DESCRIPCION: Consulta Entero a Alfanumerico para casteo   	****
********************************************************************
********************************************************************
**	REFERENCIAS:
********************************************************************
** Crea:		Andrea Ramirez									****
** Fecha:		25/Nov/2020										****
** Help:		1453282											****
********************************************************************/
/* variables */
declare @Aux_Idx int,
		@Aux_Pos int,
		@Aux_Int unsigned int,
		@Aux_Str varchar(10),
		@Aux_Dec unsigned int

/* constantes */
declare @Chr_Print  varchar(40),		
		@Num_Base   tinyint,			
		@Int_Offset int,				
		@Max_Int	int,				
		@Mas_Consec int,				
		@Str_Si	    char(1),			
		@Ent_Cuatro int,
		@Ent_Cero   int

/*Asignacion de Constantes */
select 	@Chr_Print  = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ',		/* Caracteres a imprimir*/
		@Num_Base   = 36,											/* Numero Base 36 (Caracteres de @Chr_Print*/
		@Int_Offset = 456560, 										/* Offset entero (evita gap entre el maximo int y el siguiente alpha)*/
		@Max_Int    = 9999,											/* Maximo valor entero*/
		@Mas_Consec = 1679615,										/* Maximo de Consecutivos */
		@Aux_Str    = '',											/* Auxiliar de string*/
		@Str_Si     = 'S',											/* String 'Si' */
		@Ent_Cuatro = 4,											/* Entero cuatro */
		@Ent_Cero   = 0												/* Entero cero */

if  @Ina_IntCon > @Mas_Consec
begin
	select Error = 'Overflow'
	return 0
end	

if @Ina_IntCon > @Max_Int -- alpha
begin

	select @Aux_Dec = @Ina_IntCon + @Int_Offset	
	select @Aux_Idx = @Ent_Cuatro
	
	while @Aux_Idx > @Ent_Cero
	begin
		
		select @Aux_Int =  power(@Num_Base,@Aux_Idx-1)

		select @Aux_Pos = @Aux_Dec / @Aux_Int
		
		select @Aux_Str = @Aux_Str +  SUBSTRING(@Chr_Print,@Aux_Pos+1,1)
		
		select @Aux_Dec = @Aux_Dec - (@Aux_Int * @Aux_Pos)
			
		select @Aux_Idx = @Aux_Idx -1
	end	
	
	set @Ina_ChaCon = ltrim(@Aux_Str) 
end
else
begin
	set @Ina_ChaCon = cast(@Ina_IntCon as varchar)
end

if @Ina_Select = @Str_Si
select Ina_ChaCon = @Ina_ChaCon