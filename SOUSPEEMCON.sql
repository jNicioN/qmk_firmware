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
** Modifico:	Marcelo Bautista Hernandez						****
** Fecha:		19/Enero/2021									****
** Help:		01379522										****
** Descripcion:	Se optimiza consulta de SOUSUARI				****
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
		@Str_Cero	char(1),
		@Str_BRM	char(3)
		
/* Asignacion de Constantes */
select	@Str_Vacio	= '',	/* String vacío */
		@Int_Cero	= 0,	/* Entero en cero */	
		@Int_Uno	= 1,	/* Entero en uno */	
		@Int_Tres	= 3,	/* Entero en tres */
		@Int_Cuatro	= 4,	/* Entero en cuatro */
		@Int_Seis	= 6,	/* Entero en seis */
		@Str_Cero	= '0',	/*String 0*/
		@Str_BRM	= 'BRM'

create table #Personas(
	Per_Numero  char(8)  not null
)
	
create table #UsuarioClave(
	Usc_NumCli	char(8),
	Usc_NumEmp	char(6),
	Usc_NumBrm	char(8)
)

select	@Peu_Grupo = Peu_Grupo
	from SOUNIPER noholdlock
	where	Peu_Person = @Per_Numero

insert into #Personas
	select Peu_Person
		from SOUNIPER noholdlock
		where Peu_Grupo	= @Peu_Grupo
		
insert into #UsuarioClave
	select 	Cli_Numero,	@Str_Vacio,	@Str_Vacio
	from #Personas per
		inner join CLADICIO adi noholdlock on adi.Adi_NumPer	= per.Per_Numero
		inner join CLCLIENT cli noholdlock on cli.ClClientID	= adi.ClClientID
		
update #UsuarioClave set 
	Usc_NumEmp	= Emp_Numero,
	Usc_NumBrm	= @Str_BRM+right(Emp_Numero,5)			
	from RHEMPLEA noholdlock
	where Emp_Client	= Usc_NumCli

delete #UsuarioClave
	where isnull(ltrim(rtrim(Usc_NumEmp)), @Str_Vacio) = @Str_Vacio
		
select @Ent_Encont = @Int_Uno 		
	from #UsuarioClave
	
if isnull(@Ent_Encont, @Int_Cero) > @Int_Cero begin
					
		select top 1 Usu_Numero,	Usu_Clave,	Usu_Sucurs,	Usc_NumEmp,	Usu_Nombre,
			Usc_NumCli,	Usu_EMail
			from #UsuarioClave
			inner join SOUSUARI noholdlock on Usc_NumBrm = Usu_Clave	
end 
drop table #UsuarioClave
drop table #Personas