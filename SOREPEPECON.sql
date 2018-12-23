create procedure SOREPEPECON (
	@Rpp_Person	char(8),
	@Per_Comple	char(60),
	@Per_Tipo	char(2),
	@Rpp_PerRel	char(8),
	@Tip_Consul	char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Tip_ConTip	char(1),		/* Declaracion de Variables */
		@Tip_ConCon	char(1)

declare	@Str_Vacio	char(1)			/* Declaración de Constantes */
		
/* Asignación de Constantes */
select	@Str_Vacio	= ''			/* String Vacío */

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = 'C' begin
	if @Tip_ConCon	= '1'
		select	Rpp_Person,	Rpp_PerRel,	Rpp_TiPeRe,	Per_Comple,	Tpe_Descri,
				Tpe_Abrevi
			from SOREPEPE noholdlock,
				 SOPERSON noholdlock,
				 SOTIPPER noholdlock
			where	Rpp_PerRel	= Per_Numero
			  and	Rpp_TiPeRe	= Tpe_Numero
			  and	Rpp_Person	= @Rpp_Person

	if @Tip_ConCon	= '2'
		select	Rpp_Person,	Rpp_PerRel,	Rpp_TiPeRe,	Per_Comple,	Tpe_Descri,
				Tpe_Abrevi
			from SOREPEPE noholdlock,
				 SOPERSON noholdlock,
				 SOTIPPER noholdlock
			where	Rpp_PerRel	= Per_Numero
			  and	Rpp_TiPeRe	= Tpe_Numero
			  and	Rpp_Person	= @Rpp_Person
			  and	Rpp_TiPeRe	= @Per_Tipo

	if @Tip_ConCon	= '3'
		select	Rpp_Person,	Rpp_PerRel,	Rpp_TiPeRe
			from SOREPEPE noholdlock
			where	Rpp_Person	= @Rpp_Person
			  and	Rpp_PerRel	= @Rpp_PerRel
			  and	Rpp_TiPeRe	= @Per_Tipo

	if @Tip_ConCon	= '4'
		select	Rpp_Person,	Rpp_PerRel,	Rpp_TiPeRe
			from SOREPEPE noholdlock
			where	Rpp_Person	= @Rpp_Person
			  and	Rpp_TiPeRe	= @Per_Tipo

end else begin
	select	@Per_Comple	= ltrim(rtrim(@Per_Comple)) + '%'
	
	if @Tip_ConCon = '1'
		select	Per_Numero,	Per_Comple,	Tpe_Descri
			from SOREPEPE noholdlock,
				 SOTIPPER noholdlock,
				 SOPERSON noholdlock
			where	Rpp_PerRel	= Per_Numero
			  and	Rpp_TiPeRe	= Tpe_Numero
			  and	Per_Comple	like @Per_Comple
	
	if @Tip_ConCon = '2'
		select	Per_Numero,	Per_Comple,	Tpe_Descri
			from SOREPEPE noholdlock,
				 SOTIPPER noholdlock,
				 SOPERSON noholdlock
			where	Rpp_PerRel	= Per_Numero
			  and	Rpp_TiPeRe	= Tpe_Numero
			  and	Tpe_Numero	= @Per_Tipo
			  and	Per_Comple	like @Per_Comple
			  
	if @Tip_ConCon = '3'				/* Lista de Repesentante Legal */
		select	Per_Numero,	Per_Comple,	Tpe_Descri
			from SOREPEPE noholdlock,
				 SOTIPPER noholdlock,
				 SOPERSON noholdlock
			where	Rpp_PerRel	= Per_Numero
			  and	Rpp_TiPeRe	= Tpe_Numero
  			  and	Rpp_Person	= @Rpp_Person
			  and	Tpe_Numero	= @Per_Tipo
			  
	if @Tip_ConCon = '4'				/* Lista de Repesentantes Legales Fabrica */
	
		select	Per_Numero,	Per_Comple,	Per_Tipo,	Per_Nombre,	Per_ApePat,
				Per_ApeMat,	Per_RazSoc,	Per_RFC,	Per_Calle,	Per_CalNum,	
				Per_Coloni,	Per_Entida,	Per_Locali,	Per_CodPos,	Per_Telefo,	
				Per_EstCiv,	Per_Nacion,	Adi_LugNac, Adi_NumDep,	Adi_Sexo,
				Adi_FecNac,	Adi_RegMat,	Adi_VivCas,	Adi_TieRes,	Adi_Fax,
				Adi_FecCon,	Adi_CaNuIn
				
			from SOREPEPE noholdlock,
				 SOTIPPER noholdlock,
				 SOPERSON noholdlock,
				 SOPERADI noholdlock
			where	Rpp_PerRel	= Per_Numero
			  and	Per_Numero	*= Adi_PerNum
			  and	Rpp_TiPeRe	= Tpe_Numero
  			  and	Rpp_Person	= @Rpp_Person
			  and	Tpe_Numero	= @Per_Tipo
			  
end

