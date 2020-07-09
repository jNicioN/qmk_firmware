create procedure SOMIGFIRPRO(
	@Mif_Numero	int,
	@Mif_Sucurs	char(3),
	@Mif_Estatu	char(1),
	@Fir_Observ	varchar(254),
	@Tip_Proces	char(1),
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/*
******************************************************************
**	Proceso migración firmas								    **
******************************************************************
** Creo:		Alma Perez										**
** HelpDesk:	1390218											**
** Fecha:		29/06/2020										**
******************************************************************
*/
declare	@Ent_Valido	int,		/* Entero valida existe registro */
		@Ent_Numero	int,		/* Entero identificador tabla */
		@Str_Estatu	char(1),	/* String Estatus tabla */
		@Par_FecAct	smalldatetime,	/* Fecha actual en SOPARAMS */
		@Str_NumTra	char(10),		/* String numero transaccion */
		@Ent_Contad int,			/* Entero contador */
		@Str_FecCor	char(11),		/* String Fecha corta */
		@Ent_Identi	int,			/* Entero identificador de registro */
		@Str_Cuenta	char(12),		/* String cuenta */
		@Str_Consec	char(3),		/* String consecutivo */
		@Str_NumTer	char(3),		/* String numero tercero */
		@Str_Person	char(8),		/* String numero persona */
		@Fec_FechaS	smalldatetime,	/* Fecha sistema */
		@Str_SucFil	char(4),		/* String sucursal filtro */
		@Str_EstVal	char(1),		/* String estatus validacion */
		@Ent_IdeFof	int				/* Entero identificador #NuevoFormatoFirma */

declare @Ent_Cero	int,
		@Str_Cero	char(1),
		@Str_EstPen	char(1),
		@Str_EstPro	char(1),
		@Str_EsNoPr	char(1),
		@Str_EstTer	char(1),
		@Str_EstSca	char(1),
		@Str_Vacio	char(1),
		@Str_StaAct	char(1),
		@Fec_Vacia	smalldatetime,
		@Str_RegTem	char(1),
		@Str_ActTem	char(1),
		@Str_AcTeNo	char(1),
		@Str_ConFir	char(1),
		@Str_ConTot	char(1),
		@Str_ConVac	char(3),
		@Str_Espaci	char(1),
		@Str_TipNue	char(1),
		@Str_ErrUno	char(1),
		@Str_ErrDos	char(1),
		@Str_ErrTre	char(1),
		@Str_ErrCua	char(1),
		@Str_Porcen	char(1)

select	@Ent_Cero	= 0,		/* Entero cero */
		@Str_Cero	= '0',		/* String cero */
		@Str_EstPen	= 'P',		/* Estatus pendiente */
		@Str_EstPro	= 'S',		/* Estatus procesado */
		@Str_EsNoPr	= 'N',		/* Estatus no procesado */
		@Str_EstTer	= 'T',		/* Estatus terminado */
		@Str_EstSca	= 'S',		/* Estatus scaneado */
		@Str_Vacio	= '',		/* String Vacio */
		@Str_StaAct	= 'A',		/* Estatus activo */
		@Fec_Vacia	= '1900-01-01',		/* Fecha Vacia */
		@Str_RegTem	= 'A',		/* Registro de tabla temporal */
		@Str_ActTem	= 'B',		/* Actualizacon de registro tabla temporal como procesado */
		@Str_AcTeNo	= 'C',		/* Actualizacon de registro tabla temporal como no procesado y su observacion */
		@Str_ConFir	= 'D',		/* Opcion para consultar el registro */
		@Str_ConTot	= 'E',		/* Opcion para consultar los totales por sucursal pendientes de procesar */
		@Str_ConVac	= '000',	/* String consecutivo vacio */
		@Str_Espaci	= ' ',		/* String espacio */
		@Str_TipNue	= 'N',		/* String tipo nuevo */
		@Str_ErrUno	= '1',		/* Error uno = CUENTA NO EXISTE EN CHPEFOFI */	
		@Str_ErrDos	= '2',		/* Error dos = NO SE IDENTIFICO EL FORMATO CHPEFOFI */
		@Str_ErrTre	= '3',		/* Error tres = NO SE IDENTIFICO LA PERSONA */
		@Str_ErrCua	= '4',		/* Error cuatro = REGISTROS NumTer 000 NO IDENTIFICADO */
		@Str_Porcen	= '%'		/* String porcentaje */
		
if @Tip_Proces = @Str_RegTem begin
	
	select	@Ent_Valido	= count(1)
		from SOSUCURS noholdlock
		where	Suc_Numero	= @Mif_Sucurs
	
	if @Ent_Valido = @Ent_Cero begin
		select	Err_Codigo = '000001', 
				Err_Mensaj = 'Sucursal '+@Mif_Sucurs+' no válida'
		return 1
	end
	
	select	@Ent_Numero	= @Ent_Cero
	select	@Ent_Numero	= Mif_Numero,
			@Str_Estatu	= Mif_Estatu,
			@Str_NumTra	= NumTransac
		from SOMIGFIR noholdlock
		where	Mif_Sucurs	= @Mif_Sucurs
		
	if @Ent_Numero > @Ent_Cero begin
		
		if @Str_Estatu = @Str_EstTer begin
			select	Err_Codigo = '000002', 
					Err_Mensaj = 'La sucursal '+@Mif_Sucurs+' ya ha sido procesada. Revisar detalle de registros migrados en CHTMPFIR'
			return 1
		end
		
		if @Str_Estatu = @Str_EstPen begin
			select	top 1000	Fir_Identi,	Fir_Cuenta,	Fir_Consec,	Fir_NumTer, Fir_Person
				from CHTMPFIR noholdlock
				where	NumTransac	= @Str_NumTra
				  and	Fir_Estatu	= @Str_EstPen
				order by	Fir_Identi
		end
	
	end else begin
		
		select	@FechaSis	= getdate()
		select	@Str_FecCor = convert(varchar,@FechaSis,111)
		select	@Par_FecAct	= convert(smalldatetime,@Str_FecCor)
		select	@Str_SucFil	= @Mif_Sucurs + @Str_Porcen
	
		select	@Ent_Contad	= count(1) + 1
			from SOMIGFIR noholdlock
			
		select	@Str_NumTra	= str(@Ent_Contad,10,@Str_Cero)
	
		insert into SOMIGFIR (
			Mif_Sucurs,		Mif_FecEje,		Mif_Estatu,		NumTransac,
			Transaccio,		Usuario,		FechaSis,		SucOrigen,		SucDestino )
		values (
			@Mif_Sucurs,	@Par_FecAct,	@Str_EstPen,	@Str_NumTra,
			@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino )
			
		create table #cuentasBase(
			Cue_Numero	char(12) not null)
		
		insert into #cuentasBase	
		select Fir_Cuenta
			from CHFIRMAS noholdlock
			where	Fir_Cuenta like @Str_SucFil
			group by Fir_Cuenta

		create table #baseFirmas(
			Identificador int identity not null,
			Fir_Cuenta	char(12)  not null,
			Fir_Consec	char(3)  not null,
			Fir_NumTer	char(3)  not null,
			Fir_Person	char(8)  not null,
			Fir_EstVal	char(1)  not null,
			FechaSis	smalldatetime not null)
		
		insert into #baseFirmas (
			Fir_Cuenta,	Fir_Consec,	Fir_NumTer,	Fir_Person,	FechaSis,
			Fir_EstVal)
		select	Fir_Cuenta,	@Str_Vacio, Fir_Consec,	@Str_Vacio,	FechaSis,
				@Str_EstPen
			from CHFIRMAS noholdlock
			inner join #cuentasBase on Cue_Numero = Fir_Cuenta
			order by Fir_Cuenta, FechaSis, Fir_Consec
		
		/* Borrar lo que ya existe */	
		delete #baseFirmas
			from #baseFirmas b
			inner join CHADPEFO c noholdlock on Fir_Cuenta = Apf_Cuenta
			  and	Fir_NumTer	= Apf_NumTer
			  and	b.FechaSis	= c.FechaSis
		
		/* Identificar mediante relacion datos */
		
		select	Fof_Cuenta,	Fof_Consec,	Fof_NumTer,	Fof_Person,	FechaSis,
				Fof_Status,	Fof_Tipo
			into #baseFormatoFirmas
			from CHPEFOFI noholdlock
			inner join #cuentasBase on Fof_Cuenta = Cue_Numero
			
			/* Se marcan las firmas que no tienen formato firmas */
		select distinct Fof_Cuenta
			into #formatosCuenta
			from #baseFormatoFirmas
			
		update #baseFirmas set
			Fir_EstVal	= @Str_ErrUno
			from #baseFirmas
			left join #formatosCuenta on Fof_Cuenta = Fir_Cuenta
			where Fof_Cuenta is null
		
			/* Formatos de firmas mas recientes */
		select	Fof_Cuenta,	Fof_Consec = max(Fof_Consec)
			into #ultimoFormatoFirmas
			from #baseFormatoFirmas
			where	Fof_Tipo = @Str_TipNue
			  and	Fof_Status = @Str_EstSca
			group by Fof_Cuenta
			
			/* Detalle de formatos de firmas mas recientes */
		create  table #NuevoFormatoFirmas(
			Fof_Identi	int identity not null,
			Fof_Cuenta	char(12) not null,
			Fof_Consec	char(3) not null,
			Fof_NumTer	char(3) not null,
			Fof_Person	char(8) not null,
			FechaSis	smalldatetime not null,
			Fof_Status	char(1) not null,
			Fof_Tipo	char(1) not null,
			Fof_IdeFir	int not null )
		
		insert into #NuevoFormatoFirmas (
			Fof_Cuenta,	Fof_Consec,	Fof_NumTer,	Fof_Person,	FechaSis,
			Fof_Status,	Fof_Tipo,	Fof_IdeFir )
		select	a.Fof_Cuenta,	a.Fof_Consec,	a.Fof_NumTer,	a.Fof_Person,	a.FechaSis,
				a.Fof_Status,	a.Fof_Tipo,	@Ent_Cero
		from #ultimoFormatoFirmas b
		inner join #baseFormatoFirmas a on a.Fof_Cuenta = b.Fof_Cuenta
			and a.Fof_Consec >= b.Fof_Consec
		
			/* Identificacion datos consecutivo y persona */
		update #baseFirmas set 
			Fir_Consec	= fo.Fof_Consec,
			Fir_Person	= fo.Fof_Person
			from #baseFirmas fi
			inner join #NuevoFormatoFirmas fo on Fir_Cuenta = Fof_Cuenta
					and Fir_NumTer	= Fof_NumTer
			where	Fir_EstVal = @Str_EstPen
			  and	isnull(fo.Fof_Consec,@Str_Vacio) != @Str_Vacio
			  and	isnull(fo.Fof_Person,@Str_Vacio) != @Str_Vacio
			
		/* Segundo intento */
		select @Ent_Valido	= count(1)
			from #baseFirmas
			where	Fir_EstVal	= @Str_EstPen
			  and	Fir_NumTer	= @Str_ConVac
			  
		if @Ent_Valido > @Ent_Cero begin
			
			select Identificador,	Fir_Cuenta,	FechaSis
				into #FirmasPendiente
				from #baseFirmas
				where	Fir_EstVal	= @Str_EstPen
				  and	Fir_NumTer	= @Str_ConVac
				  
			while exists( select 1 from #FirmasPendiente ) 
			begin
				select	top 1 @Ent_Identi = Identificador,
						@Str_Cuenta	= Fir_Cuenta
					from #FirmasPendiente
					order by Fir_Cuenta, FechaSis
					  
				select	top 1 @Ent_IdeFof = Fof_Identi,
						@Str_NumTer	= Fof_NumTer,
						@Str_Consec	= Fof_Consec,
						@Str_Person	= Fof_Person
					from #NuevoFormatoFirmas
					where	Fof_Cuenta	= @Str_Cuenta
					  and	Fof_IdeFir	= @Ent_Cero
					order by convert(int,Fof_Consec), convert(int,Fof_NumTer)
				
				if isnull(@Str_Person,@Str_Vacio) = @Str_Vacio begin
					
					update #baseFirmas set 
						Fir_EstVal	= @Str_ErrTre
						where	Identificador	= @Ent_Identi
						
				end else begin
					
					update #baseFirmas set 
						Fir_NumTer	= @Str_NumTer,
						Fir_Consec	= @Str_Consec,
						Fir_Person	= @Str_Person
						where	Identificador	= @Ent_Identi
						
				end
				
				update top 1 #NuevoFormatoFirmas set
					Fof_IdeFir	= @Ent_Identi
					where	Fof_Identi	= @Ent_IdeFof
				
				delete #FirmasPendiente
					where Identificador	= @Ent_Identi
				
			end
			
			drop table #FirmasPendiente
			
		end
		
		insert into CHTMPFIR ( 
			Fir_Cuenta, Fir_Consec, Fir_NumTer, Fir_Person,	 Fir_Estatu, 
			Fir_Observ,	Fir_FecSis, NumTransac )
			select	Fir_Cuenta,	Fir_Consec,	Fir_NumTer,	Fir_Person,	Fir_EstVal,
					@Str_Vacio,	FechaSis, @Str_NumTra
				from #baseFirmas
				order by Identificador
				
		drop table #cuentasBase, #baseFirmas, #baseFormatoFirmas, 
			#formatosCuenta, #ultimoFormatoFirmas, #NuevoFormatoFirmas
			
		update CHTMPFIR set 
			Fir_Observ	= 'CUENTA NO EXISTE EN CHPEFOFI'
			where	Fir_Estatu	= @Str_ErrUno
			  and	NumTransac	= @Str_NumTra
		
		update CHTMPFIR set 
			Fir_Observ	= 'NO SE IDENTIFICO EL FORMATO CHPEFOFI',
			Fir_Estatu	= @Str_ErrDos
			where	Fir_Consec	= @Str_Espaci
			  and	Fir_Estatu	= @Str_EstPen
			  and	NumTransac	= @Str_NumTra
		
		update CHTMPFIR set 
			Fir_Observ	= 'NO SE IDENTIFICO LA PERSONA'
			where	Fir_Estatu	= @Str_ErrTre
			  and	NumTransac	= @Str_NumTra
		
		select	Top 1000 Fir_Identi,	Fir_Cuenta,	Fir_Consec,	Fir_NumTer,	Fir_Person
			from CHTMPFIR noholdlock
			where	NumTransac	= @Str_NumTra
			  and	Fir_Estatu	= @Str_EstPen
			order by	Fir_Identi
						
	end
end

if @Tip_Proces = @Str_ActTem begin
	update CHTMPFIR set Fir_Estatu = @Str_EstPro
		where	Fir_Identi = @Mif_Numero
	
end

if @Tip_Proces = @Str_AcTeNo begin
	update CHTMPFIR set 
		Fir_Estatu = @Str_EsNoPr,
		Fir_Observ = @Fir_Observ
		where	Fir_Identi = @Mif_Numero
	
end

if @Tip_Proces = @Str_EstTer begin
	update SOMIGFIR set Mif_Estatu = @Str_EstTer
		where	Mif_Sucurs = @Mif_Sucurs
	
end

if @Tip_Proces = @Str_ConFir begin
	
	select	@Str_Cuenta = Fir_Cuenta,
			@Str_Consec	= Fir_NumTer,
			@Fec_FechaS	= Fir_FecSis
		from CHTMPFIR noholdlock
		where	Fir_Identi = @Mif_Numero
		
	update top 1 CHFIRMAS set
		NumTransac	= convert(char(10), @Mif_Numero)
		where	Fir_Cuenta	= @Str_Cuenta
		  and	Fir_Consec	= @Str_Consec
		  and	FechaSis	= @Fec_FechaS
		  and	NumTransac	= @Str_Espaci
	
	select	t.Fir_Identi,	t.Fir_Cuenta,	t.Fir_Consec,	t.Fir_NumTer,	t.Fir_Person,
			t.Fir_Observ,	PerPersoID,	f.Fir_Firma,	f.Usuario,	f.FechaSis
	from CHTMPFIR t noholdlock
	left join SOPERSON noholdlock on Fir_Person = Per_Numero
	left join CHFIRMAS f noholdlock on t.Fir_Cuenta = f.Fir_Cuenta
	where	t.Fir_Identi	= @Mif_Numero
	  and	f.NumTransac	= convert(char(10), @Mif_Numero)
end

if @Tip_Proces = @Str_ConTot begin
	select	@Str_NumTra	= NumTransac
		from SOMIGFIR noholdlock
		where	Mif_Sucurs = @Mif_Sucurs
	
	select	TotalRegistros = count(1)
		from CHTMPFIR noholdlock
		where	NumTransac	= @Str_NumTra
		  and	Fir_Estatu	= @Str_EstPen
end