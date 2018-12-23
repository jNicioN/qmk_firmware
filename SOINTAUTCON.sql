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
		@Cio_Status	char(1)		/* Estatus de configuración */

/* Declaracion de Constantes */
declare	@Str_C		char(1),
		@Str_Uno	char(1),
		@Str_Dos    char(1),
		@Str_Porcie	char(1),
		@Str_Vacio	char(1),
		@Ent_Cero	int,
		@Tip_PerFis	char(1),
		@Tip_Titula	char(1),
		@Sta_Activo	char(1),
		@Tip_BasCli	varchar(4),
		@Tip_BasCue	varchar(4)

/* Asignacion de Constantes */
select	@Str_C		= 'C',		/* Tipo C */
		@Str_Uno	= '1',		/* Tipo 1 */
		@Str_Dos    = '2',		/* Tipo 2 */
		@Str_Porcie	= '%',		/* String porciento */
		@Str_Vacio	= '',		/* String vacío */
		@Ent_Cero	= 0,		/* Entero en cero */
		@Tip_PerFis	= '2',		/* Tipo de persona persona física */
		@Tip_Titula	= '1',		/* Tipo de interviniente Titular */
		@Sta_Activo	= 'A',		/* Status Activo */
		@Tip_BasCli	= 'CLI',	/* Tipo base cliente(Operación con) */
		@Tip_BasCue	= 'CUE'	/* Tipo base cuenta(Operación con) */

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

create table #PersonasAutorizadas(
	Per_Numero   char(8)  not null)

create table #Personas(
	Per_Person	char(8),
	Per_Grupo	char(8),
	Per_TipFir	char(1)) 

select	@Opi_TipOpe	= Opi_TipOpe,
		@Cio_NuIdCo	= Cio_NuIdCo,
		@Cio_Status	= Cio_Status,
		@Opi_BasOpe	= Opi_BasOpe
	from SOOPEIDE ope noholdlock
		left join SOCOIDOP con noholdlock on con.Cio_NuIdOp	= ope.Opi_NuIdOp
	where	con.Cio_NuIdOp	= @Opi_NuIdOp
	  and	con.Cio_NuIdCo	= @Cio_NuIdCo

/*Base para poder obtener los intervinientes autorizados de acuerdo a la configuración dada */
if isnull(@Opi_TipOpe, @Ent_Cero) != @Ent_Cero and isnull(@Cio_Status, @Str_Vacio) = @Sta_Activo begin
	if @Opi_BasOpe	= @Tip_BasCli begin
		/* Solo podemos tener el número de cliente */
		insert into #PersonasAutorizadas
			select	adi.Adi_NumPer
				from CLCLIENT cli noholdlock
					 inner join CLADICIO adi noholdlock on adi.ClClientID = cli.ClClientID 					
				where	cli.Cli_Numero	= @Cli_Numero
				  and	cli.Cli_Tipo	= @Tip_PerFis
				  and	@Tip_Titula in(select Tii_TipInt
										from SOTIINID noholdlock
										where	Tii_NuIdCo	= @Cio_NuIdCo
										  and	Tii_Status	= @Sta_Activo)
				
	end else if @Opi_BasOpe	= @Tip_BasCue begin
		/* Se obtienen por referencias en cotitulares/beneficiarios/etc */
		select	@Cli_Numero	= Cue_Client
			from CHCUENTA noholdlock
			where	Cue_Numero	= @Cue_Numero

		--Registro de personas autorizadas(Para ciertas cuentas si existe el tipo titular y para otras solo el beneficiario, por lo que se tiene que hacer la búsqueda en CLCLIENT)
		insert into #PersonasAutorizadas
			select	adi.Adi_NumPer
				from CLCLIENT cli noholdlock
					 inner join CLADICIO adi noholdlock on adi.ClClientID = cli.ClClientID 					
				where	cli.Cli_Numero	= @Cli_Numero
				  and	cli.Cli_Tipo	= @Tip_PerFis
				  and	@Tip_Titula in(select Tii_TipInt
										from SOTIINID noholdlock
										where	Tii_NuIdCo	= @Cio_NuIdCo
										  and	Tii_Status	= @Sta_Activo)
			union
			select	Cob_Person
				from CHCOTBEN noholdlock
				where	Cob_Cuenta	= @Cue_Numero
				  and	Cob_Tipo in(select Tii_TipInt
										from SOTIINID noholdlock
										where	Tii_NuIdCo	= @Cio_NuIdCo
										  and	Tii_Status	= @Sta_Activo)
	end
