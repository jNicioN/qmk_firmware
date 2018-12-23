create procedure SOUSUREGCON (
	@Usr_Usuari	char(6),
	@Usu_Clave	char(15),
	@Usr_Region	int,
	@Usr_Perfil	char(3),
	@Usr_MulReg varchar(100),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/******************************************************************/
/* DESCRIPCION: Usuario por regiones							  */
/******************************************************************/
/* Modifica:	Jorge A. Garcia Leal							****
** Fecha:		20/07/2017										****
** Help:		985322 											****
** Modifica:	Se agrega consulta L6 y Se modifican consultas  ****
**				de char a su respectiva constante 				***/
/******************************************************************/
/******************************************************************/
/* Modifica:	Jorge A. Garcia Leal							****
** Fecha:		05/12/2016										****
** Help:		931787 											****
** Modifica:	Se cambia estructura de tabla 					***/
/******************************************************************/
/* DESCRIPCION: Consulta de Usuario-Regiones					  */
/******************************************************************/
/* Creo:		Claudia V Sandoval P							****
** Fecha:		03/10/2016										****
** Help:		903360 											****
********************************************************************/
/* Declaracion de Variables */
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1),
		@Int_Index int

/* Asignacion de Constantes */
declare	@Str_Vacio	char(1),
		@Str_Activo	char(1),
		@Str_Cero	char(1),
		@Int_Cero	int,
		@Str_Uno	char(1),
		@Str_Dos	char(1),
		@Str_Tres	char(1),
		@Str_Cuatro	char(1),
		@Str_Cinco	char(1),
		@Str_Seis	char(1)

select	@Str_Vacio	= '',			/* Caracter Vacio			*/
		@Str_Activo	= 'A',
		@Str_Cero	= '0',
		@Int_Cero	= 0,
		@Str_Uno	= '1',
		@Str_Dos	= '2',
		@Str_Tres	= '3',
		@Str_Cuatro	= '4',
		@Str_Cinco	= '5',
		@Str_Seis	= '6'

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip	= 'L' begin					/* 'L': Listas */
	if @Tip_ConCon	= @Str_Uno begin		/* L1 Usuarios por Region */
		select	Usr_Region,	Reg_Descri,	Usr_Usuari,	Usu_Clave,	Usu_Nombre
			from SOUSUREG noholdlock
			inner join SOUSUARI noholdlock on Usu_Numero = Usr_Usuari
			inner join SOREGION noholdlock on Reg_Numero = Usr_Region
			where	Usr_Region = @Usr_Region
			order by Usu_Nombre
	end
	if @Tip_ConCon	= @Str_Dos begin /* L2 Regiones por Clave de Usuario */
		select	Usr_Region,	Reg_Descri,	Usr_Usuari,	Usu_Clave,	Usu_Nombre
			from SOUSUREG noholdlock
			inner join SOUSUARI noholdlock on Usu_Numero = Usr_Usuari
			inner join SOREGION noholdlock on Reg_Numero = Usr_Region
			where	Usu_Clave = @Usu_Clave
			order by Reg_Descri
	end
	if @Tip_ConCon	= @Str_Tres begin /* L3 Regiones por Numero de Usuario */
		select	Usr_Region,	Reg_Descri,	Usr_Usuari,	Usu_Clave,	Usu_Nombre
			from SOUSUREG noholdlock
			inner join SOUSUARI noholdlock on Usu_Numero = Usr_Usuari
			inner join SOREGION noholdlock on Reg_Numero = Usr_Region
			where	Usr_Usuari = @Usr_Usuari
			order by Reg_Descri
	end
	if @Tip_ConCon	= @Str_Cuatro begin /* L4 Usuarios por Region y Perfil */
		select	Usr_Region,	Reg_Descri,	Usr_Usuari,	Usu_Clave,	Usu_Nombre,
				Usu_EMail 
			from SOUSUREG noholdlock
			inner join SOUSUARI noholdlock on Usu_Numero = Usr_Usuari
			inner join SOREGION noholdlock on Reg_Numero = Usr_Region
			inner join SAUSUPER noholdlock on Upe_Usuari = Usr_Usuari
			where	Usr_Region	= @Usr_Region
			  and	Upe_Perfil	= @Usr_Perfil
			order by Usu_Nombre
	end
	if @Tip_ConCon	= @Str_Cinco begin /* L5 Usuarios por Region y Perfil */
	
	
		/* tabla temporal para zonas*/
		create table #Regiones_Tmp(id int)
				
		/* Se separan los IDs de Zonas*/
		select @Int_Index = charindex(',', @Usr_MulReg)
		while @Int_Index > @Int_Cero begin
			insert into #Regiones_Tmp
				values (CONVERT(INT,left(@Usr_MulReg, @Int_Index-1)))
		
			set @Usr_MulReg	= substring(@Usr_MulReg, @Int_Index+1, datalength(@Usr_MulReg) - @Int_Index)
			select @Int_Index = charindex(',', @Usr_MulReg)
		end
		
		if (datalength(@Usr_MulReg) > @Int_Cero) begin
			insert into #Regiones_Tmp
				values (CONVERT(INT,@Usr_MulReg))
		end
		
		select	Usr_Numero, Usr_Region,	Reg_Descri,	Usr_Usuari,	Usu_Clave,	Usu_Nombre,
				Usu_EMail 
			from SOUSUREG noholdlock
			inner join SOUSUARI noholdlock on Usu_Numero = Usr_Usuari
			inner join SOREGION noholdlock on Reg_Numero = Usr_Region
			where	(Usr_Region in (select id from #Regiones_Tmp)
				or	@Usr_MulReg = @Str_Vacio)
			   and	(Usr_Usuari = @Usr_Usuari
				or	@Usr_Usuari = @Str_Cero)
			order by Usu_Nombre
		
		drop table #Regiones_Tmp
	end
	if @Tip_ConCon	= @Str_Seis begin /* L6 Usuarios por Region, Perfil, Usuario.*/
		select	Usr_Region,	Reg_Descri,	Usr_Usuari,	Usu_Clave,	Usu_Nombre,
				Usu_EMail 
			from SOUSUREG noholdlock
			inner join SOUSUARI noholdlock on Usu_Numero = Usr_Usuari
			inner join SOREGION noholdlock on Reg_Numero = Usr_Region
			inner join SAUSUPER noholdlock on Upe_Usuari = Usr_Usuari
			where	Usr_Region	= @Usr_Region
			  and	Upe_Perfil	= @Usr_Perfil
			  and	Usr_Usuari	= @Usr_Usuari
			order by Usu_Nombre
	end
end
