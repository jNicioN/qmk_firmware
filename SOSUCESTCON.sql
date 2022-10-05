create procedure SOSUCESTCON  (
	@Est_Nombre	varchar(50),
	@Loc_Nombre	varchar(40),
	@Suc_Catego	char(1),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as
/****************************************************************************
** DESCRIPCION: ** Consulta de sucursales por estado					****
****************************************************************************
**					STORE CONVERTIDO									****
** Convirtió: Francisco Javier Carrillo Rojas							****
** Fecha:     13/sep/2022												**** 
****************************************************************************
** Creó:		Francisco Javier Carrillo Rojas							****
** Fecha:		13/sep/2022												****
** HelpDesk:	1694392													****
*****************************************************************************/

/*	Declaracion De Variables	*/
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1)

/*	Declaración De Constantes	*/
declare	@Tip_Lista	char(1),
		@Str_Porcen	char(1),
		@Str_Vacio	char(1),
		@Lis_EstCat	char(1),
		@Min_CarBus	int

/*	Asignación De Constantes	*/
select	@Tip_Lista	= 'L',				/*	Tipo Entrega Sucursal Foranea	*/
		@Str_Porcen	= '%',				/*	String de porcentaje			*/
		@Str_Vacio	= '',				/*	String en vacío					*/
		@Lis_EstCat	= '1',				/*	Lista por estado y categoría	*/
		@Min_CarBus	= 4					/*	Mínimo de caracteres de búsqueda*/

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1),
		@Est_Nombre = ltrim(rtrim(upper(isnull(@Est_Nombre, @Str_Vacio))))

if @Tip_ConTip = @Tip_Lista begin					/*	 C O N S U L T A S	*/
	if @Tip_ConCon = @Lis_EstCat begin				/*	Consulta por nombre de estado	*/
		select @Est_Nombre = @Est_Nombre + @Str_Porcen
		
		if @Est_Nombre = @Str_Porcen begin
			select	Suc_Numero,	Suc_Nombre,	Suc_Direcc,	Est_Nombre
				from SOSUCURS as Suc noholdlock
					 inner join SOESTADO Est on Est.SoEstadoID	= Suc.SoEstadoID
				where Suc_Catego	= @Suc_Catego
		end else begin
			select	Suc_Numero,	Suc_Nombre,	Suc_Direcc,	Est_Nombre
				from SOSUCURS as Suc noholdlock
					 inner join SOESTADO Est on Est.SoEstadoID	= Suc.SoEstadoID
				where	Suc_Catego	= @Suc_Catego
				  and	Est_Nombre like @Est_Nombre		
		end 		
	end
end
