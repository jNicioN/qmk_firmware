create procedure SOUSSUSECON (
	@Par_Sucurs char(3),
	@Par_Segmen int,
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*
**************************************************************
** DESCRIPCION: Usuarios Region por Sucursal y Segmento		**
**************************************************************
** Creador:		Jaret Guanajuato Ruvalcaba					**
** Fecha:		20/01/2022									**
** HelpDesk:	1058568										**
** Descripcion:	Creacion del procedimiento					**
**************************************************************
*/

declare @Tip_ConTip char(1),
		@Tip_ConCon char(1)

declare @Str_Activo char(1),
		@Str_Lista char(1),
		@Con_Princi char(1)


select	@Str_Activo = 'A',
		@Str_Lista = 'L',
		@Con_Princi = '1'

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

		

if @Tip_ConTip = @Str_Lista begin
	if @Tip_ConCon = @Con_Princi begin
		select Usr_Usuari, space(15) as Usu_Clave, Reg_Numero, Reg_Descri, space(3) as Sucursal
			into #Regiones
			from SOUSUREG noholdlock
			inner join SOREGION noholdlock on Reg_Numero = Usr_Region
			where Reg_SegNum = @Par_Segmen

		update #Regiones
			set Usu_Clave = SOUSUARI.Usu_Clave, Sucursal = SOUSUARI.Usu_Sucurs
			from SOUSUARI noholdlock
			where SOUSUARI.Usu_Numero = #Regiones.Usr_Usuari 
			  and SOUSUARI.Usu_Sucurs = @Par_Sucurs 
			  and SOUSUARI.Usu_Status = @Str_Activo

		select Usr_Usuari,	Usu_Clave,	Reg_Numero,	Reg_Descri
			from  #Regiones 
			where Sucursal = @Par_Sucurs

		drop table #Regiones
	end
end
