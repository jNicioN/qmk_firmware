create procedure SOESTFTIPRO (
	@Eft_Numero	int,
	@Eft_EstFin int,
	@Eft_EstFi1	int,
	@Eft_EstFi2	int,
	@Eft_EstFi3	int,
	@Eft_EstFi4	int,
	@Eft_TipCue	int,
	@Eft_Valor1	numeric(14,4),
	@Eft_Valor2	numeric(14,4),
	@Eft_Valor3	numeric(14,4),
	@Eft_Valor4	numeric(14,4),
	@Eft_Porce1	numeric(10,2),
	@Eft_Porce2	numeric(10,2),
	@Eft_Porce3	numeric(10,2),
	@Eft_Porce4	numeric(10,2),
	@Eft_ParAc1	bit,
	@Eft_ParAc2	bit,
	@Eft_ParAc3	bit,
	@Eft_ParAc4	bit,
	@Eft_TieAna bit,
	@Tip_Proces char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2)
)
as

/****************************************************************/
/** DESCRIPCION: Proceso de guardado de estados financieros		*/
/****************************************************************/
/** Creo:		Felipe Castillo									*/
/** Fecha:		19/05/2017                               		*/
/** Help:		929417 					 						*/
/****************************************************************/

declare @Tip_ProA char(1),
		@Ent_Cero int,
		@Ent_Eeff int

SET @Tip_ProA = 'A',
	@Ent_Cero = 0

if @Tip_Proces = @Tip_ProA begin
	if(@Eft_EstFi1>@Ent_Cero) begin
		select @Ent_Eeff = (select count(1) from SOESFITI where Eft_EstFin=@Eft_EstFi1 and Eft_TipCue = @Eft_TipCue)
		if (@Ent_Eeff > 0) begin
			update SOESFITI set
				Eft_Valor	=	@Eft_Valor1, 
				Eft_Porcen	=	@Eft_Porce1, 
				Eft_ParAct	=	@Eft_ParAc1,
				NumTransac	=	@NumTransac,
				Transaccio	=	@Transaccio,
				Usuario		=	@Usuario,
				FechaSis	=	@FechaSis,
				SucOrigen	=	@SucOrigen,
				SucDestino	=	@SucDestino
				where Eft_EstFin = @Eft_EstFi1 
				and Eft_TipCue = @Eft_TipCue
		end else begin
			insert into SOESFITI
				(Eft_EstFin, 	Eft_TipCue, 	Eft_Valor, 		Eft_Porcen, 	Eft_TieAna,
				Eft_ParAct,		NumTransac, 	Transaccio, 	Usuario, 		FechaSis, 
				SucOrigen, 		SucDestino)
				values (
				@Eft_EstFi1, 	@Eft_TipCue, 	@Eft_Valor1, 	@Eft_Porce1, 	@Eft_TieAna, 
				@Eft_ParAc1,	@NumTransac, 	@Transaccio, 	@Usuario, 		@FechaSis, 
				@SucOrigen, 	@SucDestino)
		end
	end

	if(@Eft_EstFi2>@Ent_Cero) begin
		select @Ent_Eeff = (select count(1) from SOESFITI where Eft_EstFin=@Eft_EstFi2 and Eft_TipCue = @Eft_TipCue)
		if (@Ent_Eeff > 0) begin
			update SOESFITI set
				Eft_Valor	=	@Eft_Valor2, 
				Eft_Porcen	=	@Eft_Porce2, 
				Eft_ParAct	=	@Eft_ParAc2,
				NumTransac	=	@NumTransac,
				Transaccio	=	@Transaccio,
				Usuario		=	@Usuario,
				FechaSis	=	@FechaSis,
				SucOrigen	=	@SucOrigen,
				SucDestino	=	@SucDestino
				where Eft_EstFin = @Eft_EstFi2 
				and Eft_TipCue = @Eft_TipCue
		end else begin
			insert into SOESFITI
				(Eft_EstFin, 	Eft_TipCue, 	Eft_Valor, 		Eft_Porcen, 	Eft_TieAna, 
				Eft_ParAct,		NumTransac, 	Transaccio, 	Usuario, 		FechaSis, 
				SucOrigen, 		SucDestino)
				values (
				@Eft_EstFi2, 	@Eft_TipCue, 	@Eft_Valor2, 	@Eft_Porce2, 	@Eft_TieAna, 
				@Eft_ParAc2,	@NumTransac, 	@Transaccio, 	@Usuario, 		@FechaSis, 
				@SucOrigen, 	@SucDestino)
		end
	end

	if(@Eft_EstFi3>@Ent_Cero) begin
		select @Ent_Eeff = (select count(1) from SOESFITI where Eft_EstFin=@Eft_EstFi3 and Eft_TipCue = @Eft_TipCue)
		if (@Ent_Eeff > 0) begin
			update SOESFITI set
				Eft_Valor	=	@Eft_Valor3, 
				Eft_Porcen	=	@Eft_Porce3, 
				Eft_ParAct	=	@Eft_ParAc3,
				NumTransac	=	@NumTransac,
				Transaccio	=	@Transaccio,
				Usuario		=	@Usuario,
				FechaSis	=	@FechaSis,
				SucOrigen	=	@SucOrigen,
				SucDestino	=	@SucDestino
			where Eft_EstFin = @Eft_EstFi3 
				and Eft_TipCue = @Eft_TipCue
		end else begin
			insert into SOESFITI
				(Eft_EstFin, 	Eft_TipCue, 	Eft_Valor, 		Eft_Porcen, 	Eft_TieAna, 
				Eft_ParAct,		NumTransac, 	Transaccio, 	Usuario, 		FechaSis, 
				SucOrigen, 		SucDestino)
				values (
				@Eft_EstFi3, 	@Eft_TipCue, 	@Eft_Valor3, 	@Eft_Porce3, 	@Eft_TieAna, 
				@Eft_ParAc3,	@NumTransac, 	@Transaccio, 	@Usuario, 		@FechaSis, 
				@SucOrigen, 	@SucDestino)
		end
	end

	if(@Eft_EstFi4>@Ent_Cero) begin
		select @Ent_Eeff = (select count(1) from SOESFITI where Eft_EstFin=@Eft_EstFi4 and Eft_TipCue = @Eft_TipCue)
		if (@Ent_Eeff > 0) begin
			update SOESFITI set
				Eft_Valor	=	@Eft_Valor4, 
				Eft_Porcen	=	@Eft_Porce4, 
				Eft_ParAct	=	@Eft_ParAc4,
				NumTransac	=	@NumTransac,
				Transaccio	=	@Transaccio,
				Usuario		=	@Usuario,
				FechaSis	=	@FechaSis,
				SucOrigen	=	@SucOrigen,
				SucDestino	=	@SucDestino
				where Eft_EstFin = @Eft_EstFi4 
				and Eft_TipCue = @Eft_TipCue
		end else begin
			insert into SOESFITI
				(Eft_EstFin, 	Eft_TipCue, 	Eft_Valor, 		Eft_Porcen, 	Eft_TieAna,
				Eft_ParAct,		NumTransac,		Transaccio, 	Usuario, 		FechaSis, 
				SucOrigen, 		SucDestino)
				values (
				@Eft_EstFi4, 	@Eft_TipCue, 	@Eft_Valor4, 	@Eft_Porce4, 	@Eft_TieAna, 
				@Eft_ParAc4,	@NumTransac, 	@Transaccio, 	@Usuario, 		@FechaSis, 
				@SucOrigen, 	@SucDestino)
		end
	end
end
