create procedure SOBIACDIPRO(
	@Bad_MovNum	char(10),
	@Bad_Client	char(8),
	@Bad_Cuenta	char(12),
	@Bad_NumTar	char(16),
	@Bad_Cantid	money,
	@Bad_Moneda	char(2),
	@Bad_FecTra	smalldatetime,
	@Bad_TipTar	char(4),
	@Bad_TipOpe	char(1),
	@Bad_Sucurs	char(3),
	@Bad_Accion	char(1),
	@Tip_Proces char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

/* *****************************************************************
** DESCRIPCION: Procesos de bitácora de acumulado diario		  **
********************************************************************
**					STORE CONVERTIDO							****
** Convirtió:	Brandon Hernandez Rada							****
** Fecha:		06/Jun/2018										****
** Help:		01088831										****
********************************************************************
** Creó:		Brandon Hernandez Rada							****
** Fecha:		06/Jun/2018										****
** Help:		01088831										****
** Descripcion:	Se de de alta el registro para la bitacora del	****
**				acumulado diario operado por los clientes		****
********************************************************************/

/* declaración de variables */
declare @Tip_ClaPro char(1),
		@Tip_NumPro char(1),
		@Status     int,
		@ClClientID int
		
/* declaración de constantes */		
declare @Tip_AltReg char(1),
		@Tip_BajReg char(1),
		@Str_Uno    char(1),
		@Ent_Cero int 
		
/* asignación de constantes */		
select  @Tip_AltReg = 'A',	/*	Tipo de alta de registro */
		@Tip_BajReg = 'B',	/*	Tipo baja de registro	*/
		@Str_Uno    = '1',	/*	String en uno */
		@Ent_Cero = 0		/*	Entero en cero */
		

select	@Tip_ClaPro	= substring(@Tip_Proces, 1, 1),
		@Tip_NumPro	= substring(@Tip_Proces, 2, 1)

select	@ClClientID	= ClClientID  
	from CLCLIENT noholdlock
	where	Cli_Numero	= @Bad_Client

if @Tip_ClaPro = @Tip_AltReg begin
	if @Tip_NumPro = @Str_Uno begin
		 exec @Status = SOBIACDIALT
			@Bad_MovNum,	@ClClientID,	@Bad_Cuenta,	@Bad_NumTar,	@Bad_Cantid, 
			@Bad_Moneda,	@Bad_FecTra,	@Bad_TipTar,	@Bad_TipOpe,	@Bad_Sucurs, 
			@Bad_Accion,	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis, 
			@SucOrigen,		@SucDestino,	@Modulo
		if @Status <> @Ent_Cero begin
			rollback
			return 1
		end
	end
end
if @Tip_ClaPro = @Tip_BajReg begin
	if @Tip_NumPro = @Str_Uno begin
		exec @Status = SOBIACDIBAJ
			@Bad_FecTra,	@NumTransac,	@Transaccio,	@Usuario,	@FechaSis, 
			@SucOrigen,		@SucDestino,	@Modulo
		if @Status <> @Ent_Cero begin
			rollback
			return 1
		end
	end
end
