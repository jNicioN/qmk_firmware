create procedure SOSUCURSALT (
	@Suc_Numero char(3),
	@Suc_Nombre varchar(50),
	@Suc_Calle	varchar(40),
	@Suc_CalNum	varchar(10),
	@Suc_Coloni	varchar(150),
	@Suc_CodPos	char(6),
	@Suc_ApaPos	char(6),
	@Suc_Telefo char(15),
	@Suc_Ciudad char(3),
	@Suc_Estado char(2),
	@Suc_Pais   varchar(20),
	@Suc_Plaza  char(3),
	@Suc_Gerent	varchar(50),
	@Suc_MaiGer	varchar(50),
	@Suc_SubGer	varchar(50),
	@Suc_MaiSub	varchar(50),
	@Suc_CiCrCe	char(1),
	@Suc_Zona	char(2),
	@Suc_IVA	smallmoney,
	@Suc_FecApe	smalldatetime,
	@Suc_DifHor	int,
	@Suc_ApeSab	char(1),
	@Suc_Cerrad char(1),
	@Suc_Catego	char(1),

	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario 	char(6),
	@FechaSis 	smalldatetime,
	@SucOrigen 	char(3),
	@SucDestino char(3),
	@Modulo 	char(2))

as

/***************************************************************************
 DESCRIPCIN: 	Alta de una sucursal
****************************************************************************
 REFERENCIAS:
****************************************************************************
** Modifico:	Andrea Ramýrez M.  		   								****
** Fecha:		01 Agosto 2017											****
** Descripcin:	Eliminar la restriccion de la sucursal 999 				****
** Help:		989147													****
****************************************************************************
** Modific:	Tania De la Garza  		   								****
** Fecha:		09 Junio 2017											****
** Descripcin:	Se excluye la sucursal 999 por Num. de Cliente Global	****
** Help:		989147													****
****************************************************************************
** Modific:	Brandon Garcia				  							****
** Fecha:		20/Febrero/2017											****
** Descripcin:	Se agrega nuevo parametro para categorizar la sucursal	****
** Help Desk:	927640							
***************************************************************************
** Modific:	David Alejandro Cantu Trevio  							****
** Fecha:		24/Agosto/2015											****
** Descripcin:	Se agrega nuevo campo para identificar la sucursal como ****
**				cerrada													****
** Help Desk:	749260													****
****************************************************************************
** Modific:		Armando Garcia										****
** Fecha:		12/Feb/2010												****
** Requi:		000246228								 				****
** Descripcin:	se agrego parametro Suc_ApeSab	 						****
****************************************************************************
** Modific:		Sergio Trevio Jasso								****
** Fecha:		11/Junio/2008											****
** Help Desk:	75587													****
** Descripcion:	Se quito el mensaje 'Registro agregado'					****
****************************************************************************
** Modific:		Ricardo Elizondo Guerrero							****
** Fecha:		02/Abril/2007											****
** Help:			00024338								 			****
** Descripcin:	Incluir Status de Cierre de ArrendaRegio				****
****************************************************************************
** Modific:		Fernando Marcos Esquivel Velzquez					****
** Fecha:		14/Diciembre/2006										****
** Help:		      00003613											****
** Descripcin:	Se quito Exec CHLEESCUALT y se estadarizo				****
****************************************************************************
** Modific:		Francis Flores Contreras							****
** Fecha:		06/Sep/2006												****
** Help:		      00003611											****
** Descripcin:	Se agrego parametros Suc_FecApe y						****
**				Suc_DifHor												****
****************************************************************************
** Modific:		Gabriela Alonso Jalomo								****
** Fecha:		20/Sep/2005												****
** Descripcin:	Se agrego el campo Suc_Zona, Suc_IVA					****
** HD:			97418													****
****************************************************************************
** Modific:		Claudia Lazarn Soto								****
** Fecha:		07/Feb/2003												****
** Descripcin:	Se agregaron los campos Suc_StaCie, Suc_CiCeCr			****
****************************************************************************
** Modific:		Ral Gonzlez										****
** Fecha:		20/Ene/2003												****
** Descripcin:	Se le agrego un exec al Sp que da de alta una			****
**				Sucursal en CHLEESCU									****
****************************************************************************
** Modific:		Ma de Lourdes Valds								****
** Fecha:			3/Abr/2002											****
** Descripcin:	Agregar Validacion de Suc_PaCec							****
****************************************************************************
** Modific:		Sandra Almaguer										****
** Fecha:		27/Mar/2002												****
** Descripcin:	agregar SoSucursID, SoCiudadID, SoEstadoID				****
**				SoPlazaID, ClPromotID									****
****************************************************************************
** Modificar:		Jorge Lozano										****
** Fecha:		07/Dic/01												****
** Se agrego los campos Suc_Gerent,Suc_MaiGer,Suc_SubGer,				****
** Suc_MaiSub															****
****************************************************************************
** Creo:			Sandra Almaguer										****
** Fecha:		26/Jul/01												****
***************************************************************************/

