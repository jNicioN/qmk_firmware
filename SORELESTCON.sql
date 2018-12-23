create procedure SORELESTCON (
	@Rel_Numero	char(8),

	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/* Definicion de Constantes	*/
declare @Str_Depend char(8),
		@Str_Admini char(8)

select	@Str_Depend = '00000000',	/* Relacion de Dependencia 	*/
		@Str_Admini	= '00000001'	/* Administra la Estructura	*/

declare	@Tip_ConTip	char(1),		/* Variables para identificar el tipo de consulta */
		@Tip_ConCon	char(1)

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = 'L' begin					/* 'L':  LISTAS */
	if @Tip_ConCon = '1' begin				
		select	re.Rel_Numero,	Rel_Estruc,		Rel_Relaci,	Rel_EstRel,
				rel.Rel_Nombre,	est.Est_Nombre,	Usu_Nombre
 		from 	SORELEST re  noholdlock,
				SORELACI rel noholdlock,
				SOESTRUC est noholdlock,
				SOUSUARI usu noholdlock
		where 	re.Rel_Estruc 	= 	@Rel_Numero
	 	and		re.Rel_Relaci 	!= 	@Str_Depend
		and	   	rel.Rel_Numero 	= 	re.Rel_Relaci
		and     est.Est_Numero	=	re.Rel_EstRel 
		and 	usu.Usu_Numero	= 	est.Est_Usuari
	end 
end
if @Tip_ConTip = 'C' begin					/* 'L':  LISTAS */
	if @Tip_ConCon = '1' begin				
		select	re.Rel_Numero,	Rel_Estruc,	Rel_EstRel
 		from 	SORELEST re  noholdlock,
				SOESTRUC est noholdlock
		where 	Rel_Estruc 	= 	Est_Numero
		and		Est_Usuari	= 	@Usuario
	 	and		Rel_Relaci	= 	@Str_Admini
	end 
end