end
	  
if @Tip_ConTip = @Str_C begin
	if @Tip_ConCon	= @Str_Uno begin /* C1 - Búsqueda de interviniente autorizado(consulta principal) por id único de persona*/
		insert into #Personas
			select	Per_Numero,	Per_Numero,	@Str_Vacio
				from SOPERSON noholdlock
				where	Per_Numero in(select	aut.Per_Numero
										from #PersonasAutorizadas aut)
		update #Personas set
			Per_Grupo = Peu_Grupo
			from SOUNIPER noholdlock
			where	Peu_Person = Per_Person

		/*Solo para operaciones ligadas a cuentas, se actualiza su nivel de firma de los terceros autorizados*/
		if @Opi_BasOpe	= @Tip_BasCue begin
			update #Personas set
				Per_TipFir	= Fof_TipFir
				from CHPEFOFI noholdlock					
				where	Fof_Cuenta	= @Cue_Numero
				  and	Fof_Person	= Per_Person
		end
			
		--Salida de intervinientes autorizados para identificación
		select	Per_Numero, Per_ComOrd, Per_Comple,	Per_RFC,	Per_CURP,
				Per_Nombre,	Per_ApePat,	Per_ApeMat,	Adi_TipIde,	Adi_NumIde,
				Adi_FeVeId,	Per_Nacion,	Adi_NacExt,	Per_TipFir
			from #Personas
				 inner join SOPERSON noholdlock on Per_Numero = Per_Grupo
				 left outer join SOPERADI noholdlock on Adi_PerNum	= Per_Numero
			where	Per_Grupo	= @Per_Numero
	end	
end else begin
	if @Tip_ConCon	= @Str_Uno begin /* L1 - Búsqueda de personas autorizadas ligadas a configuración por nombre completo*/
		if isnull(@Per_Comple, @Str_Vacio) = @Str_Vacio begin
			insert into #Personas
				select	Per_Numero,	Per_Numero, @Str_Vacio
					from SOPERSON noholdlock
					where	Per_Numero in(select	aut.Per_Numero
											from #PersonasAutorizadas aut)
		end	else begin
			select	@Per_Comple	= ltrim(isnull(@Per_Comple, @Str_Vacio)) + @Str_Porcie
			
			insert into #Personas
				select	Per_Numero,	Per_Numero, @Str_Vacio
					from SOPERSON noholdlock
					where	Per_Numero in(select	aut.Per_Numero
											from #PersonasAutorizadas aut)
					  and	Per_Comple	like @Per_Comple		
		end
			
		update #Personas set
			Per_Grupo = Peu_Grupo
			from SOUNIPER noholdlock
			where	Peu_Person = Per_Person
			
		/*Solo para operaciones ligadas a cuentas, se actualiza su nivel de firma de los terceros autorizados*/
		if @Opi_BasOpe	= @Tip_BasCue begin
			update #Personas set
				Per_TipFir	= Fof_TipFir
				from CHPEFOFI noholdlock					
				where	Fof_Cuenta	= @Cue_Numero
				  and	Fof_Person	= Per_Person
		end		
			
		--Salida de intervinientes autorizados para identificación
		select	Per_Numero, Per_ComOrd, Per_Comple,	Per_RFC,	Per_CURP,
				Per_Nombre,	Per_ApePat,	Per_ApeMat,	Adi_TipIde,	Adi_NumIde,
				Adi_FeVeId,	Per_Nacion,	Adi_NacExt,	Per_TipFir
			from #Personas
				 inner join SOPERSON noholdlock on Per_Numero = Per_Grupo
				 left outer join SOPERADI noholdlock on Adi_PerNum	= Per_Numero
	end
end

drop table #Personas
drop table #PersonasAutorizadas