/* Declaracin de Variables */
declare	@Status		int,			/* Status de Ejecucion */
		@Suc_Direcc	varchar(80),	/* Direccion */
		@Str_Coloni	varchar(150),	/* Colonia */
		@Str_ApaPos	char(15),		/* Apartado Postal */
		@Str_CodPos	char(17),		/* Codigo Postal */
		@Str_CalNum	char(15),		/* Calle y Numero */
		@SoSucursID	int,			/* Identificador de Sucursal */
		@SoCiudadID	int,			/* Identificador de Ciudad */
		@SoEstadoID	int,			/* Identificador de Estado */
		@SoPlazaID	int,			/* Identificador de Plaza */
		@ClPromotID	int				/* Identificador de Promotor */

declare	@Ent_Cero	int,			/* Declaracin de Constantes */
		@Str_Vacio	char(1),
		@Fec_Vacia	smalldatetime,
		@Tab_Nombre	char(8),
		@Uld_Habil	char(1),
		@Sin_ProApe	char(1),
		@Suc_StaCre	char(1),
		@Cre_SiCie	char(1),
		@Cre_NoCie	char(1),
		@Ley_CodPos	char(7),
		@Ley_ApaPos	char(6),
		@Ley_Coloni	char(5),
		@Ley_SinNum	char(4),
		@Ley_Numero	char(3),
		@Suc_CliGlo char(3),
		@Str_Espaci char(1),
		@Str_Punto 	char(1),
		@Abr_Coloni	char(5),
		@Str_Cierre varchar(24),
		@Ent_Uno	int

/* Asignacin de Constantes */
select	@Ent_Cero	= 0,			/*	Entero en Cero						*/
		@Str_Vacio	= '',			/*	String Vaco						*/
		@Fec_Vacia 	= '1900-01-01',	/*	Fecha Vacia							*/
		@Tab_Nombre	= 'SOSUCURS',	/*	Tabla a Actualizar en SYTABLOC		*/
		@Uld_Habil	= 'H',			/*	Ultimo Da: Habil					*/
		@Sin_ProApe	= 'N',			/*	Sin Proceso de Apertura				*/
		@Suc_StaCre	= 'A',			/*	Se inicaliza Aperturado el Cierre de Crditos Centralizado	*/
		@Cre_SiCie	= 'S',			/*	Si requiere Cierre Centralizados	*/
		@Cre_NoCie	= 'N',			/*	No requiere Cierre Centralizados	*/
		@Ley_CodPos	= ', C.P. ',	/*	Leyenda Codigo Postal				*/
		@Ley_ApaPos	= ' A.P. ',		/*	Leyenda Apartado Postal				*/
		@Ley_Coloni	= 'COL. ',		/*	Leyenda Colonia						*/
		@Ley_SinNum	= ' SN ',		/*	Leyenda Sin Numero					*/
		@Ley_Numero	= ' #',			/*	Leyenda Numero						*/
		@Suc_CliGlo = '999',		/*	Sucursal Asignada para Cliente Global */
		@Str_Espaci = ' ',			/*	String Espacio */
		@Str_Punto	= '.',			/*	String Punto */
		@Abr_Coloni	= '%COL%',		/*	Abreviacion Colonia */
		@Str_Cierre = '[^@Cre_SiCie+@Cre_NoCie]', /* String Cierre */
		@Ent_Uno	= 1				/* Entero Uno*/

