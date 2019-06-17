create procedure SOPERVALPRO (
	@Per_Numero	char(8),
	@Per_RFC	char(15),
	@Per_CURP	char(18),		
	@Tip_Valida	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo char(2))
as

/*****************************************************************************/
/* DESCRIPCION: Valida Informacion General de las Personas                   */
/*****************************************************************************/
/** REFERENCIAS: 
****************************************************************************
** Creó:	    Iris Eleola Jiménez Olguín				                ****
** Fecha:	    17/Mayo/2012  					                        ****
** HD:		    00458842					                            ****
** Descripcion:	Valida Informacion de las Personas tabla SOPERSON       ****
******************************************************************************/

/*	Declaracion de Variables	*/
declare @Per_Tipo	char(1),
		@Per_Benefi	char(1),
		@Per_NuSeFi	varchar(30),
		@Per_Titulo	varchar(10),
		@Per_Nombre	varchar(40),
		@Per_ApePat	varchar(40),
		@Per_ApeMat	varchar(40),
		@Per_RazSoc	varchar(180),		
		@Per_Calle	char(40),
		@Per_CalNum	varchar(10),
		@Per_Coloni	varchar(150),
		@Per_Entida	char(3),
		@Per_Locali	char(8),
		@Per_CodPos	char(6),
		@Per_ApaPos	char(6),
		@Per_LadTel	varchar(5),
		@Per_Telefo char(15),
		@Per_Email	varchar(50),
		@Per_ComDom	char(1),
		@Per_EstCiv	varchar(20),
		@Per_Nacion	char(3),
		@Per_ActEmp char(1),
		@Per_Giro	char(30),
		@Per_Sector	char(3),
		@Per_Activi	char(10),
		@Per_ActINE	varchar(10),	
       
        @Act_Numero	char(10),
		@Act_Status	char(1),
		@Status		int,
		@PerPersoID	int,
		@PerExist	char(8),
		@Err_Descri varchar(100)

/*	Declaracion de Constantes	*/
declare	@Str_Vacio	char(1),		
		@Str_Espaci	char(1),
		@Per_Moral	char(1),
		@Per_Fisica	char(1),
		@Sta_ActIna	char(1),
		@Tab_Nombre	char(8),
		@Ent_Cero	int,
		@Tip_ActCot	char(2),
		@Per_PaiMex	char(3),
		@Str_Si		char(1),
		@Str_No		char(1),
		@Str_No123	char(6),
		@Str_123	char(5),
		@Tip_Val1   char(2)
		
/* Asignación de Constantes */
select	@Str_Vacio	= '',			/*	String Vacio	*/
		@Str_Espaci	= ' ',			/*	String Espacio	*/
		@Per_Moral	= '1',			/* Persona Moral */
		@Per_Fisica	= '2',			/* Persona Fisica */
		@Sta_ActIna = 'I',			/* Status de actividad inactiva */
		@Tab_Nombre	= 'SOPERSON',	/* Tabla que se consulta en SOFOLIOS	*/
		@Ent_Cero	= 0,			/* Entero en Cero			*/		
		@Per_PaiMex	= '001',        /* Id del Pais Mexico */
		@Str_Si		= 'S',          /* String NO */
		@Str_No		= 'N',			/* String SI */
		@Str_No123	= '[^123]',		/* String que contiene 123 */
	 	@Str_123	= '[123]',		/* String 123 */
	 	@Tip_Val1	= 'V1'		    /* Tipo validacion uno */

/* Creación de Tabla Temporal de Validaciones */
create table #TmpValida	(
        Val_NumPer	char(8) null,
        Val_Codigo	char(6) null,
        Val_Mensaj	varchar(100) null,
        Val_Variab	varchar(20) null )

if not exists ( select Per_Numero
					from SOPERSON noholdlock
					where Per_Numero = @Per_Numero )
begin
	insert into #TmpValida
	values( @Per_Numero, '000001', 'Persona no existe', 'Per_Numero'	)
