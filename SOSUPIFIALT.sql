create procedure SOSUPIFIALT (
	@Spf_Numero	int,
	@Spf_Sucurs	char(3),
	@Spf_Status	char(1),
	@Spf_FecAlt	smalldatetime, 
	@Spf_FecBaj	smalldatetime,
	
	@NumTransac	char(10),
	@Transaccio char(3), 
	@Usuario	char(6), 
	@FechaSis	smalldatetime, 
	@SucOrigen	char(3),
	@SucDestino char(3),
	@Modulo		char(2))

as

/**********************************************************
** Descripción : Alta de sucursales piloto firmas		***
***********************************************************
** Referencias: Modulo soporte aplicaciones				***
***********************************************************
** creó:	Alma Cristina Perez Ramon					***
** Fecha:	05/02/2019									***
** Help:	1162911										***
***********************************************************/

								/* Declaracion de Variables */
declare	@Par_FecAct	smalldatetime,	/* Fecha actual */
		@Ent_Contad	int,			/* Entero contador */
		@Ent_IdeSuc	int,			/* Entero identificador SOSUCURS */
		@Ent_Numero	int				/* Entero identificador SOSUPIFI */
		
								/* Declaración de constantes */
declare	@Fec_Vacia	smalldatetime,
		@Str_Status	char(1),
		@Ent_Cero	int
		
								/* Asignación de valores a constantes */
select	@Fec_Vacia	= '1900-01-01',	/* Fecha Vacia */
		@Str_Status	= 'A',		/* Estatus Activo */
		@Ent_Cero	= 0			/* Entero cero */

select	@Par_FecAct	= Par_FecAct
	from SOPARAMS noholdlock
	where	 Par_Sucurs = @SucOrigen

select	@Par_FecAct = isnull(@Par_FecAct,@Fec_Vacia)

if  @Par_FecAct = @Fec_Vacia begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Fecha de registro no valida'
	rollback
	return 1
end

select	@Ent_IdeSuc	= @Ent_Cero
select	@Ent_IdeSuc	=  SoSucursID
	from SOSUCURS noholdlock
	where	 Suc_Numero	= @Spf_Sucurs
	
if  @Ent_IdeSuc = @Ent_Cero begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Sucursal no valida'
	rollback
	return 1
end
	
select	@Ent_Contad	= @Ent_Cero
select	@Ent_Contad = count(1)
	from SOSUPIFI noholdlock
	where	Spf_Status = @Str_Status
	  and	Spf_Sucurs = @Spf_Sucurs

if  @Ent_Contad > @Ent_Cero begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'El registro ya existe'
	rollback
	return 1
end	  

insert into SOSUPIFI
	(Spf_Sucurs,	Spf_Status,		Spf_FecAlt,		Spf_FecBaj,		NumTransac,
	Transaccio,		Usuario,		FechaSis,		SucOrigen,		SucDestino)
	values (
	@Spf_Sucurs,	@Str_Status,	@Par_FecAct,	@Fec_Vacia,		@NumTransac,
	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino)

select	@Ent_Numero	= @@identity 

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Agregado',
		Spf_Numero	= @Ent_Numero