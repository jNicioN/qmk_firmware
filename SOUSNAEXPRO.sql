create procedure SOUSNAEXPRO (
	@Une_Nombre	varchar(180),
	@Une_FecNac	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/**
****************************************************************************
** DESCRIPCION: ** Inactiva Usuarios de Compra Venta					****
****************************************************************************
**	REFERENCIAS:														****
****************************************************************************
** Modifico:	Adriana Gomez 											****
** Fecha:		05/03/2021												****
** Help Desk:	1468365										 			****
****************************************************************************
**/

								/* Declaracion de Variables */
declare	@Estatus varchar(1)								
								/* Declaracion de constantes */
declare	@Sta_Activo varchar(1),
		@Sta_Inacti varchar(1),
		@Une_TaOrNa	char(1),	
		@Une_TaOrEx	char(1)	,
		@Biu_DesEst varchar(150),
		@Biu_Canal  int

								/* Asignacion de valores a constantes */
select	@Sta_Activo = 'A',		/* Estatus activo */
		@Sta_Inacti = 'I',		/* Estatus inactivo */
		@Une_TaOrNa	= '1',		/*tabla origen nacionales SOPERSON */
		@Une_TaOrEx	= '2',		/*tabla origen extranjeros SOUSUEXT*/
		@Biu_DesEst = 'Inactivacion de Usuario de compra venta por actvacion de Cuenta',  /*descripcion de inactivacion de usuarios de cv */
		@Biu_Canal  = 5			/* canal */

/*se buscan concidencias en personas */
insert into SOBITUSU (Biu_FolUsu,  Biu_Estatu, Biu_FecEst, Biu_Usuari, Biu_Sucurs, 
					  Biu_Canal,   Biu_DesEst, NumTransac, Transaccio, Usuario,	 
					  FechaSis,	   SucOrigen,  SucDestino)
			select   Une_Identi, @Sta_Inacti, @FechaSis,   @Usuario,    @SucOrigen,
					 @Biu_Canal, @Biu_DesEst, @NumTransac, @Transaccio, @Usuario,	
					 @FechaSis,	 @SucOrigen,  @SucDestino
				from SOPERSON noholdlock 
				inner join SOPERADI noholdlock on  Adi_PerNum =  Per_Numero 
				inner join SOUSNAEX noholdlock on PerPersoID = Une_IdeUsu and  Une_TabOri = @Une_TaOrNa
				where Per_Comple = @Une_Nombre 
				and Adi_FecNac= @Une_FecNac
				and Une_Estatu = @Sta_Activo
	
/* se busca en extranjeros el numero de usuario por nombre y fecha de nacimiento*/
insert  into SOBITUSU (Biu_FolUsu, Biu_Estatu,  Biu_FecEst, Biu_Usuari, Biu_Sucurs, 
					   Biu_Canal,   Biu_DesEst,  NumTransac, Transaccio, Usuario,	 
					   FechaSis,	 SucOrigen,	  SucDestino)
			   select  Une_Identi,  @Sta_Inacti, @FechaSis,   @Usuario,    @SucOrigen,
			  		   @Biu_Canal,  @Biu_DesEst, @NumTransac, @Transaccio, @Usuario,	
				       @FechaSis,	 @SucOrigen,  @SucDestino
				from SOUSUEXT noholdlock 
				inner join SOUSNAEX noholdlock on Une_IdeUsu = Use_IdUsEx 
				and  Une_TabOri =@Une_TaOrEx
				where Use_NoCoUs = @Une_Nombre
				and  Use_FecNac = @Une_FecNac
				and  Une_Estatu = @Sta_Activo
		
		
update SOUSNAEX set Une_Estatu = @Sta_Inacti  
	from SOBITUSU noholdlock 
	where Une_Identi = Biu_FolUsu  
	and  SOBITUSU.NumTransac = @NumTransac 

