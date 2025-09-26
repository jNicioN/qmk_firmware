create procedure SOINTAUTCON (
	@Opi_NuIdOp	int,			/* Número identificador de operación de identificación */
	@Cio_NuIdCo	int,			/* Número identificador de configuración de Operación de Identificación */
	@Per_Numero	char(8),		/* Número de persona */
	@Cue_Numero	char(12),		/* Número de cuenta */
	@Cli_Numero	char(8),		/* Número de cliente */	
	@Per_Comple	varchar(180),	/* Nombre completo de la persona */
	@Tip_Consul	char(2),		/* Tipo de consulta*/

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
	
as

/* *****************************************************************
** DESCRIPCION: Consulta de intervinientes Autorizados			  **
**				(para Identificación de Operaciones)			  **
********************************************************************
** Modificó:	Daniel Nevarez									****
** Fecha:		17/09/2025										****
** Help:		TCELES-36275									****
** Descripcion:	Incluir consulta a CHCOTBEN para PM en			****
				modulo de CLI									****
********************************************************************
** Modificó:	Francisco Javier Carrillo Rojas					****
** Fecha:		07/Abril/2020									****
** Help:		01379522										****
** Descripcion:	Incluir soporte para configuraciones de intervi-****
**				nientes requeridos: Terceros-Mancomunados		****
********************************************************************
** Modificó:	Francisco Javier Carrillo Rojas					****
** Fecha:		12/Junio/2019									****
** Help:		01258559										****
** Descripcion:	Considerar status de registros nuevos de firma	****
**				autorizados y escaneados para obtener el		****
**				conjunto de firmas/personas que aplican			****
********************************************************************
** Modificó:	Francisco Javier Carrillo Rojas					****
** Fecha:		31/Ene/2019										****
** Help:		01091555										****
** Descripcion:	Considerar varios registros de firmas 			****
**				existentes y obtener el correcto				****
********************************************************************
** Modificó:	Francisco Javier Carrillo Rojas					****
** Fecha:		23/Ene/2019										****
** Help:		01147468										****
** Descripcion:	Considerar como tercero autorizado el titular	****
**				cuando no haya ninguno registrado				****
**				agregar índices a tablas temporales				****
********************************************************************
**					STORE CONVERTIDO							****
** Convirtió:	Francisco Javier Carrillo Rojas					****
** Fecha:		10/Jun/2018										****
** Help:		01088831										****
********************************************************************
** Creó:		Francisco Javier Carrillo Rojas					****
** Fecha:		10/Jun/2018										****
** Help:		01088831										****
** Descripcion:	Consulta de intervinientes Autorizados			****
**				(para Identificación de Operaciones)			****
********************************************************************/
/* Declaracion de Variables */
declare	@Tip_ConTip	char(1),	/* Consulta Tipo C/L*/
		@Tip_ConCon	char(1),	/* Tipo Consecutivo */
		@Opi_TipOpe int,		/* Tipo de operación (Disposición, entrega de medios y contratación ver referencia de campo en tabla SOOPEIDE)*/
		@Opi_BasOpe varchar(4),	/* Tipo de base en parámetro recibido (ver metadata de campo en tabla SOPEIDE)*/
		@Cio_Status	char(1),	/* Estatus de configuración */
		@Ins_PerCli	int,		/* Bandera para saber si se inserta el registro de la persona del cliente */
		@Fof_MaxCon	smallint,	/* Consecutivo máximo del registro de firmas */
		@Cio_IntReq	char(2),	/* Intervinientes requeridos */
		@Cli_Tipo	char(1)		/* Tipo de cliente (física o moral) */


/* Declaracion de Constantes */
declare	@Str_C		char(1),
		@Str_Uno	char(1),
		@Str_Dos    char(1),
		@Str_Porcie	char(1),
		@Str_Vacio	char(1),
		@Ent_Cero	int,
		@Tip_PerFis	char(1),
		@Tip_PerMor	char(1),
		@Tip_Titula	char(1),
		@Tip_Cotitu	char(1),
		@Tip_Tercer	char(1),
		@Sta_Activo	char(1),
		@Tip_BasCli	varchar(4),
		@Tip_BasCue	varchar(4),
		@Tip_TerAut	char(1),
		@Tip_FirA	char(1),
		@Ent_Uno	int,
		@Sta_FirEsc	char(1),
		@Sta_FirAut	char(1),
		@Tip_ReFiNu	char(1),
		@Tip_CoTeMa	char(2),
		@Nom_Titula varchar(50),
		@Nom_Cotitu varchar(50),
		@Nom_Tercer varchar(50),
		@Nom_Otro varchar(50)

/* Asignacion de Constantes */
select	@Str_C		= 'C',		/* Tipo C */
		@Str_Uno	= '1',		/* Tipo 1 */
		@Str_Dos    = '2',		/* Tipo 2 */
		@Str_Porcie	= '%',		/* String porciento */
		@Str_Vacio	= '',		/* String vacío */
		@Ent_Cero	= 0,		/* Entero en cero */
		@Tip_PerFis	= '2',		/* Tipo de persona persona física */
		@Tip_PerMor	= '1',		/* Tipo de persona persona moral */
		@Tip_Titula	= '1',		/* Tipo de interviniente Titular */
		@Tip_Cotitu	= '3',		/* Tipo de interviniente Cotitular */
		@Tip_Tercer	= '7',		/* Tipo de interviniente Tercero autorizado */
		@Sta_Activo	= 'A',		/* Status Activo */
		@Tip_BasCli	= 'CLI',	/* Tipo base cliente(Operación con) */
		@Tip_BasCue	= 'CUE',	/* Tipo base cuenta(Operación con) */
		@Tip_TerAut	= '7',		/* Tipo tercero autorizado */
		@Tip_FirA	= 'A',		/* Tipo de firma A */
		@Ent_Uno	= 1,		/* Entero en uno */
		@Sta_FirEsc	= 'S',		/* Status de firma escaneado */
		@Sta_FirAut	= 'A',		/* Status de firma autorizado */
		@Tip_ReFiNu	= 'N',		/* Tipo de registro de firmas nuevo */
		@Tip_CoTeMa	= 'PM',		/* Tipo de configuración de Terceros-Mancomunados(Intervinientes requeridos)*/
		@Nom_Titula = 'Titular',/* Nombre titular */
		@Nom_Cotitu = 'Cotitular',/* Nombre cotitular */
		@Nom_Tercer = 'Tercero',/* Nombre tercero */
		@Nom_Otro	= ''		/* Nombre para otros */
		

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

create table #PersonasDuplicadas(
	Ped_Numero	char(8)  not null,
	Ped_Tipo	char(1))

