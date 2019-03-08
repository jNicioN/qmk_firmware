create procedure SOSUPIFICON (
	@Spf_Numero	int,
	@Spf_Sucurs	char(3),
	@Spf_Status	char(1),
	@Spf_FecAlt	smalldatetime, 
	@Spf_FecBaj	smalldatetime,
	@Tip_Consul	char(2),
	
	@NumTransac	char(10),
	@Transaccio char(3), 
	@Usuario	char(6), 
	@FechaSis	smalldatetime, 
	@SucOrigen	char(3),
	@SucDestino char(3),
	@Modulo		char(2))

as

/**********************************************************
** Descripción : Consulta de sucursales piloto firmas	***
***********************************************************
** Referencias: Modulo soporte aplicaciones				***
***********************************************************
** creó:	Alma Cristina Perez Ramon					***
** Fecha:	05/02/2019									***
** Help:	1162911										***
***********************************************************/

								/* Declaracion de Variables */
declare	@Tip_ConTip	char(1),	/* Tipo de consulta */
		@Tip_ConCon	char(1)		/* Identificador de consulta */
		
								/* Declaración de constantes */
declare	@Str_TipCon char(1),
		@Str_TipLis char(1),
		@Str_TipUno char(1),
        @Str_TipDos char(1),
		@Fec_Vacia	smalldatetime
		
								/* Asignación de valores a constantes */
select	@Str_TipCon = 'C',		/* String tipo de consulta C */
		@Str_TipLis = 'L',		/* String tipo de consulta lista */
		@Str_TipUno = '1',		/* Consulta por numero */
		@Str_TipDos = '2',		/* Consulta por sucursal */
		@Fec_Vacia	= '1900-01-01'	/* Fecha Vacia */

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = @Str_TipCon begin
	if @Tip_ConCon = @Str_TipUno begin
		select	Spf_Numero, Spf_Sucurs, Spf_Status, Spf_FecAlt, Spf_FecBaj
			from SOSUPIFI noholdlock
			where	Spf_Numero	= @Spf_Numero
	end
	if @Tip_ConCon = @Str_TipDos begin
		select	Spf_Numero, Spf_Sucurs, Spf_Status, Spf_FecAlt, Spf_FecBaj
			from SOSUPIFI noholdlock
			where	Spf_Sucurs	= @Spf_Sucurs
			  and	Spf_Status	= @Spf_Status
	end
end

if @Tip_ConTip = @Str_TipLis begin
	if @Tip_ConCon = @Str_TipUno begin
		select	Spf_Numero, Spf_Sucurs, Spf_Status, Spf_FecAlt, Spf_FecBaj,
				Suc_Nombre
			from SOSUPIFI noholdlock
			inner join SOSUCURS noholdlock on Spf_Sucurs = Suc_Numero 
			where	Spf_Status = @Spf_Status
			  and	Spf_FecBaj = @Fec_Vacia
				order by	 SoSucursID 
	end
end