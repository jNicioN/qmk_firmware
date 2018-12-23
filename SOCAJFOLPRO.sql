create procedure SOCAJFOLPRO (
	@CT_Folio	int,		/* Folio de CTFOLIOS a Actualizar o Incrementar	*/
	@CT_Autori	int,		/* Num. de Autorizacion para Tarjeta Debito	*/ 
	@TA_Autori	int,		/* Num. de Autorizacion para Tarjeta Credito	*/ 
	@Num_Increm	int,			/* Numero de Folios a Incrementar (para I, C)	*/
	@Tip_Proces	char(1),		/* Tipo de Procesamiento			*/
						/*   A = Actualiza con los datos proporcionados	*/	
						/*   I = Incrementa los tres Folios la cantidad */
						/*       de @Num_Increm y los ACTUALIZA		*/
						/*   C = Incrementa (validando) los tres folios */
						/*  	 la cantidad de @Num_Increm y solo los 	*/
						/*  	 regresa, mas NO actualiza		*/

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

declare	@Str_Vacio	char(1),		/* Declaración de constantes */
	@Ent_Cero	int,
	@Max_NumAut	int	
	
declare	@Fol_Transa	int,			/* Declaración de variables */
	@CT_Transa	char(10),
	@CT_TranExt char(10),
	@CT_NumAut	int,
	@TA_NumAut	int,
	@Tip_Actual	char(1),
	@Tip_Increm	char(1),
	@Tip_IncCon	char(1),
	@CT_FolExt	int					/* Folio de CTFOLEXT a Actualizar o Incrementar	*/
	
select	@Str_Vacio	= '',		/* String Vacio */
	@Ent_Cero 	= 0,		/* Cero Entero	*/
	@Max_NumAut	= 1000000,	/* Maximo Numero de Autorizaciones */
	@CT_FolExt = 0
	
select 	@Tip_Actual	= 'A',
		@Tip_Increm	= 'I',
		@Tip_IncCon	= 'C'

if @Tip_Proces = @Tip_Actual 
	select @Num_Increm = 0
		


if @Tip_Proces = @Tip_Actual or @Tip_Proces = @Tip_Increm
 begin
  begin transaction
  /* Numero de Transaccion de CTFOLIOS */
  update CTFOLIOS set
	Fol_Transa	= @CT_Folio + @Num_Increm

  select @Fol_Transa	= Fol_Transa
	from CTFOLIOS holdlock
  select @CT_Transa	= right('0000000000'+ ltrim(rtrim(convert(char, @Fol_Transa))), 9)

  /* Numero de Transaccion de CTFOLEXT */
  select @CT_FolExt= Fol_Transa 
  	from CTFOLEXT 
  	
  update CTFOLEXT set
	Fol_Transa	= @CT_FolExt + 20000

  select @Fol_Transa	= Fol_Transa
	from CTFOLEXT holdlock

/* MODIFICAR ESTO CUANDO ESTE CTFOLEXT en el Autorizador
  select @CT_TranExt	= right('000000000'+ ltrim(rtrim(convert(char, @Fol_Transa))), 8)
  */


  /* Numero de Autorizacion para Tarjeta de Debito */

  select @CT_Autori	= isnull(@CT_Autori, @Ent_Cero)	 

  if @CT_Autori + @Num_Increm >= @Max_NumAut
	update CTAUTORI 
	 	set Aut_Numero	= (@CT_Autori + @Num_Increm) - @Max_NumAut
  else
	update CTAUTORI 
	 	set Aut_Numero	= @CT_Autori + @Num_Increm

  select @CT_NumAut	= Aut_Numero
	from CTAUTORI noholdlock


/* Numero de Autorizacion para Tarjeta de Credito */

  select @TA_Autori	= isnull(@TA_Autori, @Ent_Cero)	 

  if @TA_Autori + @Num_Increm >= @Max_NumAut
	update TAAUTORI 
	 	set Aut_Numero	= (@TA_Autori + @Num_Increm) - @Max_NumAut
  else
	update TAAUTORI 
	 	set Aut_Numero	= @TA_Autori + @Num_Increm

  select @TA_NumAut	= Aut_Numero
	from TAAUTORI noholdlock


  commit

  select 	Err_Codigo	= '000000',
		Err_Mensaj	= 'Transaccion Correcta',
		Fol_Transa 	= @CT_Transa,
		CT_Autori	= @CT_NumAut,
		TA_Autori	= @TA_NumAut,
		Fol_TranEx  = @CT_TranExt

 end
/*
else
 if @Tip_Proces = @Tip_IncCon
*/
