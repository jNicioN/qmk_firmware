create procedure SOUSUPERCON (
	@Upe_Numero	char(6),
	@Upe_Clave	varchar(15),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/***************************************************************************
** DESCRIPCION: ** Consulta de persona por usuario **					****
****************************************************************************
** REFERENCIAS:
****************************************************************************
** Modificó:	Marcelo Bautista Hernandez								****
** Fecha:		03/Abr/2019												****
** Help:		1232660													****
** Descripción:	Se modifica la forma de consultar el numero de cliente	****
**				por coincidencias con numeros de practicantes			****
****************************************************************************
** Modificó:	Rolando Bernal											****
** Fecha:		11/Dic/2015												****
** Help:		00801121												****
** Descripción:	Optimización											****
****************************************************************************
** Creo:		Evijair Nunez Jordan									****
** Fecha:		24/Nov/2015												****
** Help:		00801121												****
***************************************************************************/

declare	@Tip_ConTip	char(1),		/* Declaración de Variables */
		@Tip_ConCon	char(1),
		@Emp_Numero	varchar(6),
		@Emp_Client	char(8),
		@Upe_GruUni	varchar(8)

declare	@Str_Vacio	char(1),		/* Declaración de Constantes */
		@Tra_TipLis	char(1),
		@Tra_TipCon	char(1),
		@Str_Cero	char(1),
		@Str_Uno	char(1),
		@Str_Dos	char(1),
		@Str_Porcen	char(1),
		@Int_Tres	smallint,
		@Int_Cuatro	smallint,
		@Int_Seis	smallint

/* Asignación de Constantes */
select	@Str_Vacio	= '',			/* String Vacío				*/
		@Tra_TipLis	= 'L',			/* Tipo : Lista				*/
		@Tra_TipCon	= 'C',			/* Tipo : Consulta			*/
		@Str_Cero	= '0',			/* String para completar busqueda por numero	*/
		@Str_Uno	= '1',			/* String para consulta por numero	*/
		@Str_Dos	= '2',			/* String para consulta por clave	*/
		@Str_Porcen	= '%',			/* String Porcentaje */
		@Int_Tres	= 3,			/* Longitud brs o brm */
		@Int_Cuatro = 4,			/* Inicio de substring Upe_Clave */
		@Int_Seis	= 6				/* Longuitud Emp_Numero de tabla RHEMPLEA */

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1),
		@Upe_GruUni	= @Str_Vacio

if @Tip_ConTip = @Tra_TipCon begin					/* 'C':  Consulta		*/
	if @Tip_ConCon = @Str_Uno begin					/* Consulta principal	*/

		select	@Emp_Client = Emp_Client 
		from RHEMPLEA noholdlock
		where Emp_Numero = @Upe_Numero
			
		if(@Emp_Client is not null)
			select	@Upe_GruUni = Peu_Grupo
				from CLADICIO noholdlock
				inner join SOPERADI noholdlock on Adi_NumPer = Adi_PerNum
				inner join SOUNIPER noholdlock on Adi_PerNum = Peu_Person
				where Adi_Client = 	@Emp_Client
		
		select	Upe_GruUni	= @Upe_GruUni
	end
	
	if @Tip_ConCon = @Str_Dos begin					/* Consulta por clave empleado	*/

		select @Emp_Numero = substring(@Upe_Clave, @Int_Cuatro, (len(@Upe_Clave)-@Int_Tres))
		select @Emp_Numero	= isnull(@Emp_Numero, @Str_Vacio)
		select @Emp_Numero = replicate(@Str_Cero,@Int_Seis - len(@Emp_Numero)) + @Emp_Numero

		select	@Emp_Client = Emp_Client 
				from RHEMPLEA noholdlock
				where Emp_Numero = @Emp_Numero
				
		if(@Emp_Client is not null)		
			select	@Upe_GruUni = Peu_Grupo
				from CLADICIO noholdlock
				inner join SOPERADI noholdlock on Adi_NumPer = Adi_PerNum
				inner join SOUNIPER noholdlock on Adi_PerNum = Peu_Person
				where Adi_Client = 	@Emp_Client	
		
		select	Upe_GruUni	= @Upe_GruUni
	end
end
