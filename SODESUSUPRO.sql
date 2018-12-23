create procedure SODESUSUPRO (

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/* Declaración de variables */			
declare	@Num_Regist	double precision	
				
/* Declaración de constantes */					
declare	@Str_No		char(1),
		@Str_Si		char(1),
		@Dob_Cero	double precision
		
/* Asignación de constantes */
select	@Str_No		= 'N',	/* String No */
		@Str_Si		= 'S',	/* String Si */
		@Dob_Cero	= 0		/* Doble Precisión: Cero */

/* Se revisa si las tabla temporal esta vacia, de lo contrario regresa error */
select @Num_Regist	= @Dob_Cero

select @Num_Regist	= count(*)
	from SOTMPUSU noholdlock
	
if @Num_Regist > @Dob_Cero begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'La tabla SOTMPUSU, contiene información. Se debe borrar la información anterior antes de continuar.'
	return 1
end

insert into SOTMPUSU
	select	Usu_Numero
		from SOUSUARI
		where	Usu_Activo = @Str_Si
		  And	Usu_Numero not in (select	Usa_Usuari
									from SOUSUACT noholdlock
									where Usa_Status = @Str_Si)
									
update SOUSUARI
	set	Usu_Activo = @Str_No
		from SOTMPUSU
		where	Usu_Numero = Tmu_Usuari	

if @@nestlevel = 1
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Usuarios Desactivados '
