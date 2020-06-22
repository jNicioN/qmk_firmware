create procedure SOUSPEEMCON (
	@Per_Numero	char(8),		/* Número de persona de la que se consultará el empleado */

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
	
as

/* *****************************************************************
** DESCRIPCION: Consulta de usuario persona por empleado		  **
********************************************************************
** Referencias:													****
********************************************************************
** Creó:		Francisco Javier Carrillo Rojas					****
** Fecha:		05/Jun/2020										****
** Help:		01379522										****
** Descripcion:	Consulta de usuario persona por empleado		****
********************************************************************/
/* Declaracion de Variables */
declare	@Peu_Grupo	char(8),	/* Persona Grupo */
		@Peu_Person	char(8),	/* Persona */
		@Ent_Encont int			/* Econtrado */

/* Declaracion de Constantes */
declare	@Str_Vacio	char(1),
		@Int_Cero	smallint,
		@Int_Uno	smallint,
		@Int_Tres	smallint,
		@Int_Cuatro	smallint,
		@Int_Seis	smallint,
		@Str_Cero	char(1)
		
/* Asignacion de Constantes */
select	@Str_Vacio	= '',	/* String vacío */
		@Int_Cero	= 0,	/* Entero en cero */	
		@Int_Uno	= 1,	/* Entero en uno */	
		@Int_Tres	= 3,	/* Entero en tres */
		@Int_Cuatro	= 4,	/* Entero en cuatro */
		@Int_Seis	= 6,	/* Entero en seis */
		@Str_Cero	= '0'	/*String 0*/

create table #Personas(
	Per_Numero  char(8)  not null
)
	
create table #UsuarioClave(
	Usc_NumCli	char(8),
	Usc_NumEmp	char(6)
)

create table #Usuario(
	Usu_Numero	char(6),
	Usu_Clave	char(15),
	Usu_Sucurs	char(3)	,
	Usu_NumEmp	varchar(6),
	Usu_Nombre  varchar(50)
)

select	@Peu_Grupo = Peu_Grupo
	from SOUNIPER noholdlock
	where	Peu_Person = @Per_Numero

insert into #Personas
	select Peu_Person
		from SOUNIPER noholdlock
		where Peu_Grupo	= @Peu_Grupo
		
insert into #UsuarioClave
	select 	Cli_Numero,	@Str_Vacio
	from #Personas per
		inner join CLADICIO adi noholdlock on adi.Adi_NumPer	= per.Per_Numero
		inner join CLCLIENT cli noholdlock on cli.ClClientID	= adi.ClClientID
		
update #UsuarioClave set 
	Usc_NumEmp	= Emp_Numero			
	from RHEMPLEA noholdlock
	where Emp_Client	= Usc_NumCli

delete #UsuarioClave
	where isnull(ltrim(rtrim(Usc_NumEmp)), @Str_Vacio) = @Str_Vacio
		
select @Ent_Encont = @Int_Uno 		
	from #UsuarioClave
	
if isnull(@Ent_Encont, @Int_Cero) > @Int_Cero begin
		insert into #Usuario
			select 	Usu_Numero,	Usu_Clave,	Usu_Sucurs,	Usu_Clave, Usu_Nombre
				from SOUSUARI noholdlock 

		update #Usuario set 
			Usu_NumEmp	= isnull(substring(Usu_Clave, @Int_Cuatro, (len(Usu_Clave)- @Int_Tres)), @Str_Vacio)

		update #Usuario set 
			Usu_NumEmp	= replicate(@Str_Cero, @Int_Seis - len(Usu_NumEmp)) + Usu_NumEmp
					
		select top 1 Usu_Numero,	Usu_Clave,	Usu_Sucurs,	Usu_NumEmp,	Usu_Nombre,	Usc_NumCli
			from #UsuarioClave
				 inner join #Usuario on Usu_NumEmp	= Usc_NumEmp						 
end 
drop table #UsuarioClave
drop table #Usuario
drop table #Personas