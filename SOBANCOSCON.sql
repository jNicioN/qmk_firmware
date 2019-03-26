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

/***********************************************************************************
** DESCRIPCION: ** Consulta alfabetica o consulta numerica de bancos.			  **
************************************************************************************
************************************************************************************
**	REFERENCIAS:																****
************************************************************************************
** Modificó:	Mauricio Avalos Pérez											****
** Fecha:		08/Mar/2019														****
** Help:		1137159															****
** Descripción:	Se agrega la consulta por siglas C7								****
****************************************************************************
** Modificó:		Lucina Gonzalez Trejo						****
** Fecha:		15/Febrero/2007							****
** Help:			20121										****
** Descripción:	Agregar Ban_Direcc y ban_LocEnt 			****
**				a Consula Vacia								****
****************************************************************************
**				STORE CONVERTIDO						****
** Convirtió: fchia											****
** Fecha:     17/Mar/2005									****
****************************************************************************
** Modificó:		Fernando Martinez M.						****
** Fecha:		17/Marzo/2005								****
** Descripción:	Agregar Ban_CoOPVe a la consulta C3		****
** Help:			Corrección									****
****************************************************************************
**				STORE CONVERTIDO						****
** Convirtió: Perla J. Abundis Orozco							****
** Fecha:     02/Mar/2005									****
****************************************************************************
** Modificó:		Fernando Martinez M.						****
** Fecha:		22/Febrero/2005							****
** Descripción:	Agregar campos Ban_CoOPVe				****
** Help:			00079403									****
****************************************************************************
**				STORE CONVERTIDO						****
** Convirtió: Perla J. Abundis Orozco							****
** Fecha:     22/Sep/2004									****
****************************************************************************
** Modificó:		Lucina Gonzalez Trejo						****
** Fecha:		07/Septiembre/2004							****
** Descripción:	Agregar campos Ban_CodGru, Ban_DiLiCa	****
****************************************************************************
**                           Store CONVERTIDO 						****
** Convirtió:		Laura Elena Cervantes D.					****
** Fecha:		05/Julio/2004								****
****************************************************************************
** Modificó:		Eduardo Salazar Gutiérrez					****
** Fecha:		24/Septiembre/2003							****
** Descripción:	Se agregó Ban_UsuCon en la Consulta Llave	****
** 				Foranea Bancos del Extranjero				****
****************************************************************************
** Modificó:		Ricardo Elizondo Guerrero					****
** Fecha:		19/Septiembre/2002							****
** Descripción:	Consulta de Ban_Domici y Ban_PagInt		****
****************************************************************************
** Modificó:		Ing. Ricardo Elizondo Guerrero				****
** Fecha:		03/Septiembre/2002							****
** Descripción:	Consulta Todos Los Bancos De Visual Basic	****
****************************************************************************
** Modificó:		Mayra Estrada								****
** Fecha:		21/Julio/1999								****
** Descripción:	@Tip_Consul p/ Cons. Tipificadas de Visual.	****
****************************************************************************/

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
		end else if @Tip_ConCon = '7' begin		/* Consulta De Bancos por Ban_Siglas	*/
			select	Ban_Numero,	Ban_Nombre	
				from SOBANCOS noholdlock
				where	Ban_Siglas	= @Ban_Nombre /* Se reutiliza el nombre del campo @Ban_Nombre, par abuscar por Sigla*/
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