create procedure SOBANCOSCON	(
	@Ban_Numero	char(3),
	@Ban_Nombre	varchar(50),
	@Ban_NumSis	char(4),
	@Tip_Consul	char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Tip_ConTip	char(1),			/*	Declaracion De Variables	*/
		@Tip_ConCon	char(1)

declare	@Str_Vacio	char(1),			/*	Declaracion De Constantes	*/
		@Ban_Extran	char(1),
		@Si_Status	char(1)

/*	Asignacion De Costantes	*/
select	@Str_Vacio	= '',				/*	String Vacio	*/
		@Ban_Extran	= 'E',				/*	Banco: Extranjero	*/
		@Si_Status	= 'S'				/*	Si Tiene Servicio	*/

if @Tip_Consul = @Str_Vacio begin		/* Cliente:  FoxPro */
	if (@Ban_Nombre = @Str_Vacio) and (@Ban_Numero = @Str_Vacio) and (@Ban_NumSis = @Str_Vacio)
		select	Ban_Numero,	Ban_Nombre,	Ban_Siglas,	Ban_NumSis,	Ban_TipBan,
				Ban_UsuCon,	Ban_CobRem,	Ban_Domici,	Ban_PagInt,	Ban_CodGru,
				Ban_DiLiCa,	Ban_Direcc,	Ban_LocEnt
			from SOBANCOS noholdlock
			order by Ban_Nombre
	else
		if (@Ban_Nombre = @Str_Vacio)
			if @Ban_NumSis = @Str_Vacio
				select	Ban_Numero,	Ban_Nombre,	Ban_Siglas,	Ban_NumSis,	Ban_TipBan,
						Ban_UsuCon,	Ban_CobRem,	Ban_Domici,	Ban_PagInt,	Ban_CodGru,
						Ban_DiLiCa,	Ban_Direcc,	Ban_LocEnt
					from SOBANCOS noholdlock
					where	Ban_Numero = @Ban_Numero
			else
				select	Ban_Numero,	Ban_Nombre,	Ban_Siglas,	Ban_NumSis,	Ban_TipBan,
						Ban_UsuCon,	Ban_CobRem,	Ban_Domici,	Ban_PagInt,	Ban_CodGru,
						Ban_DiLiCa,	Ban_CoOPVe,	Ban_Direcc,	Ban_LocEnt
					from SOBANCOS noholdlock
					where	Ban_NumSis = @Ban_NumSis
		else
			select	Ban_Numero,	Ban_Nombre,	Ban_Siglas,	Ban_NumSis,	Ban_TipBan,
					Ban_UsuCon,	Ban_CobRem
				from SOBANCOS noholdlock
				where	Ban_Nombre like @Ban_Nombre + '%'
				order by Ban_Nombre
end else begin			/* Cliente:  Visual Basic	*/
	select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
			@Tip_ConCon	= substring(@Tip_Consul, 2, 1)
	
	if @Tip_ConTip = 'C' begin		/* 'C':  Consulta */
		if @Tip_ConCon = '1' begin				/* Consulta de Llave Principal */
			select	Ban_Numero,	Ban_Nombre,	Ban_Siglas,	Ban_NumSis,	Ban_TipBan,
					Ban_UsuCon,	Ban_CobRem
				from SOBANCOS noholdlock
				where	Ban_Numero = @Ban_Numero
		end else if @Tip_ConCon = '2' begin		/* Consulta de Llave Foranea Numero */
			select	Ban_Numero,	Ban_Nombre
				from SOBANCOS noholdlock
				where	Ban_Numero = @Ban_Numero
		end else if @Tip_ConCon = '3' begin		/* Consulta de Llave Foranea NumSis */
			select	Ban_Numero,	Ban_Nombre,	Ban_NumSis, Ban_TipBan,	Ban_CoOPVe
				from SOBANCOS noholdlock
				where	Ban_NumSis = @Ban_NumSis
		end else if @Tip_ConCon = '4' begin		/* Consulta de Llave Foranea Bancos del Extranjero */
			select	Ban_Nombre,	Ban_NumSis,	Ban_UsuCon
				from SOBANCOS noholdlock
				where	Ban_NumSis = @Ban_NumSis
				and 	Ban_TipBan = @Ban_Extran
		end else if @Tip_ConCon = '5' begin		/* Consulta De Todos Los Bancos */
			select	Ban_Numero,	Ban_Nombre,	Ban_TipBan
				from SOBANCOS noholdlock
		end else if @Tip_ConCon = '6' begin		/* Consulta De Bancos Con Servicio De Domiciliar	*/
			select	Ban_Numero,	Ban_Nombre							/*	Consulta De Fox Pro		*/
				from SOBANCOS noholdlock
				where	Ban_Numero	= @Ban_Numero
				  and	Ban_Domici	= @Si_Status
		end		  
	end else begin					/* 'L':  Lista */
		select	@Ban_Nombre	= ltrim(rtrim(@Ban_Nombre)) + '%'
		
		if @Tip_ConCon = '1' begin				/* Lista General */
			select	Ban_Numero,	Ban_Nombre,	Ban_NumSis
				from SOBANCOS noholdlock
				where	Ban_Nombre like @Ban_Nombre
				order by Ban_Nombre
		end else if @Tip_ConCon = '2' begin				/* Lista Bancos del Extranjero */
			select	Ban_Nombre,	Ban_NumSis
				from SOBANCOS noholdlock
				where	Ban_Nombre like @Ban_Nombre
				and 	Ban_TipBan = @Ban_Extran
				order by Ban_Nombre
		end else if @Tip_ConCon = '3' begin				/* Lista Bancos Con Servicio Domiciliar	*/
			select	Ban_Numero,	Ban_NumSis,	Ban_Nombre			/*	Lista De Fox Pro		*/
				from SOBANCOS noholdlock
				where	Ban_Domici	= @Si_Status
				  and	Ban_Nombre like @Ban_Nombre
				order by Ban_Nombre
		end
	end
end