/* Se Inicializan Variables	*/
select	@SoSucursID	= convert(int, @Suc_Numero),
		@Suc_DifHor	= isnull(@Suc_DifHor,@Ent_Cero)

if isnull(@SoSucursID,@Ent_Cero) = @Ent_Cero begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Numero Incorrecto',
			Err_Variab	= 'Suc_Numero'
	rollback
	return @Ent_Uno
end

if exists (select	Suc_Numero
			from SOSUCURS noholdlock
			where	Suc_Numero	= @Suc_Numero) begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'La Sucursal ya Existe',
			Err_Variab	= 'Suc_Numero'
	rollback
	return @Ent_Uno
end

if isnull(@Suc_Nombre, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Nombre Incorrecto',
			Err_Variab	= 'Suc_Nombre'
	rollback
	return @Ent_Uno
end

if isnull(@Suc_Calle, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000004', 
			Err_Mensaj	= 'Calle Incorrecta', 
			Err_Variab	= 'Suc_Calle'
	rollback
	return @Ent_Uno
end 

if isnull(@Suc_Coloni, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000005', 
			Err_Mensaj	= 'Colonia Incorrecta', 
			Err_Variab	= 'Suc_Coloni'
	rollback
	return @Ent_Uno
end 

if not exists (select	Est_Numero
				from SOESTADO noholdlock
				where	Est_Numero	= @Suc_Estado) begin
	select	Err_Codigo	= '000006', 
			Err_Mensaj	= 'El estado no existe', 
			Err_Variab	= 'Suc_Ciudad'
	rollback
	return @Ent_Uno
end 

if not exists (select	Ciu_Numero
				from SOCIUDAD noholdlock
				where	Ciu_Numero	= @Suc_Ciudad
				  and	Ciu_Estado	= @Suc_Estado) begin
	select	Err_Codigo	= '000007', 
			Err_Mensaj	= 'La ciudad no existe', 
			Err_Variab	= 'Suc_Ciudad'
	rollback
	return @Ent_Uno
end 

if isnull(@Suc_Pais, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000008', 
			Err_Mensaj	= 'Pais Incorrecto', 
			Err_Variab	= 'Suc_Pais'
	rollback
	return @Ent_Uno
end 

if isnull(@Suc_Plaza, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000009', 
			Err_Mensaj	= 'Plaza Incorrecta', 
			Err_Variab	= 'Suc_Pais'
	rollback
	return @Ent_Uno
end 

if not exists(select	Pla_Numero
				from SOPLAZAS noholdlock
				where	Pla_Numero	= @Suc_Plaza) begin
	select	Err_Codigo	= '000010', 
			Err_Mensaj	= 'La Plaza no Existe', 
			Err_Variab	= 'Suc_TipCue'
	rollback
	return @Ent_Uno
end 

if isnull(@Suc_Gerent, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000011', 
			Err_Mensaj	= 'Falta Nombre del Gerente', 
			Err_Variab	= 'Suc_Gerent'
	rollback
	return @Ent_Uno
end 

if isnull(@Suc_MaiGer, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000012',
			Err_Mensaj	= 'Falta E-Mail del Gerente',
			Err_Variab	= 'Suc_MaiGer'
	rollback
	return @Ent_Uno
end

if isnull(@Suc_SubGer, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000013',
			Err_Mensaj	= 'Falta Nombre del SubGerente',
			Err_Variab	= 'Suc_SubGer'
	rollback
	return @Ent_Uno
end

if isnull(@Suc_MaiSub, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000014', 
			Err_Mensaj	= 'Falta E-Mail del SubGerente', 
			Err_Variab	= 'Suc_MaiSub'
	rollback
	return @Ent_Uno
end 

if @Suc_CiCrCe like @Str_Cierre begin
	select 	Err_Codigo = '000015', 
			Err_Mensaj = 'Cierre de Creditos Centralizado incorrecto', 
			Err_Variab = 'Suc_CiCrCe'
	rollback
	return @Ent_Uno
end

if isnull(@Suc_Zona, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000016', 
			Err_Mensaj	= 'Zona Incorrecta', 
			Err_Variab	= 'Suc_Zona'
	rollback
	return @Ent_Uno
end 

if not exists(select	Zon_Numero
				from SOZONAS noholdlock
				where	Zon_Numero	= @Suc_Zona) begin
	select	Err_Codigo	= '000017', 
			Err_Mensaj	= 'La Zona no Existe', 
			Err_Variab	= 'Suc_Zona'
	rollback
	return @Ent_Uno	
end 

if isnull(@Suc_FecApe, @Fec_Vacia) = @Fec_Vacia begin 
	select	Err_Codigo	= '000018', 
			Err_Mensaj	= 'No captur Fecha', 
			Err_Variab	= 'vFecha'
	rollback
	return @Ent_Uno
end 

if isnull(@Suc_Catego, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000019', 
			Err_Mensaj	= 'Categoria Incorrecta', 
			Err_Variab	= 'Suc_Catego'
	rollback
	return @Ent_Uno
end 

if isnull(@Suc_CodPos, @Str_Vacio) <> @Str_Vacio
	select	@Str_CodPos	= @Ley_CodPos + ltrim(rtrim(@Suc_CodPos))
else
	select	@Str_ApaPos	= @Str_Vacio

if isnull(@Suc_ApaPos, @Str_Vacio) <> @Str_Vacio
	select	@Str_ApaPos	= @Ley_ApaPos + ltrim(rtrim(@Suc_ApaPos))
else
	select	@Str_ApaPos	= @Str_Vacio

if upper(ltrim(rtrim(@Suc_Coloni))) not like @Abr_Coloni
	select	@Str_Coloni	= @Ley_Coloni + ltrim(rtrim(@Suc_Coloni))
else
	select	@Str_Coloni	= ltrim(rtrim(@Suc_Coloni))

if isnull(@Suc_CalNum, @Str_Vacio) = @Str_Vacio
	select	@Str_CalNum	= @Ley_SinNum
else
	select	@Str_CalNum	= @Ley_Numero + ltrim(rtrim(@Suc_CalNum))

select	@Suc_Direcc	= ltrim(rtrim(@Suc_Calle)) + rtrim(@Str_CalNum) + @Str_Espaci + rtrim(@Str_Coloni) + rtrim(@Str_CodPos) + rtrim(@Str_ApaPos) + @Str_Punto

select	@SoCiudadID	= convert(int, @Suc_Ciudad + @Suc_Estado),
		@SoEstadoID	= convert(int, @Suc_Estado),
		@SoPlazaID	= convert(int, @Suc_Plaza)

insert into SOSUCURS values(
	@SoSucursID,	@Suc_Numero,	@Suc_Nombre,	@Suc_Direcc,	@Suc_Calle,	
	@Suc_CalNum,	@Suc_Coloni,	@Suc_CodPos,	@Suc_ApaPos,	@Suc_Telefo,
	@SoCiudadID,	@Suc_Ciudad,	@SoEstadoID,	@Suc_Estado,	@Suc_Pais,
	@Uld_Habil,		@Sin_ProApe,	@SoPlazaID,		@Suc_Plaza,		@Suc_Gerent,
	@Suc_MaiGer,	@Suc_SubGer,	@Suc_MaiSub,	@Suc_StaCre,	@Suc_CiCrCe,
	@Suc_Zona,		@Suc_IVA,		@Suc_FecApe,	@Suc_DifHor,	@Sin_ProApe,
	@Suc_ApeSab,	@Suc_Cerrad,		@Suc_Catego,	@NumTransac,	@Transaccio,	
	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino	)

exec @Status = SYTABLOCACT
	@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
	@SucOrigen,		@SucDestino,	@Modulo
if @Status <> 0 begin
	rollback
	return @Ent_Uno
end
