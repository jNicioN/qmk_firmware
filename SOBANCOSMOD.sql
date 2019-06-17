create procedure SOBANCOSMOD (
	@Ban_Numero	char(3),
	@Ban_Nombre	varchar(50),
	@Ban_Siglas	char(10),
	@Ban_NumSis	char(4),
	@Ban_TipBan	char(1),
	@Ban_UsuCon	char(10),
	@Ban_CobRem	char(1),
	@Ban_PlaSuc	char(3),
	@Ban_Domici	char(1),
	@Ban_PagInt	char(1),
	@Ban_CodGru	char(4),
	@Ban_DiLiCa	char(1),
	@Ban_CoOPVe	char(1),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare @Ban_EdoSuc char(2),		/* Declaración de Variables */
		@Ban_CiuSuc char(3)

declare	@Str_Vacio	char(1),		/* Declaración de Constantes */
		@Tab_Nombre char(8),
		@Tip_Nacion	char(1),
		@Tip_Extran	char(1),
		@Rec_CobInm	char(1),
		@Rec_Remesa	char(1),
		@Si_Status	char(1),
		@No_Status	char(1)

/* Asignación de Constantes */
select	@Str_Vacio	= '',			/*	String Vacío */
		@Tab_Nombre = 'SOBANCOS',	/*	Nombre de la Tabla a Actualizar en Tablas Locales */
		@Tip_Nacion	= 'N',			/*	Tipo de Banco Nacional */
		@Tip_Extran	= 'E',			/*	Tipo de Banco Extranjero */
		@Rec_CobInm	= 'C',			/*	Recepción de Cheques Foraneos como Cobro Inmediato */
		@Rec_Remesa	= 'R',			/*	Recepción de Cheques Foraneos como Remesa */
		@Si_Status	= 'S',			/*	SI	*/
		@No_Status	= 'N'			/*	NO	*/
		
select	@FechaSis	= getdate()
	
select	@Ban_EdoSuc = substring(Par_TranBR, 3, 2),
		@Ban_CiuSuc = substring(Par_TranBR, 5, 3)
	from SOPARAMS noholdlock
	where	Par_Sucurs = @SucOrigen

select	@Ban_PlaSuc	= Cen_Numero
	from SOSUCURS noholdlock,
		 SOPLAZAS noholdlock,
		 SOCENPRO noholdlock
	where	Suc_Numero	= @SucOrigen
	  and	Suc_Plaza	= Pla_Numero
	  and	Pla_CenPro	= Cen_Numero

if not exists (select	Ban_NumSis
				from SOBANCOS noholdlock
				where	Ban_NumSis	= @Ban_NumSis) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Numero no existe',
			Err_Variab	= 'Ban_NumSis'
	rollback
	return 1
end
if	@Ban_Nombre = @Str_Vacio begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Nombre incorrecto',
			Err_Variab	= 'Ban_Nombre'
	rollback
	return 1
end
if (@Ban_TipBan not in (@Tip_Nacion, @Tip_Extran)) begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Tipo de banco incorrecto',
			Err_Variab	= 'Ban_TipBan'
	rollback
	return 1
end
if (@Ban_CobRem not in (@Rec_CobInm, @Rec_Remesa)) begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'Clave de Cobro incorrecto',
			Err_Variab	= 'Ban_CobRem'
	rollback
	return 1
end

if @Ban_Domici	not in (@Si_Status, @No_Status) begin
	select	Err_Codigo	= '000005',
			Err_Mensaj	= 'El Stauts Para Banco Con Servicio Domiciliado Debe Ser Si o No',
			Err_Variab	= 'Ban_Domici'
	rollback
	return 1
end 

if @Ban_PagInt	not in (@Si_Status, @No_Status) begin
	select	Err_Codigo	= '000006',
			Err_Mensaj	= 'El Stauts Para Banco Con Pago Interbancario Debe Ser Si o No',
			Err_Variab	= 'Ban_PagInt'
	rollback
	return 1
end 

update SOBANCOS set
	Ban_Numero	= @Ban_Numero,
	Ban_Nombre	= @Ban_Nombre,
	Ban_Siglas	= @Ban_Siglas,
	Ban_TipBan	= @Ban_TipBan,
	Ban_UsuCon	= @Ban_UsuCon,
	Ban_CobRem	= @Ban_CobRem,
	Ban_Domici	= @Ban_Domici,
	Ban_PagInt	= @Ban_PagInt,
	Ban_CodGru	= @Ban_CodGru,
	Ban_DiLiCa	= @Ban_DiLiCa,
	Ban_CoOPVe	= @Ban_CoOPVe,
	
	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino
	where	Ban_NumSis	= @Ban_NumSis

exec SYTABLOCACT
	@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
	@SucOrigen,		@SucDestino,	@Modulo
	
if @Ban_CobRem = @Rec_Remesa begin
	if exists (select	Ban_CiuSuc
					from SOBANSBC noholdlock
					where	Ban_EdoSuc	= @Ban_EdoSuc 
					  and	Ban_CiuSuc	= @Ban_CiuSuc
					  and	Ban_Numero	= @Ban_Numero)
		delete from SOBANSBC
			where	Ban_EdoSuc	= @Ban_EdoSuc
			  and	Ban_CiuSuc	= @Ban_CiuSuc
			  and	Ban_Numero	= @Ban_Numero
end else if @Ban_CobRem = @Rec_CobInm begin
	if not exists (select	Ban_CiuSuc
					from SOBANSBC noholdlock
					where	Ban_EdoSuc	= @Ban_EdoSuc 
					  and	Ban_CiuSuc	= @Ban_CiuSuc
					  and	Ban_Numero	= @Ban_Numero)
		insert into SOBANSBC values (
			@Ban_EdoSuc, 	@Ban_CiuSuc, 	@Ban_Numero, 	@Ban_PlaSuc,	@NumTransac,
			@Transaccio, 	@Usuario, 		@FechaSis, 		@SucOrigen, 	@SucDestino)
end

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Modificado'
