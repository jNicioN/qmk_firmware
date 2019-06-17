create procedure SOBIACDIALT(
	@Bad_MovNum	char(10),
	@ClClientID	int,
	@Bad_Cuenta	char(12),
	@Bad_NumTar	char(16),
	@Bad_Cantid	money,
	@Bad_Moneda	char(2),
	@Bad_FecTra	smalldatetime,
	@Bad_TipTar	char(4),
	@Bad_TipOpe	char(1),
	@Bad_Sucurs	char(3),
	@Bad_Accion char(1), 
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as


/* *****************************************************************
** DESCRIPCION: Alta de bitácora de acumulados diarios		  **
********************************************************************
**					STORE CONVERTIDO							****
** Convirtió:	Brandon Hernandez Rada							****
** Fecha:		06/Jun/2018										****
** Help:		01088831										****
********************************************************************
** Creó:		Brandon Hernandez Rada							****
** Fecha:		06/Jun/2018										****
** Help:		01088831										****
** Descripcion:	Alta de bitácora de acumulados diarios		 	****
********************************************************************/

/* Declaración de constantes */
declare @Str_Vacio  char(1),
        @Mon_Cero money,
        @Int_Cero   int

/* Asignacion de Constantes */		
select  @Str_Vacio  = '',		/* String en vacío */
		@Mon_Cero = $0.00,		/* Moneda en ceros */
		@Int_Cero   = 0			/* Entero en ceros */

if @Bad_MovNum = @Str_Vacio begin 
	select 	Err_Descri = 'Falta Numero de Transaccion',
			Err_Campo  = 'Bad_MovNum'
	rollback
	return 1
end
if @ClClientID = @Int_Cero begin 
	select 	Err_Descri = 'Falta Numero de Cliente',
			Err_Campo  = 'Bad_Client'
	rollback
	return 1
end
if @Bad_Cantid = @Mon_Cero begin 
	select 	Err_Descri = 'Falta Cantidad de operacion',
			Err_Campo  = 'Bad_Cantid'
	rollback
	return 1
end
if @Bad_Moneda = @Str_Vacio begin 
	select 	Err_Descri = 'Falta tipo de Moneda',
			Err_Campo  = 'Bad_Moneda'
	rollback
	return 1
end
if @Bad_FecTra = @Str_Vacio begin 
	select 	Err_Descri = 'Falta Fecha de Trasaccion',
			Err_Campo  = 'Bad_FecTra'
	rollback
	return 1
end
if @Bad_TipOpe = @Str_Vacio begin 
	select 	Err_Descri = 'Falta Tipo de Operacion A/R',
			Err_Campo  = 'Bad_TipOpe'
	rollback
	return 1
end
if @Bad_Sucurs = @Str_Vacio begin 
	select 	Err_Descri = 'Falta Numero de Sucursal',
			Err_Campo  = 'Bad_Sucurs'
	rollback
	return 1
end

insert into SOBIACDI
	(Bad_MovNum,	ClClientID,	Bad_Cuenta,	Bad_NumTar,	Bad_Cantid, 
	Bad_Moneda,		Bad_FecTra,	Bad_TipTar,	Bad_TipOpe,	Bad_Sucurs, 
	Bad_Accion,		NumTransac,	Transaccio,	Usuario,	FechaSis,
	SucOrigen,		SucDestino)
	values (
	@Bad_MovNum,	@ClClientID,	@Bad_Cuenta,	@Bad_NumTar,	@Bad_Cantid, 
	@Bad_Moneda,	@Bad_FecTra,	@Bad_TipTar,	@Bad_TipOpe,	@Bad_Sucurs, 
	@Bad_Accion,	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis, 
	@SucOrigen,		@SucDestino )
return 0