end
else begin

	select	@Per_Tipo	= Per_Tipo,
			@Per_Benefi	= Per_Benefi,
			@Per_NuSeFi	= Per_NuSeFi,
			@Per_Titulo	= Per_Titulo,
			@Per_Nombre	= Per_Nombre,
			@Per_ApePat	= Per_ApePat,
			@Per_ApeMat	= Per_ApeMat,
			@Per_RazSoc	= Per_RazSoc,
			@Per_Calle	= Per_Calle,
			@Per_CalNum	= Per_CalNum,
			@Per_Coloni	= Per_Coloni,
			@Per_Entida	= Per_Entida,
			@Per_Locali	= Per_Locali,
			@Per_CodPos	= Per_CodPos,
			@Per_ApaPos	= Per_ApaPos,
			@Per_LadTel	= Per_LadTel,
			@Per_Telefo	= Per_Telefo,
			@Per_Email	= Per_Email,
			@Per_ComDom	= Per_ComDom,
			@Per_EstCiv	= Per_EstCiv,
			@Per_Nacion	= Per_Nacion,
			@Per_ActEmp	= Per_ActEmp,
			@Per_Giro	= Per_Giro,
			@Per_Sector	= Per_Sector,
			@Per_Activi	= Per_Activi,
			@Per_ActINE	= Per_ActINE
		from SOPERSON noholdlock
		where Per_Numero	= @Per_Numero
	
		
	if @Tip_Valida = @Tip_Val1 /* Tipo validacion uno */
	begin
		/* Inicia Validaciones de Datos Generales de la Persona */
		if (@Per_Tipo like @Str_No123) begin
			insert into #TmpValida
			    values ( @Per_Numero,
					     '000002',
					     'Tipo de persona incorrecto',
					     'Per_Tipo' )
		end
		
		if (@Per_Tipo = @Per_Moral) and (@Per_RazSoc = @Str_Vacio) begin	
			insert into #TmpValida
			    values ( @Per_Numero,
			             '000003',
			             'Razon social incorrecta',
			             'Per_RazSoc' )		
		end
		
		if (@Per_Tipo like @Str_123) and (@Per_Nombre = @Str_Vacio) begin	
			insert into #TmpValida
			    values ( @Per_Numero,
				         '000004',
				         'Nombre incorrecto',
				         'Per_Nombre' )		
		end
		if (@Per_Tipo like @Str_123) and (@Per_ApePat = @Str_Vacio) begin
			insert into #TmpValida	
			    values ( @Per_Numero,
				         '000005',
				         'Apellido paterno incorrecto',
				         'Per_ApePat' )			
		end		
		if (@Per_Tipo like @Str_123) and (@Per_ApeMat = @Str_Vacio) begin
			insert into #TmpValida	
			    values ( @Per_Numero,
				         '000006',
				         'Apellido materno incorrecto',
				         'Per_ApeMat' )		
		end
		
		if not exists (select Sec_Numero
							from CLSECTOR noholdlock
							where	Sec_Numero	= @Per_Sector) begin
			insert into #TmpValida	
			    values( @Per_Numero,
			            '000007',
			            'El sector no existe',
			            'Per_Sector' )		
		end
		
		select	@Act_Numero	= Act_Numero,
				@Act_Status	= Act_Status
			from CLACTIVI noholdlock
			where	Act_Numero	= @Per_Activi
		
		select @Act_Numero	= isnull(@Act_Numero, @Str_Vacio)
		
		if @Act_Numero = @Str_Vacio begin	
			insert into #TmpValida
			    values ( @Per_Numero,
			             '000008',
			             'La actividad no existe',
			             'Per_Activi' )		
		end
		
		if @Act_Status = @Sta_ActIna begin
			insert into #TmpValida
			    values ( @Per_Numero,
			             '000009',
			             'La actividad esta inactiva',
			             'Per_Activi' )	
		end
		
		if not exists (select Act_Numero
							from CLACTINE noholdlock
							where	Act_Numero	= @Per_ActINE) begin
			insert into #TmpValida
			    values ( @Per_Numero,
			             '000010',
			             'La actividad del INEGI no existe',
			             'Per_ActINE' )		
		end
		
		if not exists (select Loc_Numero
							from CLLOCALI noholdlock
							where	Loc_Numero	= @Per_Locali) begin
			insert into #TmpValida	
			    values ( @Per_Numero,
			             '000011',
			             'La ciudad no existe' + @Per_Locali,
			             'Per_Locali' )
		
		end
		if not exists (select Ent_Numero
							from CLENTIDA noholdlock
							where	Ent_Numero	= @Per_Entida) begin
			insert into #TmpValida
			    values ( @Per_Numero,
			             '000012',
			             'El estado no existe',
			             'Per_Locali' )		
		end
		
		if not exists ( select	Pai_Numero
							from SOPAIS noholdlock
							where	Pai_Numero	= @Per_Nacion) begin
			insert into #TmpValida						
			    values ( @Per_Numero,
			             '000013',
			             'Nacionalidad Incorrecta',
			             'Per_Nacion' )		
		end
		
		if 	@Per_RFC = @Str_Vacio begin
			insert into #TmpValida
			    values ( @Per_Numero,
			             '000014',
			             'Proporcione el R.F.C.',
			             'Per_RFC' )		
		end
		
		select	@PerExist	= Per_Numero
			from SOPERSON noholdlock
			where	Per_Numero	<>	@Per_Numero
			  and	ltrim(rtrim(Per_RFC))	= ltrim(rtrim(@Per_RFC))
			  and	Per_Nacion				= @Per_PaiMex
			  and	(Per_Tipo				= @Per_Moral
			  or	(Per_Tipo				= @Per_Fisica
			  and	 Per_ActEmp				= @Str_Si))
		
		select	@PerExist	= isnull(@PerExist, @Str_Vacio)
		
		if @PerExist <> @Str_Vacio begin
			insert into #TmpValida
			    values ( @Per_Numero,
			             '000009',
			             'La persona ' + @PerExist + ' ya tiene este RFC. (Mod)',
			             'Per_RFC' )		
		end
		
		exec @Status = CLVALRFCPRO	/* Valida RFC */
			@Per_RFC,		@Per_Tipo,		@Per_ActEmp,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
		
		if @Status <> @Ent_Cero begin
			insert into #TmpValida
			    values ( @Per_Numero,
					     '000015',
					     'R.F.C. incorrecto',
					     'Per_RFC' )		
		end	
		
		if @Per_Calle = @Str_Vacio begin
			insert into #TmpValida
			    values ( @Per_Numero,
			             '000016',
			             'Proporcione la calle',
			             'Per_Calle' )		
		end
		
		if @Per_CalNum = @Str_Vacio begin
			insert into #TmpValida
			    values ( @Per_Numero,
			             '000017',
			             'Proporcione el numero',
			             'Per_CalNum' )		
		end
		
		if @Per_CodPos = @Str_Vacio or 
				not exists ( select Cpc_Numero 
								from CLCODPOS noholdlock
									where	Cpc_Entida	= @Per_Entida
									  and	Cpc_Locali	= @Per_Locali
									  and	Cpc_CodPos	= @Per_CodPos) begin
			insert into #TmpValida
			    values ( @Per_Numero,
					     '000018',
					     'Codigo Postal Incorrecto',
					     'Per_CodPos' )	
		end
	end /* Termina tipo validacion uno */
end 

select	Val_NumPer,	Val_Codigo,	Val_Mensaj,	Val_Variab
	from #TmpValida

drop table #TmpValida
