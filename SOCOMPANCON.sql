create procedure SOCOMPANCON (
	@Com_Numero	char(2),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*****************************************************************************/
/* DESCRIPCION: ** Consulta de Compania ** */
/*****************************************************************************/
/** REFERENCIAS: 
****************************************************************************
** Modifico:	Julio Cesar Diaz Lopez									****
** Fecha:		12 de Julio del 2022									****
** Help:		1390403												    ****
** Descripcion:	Se agrega C4 para dar salida al nombre del pais, 		****
**				su abreviatura y separacion numero exterior e interior	****
****************************************************************************
** Modifico:	Juan Pablo Mendez Cabrales								****
** Fecha:		24 de Abril del 2020									****
** Help:		01352603												****
** Descripcion:	Se agrega C3 para dart salida a Direccion copleta		****
****************************************************************************
** Modifico:	Jaret Guanajuato Ruvalcaba								****
** Fecha:		11/Diciembre/2013											****
** Help:		00591890													****
** Descripcion:	Agregar Com_FolEle,	Com_CorEle a C1						****
****************************************************************************
**				STORE CONVERTIDO						****
** Convirtió:		Armando Ivan Garcia Gonzalez				****
** Fecha:		25/Ene/2010								****
****************************************************************************
** Modifico:		Roberto Pascuale Morales Chavez			****
** Fecha:		25/Enero/2010								****
** Help:			223033										****
** Descri:		Agregar la Lista L1 por Com_Numero,			****
**				Com_Descri	y Estandarizar					****
****************************************************************************
** Modificó:		Adrián Labastida								****
** Fecha:		18/Enero/2007								****
** Modificación: Se agrego el campo Com_ClaIns a la cons C2	****
****************************************************************************
** Modificó:		Adrián Labastida								****
** Fecha:		12/Enero/2007								****
** Modificación: Se agregaron los ultimos 2 campos a la 		****
** 				consulta C2 (Est_Nombre y Est_Abrevi)		****
****************************************************************************
**				STORE CONVERTIDO						****
** Convirtió:		Karina Chavarría Tovar						****
** Fecha:		04/Ene/2007								****
****************************************************************************
** Modificó:		Adrián Labastida								****
** Fecha:		27/Diciembre/2006							****
** Modificación: Se agregaron los ultimos 2 campos a la 		****
** 				consulta general	 (Com_Abrevi y Com_ClaIns)	****
****************************************************************************
**				STORE CONVERTIDO						****
** Convirtió:		Karina Chavarría Tovar						****
** Fecha:		22/Diciembre/2006							****
****************************************************************************
** Modificó:		Adrián Labastida								****
** Fecha:		18/Diciembre/2006							****
** Modificación: Se agregaron los ultimos 7 campos a la 		****
** 				consulta general	 (Campo final:  Com_Pais)	****
****************************************************************************
**				STORE CONVERTIDO						****
** Convirtió:		Francisco Javier Cordero Guzmán				****
** Fecha:		01/Noviembre/2005							****
****************************************************************************
** Creó:			GFLORES        								****
** Fecha:		16/Ago/05									****
** Help:		       No. de Help al que pertenece la modificación	****
******************************************************************************/

declare @Tip_ConTip char(1),				/* Declaración de Variables */
		@Tip_ConCon char(1),
		@Com_NumExt char(10),
		@Com_NumInt char(10),
		@Tot_Caract	int,
		@Gui_Encont int

declare	@Tra_Consul	char(1),				/* Declaración de Constantes */
		@Tra_Lista	char(1),
		@Str_Uno    char(1),
		@Str_Dos    char(1),
		@Str_Tres	char(1),
		@Str_Cuatro	char(1),
		@Str_Vacio	char(1),
		@Str_Guion	char(1),
		@Ent_Uno	int,
		@Ent_Cero	int

/* Asignación de Constantes */
select	@Tra_Consul	= 'C',					/* Transacción Tipo Consulta */
		@Tra_Lista	= 'L',					/* Transacción Tipo Lista */
		@Str_Uno    = '1',
		@Str_Dos    = '2',
		@Str_Tres   = '3',
		@Str_Cuatro	= '4',
		@Str_Vacio 	= '',
		@Str_Guion	= '-',
		@Ent_Uno	= 1,
		@Ent_Cero	= 0
		
select 	@Tip_ConTip = substring(@Tip_Consul,1,1),
		@Tip_ConCon = substring(@Tip_Consul,2,1)

if @Tip_ConTip = @Tra_Consul begin
	if @Tip_ConCon = @Str_Uno begin				/* Consulta de llave Principal */

		select	Com_Numero,	Com_Descri,	Com_RFC,	Com_Calle,	Com_CalNum,
				Com_Coloni,	Com_CodPos,	Com_Ciudad,	Com_Estado,	Com_Pais,
				Com_Abrevi,	Com_ClaIns, Com_FolEle,	Com_CorEle
			from SOCOMPAN noholdlock
			where	Com_Numero	= @Com_Numero
	end

	if @Tip_ConCon = @Str_Dos begin				/* Consulta Nombre de Ciudad */
	
		select	Com_Numero,	Com_Descri,	Ciu_Nombre,	Ciu_Estado,	Est_Nombre,
				Est_Abrevi,	Com_ClaIns	
			from SOCOMPAN noholdlock,
				 SOCIUDAD noholdlock,
				 SOESTADO noholdlock
			where	Com_Numero	= @Com_Numero
			  and	Com_Ciudad	= Ciu_Numero
			  and	Com_Estado	= Est_Numero
			  and	Ciu_Estado	= Est_Numero
	end
	if @Tip_ConCon = @Str_Tres begin				/* Consulta de llave Principal */
		select	distinct
				Com_Numero,	Com_Descri,	Com_RFC,	Com_Calle,	Com_CalNum,
				Com_Coloni,	Com_CodPos,	Com_Ciudad,	Com_Estado,	Com_Pais,
				Com_Abrevi,	Com_ClaIns, Com_FolEle,	Com_CorEle, Ciu_Nombre,	
				Ciu_Estado,	Est_Nombre, Ent_Nombre
			from SOCOMPAN noholdlock
			inner join SOESTADO noholdlock 	 on Est_Numero	= Com_Estado
			inner join CLENTIDA	noholdlock	 on Est_ClaABM  = Ent_Inegi
			inner join SOCIUDAD noholdlock 	 on Ciu_Numero	= Com_Ciudad 
											and Ciu_Estado	= Est_Numero
			where	Com_Numero	= @Com_Numero
	end
	if @Tip_ConCon = @Str_Cuatro begin				/* Consulta de llave Principal + Nombre Pais y numero exterior e interior seperadp*/
		create table #Companias(
			Com_Numero 	char(2),	
			Com_Descri 	varchar(50),	
			Com_RFC		char(15),	
			Com_Calle	char(40),	
			Com_CalNum	char(10),
			Com_Coloni	char(80),	
			Com_CodPos	char(6),	
			Com_Ciudad	char(3),	
			Com_Estado	char(2),	
			Com_Pais	char(3),
			Com_Abrevi	varchar(3),	
			Com_ClaIns	char(3), 
			Com_FolEle	char(10),	
			Com_CorEle	char(30), 
			Ciu_Nombre varchar(50),	
			Ciu_Estado char(2),	
			Est_Nombre varchar(50), 
			Ent_Nombre varchar(30), 
			Pai_Nombre varchar(30), 
			Pai_Abrevi varchar(10),
			Com_NumExt char(10) null,
			Com_NumInt char(10) null
		)
		insert into #Companias -- Se obtiene informacion de la compañia
		select	distinct
						Com_Numero,	Com_Descri,	Com_RFC,	Com_Calle,	Com_CalNum,
						Com_Coloni,	Com_CodPos,	Com_Ciudad,	Com_Estado,	Com_Pais,
						Com_Abrevi,	Com_ClaIns, Com_FolEle,	Com_CorEle, Ciu_Nombre,	
						Ciu_Estado,	Est_Nombre, Ent_Nombre, Pai_Nombre, Pai_Abrevi,
						@Str_Vacio as Com_NumExt, @Str_Vacio as Com_NumInt
					from SOCOMPAN noholdlock
					inner join SOPAIS   noholdlock 	 on Com_Pais	= Pai_Numero
					inner join SOESTADO noholdlock 	 on Est_Numero	= Com_Estado
					inner join CLENTIDA	noholdlock	 on Est_ClaABM  = Ent_Inegi
					inner join SOCIUDAD noholdlock 	 on Ciu_Numero	= Com_Ciudad 
													and Ciu_Estado	= Est_Numero
					where	Com_Numero	= @Com_Numero
					
		select 	@Com_NumExt = Com_CalNum
			from #Companias noholdlock
			where	Com_Numero	= @Com_Numero
		
		/* Separar Numero Exterior de Numero Interior*/
		select 	@Tot_Caract = len(@Com_NumExt),
				@Gui_Encont = charindex(@Str_Guion,@Com_NumExt)
				
		if @Gui_Encont > @Ent_Cero begin
			select 	@Com_NumExt = ltrim(rtrim(substring(@Com_NumExt,@Ent_Uno,@Gui_Encont-@Ent_Uno))),
					@Com_NumInt = ltrim(rtrim(substring(@Com_NumExt,@Gui_Encont+@Ent_Uno,@Tot_Caract)))
		end else begin
			select 	@Com_NumExt = @Com_NumExt,
					@Com_NumInt = @Str_Vacio
		end
		
		update #Companias set 
			Com_NumExt = @Com_NumExt, 
			Com_NumInt = @Com_NumInt
		where	Com_Numero	= @Com_Numero
		
		select  Com_Numero, Com_Descri, Com_RFC, 	Com_Calle, 	Com_CalNum, 
				Com_Coloni, Com_CodPos, Com_Ciudad, Com_Estado, Com_Pais, 
				Com_Abrevi, Com_ClaIns, Com_FolEle, Com_CorEle, Ciu_Nombre, 
				Ciu_Estado, Est_Nombre, Ent_Nombre, Pai_Nombre, Pai_Abrevi, 
				Com_NumExt, Com_NumInt 
			from #Companias
		drop table #Companias
	end
	
end else if @Tip_ConTip = @Tra_Lista begin
	if @Tip_ConCon = @Str_Uno begin				
		select	Com_Numero,	Com_Descri
			from SOCOMPAN noholdlock
			order by Com_Numero
	end
end