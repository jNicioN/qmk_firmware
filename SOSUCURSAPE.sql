create procedure SOSUCURSAPE (
	@Error varchar(250) output,
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare @Par_FecAct	smalldatetime,		/*	Declaracion de Variables	*/
		@Suc_UltDia	char(1),
		@Fecha_Val	smalldatetime,
		@Sucursal	char(4),
		@Cen_Numero	char(3),
		@Suc_StaCre	char(1),
		@Suc_CiCrCe	char(1)
		
		
declare	@Sta_CiCeCr	char(1),			/*	Declaracion de Constantes	*/
		@Sta_Proces	char(1),
		@Ent_Cero	int,
		@Sta_Finali	char(1),
		@Sta_Si		char(1),
		@Sta_No		char(1),
		@Dia_Inhabi	char(1),
		@Dia_Habil	char(1),
		@Suc_OpeCon	char(3)
	
/*	Asignacion de Constantes	*/
select	@Sta_CiCeCr	= 'C',				/*	Status: Cierre de Creditos Centralizado */
		@Sta_Proces	= 'N',				/*	Status: Proceso							*/
		@Ent_Cero	= 0,				/*	Entero Cero								*/
		@Sta_Finali	= 'A',				/*	Status: Fianlizado camara de compensaciÃÂ³n */
		@Sta_Si		= 'S',				/*	Status: Si								*/
		@Sta_No		= 'N',				/*	Status: No								*/
		@Dia_Inhabi	= 'I',				/*	Dia Inhabil								*/
		@Dia_Habil	= 'H',				/*	Dia Habil								*/
		@Suc_OpeCon	= '799'				/*	Sucursal de Operaciones/Contabilidad	*/

select	@Cen_Numero = Cen_Numero
	from SOSUCURS noholdlock,
		 SOPLAZAS noholdlock,
		 SOCENPRO noholdlock
	where	Suc_Numero	= @SucOrigen
	  and	Suc_Plaza	= Pla_Numero
	  and	Pla_CenPro	= Cen_Numero

select	@Sucursal = @SucOrigen + '%'
select	@Error = null

select	@Par_FecAct = Par_FecAct
	from SOPARAMS noholdlock
	where	Par_Sucurs	= @SucOrigen

select	@Suc_UltDia	= Suc_UltDia,
		@Suc_CiCrCe	= Suc_CiCrCe,
		@Suc_StaCre	= Suc_StaCre
	from SOSUCURS noholdlock
	where	Suc_Numero	= @SucOrigen

if @Suc_UltDia = @Dia_Inhabi begin
	select	@Fecha_Val	= dateadd(dd,-1,@Par_FecAct)
	exec SOANTFECHAB
		@Fecha_Val output, @Ent_Cero, 'N', 'N'
	select	@Par_FecAct	= @Fecha_Val
end

/* Fin de la camara de compensacion */
/* -------------------------------- */
if ( select Par_StaFin 
		from CAPARAMS noholdlock
		where	Par_Plaza	= @Cen_Numero)	<> @Sta_Finali begin
	select 	@Error	= 'No Fue Finalizada La Camara De Compensacion'
	if @@nestlevel = 1 begin
		select 	Err_Codigo	= '000002',
				Err_Mensaj	= @Error
	end

	return 1
end

/*	Valida Que Se Haya Realizado El Cierre, Siempre y Cuando Este Marcado Para Realizarlo	*/
/* ------------------ */
if @Suc_CiCrCe = @Sta_Si begin
	if @Suc_StaCre <> @Sta_CiCeCr and @Suc_UltDia = @Dia_Habil begin
		select 	@Error	=  'Imposible realizar Apertura, No Se Ha Hecho El Cierre De Creditos'

		if @@nestlevel = 1 begin
			select	Err_Codigo = '000003',
					Err_Mensaj = @Error ,
					Err_Variab = 'Suc_Numero'
		end

		return 1

	end
end

/* Pasivos en Dolares */
/* ------------------ */
if	@SucOrigen = @Suc_OpeCon and (select	Cie_Pasivo
									from ESCIERRE noholdlock )	= @Sta_No begin
	select	@Error = 'Imposible realizar Apertura, No se ha hecho el cierre de Pasivos en Dolares'
	if @@nestlevel = 1 begin
		select 	Err_Codigo = '000004',
				Err_Mensaj = @Error, 
				Err_Variab = 'Suc_Numero'
	end

	return 1
end

if (select count(Suc_Numero) 
		from SOSUCURS noholdlock 
		where	Suc_Apertu	= @Sta_Si)	> 0 begin
	select	@Error = 'Otra sucursal esta haciendo su apertura. Espere 5 minutos y vuelva a intentar...'		
	if @@nestlevel = 1 begin
		select 	Err_Codigo = '000005',
				Err_Mensaj = @Error,
				Err_Variab = 'Suc_Numero'
	end

	return 1

end else begin
	select	@Error = null

	if @@nestlevel = 1 begin
		select 	Err_Codigo	= '000000',
				Err_Mensaj	= 'Autorizada La Apertura'
	end

end
