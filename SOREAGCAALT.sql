create procedure SOREAGCAALT (
	@Raa_NumAge int,
	@Raa_BrmAse	char(8),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/****************************************************************************
*** REFERENCIAS: 														****
****************************************************************************
** Creo:		Pedro de los Reyes										****
** Descripcion:	Alta de Agentes											****
** Folio:		1230668													****
** Fecha:		05/AGOSTO/2019											****
****************************************************************************/
declare	@Asesor 	int, /* Declaracion de Variables */
     	@Id_Asesor  int

declare	@Ent_Cero   int, /* Declaracion de Constantes */
		@Str_Vacio	char(1),
		@Ent_Uno 	int

/*Asignacion de constantes*/
select @Ent_Cero	= 0,			/* Entero en Cero*/
	   @Str_Vacio	= '',			/* String Vacio*/
	   @Ent_Uno		= 1				/* Entero en Uno*/
	   
select @Id_Asesor=SoUsuariID from SOUSUARI where Usu_Clave=@Raa_BrmAse
if isnull(rtrim(ltrim(convert(char, @Id_Asesor))), @Str_Vacio) = @Str_Vacio	begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'El asesor no existe'
	rollback
	return @Ent_Uno
end


insert into SOREAGCA (SoAgenteID,SoUsuariID,NumTransac,Transaccio,Usuario,FechaSis,SucOrigen,SucDestino,Modulo)
	values (@Raa_NumAge,@Id_Asesor,@NumTransac,@Transaccio,@Usuario,@FechaSis,@SucOrigen,@SucDestino,@Modulo)
	select @Id_Asesor as Asesor