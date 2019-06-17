create procedure SODIAINHALT (
	@Din_Pais	char(3),
	@Din_Fecha	smalldatetime,
	@Din_Descri	char(20),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare @Internac	int,				/* Declaración de Variables */
		@Mesa		int,
		@Factoraje	int,
		@Inversio	int,
		@FondoInv	int

declare @Pai_Mexico	char(3),			/* Declaración de Constantes */
		@Pai_EstUni	char(3),
		@Ent_Cero	int,
		@Sta_Proces	char(1),
		@Sta_Cancel	char(1)

/* Asignación de Constantes */
select	@Pai_Mexico	= '001',			/* País <México> */
		@Pai_EstUni	= '036',			/* País <Estados Unidos de América> */
		@Ent_Cero	= 0,				/* Entero en Cero */
		@Sta_Proces	= 'N',				/* Status de Procesado */
		@Sta_Cancel	= 'C'				/* Status de Cancelado */

select	@FechaSis	= getdate()

/* Validación de la Existencia del País */
if not exists (select	Pai_Numero
				from SOPAIS noholdlock
				where	Pai_Numero	= @Din_Pais) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Este País <NO> existe en el Catálogo de Países',
			Err_Variab	= ''
	rollback
	return 1
end

/* Validar si la Fecha para ese País <YA> Existe */
if exists (select	Din_Pais
			from SODIAINH noholdlock
			where	Din_Pais	= @Din_Pais
			  and	Din_Fecha	= @Din_Fecha) begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Este Día Inhábil YA existe para ese País',
			Err_Variab	= ''
	rollback
	return 1
end

/* Validación si el País es México */
if (@Din_Pais = @Pai_Mexico) begin

	/* Validacion de Internacional */
	select	@Internac	= count(Cov_FecVen)
		from ITCOMVEN noholdlock
		where	Cov_FecVen	= @Din_Fecha

	select	@Internac	= isnull(@Internac, @Ent_Cero)

	if @Internac > @Ent_Cero begin
		select	Err_Codigo	= '000003',
				Err_Mensaj	= 'Existen en Internacional Movimientos con esa Fecha ',
				Err_Variab	= ''
		rollback
		return 1
	end

	/* Validacion de Mesa Dinero */
	select	@Mesa	= count(Inv_Numero)
		from MDINVERS noholdlock
		where	Inv_FecVen	= @Din_Fecha
		  and	Inv_Status	= @Sta_Proces

	select	@Mesa	= isnull(@Mesa, @Ent_Cero)

	if @Mesa > @Ent_Cero begin
		select	Err_Codigo	= '000004',
				Err_Mensaj	= 'Existen Operaciones en Mesa con esa Fecha ',
				Err_Variab	= ''
		rollback
		return 1
	end

	/* Validacion Factoraje */
	select	@Factoraje	= count(Fac_Numero)
		from FAFACTOR noholdlock
		where	Fac_FecVen	= @Din_Fecha
		  and	Fac_Status	= @Sta_Proces

	select	@Factoraje	= isnull(@Factoraje, @Ent_Cero)

	if @Factoraje > @Ent_Cero begin
		select	Err_Codigo	= '000005',
				Err_Mensaj	= 'Existen Operaciones en Factoraje con esa Fecha ',
				Err_Variab	= ''
		rollback
		return 1
	end

	/* Validacion Pagaré */
	select	@Inversio	= count(Inv_Numero)
		from ININVERS noholdlock
		where	Inv_FecVen	= @Din_Fecha
		  and	Inv_Status	= @Sta_Proces

	select	@Inversio = isnull(@Inversio, @Ent_Cero)

	if @Inversio > @Ent_Cero begin
		select	Err_Codigo	= '000006',
				Err_Mensaj	= 'Existen Inversiones con esta fecha ',
				Err_Variab	= ''
		rollback
		return 1
	end

	/* Validacion de Fondos de Inversión */
	select	@FondoInv	= Count(Ope_Fondo)
		from FIOPERAC noholdlock,
			 FIFONDOS noholdlock,
			 FIFONPAI noholdlock
		where	Ope_Fondo	= Fon_Numero
		  and	Fop_Fondo	= Fon_Numero
		  and	Fop_Fondo	= Ope_Fondo
		  and	Fop_Pais	= @Din_Pais
		  and	(Ope_FecLiq	= @Din_Fecha
		   or	Ope_FecVen	= @Din_Fecha
		   or	Ope_FeSoVe	= @Din_Fecha
		   or	Ope_FeLiSV	= @Din_Fecha)
   		  and	Ope_Status	<> @Sta_Cancel
		  and	Fon_Status	<> @Sta_Cancel
		  group by Ope_Fondo

	select	@FondoInv = isnull(@FondoInv, @Ent_Cero)

	if @FondoInv > @Ent_Cero begin
		select	Err_Codigo	= '000007',
				Err_Mensaj	= 'Existen Fondos de Inversión con esta fecha ',
				Err_Variab	= ''
		rollback
		return 1
	end
end

/* Validación si el País es Estados Unidos de América */
if (@Din_Pais = @Pai_EstUni) begin

	/* Validacion de Internacional */
	select	@Internac	= count(Cov_FecVen)
		from ITCOMVEN noholdlock
		where	Cov_FecVen	= @Din_Fecha

	select	@Internac	= isnull(@Internac, @Ent_Cero)

	if @Internac > @Ent_Cero begin
		select	Err_Codigo	= '000008',
				Err_Mensaj	= 'Existen en Internacional Movimientos con esa Fecha ',
				Err_Variab	= ''
		rollback
		return 1
	end

	/* Validacion de Fondos de Inversión */
	select	@FondoInv	= Count(Ope_Fondo)
		from FIOPERAC noholdlock,
			 FIFONDOS noholdlock,
			 FIFONPAI noholdlock
		where	Ope_Fondo	= Fon_Numero
		  and	Fop_Fondo	= Fon_Numero
		  and	Fop_Fondo	= Ope_Fondo
		  and	Fop_Pais	= @Din_Pais
		  and	(Ope_FecLiq	= @Din_Fecha
		   or	Ope_FecVen	= @Din_Fecha
		   or	Ope_FeSoVe	= @Din_Fecha
		   or	Ope_FeLiSV	= @Din_Fecha)
   		  and	Ope_Status	<> @Sta_Cancel
		  and	Fon_Status	<> @Sta_Cancel
		  group by Ope_Fondo

	select	@FondoInv = isnull(@FondoInv, @Ent_Cero)

	if @FondoInv > @Ent_Cero begin
		select	Err_Codigo	= '000009',
				Err_Mensaj	= 'Existen Fondos de Inversión con esta fecha ',
				Err_Variab	= ''
		rollback
		return 1
	end
end

/* Validación si el País es Cualquier Otro */
if @Din_Pais not in (@Pai_Mexico, @Pai_EstUni) begin

	/* Validacion de Fondos de Inversión */
	select	@FondoInv	= Count(Ope_Fondo)
		from FIOPERAC noholdlock,
			 FIFONDOS noholdlock,
			 FIFONPAI noholdlock
		where	Ope_Fondo	= Fon_Numero
		  and	Fop_Fondo	= Fon_Numero
		  and	Fop_Fondo	= Ope_Fondo
		  and	Fop_Pais	= @Din_Pais
		  and	(Ope_FecLiq	= @Din_Fecha
		   or	Ope_FecVen	= @Din_Fecha
		   or	Ope_FeSoVe	= @Din_Fecha
		   or	Ope_FeLiSV	= @Din_Fecha)
   		  and	Ope_Status	<> @Sta_Cancel
		  and	Fon_Status	<> @Sta_Cancel
		  group by Ope_Fondo

	select	@FondoInv = isnull(@FondoInv, @Ent_Cero)

	if @FondoInv > @Ent_Cero begin
		select	Err_Codigo	= '000010',
				Err_Mensaj	= 'Existen Fondos de Inversión con esta fecha ',
				Err_Variab	= ''
		rollback
		return 1
	end
end

/* Registra el Día Inhábil */
insert into SODIAINH values(
	@Din_Pais,		@Din_Fecha,		@Din_Descri,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis, 		@SucOrigen, 	@SucDestino)

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Agregado'