create table #Terceros(
	Ter_Grupo	char(8)  not null)
	
create table #PersonasAutorizadas(
	Per_Numero	char(8)  not null,
	Cob_Tipo	char(1),
	Cob_EsTerc	int)

create table #Personas(
	Per_Person	char(8),
	Per_Grupo	char(8),
	Per_TipFir	char(1),
	Per_CobTip	char(1),
	Per_CobNom	varchar(120),
	Per_EsTerc	int) 

create index PersonasAutorizadas on #PersonasAutorizadas(Per_Numero)
create index Personas on #Personas(Per_Grupo)
	
select	@Opi_TipOpe	= Opi_TipOpe,
		@Cio_NuIdCo	= Cio_NuIdCo,
		@Cio_Status	= Cio_Status,
		@Opi_BasOpe	= Opi_BasOpe,
		@Cio_IntReq	= Cio_IntReq
	from SOOPEIDE ope noholdlock
		left join SOCOIDOP con noholdlock on con.Cio_NuIdOp	= ope.Opi_NuIdOp
	where	con.Cio_NuIdOp	= @Opi_NuIdOp
	  and	con.Cio_NuIdCo	= @Cio_NuIdCo

select	@Ins_PerCli	= @Ent_Cero
/*Base para poder obtener los intervinientes autorizados de acuerdo a la configuración dada */
if isnull(@Opi_TipOpe, @Ent_Cero) != @Ent_Cero and isnull(@Cio_Status, @Str_Vacio) = @Sta_Activo begin
	if @Opi_BasOpe	= @Tip_BasCli begin

		select	@Cli_Tipo	= Cli_Tipo
			 from	CLCLIENT noholdlock
			where	Cli_Numero	= @Cli_Numero

		/* Solo podemos tener el número de cliente */
		if @Cli_Tipo = @Tip_PerFis begin 

			insert into #PersonasAutorizadas
				select	adi.Adi_NumPer,	@Tip_Titula, @Ent_Cero
					from CLCLIENT cli noholdlock
						inner join CLADICIO adi noholdlock on adi.ClClientID = cli.ClClientID 					
					where	cli.Cli_Numero	= @Cli_Numero
					and	cli.Cli_Tipo	= @Tip_PerFis
					and	@Tip_Titula in(select Tii_TipInt
											from SOTIINID noholdlock
											where	Tii_NuIdCo	= @Cio_NuIdCo
											  and	Tii_Status	= @Sta_Activo)
		end else if @Cli_Tipo = @Tip_PerMor begin

			insert into #PersonasAutorizadas
				select	Cob_Person,	Cob_Tipo, @Ent_Cero
					from CHCOTBEN noholdlock
					inner join CHCUENTA noholdlock on Cue_Numero = Cob_Cuenta
					where	Cue_Client	= @Cli_Numero
					  and	Cob_Tipo in(select	Tii_TipInt
											from SOTIINID noholdlock
											where	Tii_NuIdCo	= @Cio_NuIdCo
											  and	Tii_Status	= @Sta_Activo)

		end
				
	end else if @Opi_BasOpe	= @Tip_BasCue begin
		/* Se obtienen por referencias en cotitulares/beneficiarios/etc */
		select	@Cli_Numero	= Cue_Client
			from CHCUENTA noholdlock
			where	Cue_Numero	= @Cue_Numero


		--Registro de personas autorizadas(Para ciertas cuentas si existe el tipo titular y para otras solo el beneficiario, por lo que se tiene que hacer la búsqueda en CLCLIENT)
		insert into #PersonasDuplicadas
			select	adi.Adi_NumPer,	@Tip_Titula
				from CLCLIENT cli noholdlock
					 inner join CLADICIO adi noholdlock on adi.ClClientID = cli.ClClientID 					
				where	cli.Cli_Numero	= @Cli_Numero
				  and	cli.Cli_Tipo	= @Tip_PerFis
				  and	@Tip_Titula in(select Tii_TipInt
										from SOTIINID noholdlock
										where	Tii_NuIdCo	= @Cio_NuIdCo
										  and	Tii_Status	= @Sta_Activo)
			union
			select	Cob_Person,	Cob_Tipo
				from CHCOTBEN noholdlock
				where	Cob_Cuenta	= @Cue_Numero
				  and	Cob_Tipo in(select Tii_TipInt
										from SOTIINID noholdlock
										where	Tii_NuIdCo	= @Cio_NuIdCo
										  and	Tii_Status	= @Sta_Activo)
		
		insert into #PersonasAutorizadas
			select	Ped_Numero, min(Ped_Tipo), @Ent_Cero
				from  #PersonasDuplicadas
				group by Ped_Numero
		
		insert into #Terceros 
			select Peu_Grupo
				from #PersonasDuplicadas as duplicadas
					 inner join SOUNIPER on Ped_Numero = Peu_Person
				where	Ped_Tipo	= @Tip_Tercer
				  and	ltrim(Ped_Numero) is not null
				group by Peu_Grupo
				
		/*Excepto para configuraciones de terceros-mancomunado, insertar de forma manual al titular como tercero autorizado cuando no haya 
		ni un tercero autorizado ligado a la cuenta, para considerarlo como firma A (ver update de tabla #Personas de más abajo)
		solo en los casos en los que para la operación en cuestión figuran como intervinientes autorizados los terceros autorizados */
		if @Cio_IntReq != @Tip_CoTeMa and (select count(1)
												from #PersonasAutorizadas) = @Ent_Cero begin
				if @Tip_TerAut in(select Tii_TipInt
										from SOTIINID noholdlock
										where	Tii_NuIdCo	= @Cio_NuIdCo
										  and	Tii_Status	= @Sta_Activo) begin
					insert into #PersonasAutorizadas
						select	adi.Adi_NumPer,	@Tip_Titula, @Ent_Uno
							from CLCLIENT cli noholdlock
								 inner join CLADICIO adi noholdlock on adi.ClClientID = cli.ClClientID 					
							where	cli.Cli_Numero	= @Cli_Numero
							  and	cli.Cli_Tipo	= @Tip_PerFis

					select	@Ins_PerCli	= @Ent_Uno
				end
		end
	end
end
				  	  
if @Tip_ConTip = @Str_C begin
	if @Tip_ConCon	= @Str_Uno begin /* C1 - Búsqueda de interviniente autorizado(consulta principal) por id único de persona*/
		insert into #Personas
			select	aut.Per_Numero,	aut.Per_Numero,	@Str_Vacio,	aut.Cob_Tipo,	@Str_Vacio,	Cob_EsTerc
				from #PersonasAutorizadas as aut
					 inner join SOPERSON as per noholdlock on per.Per_Numero	= aut.Per_Numero 

		update #Personas set
			Per_Grupo = Peu_Grupo
			from SOUNIPER noholdlock
			where	Peu_Person = Per_Person

		/*Debido a que las reglas de intervinientes requeridos PI, PS, PM incluyen tanto titulares/cotitulares y terceros, se requiere
		conservar el rastro de si previo a la agrupación, la persona también era un tercero, esto con la finalidad de obtener
		el tipo de firma inferido del nombre del interviniente cuando el número de persona es vacío en CHPEFOFI */
		update #Personas set
			Per_EsTerc	= @Ent_Uno
			from #Terceros
			where Ter_Grupo	= Per_Grupo			

		/*Solo para operaciones ligadas a cuentas, se actualiza su nivel de firma de los terceros autorizados*/
		if @Opi_BasOpe	= @Tip_BasCue begin
			if @Ins_PerCli = @Ent_Uno begin
				update #Personas set
					Per_TipFir	= @Tip_FirA
			end else begin
				update #Personas set
					Per_CobNom	= Cob_Nombre
					from CHCOTBEN noholdlock 
					where	Cob_Cuenta	= @Cue_Numero
					  and	Cob_Person	= Per_Person
					  and	(Cob_Tipo	= @Tip_TerAut
					  or	Per_EsTerc	= @Ent_Uno)

			  --Se consigue el consecutivo del registro actual válido para poder actualizar los tipos de firma de acuerdo al registro vigente y o adicionales
			  	select @Fof_MaxCon	= convert(smallint, max(Fof_Consec))
					from CHPEFOFI noholdlock
					where	Fof_Cuenta	= @Cue_Numero
					  and	Fof_Status	in (@Sta_FirEsc, @Sta_FirAut)
					  and	Fof_Tipo	= @Tip_ReFiNu
			
				update #Personas set
					Per_TipFir	= Fof_TipFir
					from CHPEFOFI noholdlock					
					where	Fof_Cuenta	= @Cue_Numero
					  and	Fof_Person	= Per_Person
					  and	Fof_Status	in (@Sta_FirEsc, @Sta_FirAut)
					  and	convert(smallint, Fof_Consec)	>= @Fof_MaxCon
					  
				--Complementar el tipo de firma con aquellos casos de terceros autorizados que no tengan el número de persona asociado en el registro de CHPEFOFI infiriéndolo de CHCOTBEN
				update #Personas set
					Per_TipFir	= Fof_TipFir
					from CHPEFOFI noholdlock
					where	Fof_Cuenta	= @Cue_Numero
					  and	ltrim(Fof_Person) is null
					  and	Fof_Status	in (@Sta_FirEsc, @Sta_FirAut)
					  and	convert(smallint, Fof_Consec)	>= @Fof_MaxCon
					  and	ltrim(Per_Person) is not null
					  and	Per_CobNom	= Fof_Nombre
					  and	ltrim(Per_TipFir) is null
			end
		end
		
		--Salida de intervinientes autorizados para identificación
		select	Per_Numero, Per_ComOrd, Per_Comple,	Per_RFC,	Per_CURP,
				Per_Nombre,	Per_ApePat,	Per_ApeMat,	Adi_TipIde,	Adi_NumIde,
				Adi_FeVeId,	Per_Nacion,	Adi_NacExt,	Per_TipFir,	Per_CobTip,
				Per_CoNoTi = case 
					when Per_CobTip = @Tip_Titula then @Nom_Titula
					when Per_CobTip = @Tip_Cotitu then @Nom_Cotitu
					when Per_CobTip = @Tip_Tercer then @Nom_Tercer
					else @Nom_Otro
				end,
				Per_EsTerc
			from #Personas
				 inner join SOPERSON noholdlock on Per_Numero = Per_Grupo
				 left outer join SOPERADI noholdlock on Adi_PerNum	= Per_Numero
			where	Per_Grupo	= @Per_Numero
			order by Per_CobTip asc
	end	
end else begin
	if @Tip_ConCon	= @Str_Uno begin /* L1 - Búsqueda de personas autorizadas ligadas a configuración por nombre completo*/
		if isnull(@Per_Comple, @Str_Vacio) = @Str_Vacio begin
			insert into #Personas
				select	aut.Per_Numero,	aut.Per_Numero,	@Str_Vacio,	aut.Cob_Tipo,	@Str_Vacio,	Cob_EsTerc
					from #PersonasAutorizadas as aut
						 inner join SOPERSON as per noholdlock on per.Per_Numero	= aut.Per_Numero 

		end	else begin
			select	@Per_Comple	= ltrim(isnull(@Per_Comple, @Str_Vacio)) + @Str_Porcie
			
			insert into #Personas
				select	aut.Per_Numero,	aut.Per_Numero,	@Str_Vacio,	aut.Cob_Tipo,	@Str_Vacio,	Cob_EsTerc
					from #PersonasAutorizadas as aut
						 inner join SOPERSON as per noholdlock on per.Per_Numero	= aut.Per_Numero 
					where	Per_Comple	like @Per_Comple		
		end
			
		update #Personas set
			Per_Grupo = Peu_Grupo
			from SOUNIPER noholdlock
			where	Peu_Person = Per_Person
			
		/*Debido a que las reglas de intervinientes requeridos PI, PS, PM incluyen tanto titulares/cotitulares y terceros, se requiere
		conservar el rastro de si previo a la agrupación, la persona también era un tercero, esto con la finalidad de obtener
		el tipo de firma inferido del nombre del interviniente cuando el número de persona es vacío en CHPEFOFI */
		update #Personas set
			Per_EsTerc	= @Ent_Uno
			from #Terceros
			where Ter_Grupo	= Per_Grupo				
			
		/*Solo para operaciones ligadas a cuentas, se actualiza su nivel de firma de los terceros autorizados*/
		if @Opi_BasOpe	= @Tip_BasCue begin
			if @Ins_PerCli = @Ent_Uno begin
				update #Personas set
					Per_TipFir	= @Tip_FirA
			end else begin 
				update #Personas set
					Per_CobNom	= Cob_Nombre
					from CHCOTBEN noholdlock 
					where	Cob_Cuenta	= @Cue_Numero
					  and	Cob_Person	= Per_Person
					  and	(Cob_Tipo	= @Tip_TerAut
					  or	Per_EsTerc	= @Ent_Uno)
			
				--Se consigue el consecutivo del registro actual válido para poder actualizar los tipos de firma de acuerdo al registro vigente y o adicionales
			  	select @Fof_MaxCon	= convert(smallint, max(Fof_Consec))
					from CHPEFOFI noholdlock
					where	Fof_Cuenta	= @Cue_Numero
					  and	Fof_Status	in (@Sta_FirEsc, @Sta_FirAut)
					  and	Fof_Tipo	= @Tip_ReFiNu

				update #Personas set
					Per_TipFir	= Fof_TipFir
					from CHPEFOFI noholdlock					
					where	Fof_Cuenta	= @Cue_Numero
					  and	Fof_Person	= Per_Person			
					  and	Fof_Status	in (@Sta_FirEsc, @Sta_FirAut)
					  and	convert(smallint, Fof_Consec)	>= @Fof_MaxCon
					  
				--Complementar el tipo de firma con aquellos casos de terceros autorizados que no tengan el número de persona asociado en el registro de CHPEFOFI infiriéndolo de CHCOTBEN
				update #Personas set
					Per_TipFir	= Fof_TipFir
					from CHPEFOFI noholdlock
					where	Fof_Cuenta	= @Cue_Numero
					  and	ltrim(Fof_Person) is null
					  and	Fof_Status	in (@Sta_FirEsc, @Sta_FirAut)
					  and	convert(smallint, Fof_Consec)	>= @Fof_MaxCon
					  and	ltrim(Per_Person) is not null
					  and	Per_CobNom	= Fof_Nombre
					  and	ltrim(Per_TipFir) is null
			end
		end		
			
		--Salida de intervinientes autorizados para identificación
		select	Per_Numero, Per_ComOrd, Per_Comple,	Per_RFC,	Per_CURP,
				Per_Nombre,	Per_ApePat,	Per_ApeMat,	Adi_TipIde,	Adi_NumIde,
				Adi_FeVeId,	Per_Nacion,	Adi_NacExt,	Per_TipFir,	Per_CobTip,
				Per_CoNoTi = case 
					when Per_CobTip = @Tip_Titula then @Nom_Titula
					when Per_CobTip = @Tip_Cotitu then @Nom_Cotitu
					when Per_CobTip = @Tip_Tercer then @Nom_Tercer
					else @Nom_Otro
				end,
				Per_EsTerc
			from #Personas
				 inner join SOPERSON noholdlock on Per_Numero = Per_Grupo
				 left outer join SOPERADI noholdlock on Adi_PerNum	= Per_Numero
			order by Per_CobTip,	Per_ComOrd asc
	end
end

drop table #PersonasDuplicadas
drop table #Terceros
drop table #Personas
drop table #PersonasAutorizadas